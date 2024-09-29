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

--- Asserts the validity of a dimension size for
--- @{gigatools.registered_multinode_tools}.
-- @param size The size value.
-- @param can_be_even Whether the dimension can be even.
-- @param name The name of the size (i.e. "width") to show in error logs.
local function assert_valid_dimension_size(size, can_be_even, name)
   assert("number" == type(size), "expected number for " .. name .. " parameter, got '" .. type(size) .. "'")
   assert(1 <= size, "expected number >= 1 for " .. name .. " parameter, got '" .. size .. "'")
   assert(size == math.floor(size), "expected integer for " .. name .. " parameter, got float (" .. size .. ")")
   assert(can_be_even or 0 ~= size % 2, "expected odd number for " .. name .. "parameter, got even (" .. size
          .. ")")
end

--- Registers a toolitem as a multinode dig tool.
-- @param name The item's name.
-- @param width The width of the cuboid to dig. Must be an odd integer >= 1.
-- @param height The height of the cuboid to dig. Must be an odd integer >= 1.
-- @param depth The depth of the cuboid to dig. Must be an integer != 0.
function gigatools.register_multinode_tool(name, width, height, depth)
   local __func__ = "gigatools.register_2d_tool"

   assert("string" == type(name), "expected string for name parameter, got '" .. type(name) .. "'")
   assert_valid_dimension_size(width,  false, "width")
   assert_valid_dimension_size(height, false, "height")
   assert_valid_dimension_size(depth,  true,  "depth")

   _gigatools.log("verbose", __func__  .. ": registered multinode toolitem '" .. name .. "'")
   gigatools.registered_multinode_tools[_gigatools.resolve_alias(name)] = {
      width  = width,
      height = height,
      depth  = depth
   }
end
