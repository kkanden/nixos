#!/usr/bin/env bash

# Color definitions mapped to terminal color indices 0-15
# Based on your theme:
# 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
# 8=bright_black, 9=bright_red, 10=bright_green, 11=bright_yellow
# 12=bright_blue, 13=bright_magenta, 14=bright_cyan, 15=bright_white

# Theme color variables (edit these to customize)
foreground=7 # CDCDCD - white/light gray
selection=14 # BEBEDA - bright cyan
comment=8    # 606079 - bright black/dark gray
red=1        # D8647e - red
orange=9     # E08398 - bright red
yellow=3     # F3BE7C - yellow
green=2      # 7FA563 - green
purple=5     # BB9DBD - magenta
cyan=6       # AEAED1 - cyan
pink=13      # C9B1CA - bright magenta
black=0      # black

# Editing related highlighting
ble-face -s region bg=$selection,fg=$foreground
ble-face -s region_target bg=$selection,fg=$black
ble-face -s region_match bg=$selection,fg=$foreground
ble-face -s region_insert fg=$selection,bg=$foreground
ble-face -s disabled fg=$comment
ble-face -s overwrite_mode fg=$black,bg=$selection
ble-face -s vbell reverse
ble-face -s vbell_erase bg=$foreground
ble-face -s vbell_flash fg=$green,reverse
ble-face -s prompt_status_line fg=$foreground,bg=$comment

# Syntax highlighting
ble-face -s syntax_default fg=$foreground
ble-face -s syntax_command fg=$cyan
ble-face -s syntax_quoted fg=$yellow
ble-face -s syntax_quotation fg=$yellow
ble-face -s syntax_escape fg=$pink
ble-face -s syntax_expr fg=$foreground
ble-face -s syntax_error fg=$red
ble-face -s syntax_varname fg=$purple
ble-face -s syntax_delimiter fg=$orange
ble-face -s syntax_param_expansion fg=$purple
ble-face -s syntax_history_expansion fg=$purple
ble-face -s syntax_function_name fg=$cyan
ble-face -s syntax_comment fg=$comment
ble-face -s syntax_glob fg=$green
ble-face -s syntax_brace fg=$orange
ble-face -s syntax_tilde fg=$purple
ble-face -s syntax_document fg=$yellow
ble-face -s syntax_document_begin fg=$yellow,bold

# Command types
ble-face -s command_builtin_dot fg=$cyan,bold
ble-face -s command_builtin fg=$cyan
ble-face -s command_alias fg=$cyan
ble-face -s command_function fg=$cyan
ble-face -s command_file fg=$cyan
ble-face -s command_keyword fg=$pink
ble-face -s command_jobs fg=$cyan
ble-face -s command_directory fg=$cyan,underline

# Filename colors
ble-face -s filename_directory underline,fg=$cyan
ble-face -s filename_directory_sticky underline,fg=$foreground,bg=$comment
ble-face -s filename_link underline,fg=$cyan
ble-face -s filename_orphan underline,fg=$red
ble-face -s filename_executable underline,fg=$cyan
ble-face -s filename_setuid underline,fg=$black,bg=$yellow
ble-face -s filename_setgid underline,fg=$black,bg=$yellow
ble-face -s filename_other underline
ble-face -s filename_socket underline,fg=$cyan,bg=$black
ble-face -s filename_pipe underline,fg=$green,bg=$black
ble-face -s filename_character underline,fg=$foreground,bg=$black
ble-face -s filename_block underline,fg=$yellow,bg=$black
ble-face -s filename_warning underline,fg=$red
ble-face -s filename_url underline,fg=$cyan
ble-face -s filename_ls_colors underline

# Variable name colors
ble-face -s varname_array fg=$orange,bold
ble-face -s varname_empty fg=$comment
ble-face -s varname_export fg=$purple,bold
ble-face -s varname_expr fg=$purple,bold
ble-face -s varname_hash fg=$green,bold
ble-face -s varname_number fg=$green
ble-face -s varname_readonly fg=$purple
ble-face -s varname_transform fg=$green,bold
ble-face -s varname_unset fg=$comment

# Arguments
ble-face -s argument_option fg=$purple
ble-face -s argument_error fg=$red

# completion
ble-face -s auto_complete fg=$comment

# binds
ble-bind -m "auto_complete" -f C-n auto_complete/insert-on-end
