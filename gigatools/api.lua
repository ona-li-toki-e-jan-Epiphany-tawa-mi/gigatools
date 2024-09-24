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

-- Gigatools API module.

-- Imports private namespace.
local _gigatools = ...



-- Global namespace.
gigatools = {}

--- A table of 2D dig tools.
-- Keys are full item names (no aliases,) values are a table with the following elements:\
--   width: the width of the plane to dig.
--   height: the height of the plane to dig.
-- Do not edit directly, use gigatools.register_2d_tool() instead.
gigatools.registered_2d_tools = {}

-- TODO Throw error on fractional dimensions.
-- TODO Throw error on registering even dimensions.
--- Registers a toolitem as a 2D dig tool.
-- @param name The item's name.
-- @param width The width of the plane to dig.
-- @param height The height of the plane to dig.
-- @return Whether the item was successfully registered.
function gigatools.register_2d_tool(name, width, height)
   local __func__ = "gigatools.register_2d_tool"

   if "string" ~= type(name) then
      _gigatools.log("error", __func__ .. ": got invalid name '" .. dump(name)
                              .. "'. Expected string, got '" .. type(name) .. "'")
      return false
   end

   if "number" ~= type(width) then
      _gigatools.log("error", __func__ .. ": got invalid width '" .. dump(width)
                              .. "'. Expected number, got '" .. type(width) .. "'")
      return false
   end
   if 1 > width then
      _gigatools.log("error", __func__ .. ": got invalid width '" .. width
                              .. "'. Expected number >= 1")
      return false
   end

   if "number" ~= type(height) then
      _gigatools.log("error", __func__ .. ": got invalid height '" .. dump(height)
                              .. "'. Expected string number, got '" .. type(height) .. "'")
      return false
   end
   if 1 > height then
      _gigatools.log("error", __func__ .. ": got invalid height '" .. height
                              .. "'. Expected number greater than or equal to 1")
      return false
   end

   _gigatools.log("verbose", __func__  .. ": registered 2D toolitem '" .. name .. "'")
   gigatools.registered_2d_tools[_gigatools.resolve_alias(name)] = { width = width, height = height }
   return true
end
