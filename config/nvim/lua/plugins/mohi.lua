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

  -- Helps with navigation within tmux
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
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
