return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            buildFlags = { "-tags=wireinject" },
          },
        },
      },
      vtsls = {
        settings = {
          typescript = {
            tsserver = {
              maxTsServerMemory = 4096
            },
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false
            }
          },
          javascript = {
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false
            }
          }
        }
      }
    },
  },
}
