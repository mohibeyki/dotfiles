return {

  -- enable inlay-hints
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enable = true } } },

  -- enable bufferline even when there is only one buffer open
  { "akinsho/bufferline.nvim", opts = { options = { always_show_bufferline = true } } },

  -- disable stuff I don't need!
  { "echasnovski/mini.pairs", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
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
