return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope")
            telescope.setup()

            -- Find Git-tracked files (respects .gitignore)
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find file" })

            -- Grep through project (respects .gitignore)
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

            -- Global diagnostics across all buffers
            vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics (global)" })
            vim.keymap.set("n", "<leader>fD", function()
                require("telescope.builtin").diagnostics({ bufnr = 0 })
            end, { desc = "Diagnostics (current buffer)" })
                    end,
        },
}
