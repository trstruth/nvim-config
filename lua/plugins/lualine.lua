return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional but looks better
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto", -- Uses your colorscheme
					section_separators = "",
					component_separators = "",
				},
			})
		end,
	},
}
