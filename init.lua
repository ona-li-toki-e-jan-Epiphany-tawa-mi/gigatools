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



-- Private namespace for internal functions.
local _gigatools = {}

--- Wrapper for minetest.log().
-- Adds a prefix to the text inidicating that the log message comes from
-- Gigatools.
-- @param level One of "none", "error", "warning", "action", "info", or "verbose".
-- @param text The log message.
function _gigatools.log(level, text)
   minetest.log(level, "[gigatools] " .. text)
end

--- Loads and executes a Gigatools Lua module.
-- @param path The file path of the module relative to the Gigatools directory.
-- @return The return value of the Lua module.
function _gigatools.load_module(path)
   return loadfile(minetest.get_modpath("gigatools") .. "/" .. path)(_gigatools)
end

-- Returns whether the mod with the given name is enabled.
function _gigatools.is_mod_enabled(name)
   return nil ~= minetest.get_modpath(name)
end



_gigatools.load_module("src/hammer.lua")
