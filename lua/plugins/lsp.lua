return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },

    config = function()
      ---------------------------------------------------------------------------
      -- Diagnostics UI
      ---------------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        signs = true,
        update_in_insert = false,
      })

      ---------------------------------------------------------------------------
      -- Capabilities (nvim-cmp)
      ---------------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end)

      ---------------------------------------------------------------------------
      -- on_attach — everything that depends on the client+buffer relationship
      ---------------------------------------------------------------------------
      local function on_attach(client, bufnr)
        -- Format on save
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end

        -- Keymaps
        local tb = require("telescope.builtin")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        local function map_v(lhs, rhs, desc)
          vim.keymap.set({ "n", "v" }, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("gi", function()
          tb.lsp_implementations({ initial_mode = "normal" })
        end, "LSP: implementations")

        map("gy", function()
          tb.lsp_type_definitions({ initial_mode = "normal" })
        end, "LSP: type definitions")

        -- Add your preferred gd mapping here
        -- map("gd", vim.lsp.buf.definition, "LSP: definition")
        map("gd", function()
          tb.lsp_definitions({ initial_mode = "normal" })
        end, "LSP: definitions")

        map("gr", function()
          tb.lsp_references({ initial_mode = "normal" })
        end, "LSP: references")
      end

      ---------------------------------------------------------------------------
      -- Mason setup
      ---------------------------------------------------------------------------
      require("mason").setup()

      local util = require("lspconfig.util")

      ---------------------------------------------------------------------------
      -- rust-analyzer (new 0.11 model)
      --
      -- NOTE: In 0.11, the correct pattern is:
      --  1. Register a config in vim.lsp.config
      --  2. Autostart client with vim.lsp.start on FileType rust
      ---------------------------------------------------------------------------
      local mason_ra = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
      local ra_exec = (vim.fn.executable(mason_ra) == 1) and mason_ra or "rust-analyzer"

      vim.lsp.config["rust_analyzer"] = {
        cmd = { ra_exec },
        cmd_env = { MSRUSTUP_TOOLCHAIN = "stable" },
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "rust" },
        root_dir = util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true, buildScripts = { enable = true } },
            procMacro = { enable = true },
            check = { command = "check" },
            diagnostics = { enable = true },
          },
        },
      }

      -- Auto-start rust-analyzer on any Rust buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(args)
          vim.lsp.start(vim.lsp.config["rust_analyzer"], { bufnr = args.buf })
        end,
      })

      ---------------------------------------------------------------------------
      -- gopls
      ---------------------------------------------------------------------------
      vim.lsp.config["gopls"] = {
        cmd = { "gopls" },
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
            hints = { assignVariableTypes = true, parameterNames = true },
          },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go", "gomod", "gowork", "gotmpl" },
        callback = function(args)
          vim.lsp.start(vim.lsp.config["gopls"], { bufnr = args.buf })
        end,
      })
    end,
  },
}

