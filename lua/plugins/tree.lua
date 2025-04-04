return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional icons
    },
    config = function()
      require("nvim-tree").setup()
      -- Keybind: ,t to toggle tree
      vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    end,
  },
}

