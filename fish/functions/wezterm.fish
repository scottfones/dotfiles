function wezterm --description "WezTerm from local build"
    prime-run /home/scott/Applications/Wezterm/wezterm/target/release/wezterm --config-file /home/scott/.config/wezterm/wezterm.lua $argv
end
