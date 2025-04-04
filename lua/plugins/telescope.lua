return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup()

      -- Find Git-tracked files (respects .gitignore)
      vim.keymap.set("n", "<leader>p", "<cmd>Telescope git_files<CR>", { desc = "Find Git files" })

      -- Find all files (even untracked)
      vim.keymap.set("n", "<leader>P", "<cmd>Telescope find_files<CR>", { desc = "Find all files" })

      -- Grep through project (respects .gitignore)
      vim.keymap.set("n", "<leader>f", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

    end,
  },
}

