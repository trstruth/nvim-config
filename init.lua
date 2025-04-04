-- init.lua

-- Set leader key
vim.g.mapleader = ","

-- Save with spacebar
vim.keymap.set("n", "<space>", "<cmd>w<CR>", { desc = "Save file" })

-- set true colors
vim.opt.termguicolors = true

-- disable netrw (default file browser)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use spaces instead of tabs, and 4 spaces wide
vim.opt.expandtab = true   -- tabs become spaces
vim.opt.shiftwidth = 4     -- >> and << shift by 4
vim.opt.tabstop = 4        -- tab key = 4 spaces
vim.opt.smartindent = true -- smart auto-indenting

-- Line numbers
vim.opt.number = true         -- Absolute line numbers
vim.opt.relativenumber = true -- Relative line numbers

-- Splits
vim.keymap.set("n", "<leader>w", "<cmd>vsplit<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>v", "<cmd>split<CR>", { desc = "Vertical split" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- quit
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close current window" })

-- Save and quit
vim.keymap.set("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Force quit (close without saving)
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force quit" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { desc = "Hover doc" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
vim.keymap.set("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")
