return {
    { "echasnovski/mini.pairs", enabled = false },
    { "mason-org/mason.nvim",   enabled = false },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "nix" } },
    },
}
