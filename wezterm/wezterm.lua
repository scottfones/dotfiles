-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local startup_settings = require("startup")
startup_settings.apply_to_config(config)

local window_settings = require("window")
window_settings.apply_to_config(config)

local font_settings = require("fonts")
font_settings.apply_to_config(config)

-- return the configuration to wezterm
return config
