-- Pull in the wezterm API
local wezterm = require('wezterm')
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

wezterm.plugin.require('https://github.com/sei40kr/wez-pain-control').apply_to_config(config, {})
local cmdpicker = wezterm.plugin.require('https://github.com/abidibo/wezterm-cmdpicker')

wezterm.plugin.require('https://github.com/yriveiro/wezterm-status').apply_to_config(config, {
  cells = {
    battery = { enabled = false },
    date = { format = '%H:%M' },
    workspace = {
      -- Enable Wezterm Workspace
      enabled = true,
      -- Clock icon
      icon = wezterm.nerdfonts.md_television_guide,
    },
  },
})

-- This is where you actually apply your config choices.
wezterm.plugin.require('https://github.com/Eric162/wezterm-agent-deck').apply_to_config(config, {
  update_interval = 500, -- ms between status checks

  colors = {
    working = '#A6E22E', -- green: agent processing
    waiting = '#E6DB74', -- yellow: needs input
    idle = '#66D9EF', -- blue: ready
    inactive = '#888888', -- gray: no agent
  },

  icons = {
    style = 'unicode', -- or 'nerd', 'emoji'
    unicode = { working = '●', waiting = '◔', idle = '○', inactive = '◌' },
  },

  notifications = {
    enabled = true,
    on_waiting = true,
    backend = 'terminal-notifier', -- or 'native' (default)
    terminal_notifier = {
      sound = 'default', -- or 'Ping', 'Glass', 'Funk', etc.
      title = 'WezTerm Agent Deck', -- notification title
      activate = true, -- focus WezTerm when notification clicked
    },
  },
})

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  { key = '{', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
  {
    key = 'z',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = '|',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'S',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
}
-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 16
config.color_scheme = 'AdventureTime'
config.tab_bar_at_bottom = true
-- config.window_background_opacity = 0.8

-- Apply picker trigger (LEADER+Space by default) — call this LAST
cmdpicker.apply_to_config(config, {
  title = 'Command Palette',
})
-- Finally, return the configuration to wezterm:
return config
