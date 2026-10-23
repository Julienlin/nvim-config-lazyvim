-- Replaces LazyVim's lang.vue extra, which assumes vtsls handles all TS files.
-- TS/JS files use tsc (TypeScript 7 native LSP), which does not load tsserver
-- plugins, so vtsls stays enabled for .vue files only and carries the Vue plugin.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.vue_ls = opts.servers.vue_ls or {}
      opts.servers.vtsls = {
        enabled = true,
        filetypes = { "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
        },
      }
    end,
  },
}
