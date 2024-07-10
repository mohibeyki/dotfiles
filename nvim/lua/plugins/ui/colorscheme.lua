return {

  -- Folke's tokyonight theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
    enabled = false,
  },

  -- Onedark pro theme
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    config = function()
      vim.cmd([[colorscheme onedark]])
    end,
    enabled = false,
  },

  -- draclua theme
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme dracula]])
    end,
    enabled = false,
  },

  -- rose pine theme
  {
    "rose-pine/neovim",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        styles = {
          italic = false,
        },
      })
      vim.cmd([[colorscheme rose-pine-moon]])
    end,
    -- enabled = false,
  },
}
