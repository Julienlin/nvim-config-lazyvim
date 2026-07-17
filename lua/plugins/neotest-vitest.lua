return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {
          filter_dir = function(name, _relpath, _root)
            return name ~= "node_modules" and name ~= "dist"
          end,
        },
      },
    },
  },
}
