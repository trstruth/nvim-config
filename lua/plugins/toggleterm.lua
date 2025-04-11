return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 15,
            open_mapping = [[<C-`>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            direction = "horizontal", -- can be 'vertical' | 'horizontal' | 'tab' | 'float'
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })

        vim.keymap.set("n", "<leader><Tab>", "<cmd>ToggleTerm<CR>", {
            noremap = true,
            silent = true,
            desc = "Toggle terminal",
        })
    end,
}
