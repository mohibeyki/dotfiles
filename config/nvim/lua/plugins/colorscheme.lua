return {
  {
    "folke/tokyonight.nvim",
    opts = function()
      return {
        style = "moon",
        on_colors = function(colors)
          colors.border = colors.orange
        end,
      }
    end,
  },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
}
