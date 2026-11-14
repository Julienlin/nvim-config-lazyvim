-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- TypeScript 7 native language server (`tsc --lsp`) instead of vtsls
vim.g.lazyvim_ts_lsp = "tsc"

-- prettier (conform) only runs in projects that have a prettier config file
vim.g.lazyvim_prettier_needs_config = true

-- ESLint backend: "lsp" (eslint language server) or "eslint_d" (daemon via nvim-lint)
-- toggle with <leader>ue
vim.g.eslint_backend = "lsp"

-- OS clipboard only when a graphical session is present, so the config also works over SSH and on headless machines
if vim.env.SSH_TTY == nil and (vim.env.WAYLAND_DISPLAY or vim.env.DISPLAY) then
  vim.opt.clipboard = "unnamedplus"
end
