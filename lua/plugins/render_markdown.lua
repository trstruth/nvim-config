return {
    -- Render Markdown inside Neovim buffers
    "MeanderingProgrammer/render-markdown.nvim",
    -- Only load when editing Markdown (or injected Markdown) buffers
    ft = { "markdown" },
    -- Treesitter is required for proper parsing/rendering
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        -- Use default settings – adjust here if desired
        require("render-markdown").setup({})

        -- Toggle rendered/raw view of the current buffer
        vim.keymap.set(
            "n",
            "<leader>um",
            function()
                require("render-markdown").toggle()
            end,
            { desc = "Toggle render Markdown" }
        )
    end,
}

