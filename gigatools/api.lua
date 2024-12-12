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



--- Asserts the validity of a dimension size for
--- @{gigatools.registered_multinode_tools}.
-- @param size The size value.
-- @param can_be_even Whether the dimension can be even.
-- @param name The name of the size (i.e. "width") to show in error logs.
local function assert_valid_dimension_size(size, can_be_even, name)
   assert(
      "number" == type(size),
      "expected number for " .. name .. " parameter, got '" .. type(size) .. "'"
   )
   assert(
      1 <= size,
      "expected number >= 1 for " .. name .. " parameter, got '" .. size .. "'"
   )
   assert(
      size == math.floor(size),
      "expected integer for " .. name .. " parameter, got float (" .. size
      .. ")"
   )
   assert(
      can_be_even or 0 ~= size % 2,
      "expected odd number for " .. name .. "parameter, got even (" .. size
      .. ")"
   )
end



-- README:
--
-- To make an item a multinode tool, you need to set _gigatools in it's
-- definition when registering it.
--
-- Do not create this value yourself. Instead, use
-- @{gigatools.multinode_definition} to construct the value.
--
-- Arbitrary example:
-- core.register_tool("example:some_tool", {
--      description = S("Some Tool"),
--      -- Dig in a 3x3x3 cube.
--      _gigatools = gigatools.multinode_definition(3, 3, 3)
-- })

-- Global namespace.
gigatools = {}

--- Creates a table that you can assign to _gigatools in an item definition.
-- @param width The width of the cuboid to dig. Must be an odd integer >= 1.
-- @param height The height of the cuboid to dig. Must be an odd integer >= 1.
-- @param depth The depth of the cuboid to dig. Must be an integer != 0.
function gigatools.multinode_definition(width, height, depth)
   local __func__ = "gigatools.register_multinode_tool"

   assert_valid_dimension_size(width,  false, "width")
   assert_valid_dimension_size(height, false, "height")
   assert_valid_dimension_size(depth,  true,  "depth")

   return {
      width  = width,
      height = height,
      depth  = depth
   }
end

--- Returns the multinode node dig dimensions of the given item.
-- @return The dimensions, or nil, if they were not present in the item's
-- definition.
function gigatools.get_dimensions(item)
   return item:get_definition()._gigatools
end
