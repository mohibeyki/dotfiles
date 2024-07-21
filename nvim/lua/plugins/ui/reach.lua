return {

  -- Reach is a plugin to quickly navigate buffers and marks
  {
    "toppair/reach.nvim",
    config = function()
      require("reach").setup()
      vim.keymap.set("n", "<leader>rb", "<cmd>ReachOpen buffers<cr>", { desc = "[R]each [B]uffers" })
    end,
  },
}
