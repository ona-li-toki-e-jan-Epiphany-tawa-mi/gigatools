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

-- Gigatools core mod.
-- Handles inner workings of multi-node digging tools.

-- TODO switch from using global register table to item metadata.
-- TODO add omnidrills that have multiple dig modes.
-- TODO add scythes which till in a 3x3.
-- TODO add sickles for breaking leaves/other plants in 3x3x3. snappy group



-- Private namespace for internal functions.
local _gigatools = {}

--- Wrapper for core.log().
-- Adds a prefix to the text inidicating that the log message comes from
-- Gigatools.
-- @param level One of "none", "error", "warning", "action", "info", or "verbose".
-- @param text The log message.
function _gigatools.log(level, text)
   core.log(level, "[gigatools] " .. text)
end

--- Resolves item name aliases.
function _gigatools.resolve_alias(name)
   return core.registered_aliases[name] or name
end

--- Loads and executes a Gigatools Lua module.
-- @param path The file path of the module relative to the Gigatools directory.
-- @return The return value of the Lua module.
function _gigatools.load_module(path)
   return loadfile(core.get_modpath("gigatools") .. "/" .. path)(_gigatools)
end



_gigatools.load_module("api.lua")
_gigatools.load_module("dig.lua")
