-- -*- lua -*-

-- luacheck configuration.

-- Removes warning for use of non-standard global variables.
allow_defined_top = true

-- Removes warning for use of global namespaces.
globals = { "core", "mcl_tools", "mcl_vars" }

-- Removes warning for use of non-standard fields in standard global namspaces.
read_globals = {
   table = {
      fields = {
         "copy",

         -- From mcl_tools.
         "merge",
      },
   },

   math  = { fields = { "sign" } },
}
