return {
    -- which-key helps you remember key bindings by showing a popup
    -- with the active keybindings of the command you started typing.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            defaults = {},
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>b",     group = "buffer" },
                    { "<leader>c",     group = "code" },
                    { "<leader>f",     group = "file/find" },
                    { "<leader>g",     group = "git" },
                    { "<leader>gh",    group = "hunks" },
                    { "<leader>q",     group = "quit/session" },
                    { "<leader>s",     group = "search" },
                    { "<leader>u",     group = "ui" },
                    { "<leader>w",     group = "windows" },
                    { "<leader>x",     group = "diagnostics/quickfix" },
                    { "[",             group = "prev" },
                    { "]",             group = "next" },
                    { "g",             group = "goto" },
                    { "gs",            group = "surround" },
                    { "z",             group = "fold" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            if not vim.tbl_isempty(opts.defaults) then
                LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
                wk.register(opts.defaults)
            end
        end,
    },
}
