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
        end,
    },
}
