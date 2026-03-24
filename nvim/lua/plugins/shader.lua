return {
  -- Treesitter parsers for shader languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "wgsl",
        "glsl",
      },
    },
  },

  -- Ensure Mason installs shader language servers
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "wgsl-analyzer",
        "glsl_analyzer",
      },
    },
  },

  -- Configure LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wgsl_analyzer = {
          settings = {
            ["wgsl-analyzer"] = {
              inlayHints = {
                structLayoutHints = true,
                typeVerbosity = "full", -- "compact" to hide address space and access mode
              },
            },
          },
        },
        glsl_analyzer = {},
      },
    },
  },
}
