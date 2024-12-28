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

local S = core.get_translator("gigatools_hammers")

--- Returns whether the mod with the given name is enabled.
--- @param name string
--- @return boolean
local function is_mod_enabled(name)
   return nil ~= core.get_modpath(name)
end

--------------------------------------------------------------------------------
-- default support (i.e. Minetest Game.)                                      --
--------------------------------------------------------------------------------

if is_mod_enabled("default") then
   -- TODO: see if values can be pulled from original tools.
   --- @param name string
   --- @param crafting_material string
   --- @param definition ItemDefinition
   local function register_hammer(name, crafting_material, definition)
      definition.sound        = definition.sound or {}
      definition.sound.breaks = "default_tool_breaks"

      definition.groups         = definition.groups or {}
      definition.groups.pickaxe = 1

      definition._gigatools = gigatools.multinode_definition(3, 3, 1)

      core.register_tool(name, definition)

      core.register_craft({
            output = name,
            recipe = {
               { crafting_material, crafting_material, crafting_material },
               { "",                "group:stick",     ""                },
               { "",                "group:stick",     ""                }
            }
      })
   end

   register_hammer("gigatools_hammers:hammer_bronze", "default:bronzeblock", {
       description     = S("Bronze Hammer"),
       inventory_image = "gigatools_hammers_bronze_hammer.png",

       tool_capabilities = {
          full_punch_interval = 1.7,
          max_drop_level      = 1,
          damage_groups       = { fleshy = 5 },

          groupcaps = {
             cracky = {
                times = { [1] = 7.65, [2] = 3.06, [3] = 1.53 },
                uses = 180,
                maxlevel = 2
             },
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
           cracky = {
              times = { [1] = 6.8, [2] = 2.72, [3] = 1.36 },
              uses = 180,
              maxlevel = 2
           }
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
             cracky = {
                times = { [1] = 4.08, [2] = 2.04, [3] = 1.02 },
                uses = 180,
                maxlevel = 3
             },
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
             cracky = {
                times = { [1] = 3.4, [2] = 1.7, [3] = 0.85 },
                uses = 270,
                maxlevel = 3
             },
          }
       }
   })
end

--------------------------------------------------------------------------------
-- mcl_tools support (i.e. Mineclonia.)                                       --
--------------------------------------------------------------------------------

if is_mod_enabled("mcl_tools") then
   --- @param name string
   --- @param crafting_material string|nil The material to craft the hammer, or
   --- nil, for no recipe.
   --- @param derivative_tool ItemDefinition The tool definition of the pickaxe
   --- that the hammer derives from.
   --- @param material_set table The material set that the hammer derives from.
   --- @param definition ItemDefinition
   local function register_hammer( name
                                 , crafting_material
                                 , derivative_tool
                                 , material_set
                                 , definition
                                 )
      definition.sound        = definition.sound or {}
      definition.sound.breaks = "default_tool_breaks"

      definition.groups = table.merge(
         material_set.groups,
         definition.groups or {}
      )
      definition.groups.pickaxe      = 1
      definition.groups.tool         = 1
      definition.groups.offhand_item = 1

      definition.tool_capabilities = definition.tool_capabilities or {}
      definition.tool_capabilities.full_punch_interval = 1.7 *
         derivative_tool.tool_capabilities.full_punch_interval
      definition.tool_capabilities.damage_groups =
         definition.tool_capabilities.damage_groups or {}
      definition.tool_capabilities.damage_groups.fleshy = 1 +
         derivative_tool.tool_capabilities.damage_groups.fleshy
      definition.tool_capabilities.max_drop_level = material_set.max_drop_level

      definition._mcl_diggroups = definition._mcl_diggroups or {}
      definition._mcl_diggroups.pickaxey = {
         uses  = 9 * material_set.uses,
         level = material_set.level,
         speed = material_set.speed / 1.7,
      }

      definition._mcl_toollike_wield = true
      definition._repair_material    = material_set.material
      definition.wield_scale         = mcl_vars.tool_wield_scale
      definition._doc_items_longdesc  = S(
         "Hammers are mining tools to mine hard blocks, such as stone, in a "
         .. "3x3 plane. A hammer can also be used as weapon, but it is rather "
         .. "inefficient."
      )

      definition._gigatools = gigatools.multinode_definition(3, 3, 1)

      core.register_tool(name, definition)

      if nil ~= crafting_material then
         core.register_craft({
               output = name,
               recipe = {
                  { crafting_material, crafting_material, crafting_material },
                  { "",                "mcl_core:stick",  ""                },
                  { "",                "mcl_core:stick",  ""                },
               },
         })
      end
   end

   register_hammer( "gigatools_hammers:hammer_iron"
                  , "mcl_core:ironblock"
                  , core.registered_tools["mcl_tools:pick_iron"]
                  , mcl_tools.sets["iron"]
                  , {
      description     = S("Iron Hammer"),
      inventory_image = "gigatools_hammers_steel_hammer.png",
   })
   register_hammer( "gigatools_hammers:hammer_gold"
                  , "mcl_core:goldblock"
                  , core.registered_tools["mcl_tools:pick_gold"]
                  , mcl_tools.sets["gold"]
                  , {
      description     = S("Golden Hammer"),
      inventory_image = "gigatools_hammers_mese_hammer.png",
   })
   register_hammer( "gigatools_hammers:hammer_diamond"
                  , "mcl_core:diamondblock"
                  , core.registered_tools["mcl_tools:pick_diamond"]
                  , mcl_tools.sets["diamond"]
                  , {
      description     = S("Diamond Hammer"),
      inventory_image = "gigatools_hammers_diamond_hammer.png",

      -- Allows upgrading to netherite.
      _mcl_upgradable   = true,
      _mcl_upgrade_item = "gigatools_hammers:hammer_netherite",
   })
   register_hammer( "gigatools_hammers:hammer_netherite"
                  , nil
                  , core.registered_tools["mcl_tools:pick_netherite"]
                  , mcl_tools.sets["netherite"]
                  , {
      description = S("Netherite Hammer"),
      -- TODO make netherite hammer texture.
   })
end
