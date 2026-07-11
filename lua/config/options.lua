-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ignoring for now because I am coming back from vacation
-- vim.g.lazyvim_ts_lsp = "tsgo"

-- prettier (conform) only runs in projects that have a prettier config file
vim.g.lazyvim_prettier_needs_config = true

-- ESLint backend: "lsp" (eslint language server) or "eslint_d" (daemon via nvim-lint)
-- toggle with <leader>ue
vim.g.eslint_backend = "lsp"
