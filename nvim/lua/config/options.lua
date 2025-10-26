-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set default shell
vim.o.shell = "/usr/bin/fish"

-- neovim python virtual environment
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/bin/python")
-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- vim.g.python3_host_prog = "/home/scott/.python_general_venv/bin/python3"
vim.o.guicursor = "n-v-c-sm-ve:block,r-cr-o-i-ci:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- wl clipboard transient window fix
vim.opt.clipboard = "unnamedplus"

-- LSP Server to use for Rust.
-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer.
-- only for diagnostics. The rest of LSP support will still be
-- provided by rust-analyzer.
-- vim.g.lazyvim_rust_diagnostics = "bacon-ls"

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = { "--all", "--", "-W", "clippy::all", "-W", "clippy::pedantic", "-W", "clippy::nursery" },
        },
      },
    },
  },
}
