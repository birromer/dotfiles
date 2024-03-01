return {
  "kentookura/forester.nvim",

  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    { "hrsh7th/nvim-cmp" },
  },
  opts = {
    forests = { "~/mega/forest/" }, -- global forests
    tree_dirs = { "trees", "notes" }, -- where the plugin will look for trees. Works outside of global forests
    conceal = false, -- Concealing is highly experimental, incomplete, partially broken. Enable only if you want to improve it!
  },
  config = function()
    local forester = require("forester")
    vim.g.mapleader = " "

    vim.keymap.set("n", "<leader>n.", "<cmd>forester browse<CR>", { silent = true })
    vim.keymap.set("n", "<leader>nn", "<cmd>forester new<CR>", { silent = true })
    vim.keymap.set("i", "<C-t>", "<cmd>forester transclude<CR>", { silent = true })
    vim.keymap.set("i", "<C-l>", "<cmd>forester link<CR>", { silent = true })
  end,
}
