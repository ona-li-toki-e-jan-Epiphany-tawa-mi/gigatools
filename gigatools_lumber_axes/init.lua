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

-- TODO: abstract magic values into variables.

local S = core.get_translator("gigatools_lumber_axes")

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
   --- @param name string
   --- @param crafting_material string
   --- @param derivative_tool ItemDefinition The tool definition of the axe that
   --- the lumber axe derives from.
   --- @param definition ItemDefinition
   local function register_lumber_axe( name
                                     , crafting_material
                                     , derivative_tool
                                     , definition
                                     )
      definition.sound = { breaks = "default_tool_breaks" }

      definition.groups = { axe = 1 }

      definition.tool_capabilities = {
         full_punch_interval = 1.7 *
            derivative_tool.tool_capabilities.full_punch_interval,
         max_drop_level = derivative_tool.tool_capabilities.max_drop_level,
         damage_groups = {
            fleshy = 1 + derivative_tool.tool_capabilities.damage_groups.fleshy,
         },
         groupcaps = {
            choppy = {
               uses = 9 *
                  derivative_tool.tool_capabilities.groupcaps.choppy.uses,
               maxlevel =
                  derivative_tool.tool_capabilities.groupcaps.choppy.maxlevel,
               times = {
                  [1] = 1.7 *
                     derivative_tool.tool_capabilities.groupcaps.choppy.times[1],
                  [2] = 1.7 *
                     derivative_tool.tool_capabilities.groupcaps.choppy.times[2],
                  [3] = 1.7 *
                     derivative_tool.tool_capabilities.groupcaps.choppy.times[3],
               },
            },
         },
      }

      definition._gigatools = gigatools.multinode_definition(3, 3, 3)

      core.register_tool(name, definition)

      core.register_craft({
            output = name,
            recipe = {
               { crafting_material, crafting_material, "" },
               { crafting_material, "group:stick",     "" },
               { "",                "group:stick",     "" }
            }
      })
   end

   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_bronze"
                      , "default:bronzeblock"
                      , core.registered_tools["default:axe_bronze"]
                      , {
       description     = S("Bronze Lumber Axe"),
       inventory_image = "gigatools_lumber_axes_bronze_lumber_axe.png",
   })
   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_steel"
                      , "default:steelblock"
                      , core.registered_tools["default:axe_steel"]
                      , {
     description     = S("Steel Lumber Axe"),
     inventory_image = "gigatools_lumber_axes_steel_lumber_axe.png",
   })
   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_mese"
                      , "default:mese"
                      , core.registered_tools["default:axe_mese"]
                      , {
       description     = S("Mese Lumber Axe"),
       inventory_image = "gigatools_lumber_axes_mese_lumber_axe.png",
   })
   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_diamond"
                      , "default:diamondblock"
                      , core.registered_tools["default:axe_diamond"]
                      , {
       description     = S("Diamond Lumber Axe"),
       inventory_image = "gigatools_lumber_axes_diamond_lumber_axe.png",
   })
end

--------------------------------------------------------------------------------
-- mcl_tools support (i.e. Mineclonia.)                                       --
--------------------------------------------------------------------------------

if is_mod_enabled("mcl_tools") then
   --- @param name string
   --- @param crafting_material string|nil The material to craft the lumber axe,
   --- or nil, for no recipe.
   --- @param derivative_tool ItemDefinition The tool definition of the axe that
   --- the lumber axe derives from.
   --- @param material_set table The material set that the lumber axe derives
   --- from.
   --- @param definition ItemDefinition
   local function register_lumber_axe( name
                                     , crafting_material
                                     , derivative_tool
                                     , material_set
                                     , definition
                                     )
      definition.sound = { breaks = "default_tool_breaks" }

      definition.groups = {
         axe          = 1,
         tool         = 1,
         offhand_item = 1,
      }

      definition.tool_capabilities = {
         full_punch_interval = 1.7 *
            derivative_tool.tool_capabilities.full_punch_interval,
         damage_groups = {
            fleshy = 1 +
               derivative_tool.tool_capabilities.damage_groups.fleshy,
         },
         max_drop_level = material_set.max_drop_level,
      }

      definition._mcl_diggroups = {
         axey = {
            uses  = 9 * material_set.uses,
            level = material_set.level,
            speed = material_set.speed / 1.7,
         },
      }

      definition._mcl_toollike_wield = true
      definition._repair_material    = material_set.material
      definition.wield_scale         = mcl_vars.tool_wield_scale
      definition._doc_items_longdesc  = S(
         "A lumber axe is your tool of choice to cut down trees, wood-based "
         .. "blocks and other blocks, and do so in a 3x3x3 cubiod. Lumber axes "
         .. "deal a lot of damage as well, but they are rather slow."
      )

      definition._gigatools = gigatools.multinode_definition(3, 3, 3)

      core.register_tool(name, definition)

      if nil ~= crafting_material then
         core.register_craft({
               output = name,
               recipe = {
                  { crafting_material, crafting_material, "" },
                  { crafting_material, "mcl_core:stick",  "" },
                  { "",                "mcl_core:stick",  "" },
               },
         })
      end
   end

   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_iron"
                      , "mcl_core:ironblock"
                      , core.registered_tools["mcl_tools:shovel_iron"]
                      , mcl_tools.sets["iron"]
                      , {
      description     = S("Iron Lumber Axe"),
      inventory_image = "gigatools_lumber_axes_steel_lumber_axe.png",
   })
   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_gold"
                      , "mcl_core:goldblock"
                      , core.registered_tools["mcl_tools:shovel_gold"]
                      , mcl_tools.sets["gold"]
                      , {
      description     = S("Golden Lumber Axe"),
      inventory_image = "gigatools_lumber_axes_gold_lumber_axe.png",
   })
   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_diamond"
                      , "mcl_core:diamondblock"
                      , core.registered_tools["mcl_tools:shovel_diamond"]
                      , mcl_tools.sets["diamond"]
                      , {
      description     = S("Diamond Lumber Axe"),
      inventory_image = "gigatools_lumber_axes_diamond_lumber_axe.png",

      -- Allows upgrading to netherite.
      _mcl_upgradable   = true,
      _mcl_upgrade_item = "gigatools_lumber_axes:lumber_axe_netherite",
   })
   register_lumber_axe( "gigatools_lumber_axes:lumber_axe_netherite"
                      , nil
                      , core.registered_tools["mcl_tools:shovel_netherite"]
                      , mcl_tools.sets["netherite"]
                      , {
      description     = S("Netherite Lumber Axe"),
      inventory_image = "gigatools_lumber_axes_netherite_lumber_axe.png",
   })
end
