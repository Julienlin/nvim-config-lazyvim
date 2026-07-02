-- Point markdownlint-cli2 at a shared config (markdownlint.yaml at the nvim
-- config root) so rules like MD013 (line-length) are disabled in every repo,
-- not only those that ship their own local markdownlint config.
local config = vim.fn.stdpath("config") .. "/markdownlint.yaml"

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", config, "-" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", config },
        },
      },
    },
  },
}
