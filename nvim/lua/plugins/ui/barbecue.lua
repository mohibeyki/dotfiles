local lsp = require("util.lsp")
local icons = require("config.icons")

return {

  -- Winbar using navic
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      {
        "SmiteshP/nvim-navic",
        opts = function()
          return {
            separator = " ",
            highlight = true,
            depth_limit = 5,
            icons = icons.kinds,
            lazy_update_context = true,
          }
        end,
      },

      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    init = function()
      vim.g.navic_silence = true
      lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = {},
  },
}
