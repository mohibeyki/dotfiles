-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('augroup-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
