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

-- Gigatools hammers submod.
-- Like pickaxes, but mine in a 3x3.

-- NOTE: when adding new hammers, multiply base item punch/dig speeds by 1.7,
-- uses by 9, and add 1 to damage groups.

-- TODO add localization.
-- TODO consider making hammers do extra knockback.
-- TODO add Mineclonia/VoxeLibre support.



-- Returns whether the mod with the given name is enabled.
local function is_mod_enabled(name)
   return nil ~= minetest.get_modpath(name)
end

--- Registers a new hammer toolitem.
-- @param name Item name.
-- @param crafting_material The name of the item to use as the crafting material
-- for the head of the hammer.
-- @param definition The item's definition as expected by
-- minetest.register_tool().
local function register_hammer(name, crafting_material, definition)
   minetest.register_tool(name, definition)
   gigatools.register_3x3_tool(name)

   minetest.register_craft({
        output = name,
        recipe = {
            { crafting_material, crafting_material, crafting_material },
            { "",                "group:stick",     ""                },
            { "",                "group:stick",     ""                }
        }
    })
end



if is_mod_enabled("default") then
   register_hammer("gigatools_hammers:hammer_bronze", "default:bronzeblock", {
       description     = "Bronze Hammer",
       inventory_image = "default_tool_bronzepick.png", -- TODO change
       sound           = { breaks  = "default_tool_breaks" },
       groups          = { pickaxe = 1 },

       tool_capabilities = {
           full_punch_interval = 1.7,
           max_drop_level      = 1,
           damage_groups       = { fleshy = 5 },

           groupcaps = {
              cracky = { times = { [1] = 7.65, [2] = 3.06, [3] = 1.53 }, uses = 180, maxlevel = 2 },
           }
       }
   })

   register_hammer("gigatools_hammers:hammer_steel", "default:steelblock", {
     description     = "Steel Hammer",
     inventory_image = "default_tool_steelpick.png", -- TODO change
     sound           = { breaks  = "default_tool_breaks" },
     groups          = { pickaxe = 1 },

     tool_capabilities = {
        full_punch_interval = 1.7,
        max_drop_level      = 1,
        damage_groups       = { fleshy = 5 },

        groupcaps = {
           cracky = { times = { [1] = 6.8, [2] = 2.72, [3] = 1.36 }, uses = 180, maxlevel = 2 }
        }
     }
   })

   register_hammer("gigatools_hammers:hammer_mese", "default:mese", {
       description     = "Mese Hammer",
       inventory_image = "default_tool_mesepick.png", -- TODO change
       sound           = { breaks  = "default_tool_breaks" },
       groups          = { pickaxe = 1 },

       tool_capabilities = {
           full_punch_interval = 1.53,
           max_drop_level      = 3,
           damage_groups       = { fleshy = 6 },

           groupcaps={
               cracky = { times = { [1] = 4.08, [2] = 2.04, [3] = 1.02 }, uses = 180, maxlevel = 3 },
           }
       }
   })

   register_hammer("gigatools_hammers:hammer_diamond", "default:diamondblock", {
       description     = "Diamond Hammer",
       inventory_image = "default_tool_diamondpick.png", -- TODO change
       sound           = { breaks  = "default_tool_breaks" },
       groups          = { pickaxe = 1 },

       tool_capabilities = {
           full_punch_interval = 1.53,
           max_drop_level      = 3,
           damage_groups       = { fleshy = 6 },

           groupcaps = {
               cracky = { times = { [1] = 3.4, [2] = 1.7, [3] = 0.85 }, uses = 270, maxlevel = 3 },
           }
       }
   })
end
