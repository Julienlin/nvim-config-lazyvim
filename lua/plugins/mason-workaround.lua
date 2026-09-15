-- Pin mason to the 2.x line. The reason this pin was added is not recorded;
-- installed at the time of this note: mason 2.3.1. Re-evaluate (i.e. drop the
-- pin) whenever LazyVim starts requiring a newer major.
return {
  { "mason-org/mason.nvim", version = "^2.0.0" },
  { "mason-org/mason-lspconfig.nvim", version = "^2.0.0" },
}
