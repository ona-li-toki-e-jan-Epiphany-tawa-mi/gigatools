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

--- @param x number
--- @param tolerance? number
--- @return 1|0|-1
function math.sign(x, tolerance) return 0 end

--- @param table table
--- @return table
function table.copy(table) return {} end

--- @alias ItemDefinition table

--- @alias ObjectRef {
---     set_wielded_item: fun(self: ObjectRef, item: ItemStack),
---     get_wielded_item: (fun(self: ObjectRef): ItemStack),
---     get_player_name: (fun(self: ObjectRef): string),
---     get_look_horizontal: (fun(self: ObjectRef): number),
---     is_player: (fun(self: ObjectRef): boolean),
--- }
--- @alias Player ObjectRef

--- @alias ToolCapabilities table
--- @alias ItemStackMetaRef {
---     set_tool_capabilities: (fun(self: ItemStackMetaRef, capabilities: ToolCapabilities|nil)),
--- }
--- @alias ItemStack {
---     get_tool_capabilities: (fun(self: ItemStack): ToolCapabilities),
---     get_meta: (fun(self: ItemStack): ItemStackMetaRef),
--- }

--- @alias Node { name: string }

--- @alias Vector { x: integer, y: integer, z: integer }
--- @alias NodePointedThing { above: Vector, under: Vector }

--- From mcl_utils
--- @param t table
--- @param ... table
--- @return table
function table.merge(t, ...) return {} end
