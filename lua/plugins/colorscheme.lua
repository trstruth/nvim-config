return {
  {
    "adisen99/apprentice.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "apprentice",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme apprentice")

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

