return {
  {
    dir = "/usr/share/fb-editor-support/nvim",
    name = "meta.nvim",
    import = "meta.lazyvim",
    cond = vim.g.metaExists,
  },
  { "zbirenbaum/copilot.lua", cond = not vim.g.metaExists },
  { "blink-cmp-copilot", cond = not vim.g.metaExists },
}
