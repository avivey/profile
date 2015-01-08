# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;

esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null || [ -n "$skip_tput_test" ]; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# in case we can't find it later
declare -F __git_ps1 >/dev/null || function __git_ps1() { true; }

if  mysql --version | grep -q readline; then
  mysql_has_readline=yes
fi 2>/dev/null

MYSQL_PS1=$'mysql \h \d> '
if [ "$color_prompt" = yes ]; then
    function prompt_command() {
      local ES=$?
      if [[ $ES -ne 0 ]]; then
        local ERRORPROMPT=" \[\033[1;30m\][ $ES ]"
      fi
      local GIT=$(__git_ps1 " %s")
      PS1=$PS1_SET_TITLE'\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[1;34m\]\w\[\033[0;31m\]'$GIT$ERRORPROMPT'\[\033[00m\]\$ '
    }
    PROMPT_COMMAND=prompt_command

    if [ "$mysql_has_readline" = yes ]; then
      MYSQL_PS1=$'\001\033[0;31m\002mysql \001\033[1;32m\002\h \001\033[1;34m\002\d\001\033[00m\002> '
    fi
else
    PS1=$PS1_SET_TITLE'\u@\h:\w$(__git_ps1)\$ '
fi

case "$TERM" in
# If this is an xterm set the title to user@host:dir
xterm*|rxvt*)
    PS1_SET_TITLE="\[\e]0;\u@\h: \w\a\]"
    if [ "$mysql_has_readline" = yes ]; then
      MYSQL_PS1=$'\001\e]0;mysql \h:\d\a\002'$MYSQL_PS1
    fi
    ;;
*)
    ;;
esac

unset color_prompt force_color_prompt mysql_has_readline
export MYSQL_PS1

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
	fi

  if [ -d ~/devtools/arcanist/resources ]; then
    . ~/devtools/arcanist/resources/shell/bash-completion
  fi

  if [ -d ~/devtools/git/contrib/completion ]; then
    . ~/devtools/git/contrib/completion/git-completion.bash
    . ~/devtools/git/contrib/completion/git-prompt.sh
  fi

  if [ -d ~/devtools/tig/contrib ]; then
    . ~/devtools/tig/contrib/tig-completion.bash
  fi
fi

#end .pyc files.
export PYTHONDONTWRITEBYTECODE=1

export PATH=$PATH:~/profile/bin
export BROWSER=send-url.sh

export BLOCK_SIZE=human-readable
export EDITOR=/usr/bin/nano
export INPUTRC=~/profile/inputrc
. ~/profile/aliases

if [ -f ~/bash_local ]; then
  . ~/bash_local
fi
