return {
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "nix" } },
  },
  { dir = "/usr/share/fb-editor-support/nvim", name = "meta.nvim" },
}
