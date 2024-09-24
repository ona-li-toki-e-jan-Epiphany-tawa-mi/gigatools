-- This file is part of gigatools.
--
-- Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
--
-- gigatools is free software: you can redistribute it and/or modify it under
-- the terms of the GNU Lesser General Public License as published by the Free
-- Software Foundation, either version 3 of the License, or (at your option) any
-- later version.
--
-- gigatools is distributed in the hope that it will be useful, but WITHOUT ANY
-- WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
-- A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with gigatools. If not, see <https://www.gnu.org/licenses/>.

-- Gigatools core mod.
-- Handles inner workings of multi-node digging tools.

-- TODO place digging code into another file.



-- Private namespace for internal functions.
local _gigatools = {}

--- Wrapper for minetest.log().
-- Adds a prefix to the text inidicating that the log message comes from
-- Gigatools.
-- @param level One of "none", "error", "warning", "action", "info", or "verbose".
-- @param text The log message.
function _gigatools.log(level, text)
   minetest.log(level, "[gigatools] " .. text)
end

--- Loads and executes a Gigatools Lua module.
-- @param path The file path of the module relative to the Gigatools directory.
-- @return The return value of the Lua module.
function _gigatools.load_module(path)
   return loadfile(minetest.get_modpath("gigatools") .. "/" .. path)(_gigatools)
end



_gigatools.load_module("api.lua")



--- Calls a function on a 2D plane of nodes along the specified axes.
-- @param func The function to call on each block in the plane.
-- Parameters:
--   position The position of the node.
--   node The node.
--   axis1_offset The offset of the node from the center along the first axis.
--   axis2_offset The offset of the node from the center along the second axis.
-- @param position The position of the center of the plane.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_size The size of the plane along axis1. Should be odd and >= 1.
-- @param axis2_field The name of the field that represents the second axis (i.e. "z".)
-- @param axis2_size The size of the plane along axis2. Should be odd and >= 1.
local function apply_2d_plane(func, position, axis1_field, axis1_size, axis2_field, axis2_size)
   local offset_position = table.copy(position)

   local axis1_half_size = math.floor(axis1_size / 2)
   local axis2_half_size = math.floor(axis2_size / 2)

   for axis1_offset=-axis1_half_size,axis1_half_size do
      for axis2_offset=-axis2_half_size,axis2_half_size do
         offset_position[axis1_field] = position[axis1_field] + axis1_offset
         offset_position[axis2_field] = position[axis2_field] + axis2_offset

         local node = minetest.get_node(offset_position)
         if "ignore" ~= node.name then
            func(offset_position, node, axis1_offset, axis2_offset)
         end
      end
   end
end

--- Returns whether a node is meant to be broken by a tool (as-in the node is a
--- part of at least one of the tool's groupcaps.)
-- @param toolitem ItemStack.
local function is_meant_to_break(toolitem, node)
   local groupcaps = toolitem:get_tool_capabilities().groupcaps

   for group, _ in pairs(groupcaps) do
      if 0 ~= minetest.get_item_group(node.name, group) then
         return true
      end
   end

   return false
end

local half_pi    = math.pi / 2
local quarter_pi = math.pi / 4
-- How many radians the player's pitch can be from +/- pi/2 (looking straight up
-- or down) to count as facing vertically.
local vertical_mining_epsilon_rad = 0.2

-- Returns whether the player is facing the y-axis (looking up or down "enough".)
local function is_player_facing_y_axis(player)
   return math.abs(player:get_look_vertical()) > half_pi - vertical_mining_epsilon_rad
end

-- Returns whether the player is facing the x-axis (looking at +/- X "enough".)
local function is_player_facing_x_axis(player)
   local yaw_rad = player:get_look_horizontal()
   return (yaw_rad > quarter_pi and yaw_rad < math.pi - quarter_pi)
       or (yaw_rad > 3*half_pi - quarter_pi and yaw_rad < 2*math.pi - quarter_pi)
end



--- Digs a 2D plane of nodes along the specified axes.
-- @param position The position of the center of the plane. The node at this
-- location will not be broken.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_size The size of the plane along axis1. Should be odd and >= 1.
-- @param axis2_field The name of the field that represents the second axis (i.e. "z".)
-- @param axis2_size The size of the plane along axis2. Should be odd and >= 1.
-- @param digger The ObjectRef thats breaking the node. May be nil.
-- @param toolitem The ItemStack to use to break the node.
local function dig_2d_plane(position, axis1_field, axis1_size, axis2_field, axis2_size, digger, toolitem)
   apply_2d_plane(function(position, node, axis1_offset, axis2_offset)
         if (0 ~= axis1_offset or 0 ~= axis2_offset) and is_meant_to_break(toolitem, node) then
            minetest.node_dig(position, node, digger)
         end
   end, position, axis1_field, axis1_size, axis2_field, axis2_size)
end

-- Used to check if a player has used a 2D tool to dig a node, meaning that the
-- resulting calls from register_on_dignode() are the result of the tool's 2D
-- digging. This is to prevent recursively mining nodes.
local is_using_2d_tool = {}

-- TODO resolve item aliases.
--- Handles checking for the use of a 2D tool and digging the extra nodes.
local function try_dig_with_2d_tool(position, old_node, digger)
   if nil == digger or not digger:is_player() then return end
   local player_name = digger:get_player_name()
   if is_using_2d_tool[player_name] then return end

   local wielded_item   = digger:get_wielded_item()
   local dig_dimensions = gigatools.registered_2d_tools[wielded_item:get_name()]
   if nil == dig_dimensions                         then return end
   if not is_meant_to_break(wielded_item, old_node) then return end

   is_using_2d_tool[player_name] = true
   if is_player_facing_x_axis(digger) then
      if is_player_facing_y_axis(digger) then
         dig_2d_plane(position, "z", dig_dimensions.width, "x", dig_dimensions.height, digger, wielded_item)
      else
         dig_2d_plane(position, "z", dig_dimensions.width, "y", dig_dimensions.height, digger, wielded_item)
      end
   else
      if is_player_facing_y_axis(digger) then
         dig_2d_plane(position, "x", dig_dimensions.width, "z", dig_dimensions.height, digger, wielded_item)
      else
         dig_2d_plane(position, "x", dig_dimensions.width, "y", dig_dimensions.height, digger, wielded_item)
      end
   end
   is_using_2d_tool[player_name] = nil
end
minetest.register_on_dignode(try_dig_with_2d_tool)



-- TODO resolve item aliases.
--- Gets the time to dig a 3x3 plane of nodes along the specified axes for a 3x3
--- digging tool.
-- The time returned is non-linear; mining more blocks at once will yield a
-- faster dig time per block.
-- @param position The position of the center of the plane.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_size The size of the plane along axis1. Should be odd and >= 1.
-- @param axis2_field The name of the field that represents the second axis (i.e. "z".)
-- @param axis2_size The size of the plane along axis2. Should be odd and >= 1.
-- @param digger The ObjectRef thats punching the node. May be nil.
-- @param toolitem The ItemStack to use to punch the node.
-- @return The dig time, or 0.0, if none of the blocks are meant to be broken by
-- the tool.
local function get_2d_plane_dig_time( position, axis1_field, axis1_size, axis2_field, axis2_size, puncher
                                    , toolitem
                                    )
   local actual_dig_time = 0.0
   local block_count     = 0

   apply_2d_plane(function(position, node, axis1_offset, axis2_offset)
         if is_meant_to_break(toolitem, node) then
            local node_definition = minetest.registered_nodes[node.name]
            actual_dig_time = actual_dig_time + minetest.get_dig_params(
               node_definition.groups,
               toolitem:get_tool_capabilities()
            ).time
            block_count = 1 + block_count
         end
   end, position, axis1_field, axis1_size, axis2_field, axis2_size)

   if block_count > 0 then
      return actual_dig_time / (1 + math.log(block_count, 10))
   else
      return 0.0
   end
end

-- TODO resolve item aliases.
--- Adjusts the dig speed of 2d tools to account for how many blocks are to be
--- broken. Yup, you can't cheat and break cobblestone by obsidian.
local function try_adjust_2d_tool_dig_time(position, node, puncher, pointed_thing)
   if nil == puncher or not puncher:is_player() then return end

   local wielded_item   = puncher:get_wielded_item()
   local dig_dimensions = gigatools.registered_2d_tools[wielded_item:get_name()]
   if nil == gigatools.registered_2d_tools[wielded_item:get_name()] then return end
   if not is_meant_to_break(wielded_item, node)                     then return end

   -- Wipe previous dig time adjustments.
   wielded_item:get_meta():set_tool_capabilities(nil)

   local dig_time
   if is_player_facing_x_axis(puncher) then
      if is_player_facing_y_axis(puncher) then
         dig_time = get_2d_plane_dig_time(
            position,
            "z", dig_dimensions.width,
            "x", dig_dimensions.height,
            puncher,
            wielded_item
         )
      else
         dig_time = get_2d_plane_dig_time(
            position,
            "z", dig_dimensions.width,
            "y", dig_dimensions.height,
            puncher,
            wielded_item
         )
      end
   else
      if is_player_facing_y_axis(puncher) then
         dig_time = get_2d_plane_dig_time(
            position,
            "x", dig_dimensions.width,
            "z", dig_dimensions.height,
            puncher,
            wielded_item
         )
      else
         dig_time = get_2d_plane_dig_time(
            position,
            "x", dig_dimensions.width,
            "y", dig_dimensions.height,
            puncher,
            wielded_item
         )
      end
   end

   -- 0.0 if there were no diggable nodes,
   if 0.0 ~= dig_time then
      -- Rewrite dig times to account for all node to digged.
      local tool_capabilities = wielded_item:get_tool_capabilities()
      for _, groupcap in pairs(tool_capabilities.groupcaps) do
         for i, time in pairs(groupcap.times) do
            groupcap.times[i] = time * dig_time
         end
      end
      wielded_item:get_meta():set_tool_capabilities(tool_capabilities)
   end

   -- Write out new dig times.
   puncher:set_wielded_item(wielded_item)
end
minetest.register_on_punchnode(try_adjust_2d_tool_dig_time)
