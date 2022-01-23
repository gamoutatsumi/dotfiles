local wezterm = require("wezterm")
return {
  default_prog = {"zsh", "--login"},
  set_environment_variables = {
    TERM = "xterm-256color",
    USE_TMUX = "true",
  },
  font_size = 11.5,
  font = wezterm.font_with_fallback({
    "HackGenNerd Console"
  }),
  color_scheme = "nightfly",
  enable_tab_bar = false,
}
