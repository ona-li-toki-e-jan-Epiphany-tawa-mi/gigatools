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
-- TODO switch from using global register table to item metadata.
-- TODO add omnidrills that have multiple dig modes.
-- TODO add scythes which till in a 3x3.
-- TODO add sickles for breaking leaves/other plants in 3x3x3. snappy group



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

--- Resolves item name aliases.
function _gigatools.resolve_alias(name)
   return minetest.registered_aliases[name] or name
end

--- Loads and executes a Gigatools Lua module.
-- @param path The file path of the module relative to the Gigatools directory.
-- @return The return value of the Lua module.
function _gigatools.load_module(path)
   return loadfile(minetest.get_modpath("gigatools") .. "/" .. path)(_gigatools)
end



_gigatools.load_module("api.lua")



local half_pi    = math.pi / 2
local quarter_pi = math.pi / 4

--- Returns whether the player is facing the +/- X axis "enough."
local function is_player_facing_x_axis(player)
   local yaw_rad = player:get_look_horizontal()
   return (yaw_rad > 3*half_pi - quarter_pi and yaw_rad < 2*math.pi - quarter_pi)
          or (yaw_rad > quarter_pi and yaw_rad < math.pi - quarter_pi)
end

--- Returns a set of axes representing the cuboid digging area the player has.
-- See @{apply_cuboid} for what this is used for.
-- @param pointed_thing The digging location as a pointed_thing.
-- @return The field name for the width axis.
-- @return The field name for the height axis.
-- @return The field name for the depth axis.
-- @return The sign (+/-) of the depth axis.
local function get_digging_cuboid_axes(player, pointed_thing)
   assert("node" == pointed_thing.type, "expected a pointed_thing of type node, got '" .. pointed_thing.type .. "'")

   local above = pointed_thing.above
   local under = pointed_thing.under

   if above.x < under.x then -- -X node face.
      return "z", "y", "x", 1
   elseif above.x > under.x then -- +X node face.
      return "z", "y", "x", -1
   elseif above.z < under.z then -- -Z node face.
      return "x", "y", "z", 1
   elseif above.z > under.z then -- +Z node face.
      return "x", "y", "z", -1
   elseif above.y < under.y then -- -Y node face.
      if is_player_facing_x_axis(player) then
         return "z", "x", "y", 1
      else
         return "x", "z", "y", 1
      end
   else -- +Y node face.
      if is_player_facing_x_axis(player) then
         return "z", "x", "y", -1
      else
         return "x", "z", "y", -1
      end
   end

   assert(false, "unreachable")
end

--- Returns the sign of a number: 1 for positive, -1 for negative, and 0 for 0.
local function signum(number)
   if number > 0 then
      return 1
   elseif number < 0 then
      return -1
   end
   return 0
end

--- Calls a function on a directional cuboid of nodes.
-- @param position The cuboid's center for width/height and the starting
-- position for the depth.
-- @param width_field The field name that represents the width axis (i.e. "x".)
-- @param width_size The size of the cuboid along the width axis. Should be an
-- odd integer >= 1.
-- @param height_field The field name that represents the height axis (i.e. "y".)
-- @param height_size The size of the cuboid along the height axis. Should be an
-- odd integer >= 1.
-- @param depth_field The field name that represents the depth axis (i.e. "z".")
-- @param depth_distance The size of cuboid along the depth axis. Sign (+/-)
-- specifies direction on the axis. Should be an integer ~= 0.
-- @param func The function to call on each node in the cuboid.
-- Parameters:
--   1. position The position of the node.
--   2. node The node.
--   3. width_offset The node's offset from the center along the width axis.
--   4. height_offset The node's offset from the center along the height axis.
--   5. depth_offset The node's offset from the starting position along the depth
--   axis.
local function apply_cuboid( position, width_field, width_size, height_field, height_size, depth_field
                           , depth_distance, func
                           )
   local offset_position = table.copy(position)

   local width_half_size  = math.floor(width_size  / 2)
   local height_half_size = math.floor(height_size / 2)
   local depth_direction  = signum(depth_distance)

   for depth_offset=0,depth_distance-depth_direction,depth_direction do
      offset_position[depth_field] = position[depth_field] + depth_offset
      for width_offset=-width_half_size,width_half_size do
         offset_position[width_field] = position[width_field] + width_offset
         for height_offset=-height_half_size,height_half_size do
            offset_position[height_field] = position[height_field] + height_offset

            local node = minetest.get_node(offset_position)
            if "ignore" ~= node.name then
               func(offset_position, node, width_offset, height_offset, depth_offset)
            end
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



-- Used to check if a player has used a multinode tool to dig a node, meaning
-- that the resulting calls from register_on_dignode() are the result of the
-- tool's multinode digging. This is to prevent recursively mining nodes.
local is_using_multinode_tool = {}

-- Map between player names and the pointed_thing from
-- try_adjust_multinode_tool_dig_time(). This is needed because
-- minetest.register_on_dignode() does not return a pointed_thing, which is
-- needed to determine the mining cuboid axes.
local player_pointed_things = {}

--- Handles checking for the use of a multinode tool and digging the extra nodes.
local function try_dig_with_multinode_tool(position, old_node, digger)
   if nil == digger or not digger:is_player() then return end
   local player_name = digger:get_player_name()
   if is_using_multinode_tool[player_name] then return end

   local wielded_item   = digger:get_wielded_item()
   local dig_dimensions = gigatools.registered_multinode_tools[
      _gigatools.resolve_alias(wielded_item:get_name())]
   if nil == dig_dimensions                         then return end
   if not is_meant_to_break(wielded_item, old_node) then return end

   is_using_multinode_tool[player_name] = true

   local pointed_thing = player_pointed_things[player_name]
   assert(nil ~= pointed_thing, "expected valid pointed_thing, got nil")
   local width_axis, height_axis, depth_axis, depth_axis_sign = get_digging_cuboid_axes(digger, pointed_thing)
   apply_cuboid(
      position,
      width_axis,  dig_dimensions.width,
      height_axis, dig_dimensions.height,
      depth_axis,  dig_dimensions.depth * depth_axis_sign,
      function(position, node, width_offset, height_offset, depth_offset)
         if (0 ~= width_offset or 0 ~= height_offset or 0 ~= depth_offset)
            and is_meant_to_break(wielded_item, node)
         then
            minetest.node_dig(position, node, digger)
         end
      end
   )

   is_using_multinode_tool[player_name] = nil
end
minetest.register_on_dignode(try_dig_with_multinode_tool)



--- Adjusts the dig speed of multinode tools to account for how many blocks are
--- to be broken.
-- Yup, you can't cheat and break cobblestone by obsidian.
local function try_adjust_multinode_tool_dig_time(position, node, puncher, pointed_thing)
   if nil == puncher or not puncher:is_player() then return end

   local wielded_item   = puncher:get_wielded_item()
   local dig_dimensions = gigatools.registered_multinode_tools[
      _gigatools.resolve_alias(wielded_item:get_name())]
   if nil == dig_dimensions                     then return end
   if not is_meant_to_break(wielded_item, node) then return end

   -- Save pointed_thing for try_dig_with_multinode_tool().
   player_pointed_things[puncher:get_player_name()] = pointed_thing

   -- Wipe previous dig time adjustments.
   wielded_item:get_meta():set_tool_capabilities(nil)
   local tool_capabilities = wielded_item:get_tool_capabilities()

   -- Calculates how long it would take to mine all the applicable blocks.
   local dig_time    = 0.0
   local block_count = 0
   local width_axis, height_axis, depth_axis, depth_axis_sign = get_digging_cuboid_axes(puncher, pointed_thing)
   apply_cuboid(
      position,
      width_axis,  dig_dimensions.width,
      height_axis, dig_dimensions.height,
      depth_axis,  dig_dimensions.depth * depth_axis_sign,
      function(position, node, width_offset, height_offset)
         if is_meant_to_break(wielded_item, node) then
            local node_definition = minetest.registered_nodes[_gigatools.resolve_alias(node.name)]
            dig_time = dig_time + minetest.get_dig_params(
               node_definition.groups,
               tool_capabilities
            ).time
            block_count = 1 + block_count
         end
      end
   )

   -- Adjusts tool dig speed.
   if block_count > 0 then
      -- Slow on few blocks, fast on many.
      local dig_time_multiplier = dig_time / (1 + math.log(block_count, 10))

      for _, groupcap in pairs(tool_capabilities.groupcaps) do
         for i, time in pairs(groupcap.times) do
            groupcap.times[i] = time * dig_time_multiplier
         end
      end
      wielded_item:get_meta():set_tool_capabilities(tool_capabilities)
   end

   -- Write out new dig times.
   puncher:set_wielded_item(wielded_item)
end
minetest.register_on_punchnode(try_adjust_multinode_tool_dig_time)
