local M = {}

---@param opts? LazyVimConfig
function M.setup(opts)
  require("mohi.lazy")
  require("mohi.config").setup(opts)
  require("mohi.keymaps")
  require("mohi.after")
end

return M
