-- -*- lua -*-

-- luacheck configuration.

-- Removes warning for use of non-standard global variables.
allow_defined_top = true

-- Removes warning for use of global namespaces.
globals = { "core" }

read_globals = {
    -- Removes warning for using table methods.
    table = { fields = { "copy" } }
}
