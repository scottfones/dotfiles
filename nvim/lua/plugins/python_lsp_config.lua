return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          -- Force basedpyright to use git root as project root
          -- This prevents duplicate LSP instances in UV workspaces
          root_markers = {
            ".git",
            ".venv",
          },
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "workspace",
              },
            },
          },
        },
        ruff = {
          root_markers = {
            ".git",
            ".venv",
          },
        },
      },
    },
  },
}
