function nvidia-run --wraps='LD_PRELOAD=/usr/lib/libjemalloc.so.2 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia' --description 'alias nvidia-run LD_PRELOAD=/usr/lib/libjemalloc.so.2 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'
  LD_PRELOAD=/usr/lib/libjemalloc.so.2 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $argv
        
end
