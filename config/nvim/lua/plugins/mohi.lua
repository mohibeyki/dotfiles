return {
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "nix" } },
  },
  {
    dir = "/usr/share/fb-editor-support/nvim",
    name = "meta.nvim",
    cond = function()
      local file = vim.fn.expand("/usr/share/fb-editor-support/nvim")
      local f = io.open(file, "r")
      if f ~= nil then
        io.close(f)
        return true
      else
        return false
      end
    end,
  },
}
