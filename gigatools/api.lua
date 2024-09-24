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

--- A table of multinode dig tools.
-- Keys are full item names (no aliases,) values are a table with the following elements:
--   width: the width of the cuboid to dig. Must be an odd integer >= 1.
--   height: the height of the cuboid to dig. Must be an odd integer >= 1.
--   depth: the depth of the cuboid to dig. Must be an integer != 0.
-- Do not edit directly, use @{gigatools.register_multinode_tool} instead.
gigatools.registered_multinode_tools = {}

--- Validates a dimension size for @{gigatools.registered_multinode_tools}.
-- @param size The size value.
-- @param can_be_even Whether the dimension can be even.
-- @param name The name of the size (i.e. "width") to show in error logs.
-- @param __func__ The name of the function to show in error logs.
-- @return Whether the size is valid.
local function is_dimension_size_valid(size, can_be_even, name, __func__)
   if "number" ~= type(size) then
      _gigatools.log("error", __func__ .. ": got invalid " .. name .. " '" .. dump(size)
                              .. "'. Expected number, got '" .. type(size) .. "'")
      return false
   end

   if 1 > size then
      _gigatools.log("error", __func__ .. ": got invalid " .. name .. " '" .. size
                              .. "'. Expected number >= 1")
      return false
   end

   if size ~= math.floor(size) then
      _gigatools.log("error", __func__ .. ": got invalid " .. name .. " '" .. size
                              .. "'. Expected integer, got float")
      return false
   end

   if not can_be_even and 0 == size % 2 then
      _gigatools.log("error", __func__ .. ": got invalid " .. name .. " '" .. size
                              .. "'. Expected odd number")
      return false
   end

   return true
end

--- Registers a toolitem as a multinode dig tool.
-- @param name The item's name.
-- @param width The width of the cuboid to dig. Must be an odd integer >= 1.
-- @param height The height of the cuboid to dig. Must be an odd integer >= 1.
-- @param depth The depth of the cuboid to dig. Must be an integer != 0.
-- @return Whether the item was successfully registered.
function gigatools.register_multinode_tool(name, width, height, depth)
   local __func__ = "gigatools.register_2d_tool"

   if "string" ~= type(name) then
      _gigatools.log("error", __func__ .. ": got invalid name '" .. dump(name)
                              .. "'. Expected string, got '" .. type(name) .. "'")
      return false
   end

   if not is_dimension_size_valid(width,  false, "width",  __func__) then return false end
   if not is_dimension_size_valid(height, false, "height", __func__) then return false end
   if not is_dimension_size_valid(depth,  true,  "depth",  __func__) then return false end

   _gigatools.log("verbose", __func__  .. ": registered multinode toolitem '" .. name .. "'")
   gigatools.registered_multinode_tools[_gigatools.resolve_alias(name)] = {
      width  = width,
      height = height,
      depth  = depth
   }
   return true
end
