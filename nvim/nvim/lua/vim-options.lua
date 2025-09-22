vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>w", ":wa<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":qa<CR>", { noremap = true, silent = true })

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.number = true
vim.opt.relativenumber = true

vim.diagnostic.config({
	signs = true,
	underline = true,
	severity_sort = true,
})
