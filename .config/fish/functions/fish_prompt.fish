function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (uname -n|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char '# '
      case '*'
        set -g __fish_prompt_char '⋉> '
    end
  end

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
  set -l nord14 (set_color A3BE8C) # light green
  set -l nord15 (set_color B48EAD) # purple

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
  #  echo -n $hostcolor'╭─'$hotpink$current_user$white' at '$orange$__fish_prompt_hostname$white' in '$limegreen(pwd|sed "s=$HOME=⌁=")$turquoise
  #__fish_git_prompt " (%s)"
  #echo
  set -l exit_code $status
  set -l cmd_duration $CMD_DURATION
  echo -n $nord3'┌─╼['$nord8$current_user'@'$__fish_prompt_hostname$nord3']╾─╼['
  if test $exit_code -ne 0
    echo -n $nord12
  else
    echo -n $nord8
  end
  printf '%d' $exit_code
  echo -n $nord3']['
  if test $cmd_duration -ge 5000
    echo -n $nord12
  else
    echo -n $nord8
  end
  printf '%s' (__print_duration $cmd_duration)
  echo -n $nord3']╾─╼['$nord8(date +%H:%M:%S)$nord3']'
  echo

  ##
  ## Line 2
  ##
  echo -n $nord3'╰─╼['$nord8(pwd|sed "s=$HOME=~=")$nord3']'
  __fish_git_prompt "$nord3╾─╼[$nord8%s$nord3]"
  echo

  # Disable virtualenv's deault prompt
  set -g VIRTUAL_ENV_DISABLE_PROMPT true

  # support or virtual env name
  if set -q VIRTUAL_ENV
    echo -n "($nord7"(basename "$VIRTUAL_ENV")"$nord3)"
  end

  ##
  ## Support for vi mode
  ##
  set -l lambdaViMode "$THEME_LAMBDA_VI_MODE"

  # Do nothing if not in vi mode
  if test "$fish_key_bindings" = fish_vi_key_bindings
      or test "$fish_key_bindings" = fish_hybrid_key_bindings
    if test -z (string match -ri '^no|false|0$' $lambdaViMode)
      set_color --bold
      echo -n $nord3'─['
      switch $fish_bind_mode
        case default
          set_color red
          echo -n 'n'
        case insert
          set_color green
          echo -n 'i'
        case replace_one
          set_color green
          echo -n 'r'
        case replace
          set_color cyan
          echo -n 'r'
        case visual
          set_color magenta
          echo -n 'v'
      end
      echo -n $nord3']'
    end
  end

  ##
  ## Rest of the prompt
  ##
  echo -n $nord3$__fish_prompt_char $normal
end

function __print_duration
  set -l duration $argv[1]
 
  set -l millis  (math $duration % 1000)
  set -l seconds (math -s0 $duration / 1000 % 60)
  set -l minutes (math -s0 $duration / 60000 % 60)
  set -l hours   (math -s0 $duration / 3600000 % 60)
 
  if test $duration -lt 60000;
    # Below a minute
    printf "%d.%03d\n" $seconds $millis
  else if test $duration -lt 3600000;
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
