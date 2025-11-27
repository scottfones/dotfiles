return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          -- Prioritize pyproject.toml for Python project root detection
          -- This allows Python subprojects in monorepos to be detected correctly
          root_markers = {
            "pyproject.toml",
            ".venv",
            ".git",
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
