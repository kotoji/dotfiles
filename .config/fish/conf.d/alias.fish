# 
# alias
#

# override
alias cat='bat --style=plain --theme=Nord'
alias ls='eza'
alias la='eza -a'
alias ll='eza -lgho'
alias lla='eza -algho'
alias lt='eza --tree'
alias ..='cd ..'
alias ...='cd ../..'

# ps
alias psf='ps -o \'user pid ppid thcount %cpu %mem vsz rss tname stat stime bsdtime command\''
#alias psf='ps -o \'user pid ppid %cpu %mem vsz rss tty stat stime time command\''
alias psns='ps -o \'user pid ppid cgroup mntns pidns netns ipcns utsns userns cgroupns timens stime command\''
alias psnsf='ps -o \'user pid ppid thcount %cpu %mem vsz rss tname stat cgroup mntns pidns netns ipcns utsns userns cgroupns timens stime bsdtime command\''

alias header='head -n 1'

# global IP
alias gip="curl -s httpbin.org/ip | jq -r '.origin'"

function docker
    if [ "$argv[1]" = ps ] && [ "$argv[2]" = --json ]
        docker ps --all --no-trunc --format=json | tr '\n' ',' | string trim --right --chars=',' | xargs -0 printf "[%s]" | jq -r "."
    else if [ "$argv[1]" = compose ] && [ "$argv[2]" = ps ] && [ "$argv[3]" = --json ]
        docker compose ps --all --format=json | jq -r "."
    else
        command docker $argv
    end
end

# psql
# ref. https://qiita.com/hoto17296/items/8bb8ea081d9f8ce1b260
set -gx PGPASSWORD postgres
alias psql='docker run -i --rm -e PGPASSWORD=$PGPASSWORD --net=host postgres:latest psql'
alias psqlt='docker run -it --rm -e PGPASSWORD=$PGPASSWORD --net=host postgres:latest psql'

# parquet-tools
alias pqt='parquet-tools'
