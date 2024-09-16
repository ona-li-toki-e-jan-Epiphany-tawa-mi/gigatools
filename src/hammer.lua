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

-- TODO: add localization.

-- Imports private namespace.
local _gigatools = ...



-- TODO figure out mining speed
minetest.register_tool("gigatools:hammer_steel", {
  description     = "Steel Hammer",
  inventory_image = "default_tool_steelpick.png",        -- TODO change
  sound           = { breaks  = "default_tool_breaks" },
  groups          = { pickaxe = 1 },

  tool_capabilities = {
     full_punch_interval = 1.0 * 2.5,
     max_drop_level      = 1,
     damage_groups       = { fleshy = 4 }, -- TODO change

     groupcaps = {
        cracky = { times = { [1] = 4.00 * 2.5, [2] = 1.60 * 2.5, [3] = 0.80 * 2.5 }, uses = 20, maxlevel = 2 }
     }
  }
})




local half_pi    = math.pi / 2
local quarter_pi = math.pi / 4

-- How many radians the player's pitch can be from +/- pi/2 (looking straight up
-- or down) to count as mining vertically.
local vertical_mining_epsilon_rad = 0.2

local function try_hammer(position, old_node, digger)
   if nil == digger or not digger:is_player() then return end
   -- TODO set up registering system for hammers.
   if "gigatools:hammer_steel" ~= digger:get_wielded_item():get_name() then return end

   -- Since we don't know which face of the block the player broke, we will have
   -- to guess based on their rotation.
   local yaw_rad   = digger:get_look_horizontal()
   local pitch_rad = digger:get_look_vertical()

   if math.abs(pitch_rad) > half_pi - vertical_mining_epsilon_rad then
      -- If facing up/down "enough," break across the XZ plane.
      print("Breaking XZ plane!") -- TODO.
   elseif (yaw_rad > quarter_pi and yaw_rad < math.pi - quarter_pi)
       or (yaw_rad > 3*half_pi - quarter_pi and yaw_rad < 2*math.pi - quarter_pi)
   then
      -- If facing the +/- X axis "enough," break across the ZY plane.
      print("Breaking ZY plane!") -- TODO.
   else
      -- If facing the +/- Z axis "enough," break across the XY plane.
      print("Breaking XY plane!") -- TODO.
   end
end
minetest.register_on_dignode(try_hammer)
