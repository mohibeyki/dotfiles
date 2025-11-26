return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "go",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "vim",
        "yaml",
        "zig",
      },
    },
  },

  --
  -- Disabled plugins from lazyvim
  --
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "mason-org/mason.nvim",
    enabled = false,
  },
}
