# show full path in zsh
#PS1='%n@%m %1/ %# '
PS1='%~ %# '

autoload bashcompinit && bashcompinit

# node version manager
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completionexport PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

eval "$(zoxide init zsh)"

export XDG_CONFIG_HOME="$HOME/.config"

# Created by `pipx` on 2023-03-24 18:21:46
export PATH="$PATH:$HOME/.local/bin"

alias lg='lazygit'
alias df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ldf='/opt/homebrew/bin/lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

gbd() {
  # https://stackoverflow.com/a/33548037/10735867
  git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
}

bindkey -v
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward

# fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Yank to the system clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Function to set the tab title during command execution
function preexec() {
    print -Pn "\e]0;%~ ($1)\a"
}

# Function to set the tab title after command completion
function precmd() {
    print -Pn "\e]0;%~\a"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
