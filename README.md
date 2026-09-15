# 💤 LazyVim

Based on the [LazyVim](https://github.com/LazyVim/LazyVim) starter.
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Local specifics

Everything below is a deliberate deviation from stock LazyVim. Enabled extras
live in `lazyvim.json`; picker and explorer are snacks, completion is nvim-cmp
(with a supertab mapping), colorscheme is tokyonight `day`.

### Large TypeScript monorepos (`lua/plugins/nvim-lspconfig.lua`)

- `vtsls`: `maxTsServerMemory = 8192` (the 3GB default makes tsserver OOM-loop),
  `includePackageJsonAutoImports = "off"`, server-side fuzzy match with a 75-entry
  limit, and `importModuleSpecifier = "non-relative"` so auto-imports use
  `baseUrl`/`paths` rather than relative paths.
- Inlay hints are off by default (they fire a tsserver request on every edit and
  scroll). Toggle per session with `<leader>uh`.
- `eslint` LSP runs `onSave` only — type-checked configs are far too slow on every
  keystroke.
- Convention: when a repo ships `eslint/eslint-fast.config.js` (a lighter,
  non-type-checked config), it is used for editor feedback instead of the repo's
  default eslint config. Implemented for both backends below.

### ESLint backends (`lua/plugins/eslint-d.lua`, `lua/config/keymaps.lua`)

Two interchangeable backends, selected by `vim.g.eslint_backend`:

- `"lsp"` (default) — the eslint language server.
- `"eslint_d"` — the daemon, via nvim-lint.

Toggle with `<leader>ue`. Switching stops the eslint LSP clients / clears the
eslint_d diagnostics, so the two never run at once.

### Testing (`lua/plugins/neotest-vitest.lua`)

- `<leader>td` debugs the nearest test with `--testTimeout=0 --hookTimeout=0`.
- In `padoa/npm-packages`, the root `vitest.config.ts` derives `PACKAGE_NAME` from
  the last argv, but neotest-vitest ends its command with `--watch=false`. The
  adapter's `build_spec` is wrapped to inject `PACKAGE_NAME` into the env instead,
  derived from the test file path.

### Formatting & linting

- Prettier (conform) only runs in projects that have a prettier config file
  (`vim.g.lazyvim_prettier_needs_config`).
- markdownlint-cli2 points at `markdownlint.yaml` at this config's root, so MD013
  (line length) is off in every repo, not just those shipping their own config
  (`lua/plugins/markdown.lua`).
- Autoformat is disabled for `lua` files (`lua/config/autocmds.lua`). Run
  `stylua .` manually before committing to this repo.

### Misc

- `gopls` builds with `-tags=wireinject`.
- mason is pinned to the 2.x line (`lua/plugins/mason-workaround.lua`).
- `<c-h/j/k/l>` are tmux-aware via vim-tmux-navigator.
