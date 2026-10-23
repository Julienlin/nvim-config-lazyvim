-- nvim-lspconfig roots vtsls/eslint at the nearest lockfile. A lockfile without a
-- package.json next to it is not a project root (e.g. haw-backend-steroids'
-- server/workers/yarn.lock, used to publish the worker client): it would start a
-- separate tsserver without the repo tsconfig, and hide the repo eslint config.
local lockfiles = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }

local function js_project_root(bufnr)
  return vim.fs.root(bufnr, function(name, path)
    if name == ".git" then
      return true
    end
    return vim.list_contains(lockfiles, name) and vim.uv.fs_stat(path .. "/package.json") ~= nil
  end)
end

local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

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
        root_dir = function(bufnr, on_dir)
          local root = js_project_root(bufnr) or vim.fn.getcwd()
          -- only attach when an eslint config exists between the file and the root
          local config_file = vim.fs.find(eslint_config_files, {
            path = vim.api.nvim_buf_get_name(bufnr),
            type = "file",
            limit = 1,
            upward = true,
            stop = vim.fs.dirname(root),
          })[1]
          if config_file then
            on_dir(root)
          end
        end,
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
        root_dir = function(bufnr, on_dir)
          on_dir(js_project_root(bufnr) or vim.fn.getcwd())
        end,
        settings = {
          typescript = {
            tsserver = {
              -- large monorepos need more than the 3GB default; too low a cap makes
              -- tsserver OOM and restart in a loop
              maxTsServerMemory = 8192,
            },
            preferences = {
              -- don't eagerly index every dependency's package.json for auto-imports
              includePackageJsonAutoImports = "off",
              -- auto-imports use absolute paths (baseUrl/paths) instead of relative ones
              importModuleSpecifier = "non-relative",
            },
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
            },
          },
          javascript = {
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
            },
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
        },
      },
    },
  },
}
