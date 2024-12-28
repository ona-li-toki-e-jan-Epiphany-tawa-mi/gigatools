# Gigatools

A mod pack for Luanti [https://www.luanti.org](https://www.luanti.org/) that
adds an API for creating tools that can dig large areas, and some user-focused
content mods to go along with it.

## gigatools

`gigatools` is the main mod, and is an API that makes it easy to implement tools
that can dig large areas.

Tools can be set to dig lines, planes, and cuboids of arbitrary size.

This can be set as part of a tool definition to apply to all tools of a
paticular name, or dynamically applied to individual item stacks using
metadata.

See the API in `gigatools/api.lua` for more details.

## gigatools\_hammers

`gigatools_hammers` is a mod provided with gigatools that uses the API to add
hammers, which are like pickaxes, but dig in a 3x3 plane.

Hammers are made with the same materials as their pickaxe counterparts, but with
blocks instead of ingots/gems.

If the mod `default` (i.e. Minetest Game) is present, adds hammers for the
following materials:

- Bronze.
- Steel.
- Diamond.
- Mese.

If the mod `mcl_tools` (i.e. Mineclonia, VoxeLibre) is present, adds hammers for
the following materials:

- Iron.
- Gold.
- Diamond.
- Netherite.

## gigatools\_excavators

`gigatools_excavators` is a mod provided with gigatools that uses the API to add
excavators, which are like shovels, but dig in a 3x3 plane.

Excavators are made with the same materials as their shovel counterparts, but
with blocks instead of ingots/gems.

If the mod `default` (i.e. Minetest Game) is present, adds excavators for the
following materials:

- Bronze.
- Steel.
- Diamond.
- Mese.

If the mod `mcl_tools` (i.e. Mineclonia, VoxeLibre) is present, adds excavators for
the following materials:

- Iron.
- Gold.
- Diamond.
- Netherite.

## gigatools\_lumber\_axes

`gigatools_lumber_axes` is a mod provided with gigatools that uses the API to
add lumber axes, which are like axes, but dig in a 3x3x3 cuboid.

Lumber axes are made with the same materials as their axe counterparts, but with
blocks instead of ingots/gems.

If the mod `default` (i.e. Minetest Game) is present, adds lumber axes for the
following materials:

- Bronze.
- Steel.
- Diamond.
- Mese.

If the mod `mcl_tools` (i.e. Mineclonia, VoxeLibre) is present, adds lumber axes
for the following materials:

- Iron.
- Gold.
- Diamond.
- Netherite.

## How to install

You can place this directory, or symlink it, into the mods folder in your
Luanti directory.

## Licensing

`LEGAL.md` contains the information on licensing for source code and other
assets.

## How to test

Dependencies:

- Lua - [https://www.lua.org](https://www.lua.org/)
- lua-language-server - [https://github.com/LuaLS/lua-language-server](https://github.com/LuaLS/lua-language-server)

There is a `flake.nix` you can use with `nix develop` to generate a development
enviroment.

Then, run the following command(s):

```sh
./tools/static-analysis.lua
```
