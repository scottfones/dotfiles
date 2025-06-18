function mpv --description 'alias mpv LD_PRELOAD=/usr/lib/libjemalloc.so.2 prime-run mpv'
  LD_PRELOAD=/usr/lib/libjemalloc.so.2 prime-run mpv $argv
        
end
