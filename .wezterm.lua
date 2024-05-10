local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'Menlo'
config.font_size = 14

config.color_scheme = 'Catppuccin Mocha (Gogh)'
-- config.color_scheme = 'tokyonight_storm'
-- config.color_scheme = 'MaterialOcean'

config.hide_tab_bar_if_only_one_tab = true

config.initial_cols = 200
config.initial_rows = 40

config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

return config
