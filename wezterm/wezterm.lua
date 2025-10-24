-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set TERM to constructed wezterm in ~/.terminfo/w/wezterm
config.term = "wezterm"

-- This is where you actually apply your config choices
local startup_settings = require("startup")
startup_settings.apply_to_config(config)

local window_settings = require("window")
window_settings.apply_to_config(config)

local tabbar_settings = require("tabbar")
tabbar_settings.apply_to_config(config)

local font_settings = require("fonts")
font_settings.apply_to_config(config)

local cursor_settings = require("cursor")
cursor_settings.apply_to_config(config)

local keymap_settings = require("keymaps")
keymap_settings.apply_to_config(config)

-- return the configuration to wezterm
return config
