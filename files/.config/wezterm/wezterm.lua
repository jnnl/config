local wezterm = require('wezterm')
local cfg = wezterm.config_builder()

cfg.check_for_updates = false
cfg.color_scheme = 'Tomorrow Night'
cfg.enable_scroll_bar = true
cfg.enable_wayland = false
cfg.font = wezterm.font('Source Code Pro', {})
cfg.font_size = 10
cfg.line_height = 1.1
cfg.scrollback_lines = 10000
cfg.skip_close_confirmation_for_processes_named = { 'bash', 'sh' }
cfg.use_fancy_tab_bar = false

return cfg
