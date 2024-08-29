eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH:/Users/alex/Library/Application Support/JetBrains/Toolbox/scripts" # Added by Toolbox App

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

