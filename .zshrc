# IMPORTS {{{
[[ -f $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"
# }}}

# INITIALIZE {{{
if [[ -z "$XDG_DATA_HOME" ]]; then
  export XDG_DATA_HOME="$HOME/.local/share"
fi
if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi
if [[ -z "$XDG_CACHE_HOME" ]]; then
  export XDG_CACHE_HOME="$HOME/.cache"
fi
if [ ! -z "$ZSHRC_PROFILE" ]; then
  zmodload zsh/zprof && zprof > /dev/null
fi


# ostype returns the lowercase OS name
ostype() {
  uname | tr "[:upper:]" "[:lower:]"
}

# os_detect export the PLATFORM variable as you see fit
case "$(ostype)" in
  *'linux'*)  
    if grep -iq 'microsoft' "/proc/sys/kernel/osrelease"; then
      PLATFORM='wsl'
    else
      PLATFORM='linux'
      fi                         ;;
    *'darwin'*) PLATFORM='osx'     ;;
    *'bsd'*)    PLATFORM='bsd'     ;;
    *)          PLATFORM='unknown' ;;
  esac
  export PLATFORM

# is_osx returns true if running OS is Macintosh
is_osx() {
  if [[ "$PLATFORM" = "osx" ]]; then
    return 0
  else
    return 1
  fi
}

is_wsl() {
  if [[ "$PLATFORM" = "wsl" ]]; then
    return 0
  else
    return 1
  fi
}

exists() {
  if type "$@" > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}


if [[ -z "$TMUX" ]] && [[ "$USE_TMUX" == "true" ]] ;then
    ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
  if [[ -z "$ID" ]]; then # if not available create a new one
    exec tmux new-session
  else
    exec tmux attach-session -t "$ID" # if available attach to it
  fi
fi
# }}}

# {{{ PLUGINS
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin"
  local isok=$!
  if [[ $isok == 1 ]]; then
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b"
  else
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
  fi
fi

source "${HOME}/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
      zinit-zsh/z-a-rust \
      zinit-zsh/z-a-as-monitor \
      zinit-zsh/z-a-patch-dl \
      zinit-zsh/z-a-bin-gem-node

zinit snippet OMZT::gnzh

zicompinit

zinit ice depth'1' atinit"export ASDF_DATA_DIR=$XDG_DATA_HOME/asdf" atload'zicdreplay' silent; zinit light 'asdf-vm/asdf'
zinit ice wait'0' depth'1' silent; zinit light 'Tarrasch/zsh-autoenv'
zinit ice depth'1'; zinit light 'romkatv/powerlevel10k'
zinit ice wait'0' depth'1' atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+="zeno-auto-snippet-and-accept-line-fallback"; _zsh_autosuggest_start' silent; zinit light 'zsh-users/zsh-autosuggestions'
zinit light 'chrissicool/zsh-256color'
zinit ice wait'0' depth'1' lucid light-mode silent; zinit light 'yuki-yano/tmk'
zinit ice wait'0' depth'1' lucid light-mode silent; zinit light 'yuki-yano/tms'
zinit ice wait'0' depth'1' lucid light-mode silent; zinit light 'b4b4r07/enhancd'
zinit ice wait'0' depth'1' atload'!_zsh_autosuggest_start; set_fast_theme' silent; zinit light 'zdharma/fast-syntax-highlighting'
zinit ice wait lucid depth'1' silent atload'zicdreplay' silent blockf; zinit light 'zsh-users/zsh-completions'
zinit ice wait lucid depth'1' silent light-mode as'command' id-as'fzf-tmux'; zinit snippet 'https://github.com/junegunn/fzf/blob/master/bin/fzf-tmux'
zinit ice wait lucid depth'1' silent light-mode as'command' sbin'ytfzf' pick'ytfzf'; zinit light 'pystardust/ytfzf'
zinit ice wait lucid ver'c91f047' atinit'export ZENO_ENABLE_SOCK=1; export ZENO_ENABLE_FZF_TMUX=1' blockf; zinit light 'yuki-yano/zeno.zsh'
zinit ice wait lucid depth'1' silent from'gh-r' as'null' sbin'fzf' id-as'fzf'; zinit light 'junegunn/fzf'
zinit ice wait silent as'program' from'gh-r' mv'ripgrep* -> rg' pick'rg/rg'; zinit light 'BurntSushi/ripgrep'
zinit ice wait silent as'program' from'gh-r' mv'ripgrep_all* -> rga' pick'rga/rga'; zinit light 'phiresky/ripgrep-all'
zinit ice wait silent as'program' from'gh-r' mv'exa* -> exa' pick'bin/exa'; zinit light 'ogham/exa'
zinit ice wait silent as'program' from'gh-r' mv'dog* -> dog' pick'bin/dog'; zinit light 'ogham/dog'
zinit ice wait silent as'program' from'gh-r' mv'bat* -> bat' atclone'mv bat/autocomplete/bat.zsh bat/autocomplete/_bat' pick'bat/bat'; zinit light 'sharkdp/bat'
zinit ice wait silent as'program' from'gh-r' mv'fd* -> fd' pick'fd/fd'; zinit light 'sharkdp/fd'
zinit ice wait silent as'program' from'gh-r' mv'ghq* -> ghq' pick'ghq/ghq'; zinit light 'x-motemen/ghq'
zinit ice wait silent as'program' from'gh-r' ver'latest' mv'gh* -> gh' bpick'*.tar.gz' pick'gh/bin/gh'; zinit light 'cli/cli'
zinit ice wait silent as'program' from'gh-r' pick'gron/gron'; zinit light 'tomnomnom/gron'
zinit ice wait silent as'program' from'gh-r' mv'delta* -> delta' pick'delta/delta'; zinit light 'dandavison/delta'
zinit ice wait silent as'program' from'gh-r' mv'dust* -> dust' pick'dust/dust'; zinit light 'bootandy/dust'
zinit ice wait silent as'program' from'gh-r' pick'silicon/silicon'; zinit light 'Aloxaf/silicon'
zinit ice wait silent as'program' from'gh-r' mv'xh* -> xh' pick'xh/xh'; zinit light 'ducaale/xh'
zinit ice wait silent as'program' from'gh-r' mv'cargo-compete* -> cargo-compete' pick'cargo-compete/cargo-compete'; zinit light 'qryxip/cargo-compete'
zinit ice wait silent as'program' from'gh-r' mv'actionlint* -> actionlint' pick'actionlint/actionlint'; zinit light 'rhysd/actionlint'
zinit ice wait silent as'program' from'gh-r' mv'kubeval* -> kubeval' pick'kubeval/kubeval'; zinit light 'instrumenta/kubeval'
zinit ice wait silent as'program' from'gh-r' mv'hadolint* -> hadolint' pick'hadolint/hadolint'; zinit light 'hadolint/hadolint'
zinit ice wait silent as'program' from'gh-r' mv'shellcheck* -> shellcheck' pick'shellcheck/shellcheck'; zinit light 'koalaman/shellcheck'
#zinit ice wait silent as'completion' mv'completions.zsh -> _exa' silent; zinit snippet 'https://github.com/ogham/exa/blob/master/completions/completions.zsh'
zinit ice wait silent as'program' from'gh-r' pick'gomi/gomi'; zinit light 'b4b4r07/gomi'
zinit ice wait as'program' from'gh-r' pick'flarectl' silent; zinit light 'cloudflare/cloudflare-go'
zinit ice wait as'program' from'gh-r' bpick'bw-*.zip' pick'bw/bw' silent; zinit light 'bitwarden/cli'
zinit ice id-as"deno" depth'1' wait as"completion" atclone"source *.zsh" atpull"%atclone" silent; zinit light 'NotTheDr01ds/zsh-plugin-deno'
zinit ice id-as"rustup" depth'1' wait as"completion" atclone"source *.zsh" atpull"%atclone" silent; zinit light 'gamoutatsumi/zsh-plugin-rustup'

setopt nonomatch

function set_fast_theme() {
  FAST_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
  FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=cyan,underline'
  FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=blue'
  FAST_HIGHLIGHT_STYLES[alias]='fg=blue'
  FAST_HIGHLIGHT_STYLES[precommand]='fg=blue'
  FAST_HIGHLIGHT_STYLES[command]='fg=blue'
  FAST_HIGHLIGHT_STYLES[arg0]='fg=025'
  FAST_HIGHLIGHT_STYLES[globbing]='fg=green,bold'
  FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
  FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
  FAST_HIGHLIGHT_STYLES[default]='fg=cyan'
  FAST_HIGHLIGHT_STYLES[unknown-token]='fg=196'
  FAST_HIGHLIGHT_STYLES[builtin]='fg=blue'
  FAST_HIGHLIGHT_STYLES[global-alias]='fg=green'
}

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

FZF_PREVIEW_ENABLE_TMUX=1

FZF_PREVIEW_DEFAULT_SETTING="--sync --height='80%' --preview-window='right:50%' --expect='ctrl-space' --header='C-Space: continue fzf completion'"
FZF_PREVIEW_DEFAULT_BIND="ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview"
### End of Zinit's installer chunk

# }}}

# ALIAS {{{
# OS Settings
if is_osx; then
  if exists pyenv; then
    alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"
  fi
else
  alias mozc_dic='/usr/lib/mozc/mozc_tool --mode=dictionary_tool'
  alias mozc_word='/usr/lib/mozc/mozc_tool --mode=word_register_dialog'
  alias open='xdg-open'
fi

if is_wsl; then
  alias pbcopy='/mnt/c/Windows/System32/clip.exe'
elif is_osx; then
  :
else
  alias pbcopy='xsel --clipboard --input'
fi

alias sudo='sudo '

# ls alias
alias ls='exa --icons'
alias ll='ls -lg --git'
alias la='ll -a'
alias tree='ls -T'

# Utilities
alias du='du -sh *'
alias filecount='\ls -lF | grep -v / | wc -l'
alias ..='cd ..'
alias q='exit'
alias top='htop'
alias k='kubectl'
alias rm='gomi'

# editors
alias vim='nvim'
alias vi='vim'
alias v='vi'
alias vimdiff='nvim -d'
alias emacs='TERM=xterm-direct emacs -nw'

# dotfiles
alias dot='cd ~/dotfiles'
alias zshconfig='nvim ~/.zshrc'
alias vimconfig='nvim ~/.config/nvim/lua/core/init.lua -c "cd ~/dotfiles/.config/nvim"'
alias cocconfig='nvim -c CocConfig'
alias tmuxconfig='nvim ~/.tmux.conf'
alias sshconfig='nvim ~/.ssh/config'
alias gitconfig='nvim ~/.gitconfig'
alias deinconfig='nvim ~/.config/nvim/dein.toml'
alias deinlzconfig='nvim ~/.config/nvim/dein_lazy.toml'
alias ssconfig='nvim ~/.config/starship.toml'
alias reload='source ~/.zshrc'
alias path='echo $PATH'

# TMUX
alias ssh='TERM=xterm ssh'

# Docker
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcu='docker-compose up'
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'
alias dcdv='docker-compose down -v'
alias dcdall='docker-compose down --rmi all -v'
alias dcst='docker-compose stop'
alias dcrs='docker-compose restart'

alias zu='zinit update'

globalias() {
  if [[ $LBUFFER =~ [A-Z0-9]+$ ]]; then
    zle _expand_alias
    zle expand-word
    zle self-insert
  else
    zle zeno-auto-snippet
  fi
}

# zle -N globalias
# }}}

# KEY {{{
typeset -A key

if [[ -n "${terminfo}" ]]; then
  key[Home]="${terminfo[khome]}"
  key[End]="${terminfo[kend]}"
  key[Insert]="${terminfo[kich1]}"
  key[Delete]="${terminfo[kdch1]}"
  key[Up]="${terminfo[kcuu1]}"
  key[Down]="${terminfo[kcud1]}"
  key[Left]="${terminfo[kcub1]}"
  key[Right]="${terminfo[kcuf1]}"
  key[PageUp]="${terminfo[kpp]}"
  key[PageDown]="${terminfo[knp]}"

  # setup key accordingly
  [[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
  [[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
  [[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
  [[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
  [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
  [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
  [[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
  [[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
  [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
  [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
fi

# word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () {
    printf '%s' "${terminfo[smkx]}"
  }
  function zle-line-finish () {
    printf '%s' "${terminfo[rmkx]}"
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

function zeno-auto-snippet-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-auto-snippet
  else
    zle self-insert
  fi
}

function zeno-auto-snippet-and-accept-line-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-auto-snippet-and-accept-line
  else
    zle accept-line
  fi
}

function zeno-insert-snippet-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-insert-snippet
  fi
}

function zeno-completion-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-completion
  else
    zle expand-or-complete
  fi
}

function zeno-history-selection-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-history-selection
  else
    zle history-incremental-search-backward
  fi
}

function zeno-ghq-cd-fallback() {
 if [[ -n $ZENO_LOADED ]]; then
   zeno-ghq-cd
 else
   zle vi-find-next-char
 fi
}

zle -N zeno-auto-snippet-fallback
zle -N zeno-auto-snippet-and-accept-line-fallback
zle -N zeno-insert-snippet-fallback
zle -N zeno-completion-fallback
zle -N zeno-history-selection-fallback
zle -N zeno-ghq-cd-fallback

# zeno.zsh
bindkey ' '    zeno-auto-snippet-fallback
bindkey '^m'   zeno-auto-snippet-and-accept-line-fallback
bindkey '^x^s' zeno-insert-snippet-fallback
bindkey '^i'   zeno-completion-fallback
bindkey '^r'   zeno-history-selection-fallback
bindkey '^x^f' zeno-ghq-cd-fallback

bindkey '^[k' tmk
bindkey '^[t' tms

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
# }}}

# {{{ ENVVARS
if is_osx; then
  export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:$PATH"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman/usr/local/opt/grep/libexec/gnuman:$MANPATH"
fi

# Setting PATH
#export PYENV_ROOT="$HOME/.pyenv"
#export NODENV_ROOT="$HOME/.nodenv"
export LUAROCKS_HOME="$HOME/.luarocks"
export GEM_HOME=$(ruby -e 'print Gem.user_dir')
export CARGO_HOME="$HOME/.cargo"
export GOPATH="$HOME/go"
export PATH="$LUAROCKS_HOME/bin:$GOPATH/bin:$CARGO_HOME/bin:$HOME/.local/bin:$GEM_HOME/bin:$PATH"
export MANPAGER='nvim -c MANPAGER -'

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export EDITOR="nvim"

export DOCKER_BUILDKIT=1

# sccache
if exists sccache; then
  export SCCACHE_REDIS="redis://localhost:6379/1"
  #export RUSTC_WRAPPER="$(which sccache)"
fi

export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>' 

if is_wsl; then
  export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}';)
fi
# }}}

# GENERAL {{{
setopt AUTO_CD
setopt IGNOREEOF

stty stop undef
stty start undef

# opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
#}}}

#{{{ HISTORY
HISTORY_IGNORE="cd|pwd|l[sal]|cp|mv|rm"

zshaddhistory() {
  emulate -L zsh
  [[ ${1%%$'\n'} != ${~HISTORY_IGNORE} ]]
}

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP
setopt HIST_REDUCE_BLANKS
#}}}

# {{{ STYLE
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

zstyle ':completion:*:default' menu select=2

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# Disalbe Right Prompt
RPROMPT=""
# }}}

# {{{ GPG-SSH
export GPG_TTY=$(tty)

if type "gpg" > /dev/null 2>&1; then
  if [[ -z $SSH_AUTH_SOCK ]]; then
    gpg-connect-agent updatestartuptty /bye >/dev/null
    gpgconf --launch gpg-agent
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  fi
fi

# In WSL2
if is_wsl; then
  export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
  ss -a | grep -q $SSH_AUTH_SOCK
  if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe >/dev/null 2>&1 &)
  fi

  export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
  ss -a | grep -q $GPG_AGENT_SOCK
  if [ $? -ne 0 ]; then
    rm -rf $GPG_AGENT_SOCK
    (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$HOME/.ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" >/dev/null 2>&1 &)
  fi
fi
# }}}

# {{{ COMPLETIONS
# GitHub-Cli Completions
if exists gh; then
  if ! [ -f /tmp/gh-completion.cache ]; then
    gh completion -s zsh > /tmp/gh-completion.cache
    zcompile /tmp/gh-completion.cache
  fi
  source /tmp/gh-completion.cache
fi

if exists pip; then
  if ! [ -f /tmp/pip-completion.cache ]; then
    pip completion --zsh > /tmp/pip-completion.cache
    zcompile /tmp/pip-completion.cache
  fi
  source /tmp/pip-completion.cache
fi

if exists aws; then
  zinit snippet 'https://github.com/aws/aws-cli/blob/v2/bin/aws_zsh_completer.sh'
fi

if exists npm; then
  zinit light 'lukechilds/zsh-better-npm-completion'
fi

# }}}

# {{{ TMUX
autoload -Uz add-zsh-hook
function tmux_ssh_preexec() {
  local command=$1
  if [[ "$command" = *ssh* ]]; then
    tmux setenv TMUX_SSH_CMD_$(tmux display -p "#I") $command
  fi
}
add-zsh-hook preexec tmux_ssh_preexec

function precmd() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi
}

function f() {
  local project dir repository session current_session out
  local ghq_root=$(ghq root)
  local ghq_command="ghq list -p | sed -e \"s|$HOME|~|\""
  local fzf_options_="--expect=ctrl-space --preview='eval bat --paging=never --style=plain --color=always {}/README.md 2>/dev/null'"
  local fzf_command="fzf-tmux ${fzf_options_}"
  fzf_command+=" ${FZF_PREVIEW_DEFAULT_SETTING}"
  fzf_command+=" --bind='${FZF_PREVIEW_DEFAULT_BIND}'"
  local command="${ghq_command} | ${fzf_command}"

  out=$(eval $command)
  dir=$(tail -1 <<< $out)
  project=$(echo $dir | sed -e "s|$ghq_root||")

  if [[ $project == "" ]]; then
    return 1
  fi

  if [[ ! -z ${TMUX} ]]; then
    repository=${dir##*/}
    session=${repository//./-}
    current_session=$(tmux list-sessions | grep 'attached' | cut -d":" -f1)

    tmux list-sessions | cut -d":" -f1 | grep -qe "^${session}\$"
    local ret=$?
    if [[ $ret = 0 ]]; then
      local is_duplicate=true
    else
      local is_duplicate=false
    fi

    if [[ $current_session =~ ^[0-9]+$ ]]; then
      if ! $is_duplicate; then
        eval builtin cd $dir
        tmux rename-session -t $current_session $session
      else
        tmux switch-client -t $session
      fi
    else
      if ! $is_duplicate; then
        eval tmux new-session -d -c "${dir}" -s "${session}"
        tmux switch-client -t $session
      else
        tmux switch-client -t $session
      fi
    fi
  fi
}

function _left-pane() {
  tmux select-pane -L
}
zle -N left-pane _left-pane

function _down-pane() {
  tmux select-pane -D
}
zle -N down-pane _down-pane

function _up-pane() {
  tmux select-pane -U
}
zle -N up-pane _up-pane

function _right-pane() {
  tmux select-pane -R
}
zle -N right-pane _right-pane

function _backspace-or-left-pane() {
  if [[ $#BUFFER -gt 0 ]]; then
    zle backward-delete-char
  elif [[ ! -z ${TMUX} ]]; then
    zle left-pane
  fi
}
zle -N backspace-or-left-pane _backspace-or-left-pane

function _kill-line-or-up-pane() {
  if [[ $#BUFFER -gt 0 ]]; then
    zle kill-line
  elif [[ ! -z ${TMUX} ]]; then
    zle up-pane
  fi
}
zle -N kill-line-or-up-pane _kill-line-or-up-pane

function _accept-line-or-down-pane() {
  if [[ $#BUFFER -gt 0 ]]; then
    zle accept-line
  elif [[ ! -z ${TMUX} ]]; then
    zle down-pane
  fi
}
zle -N accept-line-or-down-pane _accept-line-or-down-pane

bindkey '^k' kill-line-or-up-pane
bindkey '^l' right-pane
bindkey '^h' backspace-or-left-pane
bindkey '^j' accept-line-or-down-pane
# }}}

# FUNCTIONS {{{
# function emacs() {
#   echo "
#                     ■■                                        ■■                                                                                    
#                    ■■■■                                      ■■■■                               ■■■■■■■             ■■■■■■           ■■■■■■■■■      
#                    ■■■■                                      ■■■■                             ■■■■■■■■■■          ■■■■■■■■■■         ■■■■■■■■■■■    
#                                                                                              ■■■■■■ ■■■■■■       ■■■■■ ■■■■■■        ■■■    ■■■■■■  
#                                                                                             ■■■■       ■■       ■■■■      ■■■■       ■■■       ■■■  
#                                                                                            ■■■■                ■■■         ■■■■      ■■■        ■■■ 
#                                                                                            ■■■                 ■■■          ■■■      ■■■        ■■■■
#   ■■■         ■■■   ■■      ■■   ■■■■      ■■■■               ■■       ■■■■■■             ■■■                 ■■■           ■■■      ■■■         ■■■
#    ■■■        ■■    ■■      ■■  ■■■■■■■  ■■■■■■■              ■■      ■■■■■■■■■           ■■■                 ■■■            ■■■     ■■■         ■■■
#    ■■■       ■■■    ■■      ■■■■■■ ■■■■ ■■■■■■■■■             ■■     ■■■■   ■■■           ■■■                 ■■■            ■■■     ■■■         ■■■
#     ■■       ■■■    ■■      ■■■■     ■■■■■    ■■■             ■■     ■■■                  ■■■                 ■■■            ■■■     ■■■          ■■
#     ■■■      ■■     ■■      ■■■      ■■■       ■■■            ■■     ■■                   ■■■                 ■■■            ■■■     ■■■          ■■
#     ■■■     ■■■     ■■      ■■       ■■■       ■■■            ■■     ■■■                  ■■■      ■■■■■■■    ■■■            ■■■     ■■■          ■■
#      ■■     ■■■     ■■      ■■       ■■■       ■■■            ■■     ■■■■■                ■■■      ■■■■■■■    ■■■            ■■■     ■■■         ■■■
#      ■■■    ■■      ■■      ■■       ■■■       ■■■            ■■       ■■■■■■             ■■■          ■■■    ■■■            ■■■     ■■■         ■■■
#      ■■■   ■■■      ■■      ■■       ■■■       ■■■            ■■         ■■■■■            ■■■          ■■■    ■■■            ■■■     ■■■         ■■■
#       ■■   ■■■      ■■      ■■       ■■■       ■■■            ■■           ■■■■           ■■■          ■■■    ■■■           ■■■      ■■■         ■■■
#       ■■■  ■■       ■■      ■■       ■■■       ■■■            ■■             ■■            ■■■         ■■■     ■■■          ■■■      ■■■        ■■■ 
#       ■■■ ■■■       ■■      ■■       ■■■       ■■■            ■■             ■■■           ■■■■        ■■■     ■■■■        ■■■■      ■■■        ■■■ 
#        ■■ ■■■       ■■      ■■       ■■■       ■■■            ■■     ■       ■■             ■■■■       ■■■      ■■■■      ■■■■       ■■■      ■■■■  
#        ■■■■■        ■■      ■■       ■■■       ■■■            ■■    ■■■■    ■■■              ■■■■■■ ■■■■■■       ■■■■■ ■■■■■■        ■■■    ■■■■■   
#         ■■■■        ■■      ■■       ■■■       ■■■            ■■     ■■■■■■■■■                ■■■■■■■■■■■         ■■■■■■■■■■         ■■■■■■■■■■■    
#         ■■■         ■■      ■■       ■■■       ■■■            ■■       ■■■■■■                   ■■■■■■■             ■■■■■■           ■■■■■■■■■      
#   " && sleep 1 && if [[ "$@" =~  - ]]; then vim $2; else vim $@; fi
# }
function vim-startuptime-detail() {
  local time_file
  time_file=$(mktemp --suffix "_vim_startuptime.txt")
  echo "output: $time_file"
  time nvim --startuptime $time_file -c q
  tail -n 1 $time_file | cut -d " " -f1 | tr -d "\n" && echo " [ms]\n"
  cat $time_file | sort -n -k 2 | tail -n 20
}
function zsh-profiler() {
  ZSHRC_PROFILE=1 zsh -i -c zprof
}
# }}}

# {{{ HOOKS
add-zsh-hook preexec git_auto_save
function git_auto_save() {
  if [[ -d .git ]] && [[ -f .git/auto-save ]] && [[ $(find .git/auto-save -mmin -$((60)) | wc -l) -eq 0 ]]; then
    if [[ ! -f ".git/MERGE_HEAD" ]] && [[ $(git --no-pager diff --cached | wc -l) -eq 0 ]] && [[ ! -f .git/index.lock ]] && [[ ! -d .git/rebase-merge ]] && [[ ! -d .git/rebase-apply ]]; then
      touch .git/auto-save && git add --all && git commit --no-verify --message "Auto save: $(date -R)" >/dev/null && git reset HEAD^ >/dev/null
      echo "Git auto save!"
    fi
  fi
}
# }}}

# {{{ ENV
if exists opam; then
  if ! [ -f /tmp/opam.cache ]; then
    opam env > /tmp/opam.cache
    zcompile /tmp/opam.cache
  fi
  source /tmp/opam.cache
fi
# }}}

# {{{ OPTS
typeset -gU PATH
# }}}
