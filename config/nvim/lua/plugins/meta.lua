return {
  {
    dir = "/usr/share/fb-editor-support/nvim",
    name = "meta.nvim",
    import = "meta.lazyvim",
    cond = function()
      local f = io.open("/usr/share/fb-editor-support", "r")
      if f ~= nil then
        io.close(f)
        return true
      else
        return false
      end
    end,
  },
}
