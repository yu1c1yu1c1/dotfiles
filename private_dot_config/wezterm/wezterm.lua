-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- OSを判定する変数を定義
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac = wezterm.target_triple:find("apple") ~= nil

----------------------------------------------------
-- Main screen
----------------------------------------------------
-- OSごとの個別設定
if is_windows then
    -- Windowsの場合：WSLをデフォルトのドメインにする
    -- wsl.exe
    config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" }
    config.launch_menu = {
      { label = 'PowerShell', args = { 'powershell.exe' } },
      { label = 'Ubuntu', args = { 'wsl.exe', '-d', 'Ubuntu', '--cd', '~' } },
      { label = 'Kali Linux', args = { 'wsl.exe', '-d', 'kali-linux', '--cd', '~' } },
    }
elseif is_mac then
    -- MacでHomebrewなどのzshを使いたい場合は明示的に指定
    -- 指定しない場合は、システム標準のシェルが起動します
    config.default_prog = { '/bin/zsh', '--login' }
    
    -- Mac用の起動メニュー（任意）
    config.launch_menu = {
      { label = 'Zsh', args = { 'zsh' } },
      { label = 'Bash', args = { 'bash' } },
    }
end
  
-- other settings
config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 3


----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_frame = {

  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",

}

config.window_background_gradient = {

  colors = { "#000000" },

}

config.colors = {

  tab_bar = {

    inactive_tab_edge = "none",

  },

}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

  local background = "#5c6d74"

  local foreground = "#FFFFFF"

  local edge_background = "none"

  if tab.is_active then

    background = "#769ff0"

    foreground = "#FFFFFF"

  end

  local edge_foreground = background

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "


  return {
    { Background = { Color = edge_background } },

    { Foreground = { Color = edge_foreground } },

    { Text = SOLID_LEFT_ARROW },

    { Background = { Color = background } },

    { Foreground = { Color = foreground } },

    { Text = title },

    { Background = { Color = edge_background } },

    { Foreground = { Color = edge_foreground } },

    { Text = SOLID_RIGHT_ARROW },

  }

end)

----------------------------------------------------
-- Pane
----------------------------------------------------
-- config.show_pane_ids_by_default = true

----------------------------------------------------
-- keybinds
----------------------------------------------------

-- config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 5000 }

-- and finally, return the configuration to wezterm
return config
