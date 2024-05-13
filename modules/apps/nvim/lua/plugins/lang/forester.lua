return {
  "kentookura/forester.nvim",
  --  lazy = false,
  event = "InsertEnter",
  cmd = { "Forester" },
  opts = {
    forests = { "~/mega/forest/" }, -- global forests
    tree_dirs = { "trees" }, -- where the plugin will look for trees. Works outside of global forests
    conceal = false, -- Concealing is highly experimental, incomplete, partially broken. Enable only if you want to improve it!
  },
  config = function()
    local forester = require("forester")

    vim.keymap.set("n", "<leader>n.", "<cmd>Forester browse<CR>", { silent = true })
    vim.keymap.set("n", "<leader>nn", "<cmd>Forester new<CR>", { silent = true })
    vim.keymap.set("i", "<C-t>", "<cmd>Forester transclude<CR>", { silent = true })
    vim.keymap.set("i", "<C-l>", "<cmd>Forester link<CR>", { silent = true })
  end,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    { "hrsh7th/nvim-cmp" },
  },
},
  require("nvim-web-devicons").setup({ override_by_extension = { ["tree"] = { icon = "🌲" } } })
