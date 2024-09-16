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
-- TODO make group checking use groupcaps present in item.
-- TODO make mining time depend on the nodes to mine for hammer.

-- Imports private namespace.
local _gigatools = ...



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
        cracky = { times = { [1] = 10.0, [2] = 4.0, [3] = 2.0 }, uses = 20, maxlevel = 2 } -- TODO increase durability.
     }
  }
})



--- Returns whether a node is meant to be broken by a tool (as-in the node is a
--- part of at least one of the tool's groupcaps.
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

--- Breaks a 3x3 plane of nodes along the specified axes.
-- @param position The position of the center of the plane. The node at this
-- location will not be broken.
-- @param axis1_field The name of the field that represents the first axis (i.e. "x".)
-- @param axis1_field The name of the field that represents the second axis (i.e. "z".)
-- @param digger The ObjectRef thats breaking the node. May be nil.
-- @param toolitem The ItemStack to use to break the node.
local function break_3x3_plane(position, axis1_field, axis2_field, digger, toolitem)
   local offset_position = table.copy(position)

   for axis1_offset=-1,1 do
      for axis2_offset=-1,1 do
         if 0 ~= axis1_offset or 0 ~= axis2_offset then
            offset_position[axis1_field] = position[axis1_field] + axis1_offset
            offset_position[axis2_field] = position[axis2_field] + axis2_offset

            local node = minetest.get_node(offset_position)
            if "ignore" ~= node.name and is_meant_to_break(toolitem, node) then
               minetest.dig_node(offset_position, digger)
            end
         end
      end
   end
end

local half_pi    = math.pi / 2
local quarter_pi = math.pi / 4
-- How many radians the player's pitch can be from +/- pi/2 (looking straight up
-- or down) to count as mining vertically.
local vertical_mining_epsilon_rad = 0.2

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

   -- Since we don't know which face of the node the player broke, we will have
   -- to guess based on their rotation.
   local yaw_rad   = digger:get_look_horizontal()
   local pitch_rad = digger:get_look_vertical()

   if math.abs(pitch_rad) > half_pi - vertical_mining_epsilon_rad then
      -- If facing up/down "enough," break across the XZ plane.
      break_3x3_plane(position, "x", "z", digger, wielded_item)
   elseif (yaw_rad > quarter_pi and yaw_rad < math.pi - quarter_pi)
       or (yaw_rad > 3*half_pi - quarter_pi and yaw_rad < 2*math.pi - quarter_pi)
   then
      -- If facing the +/- X axis "enough," break across the ZY plane.
      break_3x3_plane(position, "z", "y", digger, wielded_item)
   else
      -- If facing the +/- Z axis "enough," break across the XY plane.
      break_3x3_plane(position, "x", "y", digger, wielded_item)
   end

   is_hammering[player_name] = nil
end
minetest.register_on_dignode(try_hammer)
