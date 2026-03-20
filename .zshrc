autoload -Uz vcs_info

orange1_rgb=$'%{\e[38;2;254;191;86m%}'
orange2_rgb=$'%{\e[38;2;254;209;134m%}'
green1_rgb=$'%{\e[38;2;168;240;125m%}'
green2_rgb=$'%{\e[38;2;191;240;161m%}'
purple_rgb=$'%{\e[38;2;181;116;218m%}'
red1_rgb=$'%{\e[38;2;230;131;131m%}'
red2_rgb=$'%{\e[38;2;236;96;96m%}'
gray_rgb=$'%{\e[38;2;199;190;200m%}'
pink_rgb=$'%{\e[38;2;255;167;196m%}'
reset=$'%{\e[0m%}'

_set_colors() {
  printf "\e]4;0;#222426\a"
  printf "\e]4;1;#ec6060\a"
  printf "\e]4;2;#a8f07d\a"
  printf "\e]4;3;#febf56\a"
  printf "\e]4;4;#5ba6df\a"
  printf "\e]4;5;#b574da\a"
  printf "\e]4;6;#78d0d5\a"
  printf "\e]4;7;#8b838b\a"
  printf "\e]4;8;#3a3e41\a"
  printf "\e]4;9;#e68383\a"
  printf "\e]4;10;#bff0a1\a"
  printf "\e]4;11;#fed186\a"
  printf "\e]4;12;#72afdf\a"
  printf "\e]4;13;#c195da\a"
  printf "\e]4;14;#a1ddd5\a"
  printf "\e]4;15;#c7bec8\a"
}

_set_colors

if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

alias ls='ls --color=auto -A'
alias grep='grep --color=auto'

export TERM=xterm-256color

export LESS='-R'
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

export GIT_PAGER=less
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=color.ui
export GIT_CONFIG_VALUE_0=auto

# ---------------------------------------------------- #

_set_ps1() {
  local hour=$(date +%H)

  local branch=""
  [[ -n $vcs_info_msg_0_ ]] && branch=" ${pink_rgb}‹${vcs_info_msg_0_}›"

  local prefix=""
  if (( hour >= 18 || hour < 6 )); then
    prefix="${orange1_rgb}⏾${orange2_rgb}⋆.˚"
  else
    prefix="${green2_rgb}𓂃${orange1_rgb}☼${gray_rgb}ᨒ "
  fi

  PS1="${prefix} ${green1_rgb}%n ${purple_rgb}%1~${branch} ${red1_rgb}₊˚˖${red2_rgb}♡ ${reset}"
}

zstyle ':vcs_info:git:*' formats '%b'

precmd() {
  vcs_info
  _set_colors
  _set_ps1
}

# ---------------------------------------------------- #

setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# ---------------------------------------------------- #

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description "${pink_rgb}describe: %d${reset}"
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format "${pink_rgb}‹${purple_rgb} %d ${pink_rgb}›${reset}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-prompt "${gray_rgb}˚ tab for more at %p ${pink_rgb}♡${reset}"
zstyle ':completion:*' select-prompt "${gray_rgb}˚ scrolling ~ %p ${pink_rgb}♡${reset}"
zstyle ':completion:*' verbose true
zstyle ':completion:*' warnings "${red1_rgb}!! %d !!${reset}"
zstyle ':completion:*:corrections' format "${green1_rgb}˖° fixed %d ${gray_rgb}(errors: %e)${reset}"
zstyle ':completion:*:messages' format "${gray_rgb}˚° %d${reset}"
zstyle ':completion:*:descriptions' format "${pink_rgb}‹${purple_rgb} %d ${pink_rgb}›${reset}"

# ---------------------------------------------------- #

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh