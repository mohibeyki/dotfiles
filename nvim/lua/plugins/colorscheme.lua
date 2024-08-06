return {

  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Ensure it loads first
  },

  -- enable onedark pro colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
