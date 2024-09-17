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

-- Gigatools hammers module.
-- Like pickaxes, but mine in a 3x3.

-- TODO add localization.
-- TODO make sure this consumes accurate durability.
-- TODO set up registering system for hammers.
-- TODO add hammers for all metal and gem materials.
-- TODO add crafting recipes.
-- TODO add division (like 1/3) to the total adjusted mining time of the hammers to make them a little faster.

-- Imports private namespace.
local _gigatools = ...



-- Note for adding new hammers: multiply base item mining speeds by 1.7.
minetest.register_tool("gigatools:hammer_steel", {
  description     = "Steel Hammer",
  inventory_image = "default_tool_steelpick.png",        -- TODO change
  sound           = { breaks  = "default_tool_breaks" },
  groups          = { pickaxe = 1 },

  tool_capabilities = {
     full_punch_interval = 2.5,
     max_drop_level      = 1,
     damage_groups       = { fleshy = 4 }, -- TODO change

     groupcaps = {
        cracky = { times = { [1] = 6.8, [2] = 2.72, [3] = 1.36 }, uses = 20, maxlevel = 2 } -- TODO increase durability.
     }
  }
})



--- Calls a function on 3x3 plane of nodes along the specified axes.
-- @param func The function to call on each block in the plane.
-- Parameters:
--   position The position of the node.
--   node The node.
--   axis1_offset The offset of the node from the center along the first axis.
--   axis2_offset The offset of the node from the center along the second axis.
-- @param position The position of the center of the plane.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_field The name of the field that represents the second axis (i.e. "z".)
local function apply_3x3_plane(func, position, axis1_field, axis2_field)
   local offset_position = table.copy(position)

   for axis1_offset=-1,1 do
      for axis2_offset=-1,1 do
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



--- Breaks a 3x3 plane of nodes along the specified axes.
-- @param position The position of the center of the plane. The node at this
-- location will not be broken.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_field The name of the field that represents the second axis (i.e. "z".)
-- @param digger The ObjectRef thats breaking the node. May be nil.
-- @param toolitem The ItemStack to use to break the node.
local function break_3x3_plane(position, axis1_field, axis2_field, digger, toolitem)
   apply_3x3_plane(function(position, node, axis1_offset, axis2_offset)
         if (0 ~= axis1_offset or 0 ~= axis2_offset) and is_meant_to_break(toolitem, node) then
            minetest.dig_node(position, digger)
         end
   end, position, axis1_field, axis2_field)
end

-- Used to check if a player has hammered a node and that the resulting calls
-- from register_on_nodedig() are the result of the hammer's 3x3 mining. This is
-- to prevent recursively mining nodes.
local is_hammering = {}

--- Handles checking for the use of a hammer and digging the extra nodes.
local function try_hammer(position, old_node, digger)
   if nil == digger or not digger:is_player() then return end
   local player_name = digger:get_player_name()
   if is_hammering[player_name] then return end

   local wielded_item = digger:get_wielded_item()
   if "gigatools:hammer_steel" ~= wielded_item:get_name() then return end
   -- Only run 3x3 breaking if the tool is meant to break that node.
   if not is_meant_to_break(wielded_item, old_node) then return end

   is_hammering[player_name] = true
   if is_player_facing_y_axis(digger) then
      break_3x3_plane(position, "x", "z", digger, wielded_item)
   elseif is_player_facing_x_axis(digger) then
      break_3x3_plane(position, "z", "y", digger, wielded_item)
   else
      break_3x3_plane(position, "x", "y", digger, wielded_item)
   end
   is_hammering[player_name] = nil
end
minetest.register_on_dignode(try_hammer)



--- Gets the time to dig a 3x3 plane of nodes along the specified axes for a 3x3
--- digging tool.
-- The time returned is non-linear; mining more blocks at once will yield a
-- faster dig time per block.
-- @param position The position of the center of the plane.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_field The name of the field that represents the second axis (i.e. "z".)
-- @param digger The ObjectRef thats punching the node. May be nil.
-- @param toolitem The ItemStack to use to punch the node.
-- @return The dig time, or 0.0, if none of the blocks are meant to be broken by
-- the tool.
local function get_3x3_plane_dig_time(position, axis1_field, axis2_field, puncher, toolitem)
   local actual_dig_time = 0.0
   local block_count     = 0

   apply_3x3_plane(function(position, node, axis1_offset, axis2_offset)
         if is_meant_to_break(toolitem, node) then
            local node_definition = minetest.registered_nodes[node.name]
            actual_dig_time = actual_dig_time + minetest.get_dig_params(
               node_definition.groups,
               toolitem:get_tool_capabilities()
            ).time
            block_count = 1 + block_count
         end
   end, position, axis1_field, axis2_field)

   if block_count > 0 then
      return actual_dig_time / (1 + math.log(block_count))
   else
      return 0.0
   end
end

--- Adjusts the dig speed of the hammer to account for how many blocks are to be
--- broken. Yup, you can't cheat and break cobblestone by obsidian.
local function try_adjust_hammer_dig_time(position, node, puncher, pointed_thing)
   if nil == puncher or not puncher:is_player() then return end

   local wielded_item = puncher:get_wielded_item()
   if "gigatools:hammer_steel" ~= wielded_item:get_name() then return end
   -- Only run 3x3 breaking if the tool is meant to break that node.
   if not is_meant_to_break(wielded_item, node) then return end

   -- Wipe previous dig time adjustments.
   wielded_item:get_meta():set_tool_capabilities(nil)

   local dig_time
   if is_player_facing_y_axis(puncher) then
      dig_time = get_3x3_plane_dig_time(position, "x", "z", puncher, wielded_item)
   elseif is_player_facing_x_axis(puncher) then
      dig_time = get_3x3_plane_dig_time(position, "z", "y", puncher, wielded_item)
   else
      dig_time = get_3x3_plane_dig_time(position, "x", "y", puncher, wielded_item)
   end

   -- 0.0 if there were no mineable blocks,
   if 0.0 ~= dig_time then
      -- Rewrite dig times to account for all blocks to be mined.
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
minetest.register_on_punchnode(try_adjust_hammer_dig_time)
