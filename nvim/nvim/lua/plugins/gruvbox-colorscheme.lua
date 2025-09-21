return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		vim.o.background = "dark"
		vim.cmd([[colorscheme gruvbox]])
        vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { link = "GruvboxBlue" })
        vim.api.nvim_set_hl(0, "NeoTreeGitRemoved", { link = "GruvboxRed" })
        vim.api.nvim_set_hl(0, "NeoTreeGitModified", { link = "GruvboxGreen" })
	end,
}
