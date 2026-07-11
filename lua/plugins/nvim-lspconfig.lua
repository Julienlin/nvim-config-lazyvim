return {
  "neovim/nvim-lspconfig",
  opts = {
    -- inlay hints trigger tsserver requests on every edit/scroll; too costly in big
    -- TS monorepos. Toggle on demand with <leader>uh.
    inlay_hints = { enabled = false },
    servers = {
      gopls = {
        settings = {
          gopls = {
            buildFlags = { "-tags=wireinject" },
          },
        },
      },
      eslint = {
        settings = {
          -- lint on save only: type-checked eslint configs are far too slow to run on
          -- every keystroke in large repos
          run = "onSave",
        },
        before_init = function(params, config)
          -- defining before_init here replaces nvim-lspconfig's default one, which sets
          -- the required workspaceFolder setting (and flat-config/PnP support) — run it first
          local default_file = vim.api.nvim_get_runtime_file("lsp/eslint.lua", false)[1]
          if default_file then
            local ok, default = pcall(dofile, default_file)
            if ok and type(default) == "table" and type(default.before_init) == "function" then
              default.before_init(params, config)
            end
          end
          -- some repos (e.g. haw-backend-steroids) ship a lighter eslint config without
          -- the type-checked/slow rules; use it for editor feedback when present
          local root = config.root_dir
          if root then
            local fast_config = root .. "/eslint/eslint-fast.config.js"
            if vim.uv.fs_stat(fast_config) then
              config.settings = config.settings or {}
              config.settings.options = { overrideConfigFile = fast_config }
            end
          end
        end,
      },
      vtsls = {
        settings = {
          typescript = {
            tsserver = {
              -- large monorepos need more than the 3GB default; too low a cap makes
              -- tsserver OOM and restart in a loop
              maxTsServerMemory = 8192
            },
            preferences = {
              -- don't eagerly index every dependency's package.json for auto-imports
              includePackageJsonAutoImports = "off"
            },
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false
            }
          },
          javascript = {
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false
            }
          },
          vtsls = {
            experimental = {
              completion = {
                -- filter completions server-side instead of shipping 10k+ entries
                -- to the client on each keystroke
                enableServerSideFuzzyMatch = true,
                entriesLimit = 75,
              },
            },
          },
        }
      }
    },
  },
}
