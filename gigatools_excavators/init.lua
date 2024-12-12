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

-- Gigatools excavators submod.
-- Like shovels, but dig in a 3x3.

-- NOTE: when adding new excavators, multiply base item punch/dig speeds by 1.7,
-- uses by 9, and add 1 to damage groups.

-- TODO add Mineclonia/VoxeLibre support.

local S = core.get_translator("gigatools_excavators")



-- Returns whether the mod with the given name is enabled.
local function is_mod_enabled(name)
   return nil ~= core.get_modpath(name)
end

--- Registers a new excavator toolitem.
-- @param name Item name.
-- @param crafting_material The name of the item to use as the crafting material
-- for the head of the excavator.
-- @param definition The item's definition as expected by core.register_tool().
local function register_excavator(name, crafting_material, definition)
   definition.wield_image = definition.inventory_image .. "^[transformR90"
   definition.sound       = { breaks  = "default_tool_breaks" }
   definition.groups      = { shovel = 1 }
   core.register_tool(name, definition)

   gigatools.register_multinode_tool(name, 3, 3, 1)

   core.register_craft({
        output = name,
        recipe = {
            { "", crafting_material, "" },
            { "", "group:stick",     "" },
            { "", "group:stick",     "" }
        }
    })
end



if is_mod_enabled("default") then
   register_excavator("gigatools_excavators:excavator_bronze", "default:bronzeblock", {
       description     = S("Bronze Excavator"),
       inventory_image = "gigatools_excavators_bronze_excavator.png",

       tool_capabilities = {
           full_punch_interval = 1.87,
           max_drop_level      = 1,
           damage_groups       = { fleshy = 4 },

           groupcaps = {
              crumbly = { times = { [1] = 2.805, [2] = 1.785, [3] = 0.765 }, uses = 225, maxlevel = 2 },
           }
       }
   })

   register_excavator("gigatools_excavators:excavator_steel", "default:steelblock", {
     description     = S("Steel Excavator"),
     inventory_image = "gigatools_excavators_steel_excavator.png",

     tool_capabilities = {
        full_punch_interval = 1.87,
        max_drop_level      = 1,
        damage_groups       = { fleshy = 4 },

        groupcaps = {
           crumbly = { times = { [1] = 2.55, [2] = 1.53, [3] = 0.68 }, uses = 270, maxlevel = 2 }
        }
     }
   })

   register_excavator("gigatools_excavators:excavator_mese", "default:mese", {
       description     = S("Mese Excavator"),
       inventory_image = "gigatools_excavators_mese_excavator.png",
       tool_capabilities = {
           full_punch_interval = 1.7,
           max_drop_level      = 3,
           damage_groups       = { fleshy = 5 },

           groupcaps={
               crumbly = { times = { [1] = 2.04, [2] = 1.02, [3] = 0.51 }, uses = 225, maxlevel = 3 },
           }
       }
   })

   register_excavator("gigatools_excavators:excavator_diamond", "default:diamondblock", {
       description     = S("Diamond Excavator"),
       inventory_image = "gigatools_excavators_diamond_excavator.png",

       tool_capabilities = {
           full_punch_interval = 1.7,
           max_drop_level      = 3,
           damage_groups       = { fleshy = 5 },

           groupcaps = {
               crumbly = { times = { [1] = 1.87, [2] = 0.85, [3] = 0.51 }, uses = 270, maxlevel = 3 },
           }
       }
   })
end
