return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "gruvbox-material",
				section_separators = "", -- Make separators flat & not angled
				component_separators = "",
			},
		})
	end,
}
