return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local function my_on_attach(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end

                -- Default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- Custom mappings
                vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
                vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))

                -- Ctrl+n to create file
                vim.keymap.set("n", "<C-n>", api.fs.create, opts("Create File"))

                -- Ctrl+Shift+n to create folder (depends on terminal support)
                vim.keymap.set("n", "<C-S-n>", function()
                    vim.ui.input({ prompt = "Folder name: " }, function(input)
                        if input and input ~= "" then
                            api.fs.create(input .. "/")
                        end
                    end)
                end, opts("Create Folder"))

                -- Delete with <Del>
                vim.keymap.set("n", "<Del>", api.fs.remove, opts("Delete with confirm"))

                -- Enter to open in current window (buffer-style)
                vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open: In Current Window"))
            end

            require("nvim-tree").setup({
                on_attach = my_on_attach,
            })

            vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
        end,
    },
}
