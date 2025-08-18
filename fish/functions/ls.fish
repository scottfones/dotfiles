function ls --wraps='lsd --group-dirs first' --description 'alias ls lsd --group-dirs first'
    lsd --group-dirs first --classify --total-size $argv

end
