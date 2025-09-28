return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional
	},
	lazy = false, -- neo-tree lazily loads itself
	config = function()
		vim.keymap.set("n", "<leader>o", ":Neotree toggle<CR>")
		vim.keymap.set("n", "<leader>e", ":Neotree focus<CR>")

		require("neo-tree").setup({
			default_component_configs = {
				git_status = {
					symbols = {
						added = " ",
						deleted = " ",
						modified = " ",
						renamed = " ",
						untracked = "",
						ignored = " ",
						unstaged = "",
						staged = "",
						conflict = "",
					},
					align = "right",
				},
			},
			filesystem = {
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					hide_by_pattern = {
						-- Godot
						"*.gd.uid",
						"*.gdshader.uid",
					},
				},
			},
		})
	end,
}
