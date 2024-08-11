return {

  -- enable inlay-hints
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enable = true } } },

  -- enable bufferline even when there is only one buffer open
  { "akinsho/bufferline.nvim", opts = { options = { always_show_bufferline = true } } },

  -- disable stuff I don't need!
  { "echasnovski/mini.pairs", enabled = false },
  { "catppuccin/nvim", enabled = false },

  -- disable rust-analyzer to use system's rust-analyzer
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  -- helps with resizing windows
  { "kwkarlwang/bufresize.nvim" },

  -- tmux navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- some neotree settings
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
          never_show = {},
        },
      },
    },
  },
}
