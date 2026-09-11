# Kanagawa Dragon syntax colors — https://github.com/rebelot/kanagawa.nvim
# Adapted from the theme's own fish extra, which ships the Wave palette.
# Fish stores colors as universal variables once set interactively, so these
# `set -g` assignments are re-applied on every shell start and stay in sync
# with the file rather than with whatever was last saved in fish_variables.

set -l foreground c5c9c5 # dragonWhite
set -l selection 2d4f67  # waveBlue2
set -l comment 737c73    # dragonAsh
set -l red c4746e        # dragonRed
set -l orange b6927b     # dragonOrange
set -l yellow c4b28a     # dragonYellow
set -l green 8a9a7b      # dragonGreen2
set -l violet 8992a7     # dragonViolet
set -l aqua 8ea4a2       # dragonAqua
set -l pink a292a3       # dragonPink
set -l blue 8ba4b0       # dragonBlue2
set -l gray a6a69c       # dragonGray

# Syntax highlighting
set -g fish_color_normal $foreground
set -g fish_color_command $blue
set -g fish_color_keyword $violet
set -g fish_color_quote $green
set -g fish_color_redirection $aqua
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $foreground
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $red
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
set -g fish_color_option $yellow
set -g fish_color_valid_path --underline
set -g fish_color_cwd $yellow
set -g fish_color_host $aqua
set -g fish_color_user $violet

# Completion pager
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $blue --bold
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $gray
set -g fish_pager_color_selected_background --background=$selection
