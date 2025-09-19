function fish_prompt
    # empty line
    echo ''

    # Cache exit status
    set -l last_status $status

    # Setup coors
    set -l nord0 (set_color 2E3440) # polar night
    set -l nord1 (set_color 3B4252) # polar night (brighter)
    set -l nord2 (set_color 434C5E) # polar night (more brighter)
    set -l nord3 (set_color 6b7994) # original is 4C566A # polar night (even more brighter)
    set -l nord4 (set_color D8DEE9) # snow storm
    set -l nord5 (set_color E5E9F0) # snow storm (brighter)
    set -l nord6 (set_color ECEFF4) # snow storm (more brighter)
    set -l nord7 (set_color 8FBCBB) # turquoise
    set -l nord8 (set_color 88C0D0) # light blue
    set -l nord9 (set_color 98b3cd) # original is 81A1C1 # pale blue
    set -l nord10 (set_color 5E81AC) # deep blue
    set -l nord11 (set_color BF616A) # red
    set -l nord12 (set_color D08770) # deep orange
    set -l nord13 (set_color EBCB8B) # yellow
    set -l nord14 (set_color aac98f) # original is A3BE8C # light green
    set -l nord15 (set_color B48EAD) # purple

    set -l bold (set_color -o)
    set -l normal (set_color normal)

    # Just calculate these once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (uname -n|cut -d . -f 1)
    end

    # Configure __fish_git_prompt
    set -g __fish_git_prompt_char_stateseparator ' '
    set -g __fish_git_prompt_color 88C0D0
    set -g __fish_git_prompt_color_flags D08770
    set -g __fish_git_prompt_color_prefix D8DEE9
    set -g __ish_git_prompt_color_suffix D8DEE9
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_showuntrackedfiles true
    set -g __fish_git_prompt_showstashstate true
    set -g __fish_git_prompt_show_informative_status true
    set -l current_user (whoami)

    ##
    ## Line 1
    ##
    set -l exit_code $status
    set -l cmd_duration $CMD_DURATION
    echo -n $nord3'╭─╼['$nord8$current_user'@'$__fish_prompt_hostname$normal$nord3']╾─╼['
    if test $last_status -ne 0
        echo -n $nord12
    else
        echo -n $nord8
    end
    printf '%d' $last_status
    echo -n $nord3']['
    if test $cmd_duration -ge 5000
        echo -n $nord12
    else
        echo -n $nord8
    end
    printf '%s' (__print_duration $cmd_duration)
    echo -n $nord3']╾─╼['$nord8(date -u +%H:%M:%S)$nord3']'
    echo

    ##
    ## Line 2
    ##
    echo -n $nord3'╰───╼['$nord8(pwd|sed "s=$HOME=~=")$nord3']'
    __fish_git_prompt "$nord3╾─╼[$nord8%s$nord3]"

    # support for virtual env name
    set -g VIRTUAL_ENV_DISABLE_PROMPT 1
    if set -q VIRTUAL_ENV
        if functions -q deactivate
            # NOTE: I actually want to show the venv project name defined in pyvenv.cfg...
            set -l VIRTUAL_ENV_PARENT_DIR (dirname "$VIRTUAL_ENV") # $VIRTUAL_ENV like `/path/to/maybe_project_root/.venv`
            echo -n "$nord3╾─╼[$nord8󰌠$nord3]($nord8"(basename "$VIRTUAL_ENV_PARENT_DIR")"$nord3)"
        else
            set -x VIRTUAL_ENV
        end
    end

    echo

    ##
    ## Rest of the prompt
    ##
    switch (id -u)
        case 0
            echo -n $nord11'⋉#ROOT#≫'$normal' '
        case '*'
            echo -n $nord3'⋉>'$normal' '
    end
end

function __print_duration
    set -l duration $argv[1]
    set -l millis (math $duration % 1000)
    set -l seconds (math -s0 $duration / 1000 % 60)
    set -l minutes (math -s0 $duration / 60000 % 60)
    set -l hours (math -s0 $duration / 3600000 % 60)
    if test $duration -lt 60000
        # Below a minute
        printf "%d.%03d\n" $seconds $millis
    else if test $duration -lt 3600000
        # Below a hour
        printf "%02d:%02d.%03d\n" $minutes $seconds $millis
    else
        # Everything else
        printf "%02d:%02d:%02d.%03d\n" $hours $minutes $seconds $millis
    end
end

function _convertsecs
    printf "%02d:%02d:%02d\n" (math -s0 $argv[1] / 3600) (math -s0 (math $argv[1] \% 3600) / 60) (math -s0 $argv[1] \% 60)
end
