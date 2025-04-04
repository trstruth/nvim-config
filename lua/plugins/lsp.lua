return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			vim.diagnostic.config({
				underline = true, -- this enables underlines
				virtual_text = true, -- optional: inline messages
				signs = true, -- optional: signs in the gutter
				update_in_insert = false, -- only update diagnostics after leaving insert mode
			})


			-- Lua
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			-- Python
			lspconfig.pyright.setup({})

			-- Go
			lspconfig.gopls.setup({})

			-- Rust
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			})


			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
