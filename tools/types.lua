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

--- Common type aliases for lua-language-server static type checking.

--------------------------------------------------------------------------------
-- Core                                                                       --
--------------------------------------------------------------------------------

--- @alias ObjectRef {
---     set_wielded_item: fun(self: ObjectRef, item: ItemStack),
---     get_wielded_item: (fun(self: ObjectRef): ItemStack),
---     get_player_name: (fun(self: ObjectRef): string),
---     get_look_horizontal: (fun(self: ObjectRef): number),
---     is_player: (fun(self: ObjectRef): boolean),
--- }
--- @alias Player ObjectRef

--- @alias Rating integer
--- @alias Groups table<string, Rating>

--- @alias GroupCaps {}
--- @alias ToolCapabilities { groupcaps: GroupCaps? }
--- @alias ItemDefinition {
---     inventory_image: string?,
---     wield_image: string?,
---     tool_capabilities: ToolCapabilities?,
---     sound: {}?,
---     groups: Groups?,
---     wield_scale: Vector?,
---     [any]: any,
--- }
--- @alias ItemStackMetaRef {
---     set_tool_capabilities: (fun(self: ItemStackMetaRef, capabilities: ToolCapabilities|nil)),
--- }
--- @alias ItemStack {
---     get_tool_capabilities: (fun(self: ItemStack): ToolCapabilities),
---     get_meta: (fun(self: ItemStack): ItemStackMetaRef),
--- }

--- @alias NodeDefinition { groups: Groups? }
--- @alias Node { name: string }

--- @alias Vector { x: integer, y: integer, z: integer }

--- @alias NodePointedThing { type: "node", above: Vector, under: Vector }
--- @alias PointedThing { type: "nothing" } | NodePointedThing

--- @alias CraftRecipeShaped {
---     type?: "shaped",
---     output: string,
---     recipe: string[][],
--- }
--- @alias CraftRecipe CraftRecipeShaped

--- @alias LogLevel "none" | "error" | "warning" | "action" | "info" | "verbose"

--- @alias DigParams {
---     diggable: boolean,
---     time: number,
---     wear: integer,
--- }

--- @type {
---     registered_aliases: table<string, string>,
---     registered_tools: table<string, ItemDefinition>,
---     registered_nodes: table<string, NodeDefinition>,
---     log: fun(level: LogLevel|nil, text: string),
---     get_item_group: (fun(name: string, group: Groups): integer),
---     get_node: (fun(pos: Vector): Node),
---     get_modpath: (fun(modname: string): string|nil),
---     get_translator: (fun(modname: string): fun(text: string): string),
---     register_tool: fun(name: string, item_definition: ItemDefinition),
---     register_craft: fun(recipe: CraftRecipe),
---     get_dig_params: (fun(groups: table, tool_capabilities: ToolCapabilities, wear: integer?): DigParams),
---     node_dig: fun(pos: Vector, node: Node, digger: ObjectRef|nil),
---     register_on_dignode: fun(callback: fun(pos: Vector, oldnode: Node, digger: ObjectRef|nil)),
---     register_on_punchnode: fun(callback: fun(pos: Vector, node: Node, puncher: ObjectRef|nil, pointed_thing: NodePointedThing)),
--- }
core = {}

--- @param x number
--- @param tolerance? number
--- @return 1|0|-1
function math.sign(x, tolerance) return 0 end

--- @param table table
--- @return table
function table.copy(table) return {} end

--------------------------------------------------------------------------------
-- Mineclonia, VoxeLibre, etc.                                                --
--------------------------------------------------------------------------------

--- @type {}
mcl_vars = {}

--- @type {}
mcl_tools = {}

--- From mcl_utils
--- @param t table
--- @param ... table
--- @return table
function table.merge(t, ...) return {} end
