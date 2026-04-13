eval (/opt/homebrew/bin/brew shellenv)

fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.go/bin

set -x GOPATH $HOME/.go

if status is-interactive
    set -U fish_greeting ""

    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # Directories
    abbr -a s du -h
    abbr -a p pwd
    abbr -a pc 'pwd | tee /dev/tty | pbcopy'
    abbr -a ll 'ls -lah'
    abbr -a lt 'ls -laht'
    abbr -a ltt 'ls -laht --color=always | tac'

    # Fuzzy Finder
    abbr -a f "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
    abbr -a fvf 'vim (fzf --height 40% --reverse)'
    abbr -a hist 'history | fzf'
    abbr -a ps "ps aux | sed 1,1d | fzf --height 40% --reverse | sed -En 's/^[^0-9]+[ ]+([0-9]+)[ ]+.*/\1/p'"

    # Python
    abbr -a python python3
    abbr -a pip pip3

    # Claude Code
    abbr -a c claude
    abbr -a cc 'claude --continue'

    # Neovim
    abbr -a vim nvim

    # Git
    abbr -a gco git checkout
    abbr -a gcob git checkout -b
    abbr -a gst git status
    abbr -a gp git push

    # Miscellaneous
    abbr -a copy pbcopy
    abbr -a reload 'source ~/.config/fish/config.fish'
    abbr -a config 'nvim ~/.config/fish/config.fish'

    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
end

function fish_title
    echo $PWD | string replace $HOME '~'
end

if test -n "$SSH_CONNECTION"
      set -x EDITOR vim # remote
  else
      set -x EDITOR nvim # local
  end
