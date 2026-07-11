-- eslint_d (daemon) as an alternative backend to the eslint LSP.
-- vim.g.eslint_backend ("lsp" | "eslint_d") selects the active one — toggle with <leader>ue.
return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "eslint_d" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
      },
      linters = {
        eslint_d = {
          -- only run when the eslint_d backend is selected (see keymaps.lua toggle)
          condition = function()
            return vim.g.eslint_backend == "eslint_d"
          end,
          -- appended after the default args; a function arg must always return a
          -- string (nil would corrupt the arg list), hence the harmless fallback
          prepend_args = {
            function()
              -- same trick as the eslint LSP: prefer the repo's lighter non-type-checked
              -- config (e.g. haw-backend-steroids) when it exists
              local cfg = vim.fs.find(
                { "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs" },
                { path = vim.api.nvim_buf_get_name(0), upward = true }
              )[1]
              if cfg then
                local fast = vim.fs.dirname(cfg) .. "/eslint/eslint-fast.config.js"
                if vim.uv.fs_stat(fast) then
                  return "--config=" .. fast
                end
              end
              return "--no-color"
            end,
          },
        },
      },
    },
  },
}
