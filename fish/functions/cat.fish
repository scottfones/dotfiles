function cat --wraps=bat --wraps='bat --paging=never' --description 'alias cat=bat --paging=never'
  bat --paging=never $argv
        
end
