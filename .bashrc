# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

parse_git_info() {
    # Ensure inside a git repository
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return

    # Detect main/master
    local main_branch=""
    if git show-ref --verify --quiet refs/heads/main; then
        main_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        main_branch="master"
    fi

    # Check dirty status
    local dirty=""
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        dirty="*"
    fi

    # Determine upstream status
    local upstream upstream_status=""
    upstream=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)

    if [ -n "$upstream" ]; then
        local behind ahead
        read behind ahead <<<"$(git rev-list --left-right --count "$upstream"...HEAD 2>/dev/null)"

        if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
            upstream_status+="↕${ahead}/${behind}"  # diverged
        else
            [ "$ahead" -gt 0 ] && upstream_status+="↑$ahead"
            [ "$behind" -gt 0 ] && upstream_status+="↓$behind"
        fi
    else
        upstream_status="⨯no-upstream"
    fi

    # Compare with main/master
    local main_status=""
    if [ -n "$main_branch" ] && [ "$branch" != "$main_branch" ]; then
        local mbehind mahead
        read mbehind mahead <<<"$(git rev-list --left-right --count "$main_branch"...HEAD 2>/dev/null)"
        [ "$mahead" -gt 0 ] && main_status+="⇡$mahead"
        [ "$mbehind" -gt 0 ] && main_status+="⇣$mbehind"
    fi

    # Build final status string
    local status=""
    [ -n "$upstream_status" ] && status+="$upstream_status "
    [ -n "$main_status" ] && status+="$main_status "

    # Trim trailing spaces
    status=$(echo "$status" | sed 's/ *$//')

    # Branch + dirty star right next to it
    echo "${branch}${dirty}${status:+ $status}"
}

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\] \$(parse_git_info)\[\033[00m\]\n\$ "
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w \$(parse_git_info)\n\$ "
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
eval "$(/home/dario-pranjic/.local/bin/mise activate bash)"

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias idea='intellij-idea-ultimate'

runSagittariusChecks() {
  pids=()

  cleanup() {
    echo "Caught Ctrl+C — killing all background jobs..."
    for pid in "${pids[@]}"; do
      kill "$pid" 2>/dev/null
    done
    return 1
  }
  trap cleanup INT

  echo "Running rubocop"
  bundle exec rubocop -A &
  pids+=($!)

  echo "Compiling docs"
  bin/rake graphql:compile_docs &
  pids+=($!)

  echo "Running tests"
  bin/rspec &
  pids+=($!)

  for pid in "${pids[@]}"; do
    wait "$pid"
  done

  echo "All tasks finished"
}

alias sag-checks='runSagittariusChecks'
