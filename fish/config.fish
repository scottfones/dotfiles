if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set ls colors
# eval (dircolors -c)
set -gx LS_COLORS "$(vivid generate one-dark)"

# theme
# source ~/.config/fish/themes/kanagawa.fish

# nvm, npm, node 
bass source ~/.nvm/nvm.sh

# source /home/scott/.python_general_venv/bin/activate.fish
starship init fish | source
zoxide init fish | source
