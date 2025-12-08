return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",            -- lazy-load when you run :Mason
        build = ":MasonUpdate",   -- keep registries up to date
        keys = {
            { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
        },
        config = function()
            require("mason").setup()
        end,
    },
}

