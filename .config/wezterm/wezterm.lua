local wezterm = require("wezterm")
return {
  default_prog = {"zsh", "--login"},
  set_environment_variables = {
    TERM = "xterm-256color",
    USE_TMUX = "false",
  },
  font_size = 11.5,
  font = wezterm.font_with_fallback({
    "HackGenNerd Console"
  }),
  color_scheme = "nightfly",
  enable_tab_bar = true,
  unix_domains = {
    {
      name = "unix",
    }
  },
  default_gui_startup_args = {"connect", "unix"},
}
