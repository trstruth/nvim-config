-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
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

      -- Mason (binaries only)
      require("mason").setup()

      local lspconfig = require("lspconfig")
      local util = lspconfig.util

      -- --------------------
      -- Rust (msrustup aware)
      -- --------------------
      local ms_toolchain = "ms-1.82" -- Match repo rust-toolchain.toml
      local mason_ra = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
      local ra_exec = (vim.fn.executable(mason_ra) == 1) and mason_ra or "rust-analyzer"

      -- Use MS toolchain by environment so cargo/rustc invoked by rust-analyzer
      -- go through msrustup multiplexing.
      local ra_cmd = { ra_exec }
      local ra_cmd_env = {
        MSRUSTUP_TOOLCHAIN = ms_toolchain,
      }

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        cmd = ra_cmd,
        cmd_env = ra_cmd_env,
        root_dir = util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              buildScripts = { enable = true }, -- needed for tonic/prost
            },
            procMacro = { enable = true },
            check = { command = "check" },
            diagnostics = { enable = true },
          },
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
            })
          end
        end,
      })

      -- ---------------
      -- Go (gopls)
      -- ---------------
      -- If gopls isn’t on PATH, point directly to Mason’s binary:
      -- local gopls_cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/gopls") }
      -- Otherwise just use "gopls":
      local gopls_cmd = { "gopls" }

      lspconfig.gopls.setup({
        cmd = gopls_cmd,
        capabilities = capabilities,
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            -- Formatting & imports:
            gofumpt = true,            -- stricter formatting
            -- Analyses & checks:
            staticcheck = true,
            analyses = {
              unusedparams = true,
              nilness = true,
              shadow = true,
              unusedwrite = true,
              useany = true,
            },
            -- Performance/UX:
            directoryFilters = { "-vendor" },
            usePlaceholders = true,
            hints = { assignVariableTypes = true, parameterNames = true },
          },
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
            })
          end
        end,
      })
    end,
  },
}
