return {
	{
        -- TODO: setup keybindings
		"FabijanZulj/blame.nvim",
		lazy = false,
		config = function()
			require("blame").setup({})
		end,
	},
}
