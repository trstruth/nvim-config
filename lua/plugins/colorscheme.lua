return {
  {
    "adisen99/apprentice.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "apprentice",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme apprentice")

      -- Optional: add a few LSP semantic token -> highlight group links so
      -- methods/functions stand out if semantic highlighting is enabled.
      -- These links are no-ops if your Neovim build doesn't send semantic tokens.
      local function link(src, dst)
        vim.api.nvim_set_hl(0, src, { link = dst, default = false })
      end
      -- LSP semantic tokens → fall back to Function/Type
      link("@lsp.type.method", "Function")
      link("@lsp.type.function", "Function")
      link("@lsp.mod.static", "Type")
      link("@lsp.typemod.function.declaration", "Function")

      -- Tree-sitter captures used by many queries
      link("@method", "Function")
      link("@function", "Function")
      link("@function.call", "Function")
      link("@method.call", "Function")

      -- Telescope highlight fixes
      vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#444444", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#ffffff" })

      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1c1c1c", fg = "#d0d0d0" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#1c1c1c", fg = "#5f5f5f" })

      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#1c1c1c", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#1c1c1c", fg = "#5f5f5f" })

      vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#1c1c1c" })
      vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#1c1c1c" })
    end,
  }
}
