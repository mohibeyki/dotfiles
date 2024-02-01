return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function()
      require("trouble").setup({})

      vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle()
      end, { desc = "Trouble: Toggle" })

      vim.keymap.set("n", "<leader>xw", function()
        require("trouble").toggle("workspace_diagnostics")
      end, { desc = "Trouble: Workspace Diagnostics" })

      vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
      end, { desc = "Trouble: Document Diagnostics" })

      vim.keymap.set("n", "<leader>xq", function()
        require("trouble").toggle("quickfix")
      end, { desc = "Trouble: Quickfix" })

      vim.keymap.set("n", "<leader>xl", function()
        require("trouble").toggle("loclist")
      end, { desc = "Trouble: LOCList" })

      vim.keymap.set("n", "gR", function()
        require("trouble").toggle("lsp_references")
      end, { desc = "Trouble: LSP References" })
    end
  },
}
