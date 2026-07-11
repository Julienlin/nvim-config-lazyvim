-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Switch the ESLint backend between the eslint LSP (default) and eslint_d via nvim-lint
-- (see plugins/eslint-d.lua)
Snacks.toggle({
  name = "eslint_d (instead of eslint LSP)",
  get = function()
    return vim.g.eslint_backend == "eslint_d"
  end,
  set = function(state)
    vim.g.eslint_backend = state and "eslint_d" or "lsp"
    -- stops running eslint LSP clients when disabled, re-attaches open buffers when enabled
    vim.lsp.enable("eslint", not state)
    if state then
      require("lint").try_lint()
    else
      local ns = require("lint").get_namespace("eslint_d")
      if ns then
        vim.diagnostic.reset(ns)
      end
    end
  end,
}):map("<leader>ue")
