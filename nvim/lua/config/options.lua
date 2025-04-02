-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_check_order = false

vim.g.meta = false
local f = io.open("/usr/share/fb-editor-support", "r")
if f ~= nil then
  io.close(f)
  vim.g.meta = true
end
