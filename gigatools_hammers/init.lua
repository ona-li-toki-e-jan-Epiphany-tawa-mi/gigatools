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
-- Like pickaxes, but dig in a 3x3.

-- NOTE: when adding new hammers, multiply base item punch/dig speeds by 1.7,
-- uses by 9, and add 1 to damage groups.

-- TODO consider making hammers do extra knockback.
-- TODO add Mineclonia/VoxeLibre support.

local S = core.get_translator("gigatools_hammers")



-- Returns whether the mod with the given name is enabled.
local function is_mod_enabled(name)
   return nil ~= core.get_modpath(name)
end

--- Registers a new hammer toolitem.
-- @param name Item name.
-- @param crafting_material The name of the item to use as the crafting material
-- for the head of the hammer.
-- @param definition The item's definition as expected by core.register_tool().
local function register_hammer(name, crafting_material, definition)
   definition.sound  = { breaks  = "default_tool_breaks" }
   definition.groups = { pickaxe = 1 }
   core.register_tool(name, definition)

   gigatools.register_multinode_tool(name, 3, 3, 1)

   core.register_craft({
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
       description     = S("Bronze Hammer"),
       inventory_image = "gigatools_hammers_bronze_hammer.png",

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
     description     = S("Steel Hammer"),
     inventory_image = "gigatools_hammers_steel_hammer.png",

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
       description     = S("Mese Hammer"),
       inventory_image = "gigatools_hammers_mese_hammer.png",

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
       description     = S("Diamond Hammer"),
       inventory_image = "gigatools_hammers_diamond_hammer.png",

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
