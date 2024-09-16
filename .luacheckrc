-- -*- lua -*-

-- luacheck configuration.



-- Removes warning for use of non-standard global variables.
allow_defined_top = true

-- Removes warning for use of the minetest namespace.
globals = { "minetest" }

read_globals = {
    -- Removes warning for using table methods.
    table = { fields = { "indexof", "copy" } },

    -- Removes warning for using builtin methods.
    "dump"
}
