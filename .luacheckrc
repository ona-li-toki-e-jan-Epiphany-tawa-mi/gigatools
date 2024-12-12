-- -*- lua -*-

-- luacheck configuration.

-- Removes warning for use of non-standard global variables.
allow_defined_top = true

-- Removes warning for use of Luanti namespace.
globals = { "core" }

-- Removes warning for use of non-standard fields in standard global namspaces.
read_globals = {
   table = { fields = { "copy" } },
   math  = { fields = { "sign" } }
}
