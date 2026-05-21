return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window/Pane left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window/Pane down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window/Pane up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window/Pane right" },
    },
  },
}
