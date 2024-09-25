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

-- Gigatools lumber axes submod.
-- Like axes, but dig in a 3x3x3.

-- NOTE: when adding new lumberaxes, multiply base item punch/dig speeds by 1.7,
-- uses by 9, and add 1 to damage groups.

-- TODO add Mineclonia/VoxeLibre support.

local S = minetest.get_translator("gigatools_lumber_axes")



-- Returns whether the mod with the given name is enabled.
local function is_mod_enabled(name)
   return nil ~= minetest.get_modpath(name)
end

--- Registers a new lumber axe toolitem.
-- @param name Item name.
-- @param crafting_material The name of the item to use as the crafting material
-- for the head of the lumber axe.
-- @param definition The item's definition as expected by
-- minetest.register_tool().
local function register_lumber_axe(name, crafting_material, definition)
   minetest.register_tool(name, definition)
   gigatools.register_multinode_tool(name, 3, 3, 3)

   minetest.register_craft({
        output = name,
        recipe = {
            { crafting_material, crafting_material, "" },
            { crafting_material, "group:stick",     "" },
            { "",                "group:stick",     "" }
        }
    })
end



if is_mod_enabled("default") then
   register_lumber_axe("gigatools_lumber_axes:lumber_axe_bronze", "default:bronzeblock", {
       description     = S("Bronze Lumber Axe"),
       inventory_image = "gigatools_lumber_axes_bronze_lumber_axe.png",
       sound           = { breaks = "default_tool_breaks" },
       groups          = { axe    = 1 },

       tool_capabilities = {
           full_punch_interval = 1.7,
           max_drop_level      = 1,
           damage_groups       = { fleshy = 5 },

           groupcaps = {
              choppy = { times = { [1] = 4.65, [2] = 2.89, [3] = 1.955 }, uses = 180, maxlevel = 2 },
           }
       }
   })

   register_lumber_axe("gigatools_lumber_axes:lumber_axe_steel", "default:steelblock", {
     description     = S("Steel Lumber Axe"),
     inventory_image = "gigatools_lumber_axes_steel_lumber_axe.png",
     sound           = { breaks = "default_tool_breaks" },
     groups          = { axe    = 1 },

     tool_capabilities = {
        full_punch_interval = 1.7,
        max_drop_level      = 1,
        damage_groups       = { fleshy = 5 },

        groupcaps = {
           choppy = { times = { [1] = 4.25, [2] = 2.38, [3] = 1.7 }, uses = 180, maxlevel = 2 }
        }
     }
   })

   register_lumber_axe("gigatools_lumber_axes:lumber_axe_mese", "default:mese", {
       description     = S("Mese Lumber Axe"),
       inventory_image = "gigatools_lumber_axes_mese_lumber_axe.png",
       sound           = { breaks = "default_tool_breaks" },
       groups          = { axe    = 1 },

       tool_capabilities = {
           full_punch_interval = 1.53,
           max_drop_level      = 3,
           damage_groups       = { fleshy = 7 },

           groupcaps={
               choppy = { times = { [1] = 3.74, [2] = 1.7, [3] = 1.02 }, uses = 180, maxlevel = 3 },
           }
       }
   })

   register_lumber_axe("gigatools_lumber_axes:lumber_axe_diamond", "default:diamondblock", {
       description     = S("Diamond Lumber Axe"),
       inventory_image = "gigatools_lumber_axes_diamond_lumber_axe.png",
       sound           = { breaks = "default_tool_breaks" },
       groups          = { axe    = 1 },

       tool_capabilities = {
           full_punch_interval = 1.53,
           max_drop_level      = 3,
           damage_groups       = { fleshy = 6 },

           groupcaps = {
               choppy = { times = { [1] = 3.57, [2] = 1.53, [3] = 0.85 }, uses = 270, maxlevel = 3 },
           }
       }
   })
end
