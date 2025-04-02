return {
  { import = "lazyvim.plugins.extras.lsp.none-ls" },
  {
    dir = "/usr/share/fb-editor-support/nvim",
    name = "meta.nvim",
    config = function()
      require("meta").setup()
      require("meta.lsp")
      local servers = { "rust-analyzer@meta", "pyls@meta", "pyre@meta", "thriftlsp@meta", "cppls@meta" }
      for _, lsp in ipairs(servers) do
        require("lspconfig")[lsp].setup({
          on_attach = on_attach,
        })
      end
    end,
  },
}
