return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },

    config = function()
      --------------------------------------------------------------------
      -- Diagnostics UI
      --------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      --------------------------------------------------------------------
      -- Capabilities (cmp integration)
      --------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end)

      --------------------------------------------------------------------
      -- Dependencies
      --------------------------------------------------------------------
      require("mason").setup()
      local tb = require("telescope.builtin")
      local util = require("lspconfig.util")

            --------------------------------------------------------------------
            -- Global on_attach
            --------------------------------------------------------------------
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    ---------------------------------------------------------------
                    -- Format on save
                    ---------------------------------------------------------------
                    if client.server_capabilities.documentFormattingProvider then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end

                    ---------------------------------------------------------------
                    -- Organize imports (range-aware)
                    ---------------------------------------------------------------
                    local function organize_imports()
                        local mode = vim.fn.mode()

                        -- Visual mode = range version
                        if mode == "v" or mode == "V" or mode == "\22" then
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { "source.organizeImports" } }

                            local results =
                            vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 700)

                            if results then
                                for _, res in pairs(results) do
                                    for _, action in ipairs(res.result or {}) do
                                        vim.lsp.buf.execute_command(action.command or action)
                                        return
                                    end
                                end
                            end
                        end

                        -- Normal mode = entire file
                        local params = { context = { only = { "source.organizeImports" } } }

                        local results =
                        vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 700)

                        if results then
                            for _, res in pairs(results) do
                                for _, action in ipairs(res.result or {}) do
                                    vim.lsp.buf.execute_command(action.command or action)
                                    return
                                end
                            end
                        end
                    end

                    ---------------------------------------------------------------
                    -- Keymaps
                    ---------------------------------------------------------------
                    local tb = require("telescope.builtin")

                    local function map(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    local function map_v(lhs, rhs, desc)
                        vim.keymap.set({ "n", "v" }, lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    map("gd", function() tb.lsp_definitions({ initial_mode = "normal" }) end, "Go to definition")
                    map("gr", function() tb.lsp_references({ initial_mode = "normal" }) end, "Find references")
                    map("gi", function() tb.lsp_implementations({ initial_mode = "normal" }) end, "Go to implementations")
                    map("gy", function() tb.lsp_type_definitions({ initial_mode = "normal" }) end, "Go to type definitions")

                    map_v("<leader>oi", organize_imports, "Organize imports")
                end,
            })


            --------------------------------------------------------------------
            -- rust-analyzer
            --------------------------------------------------------------------
            local ms_toolchain = "ms-1.82"
            local mason_ra = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
            local ra_exec = (vim.fn.executable(mason_ra) == 1) and mason_ra or "rust-analyzer"

            vim.lsp.config["rust_analyzer"] = {
                cmd = { ra_exec },
                cmd_env = { MSRUSTUP_TOOLCHAIN = ms_toolchain },
                capabilities = capabilities,
                root_dir = util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            buildScripts = { enable = true },
                        },
                        procMacro = { enable = true },
                        check = { command = "check" },
                        diagnostics = { enable = true },
                    },
                },
            }

            vim.lsp.enable("rust_analyzer")

            --------------------------------------------------------------------
            -- gopls
            --------------------------------------------------------------------
            vim.lsp.config["gopls"] = {
                cmd = { "gopls" },
                capabilities = capabilities,
                root_dir = util.root_pattern("go.work", "go.mod", ".git"),
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        analyses = {
                            unusedparams = true,
                            nilness = true,
                            shadow = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        directoryFilters = { "-vendor" },
                        usePlaceholders = true,
                        hints = {
                            assignVariableTypes = true,
                            parameterNames = true,
                        },
                    },
                },
            }

            vim.lsp.enable("gopls")
        end,
    },
}

