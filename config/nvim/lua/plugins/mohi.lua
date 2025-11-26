return {
  -- Nix setup
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "nix" } } },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {},
      },
    },
  },
  opts = {
    formatters_by_ft = {
      nix = { "nixfmt" },
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
