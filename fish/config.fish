if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set ls colors
eval (dircolors -c)

# source /home/scott/.python_general_venv/bin/activate.fish
starship init fish | source
zoxide init fish | source
