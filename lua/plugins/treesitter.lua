return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
            -- Ensure parsers for languages you work with so function/method
            -- nodes can be highlighted by Tree-sitter too.
            ensure_installed = { "lua", "vim", "markdown", "c", "go", "gomod", "gowork", "rust" },
        })

        -- For Neovim versions where Tree-sitter highlighting can be overridden
        -- by semantic tokens, explicitly prefer TS highlight groups for functions
        -- if you like their style more than the default.
        vim.api.nvim_set_hl(0, "@method", { link = "Function", default = false })
        vim.api.nvim_set_hl(0, "@function", { link = "Function", default = false })
        vim.api.nvim_set_hl(0, "@method.call", { link = "Function", default = false })
        vim.api.nvim_set_hl(0, "@function.call", { link = "Function", default = false })
    end,
}
