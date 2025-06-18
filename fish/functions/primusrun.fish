function primusrun --wraps='LD_PRELOAD=/usr/lib/libjemalloc.so.2 __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only' --description 'alias primusrun LD_PRELOAD=/usr/lib/libjemalloc.so.2 __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only'
  LD_PRELOAD=/usr/lib/libjemalloc.so.2 __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only $argv
        
end
