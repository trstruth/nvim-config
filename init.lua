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

-- case-insensitive search/replace
vim.opt.ignorecase = true

-- system clipboard
vim.opt.clipboard = "unnamedplus"

-- Portable clipboard provider (WSL, Linux/Wayland, Linux/X11)
local function has(cmd) return vim.fn.executable(cmd) == 1 end
local is_wsl = (vim.fn.has("wsl") == 1) or (vim.loop.os_uname().release or ""):match("Microsoft")

if is_wsl then
  if has("win32yank.exe") then
    -- Fastest/cleanest on WSL if present
    vim.g.clipboard = {
      name = "win32yank",
      copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
      paste = { ["+"] = "win32yank.exe -o --lf",   ["*"] = "win32yank.exe -o --lf"   },
      cache_enabled = 0,
    }
  elseif has("pwsh.exe") then
    -- PowerShell 7 gives Set-Clipboard / Get-Clipboard
    vim.g.clipboard = {
      name = "pwsh",
      copy  = { ["+"] = "pwsh.exe -NoProfile -Command Set-Clipboard", ["*"] = "pwsh.exe -NoProfile -Command Set-Clipboard" },
      paste = { ["+"] = "pwsh.exe -NoProfile -Command Get-Clipboard", ["*"] = "pwsh.exe -NoProfile -Command Get-Clipboard" },
      cache_enabled = 0,
    }
  else
    -- Classic Windows PowerShell v5 + clip.exe
    vim.g.clipboard = {
      name = "WslClipboard",
      copy  = { ["+"] = "clip.exe", ["*"] = "clip.exe" },
      paste = {
        ["+"] = "powershell.exe -NoProfile -Command Get-Clipboard",
        ["*"] = "powershell.exe -NoProfile -Command Get-Clipboard",
      },
      cache_enabled = 0,
    }
  end
else
  -- Native Linux (no WSL): prefer Wayland, then X11
  if os.getenv("WAYLAND_DISPLAY") and has("wl-copy") and has("wl-paste") then
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy  = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
      paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --no-newline" },
      cache_enabled = 0,
    }
  elseif has("xclip") then
    vim.g.clipboard = {
      name = "xclip",
      copy  = { ["+"] = "xclip -selection clipboard -in",  ["*"] = "xclip -selection primary -in" },
      paste = { ["+"] = "xclip -selection clipboard -out", ["*"] = "xclip -selection primary -out" },
      cache_enabled = 0,
    }
  elseif has("xsel") then
    vim.g.clipboard = {
      name = "xsel",
      copy  = { ["+"] = "xsel --clipboard --input",  ["*"] = "xsel --primary --input" },
      paste = { ["+"] = "xsel --clipboard --output", ["*"] = "xsel --primary --output" },
      cache_enabled = 0,
    }
  end
end

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

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

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
