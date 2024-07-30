return {

  -- enable inlay-hints
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enable = true } } },

  -- enable bufferline even when there is only one buffer open
  { "akinsho/bufferline.nvim", opts = { options = { always_show_bufferline = true } } },

  -- disable stuff I don't need!
  { "echasnovski/mini.pairs", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },

  -- add lazyvim language extras
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.nix" },
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- enable extra plugins
  { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.editor.illuminate" },
  { import = "lazyvim.plugins.extras.editor.navic" },
  { import = "lazyvim.plugins.extras.editor.outline" },
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "go",
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
      },
    },
  },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "delve",
        "flake8",
        "gofumpt",
        "golangci-lint",
        "golangci-lint-langserver",
        "gopls",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
  },
}
