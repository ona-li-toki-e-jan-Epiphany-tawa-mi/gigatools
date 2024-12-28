#!/usr/bin/env lua

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

-- gigatools static analysis testing script.
--
-- Run './tools/test.lua' in the project directory to run tests.

local json = dofile("tools/json.lua")



--- Runs the given shell command. Crashes if it fails.
--- @param command string
local function run(command)
   print("+ " .. command)
   local success = os.execute(command)
   if not success then
      os.exit(false)
   end
end

--- Reads in the entire file at the given oath. Crashes if it fails.
--- @param file_path string
--- @return string
local function read_file(file_path)
   local file, error_message = io.open(file_path)
   if not file then
      print("ERROR: " .. error_message)
      os.exit(false)
   end

   local contents = file:read("*a")

   file:close()
   return contents
end



local lls_path = ".lls"
run("lua-language-server --check . --logpath " .. lls_path)
local report = read_file(lls_path .. "/check.json")

if "[]" ~= report then
   for file, issues in pairs(json.decode(report)) do
      for _, issue in pairs(issues) do
         local location = issue.range.start
         print(
            file .. ":" .. 1+location.line .. ":" .. 1+location.character
            .. ": " .. issue.message
         )
      end
   end
   os.exit(false)
end
