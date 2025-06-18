-- I am window.lua and I should live in ~/.config/wezterm/window.lua
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
	config.window_frame = {
		-- The font used in the tab bar.
		-- Roboto Bold is the default; this font is bundled
		-- with wezterm.
		-- Whatever font is selected here, it will have the
		-- main font setting appended to it to pick up any
		-- fallback fonts you may have used there.
		font = wezterm.font({ family = "MonaspiceNe Nerd Font Mono", weight = "Bold" }),

		-- The size of the font in the tab bar.
		-- Default to 10.0 on Windows but 12.0 on other systems
		font_size = 14.0,

		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = "#333333",

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = "#333333",
	}

	config.window_background_opacity = 0.75
	-- config.window_decorations = "RESIZE"

	config.colors = {
		tab_bar = {
			-- The color of the inactive tab bar edge/divider
			inactive_tab_edge = "#575757",
		},
	}
	-- config.color_scheme = "GruvboxDarkHard"
	-- config.color_scheme = "Gruvbox Material (Gogh)"
	-- config.color_scheme = "Gruvbox Dark (Gogh)"
	-- config.color_scheme = "Github Dark (Gogh)"
end

return module
