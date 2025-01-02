return {
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
  },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine-moon")
    end,
  },
}
