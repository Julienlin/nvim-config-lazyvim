return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    keys = {
      {
        "<leader>td",
        function()
          require("neotest").run.run({
            strategy = "dap",
            extra_args = { "--testTimeout=0", "--hookTimeout=0" },
          })
        end,
        desc = "Debug Nearest (no timeout)",
      },
    },
    opts = function(_, opts)
      local vitest = require("neotest-vitest")({
        filter_dir = function(name, _relpath, _root)
          return name ~= "node_modules" and name ~= "dist"
        end,
      })

      -- padoa/npm-packages : le vitest.config.ts racine déduit PACKAGE_NAME du
      -- dernier argv, mais neotest-vitest termine sa commande par --watch=false.
      -- On injecte donc PACKAGE_NAME dans l'env à partir du chemin du test.
      local build_spec = vitest.build_spec
      vitest.build_spec = function(args)
        local spec = build_spec(args)
        if spec then
          local pkg = args.tree:data().path:match("/npm%-packages[^/]*/packages/([^/]+)")
          if pkg then
            spec.env = vim.tbl_extend("force", spec.env or {}, { PACKAGE_NAME = pkg })
          end
        end
        return spec
      end

      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, vitest)
    end,
  },
}
