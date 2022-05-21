set -Ux EDITOR nvim

## Appearance
# Do not display git status on left prompt
#set -g theme_display_git no
# Do not omit default branch name
set -g theme_display_git_default_branch yes
# Abbreviate long branch name
set -g theme_use_abbreviated_branch_name yes
# 
set -g theme_display_user ssh
# 
set -g theme_display_hostname ssh
# Use custom datetime format
#set -g theme_date_format "+%a %H:%M"
# Use UTC
set -g theme_date_timezone UTC
# 
#set -g default_user your_normal_user
# Do not abbreviate path
set -g fish_prompt_pwd_dir_length 0
# Use 2nd line for prompt
set -g theme_newline_cursor yes
# Set prompt of 2nd line
set -g theme_newline_prompt '⋉> '

