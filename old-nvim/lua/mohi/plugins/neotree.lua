return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>nt", "<cmd>Neotree toggle<CR>", mode = "n", desc = "NeoTree: Toggle" },
  },
  opts = {
    filesystem = {
      netrw_hijack_behavior = "open_split"
    },
  },
  lazy = false
}
