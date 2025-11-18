show_gitmux() { # save this module in a file with the name <module_name>.sh
  local index=$1 # this variable is used by the module loader in order to know the position of this module 
  local icon="$(get_tmux_option "@catppuccin_gitmux_icon" "")"
  local color="$(get_tmux_option "@catppuccin_gitmux_color" "")"
  local text="$(get_tmux_option "@catppuccin_gitmux_text" "#(gitmux -cfg $HOME/.config/tmux/gitmux.conf '#{pane_current_path}')")"

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}