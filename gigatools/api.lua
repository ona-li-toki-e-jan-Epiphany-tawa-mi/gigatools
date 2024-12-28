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



--- Asserts the validity of a dimension size.
--- @param size integer The size value.
--- @param can_be_even boolean Whether the dimension can be even.
--- @param name string The name of the size (i.e. "width") to show in error
--- logs.
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

-- Keys for storing multinode dimensions in item metadata.
local width_meta_key  = "gigatools_width"
local height_meta_key = "gigatools_height"
local depth_meta_key  = "gigatools_depth"



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
--
-- You can also set an individual itemstack to have custom multinode dimensions,
-- see gigatools.make_multinode().

--- @alias MultinodeDefinition { width: integer, height: integer, depth: integer }

-- Global namespace.
gigatools = {}

--- Creates a table that you can assign to _gigatools in an item definition.
--- @param width integer The width of the cuboid to dig. Must be odd and >= 1.
--- @param height integer The height of the cuboid to dig. Must be odd and >= 1.
--- @param depth integer The depth of the cuboid to dig. Must be >= 0.
--- @return MultinodeDefinition
function gigatools.multinode_definition(width, height, depth)
   assert_valid_dimension_size(width,  false, "width")
   assert_valid_dimension_size(height, false, "height")
   assert_valid_dimension_size(depth,  true,  "depth")

   return {
      width  = width,
      height = height,
      depth  = depth
   }
end

--- Sets an individual item to have custom multinode dimensions. Overrides the
--- dimensions in the item's definition.
--- @param width integer The width of the cuboid to dig. Must be odd and >= 1.
--- @param height integer The height of the cuboid to dig. Must be odd and >= 1.
--- @param depth integer The depth of the cuboid to dig. Must be >= 0.
function gigatools.make_multinode(item, width, height, depth)
   assert_valid_dimension_size(width,  false, "width")
   assert_valid_dimension_size(height, false, "height")
   assert_valid_dimension_size(depth,  true,  "depth")

   local meta = item:get_meta()
   meta:set_int(width_meta_key, width)
   meta:set_int(height_meta_key, height)
   meta:set_int(depth_meta_key, depth)
end

--- Returns the multinode node dig dimensions of the given item.
--- @return MultinodeDefinition|nil The dimensions, or nil, if they are not
--- present.
function gigatools.get_dimensions(item)
   local meta   = item:get_meta()
   local width  = meta:get_int(width_meta_key)
   local height = meta:get_int(height_meta_key)
   local depth  = meta:get_int(depth_meta_key)

   if 0 ~= width and 0 ~= height and 0 ~= depth then
      return {
         width  = width,
         height = height,
         depth  = depth
      }
   end

   return item:get_definition()._gigatools
end
