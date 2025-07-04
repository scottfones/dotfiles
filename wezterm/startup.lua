-- I am startup.lua and I should live in ~/.config/wezterm/startup.lua
local wezterm = require("wezterm")

-- This is the module table that we will export
local module = {}
-- define a function in the module table.
-- Only functions defined in `module` will be exported to
-- code that imports this module.
-- The suggested convention for making modules that update
-- the config is for them to export an `apply_to_config`
-- function that accepts the config object, like this:
function module.apply_to_config(config)
	config.default_prog = { "/bin/bash", "-l" }
end

return module
