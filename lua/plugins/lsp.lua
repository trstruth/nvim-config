-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Diagnostics UI
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      -- Capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end)

      -- Mason binary manager
      require("mason").setup()

      local lspconfig = require("lspconfig")
      local util = lspconfig.util
      local tb = require("telescope.builtin")

      ---------------------------------------------------
      -- Shared on_attach: formatting + LSP keybindings --
      ---------------------------------------------------
      local function on_attach(client, bufnr)
        -- Auto-format on save if supported
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end

        -- Buffer-local keymap helper
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        ---------------------------------------------------
        -- LSP Navigation (Telescope-powered)
        ---------------------------------------------------
        map("gd", function() tb.lsp_definitions({ initial_mode = "normal" }) end, "Go to definition")
        map("gr", function() tb.lsp_references({ initial_mode = "normal" }) end, "Find references")
        map("gi", function() tb.lsp_implementations({ initial_mode = "normal" }) end, "Go to implementations")
        map("gy", function() tb.lsp_type_definitions({ initial_mode = "normal" }) end, "Go to type definitions")
      end

      --------------------
      -- Rust Analyzer --
      --------------------
      local ms_toolchain = "ms-1.82"
      local mason_ra = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
      local ra_exec = (vim.fn.executable(mason_ra) == 1) and mason_ra or "rust-analyzer"

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        cmd = { ra_exec },
        cmd_env = { MSRUSTUP_TOOLCHAIN = ms_toolchain },
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
        on_attach = on_attach,
      })

      --------------
      -- Go (gopls)
      --------------
      local gopls_cmd = { "gopls" }

      lspconfig.gopls.setup({
        cmd = gopls_cmd,
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
        on_attach = on_attach,
      })
    end,
  },
}

