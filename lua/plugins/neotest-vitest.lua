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
