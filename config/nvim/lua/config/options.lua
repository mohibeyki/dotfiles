-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- show absolute numbers in insert mode, relative in normal mode
opt.relativenumber = true

opt.hidden = true -- allow background buffers
opt.joinspaces = false -- join lines without two spaces

-- Disable LazyVim's default clipboard.
opt.clipboard = ""

-- Tab complete for cmd mode should autocomplete the first result immediately.
opt.wildmode = "full"

vim.g.metaExists = false
local file = io.open("/usr/share/fb-editor-support/nvim", "r")
if file ~= nil then
  io.close(file)
  vim.g.metaExists = true
else
  vim.g.metaExists = false
end
