-- I am ssh.lua and I should live in ~/.config/wezterm/ssh.lua

local ssh_domains = {
	{
		name = "SERVER NAME",
		remote_address = "YOUR IP HERE",
		username = "YOUR USERNAME HERE",
		multiplexing = "None",
	},
	{
		name = "SERVER NAME",
		remote_address = "YOUR IP HERE",
		username = "YOUR USERNAME HERE",
		multiplexing = "None",
	},
}

-- This is the module table that we will export
local module = {}
-- define a function in the module table.
-- Only functions defined in `module` will be exported to
-- code that imports this module.
-- The suggested convention for making modules that update
-- the config is for them to export an `apply_to_config`
-- function that accepts the config object, like this:
function module.apply_to_config(config) end

return module
