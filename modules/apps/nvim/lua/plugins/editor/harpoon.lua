return {
  "ThePrimeagen/harpoon",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  keys = {
    { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Mark file with harpoon" } },
    {
      "<C-e>",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { desc = "Show harpoon marks", noremap = true, silent = true },
    },
    --    {
    --      "<C-h>",
    --      "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",
    --      { desc = "1st harpoon mark", noremap = true, silent = true },
    --    },
    --    {
    --      "<C-j>",
    --      "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",
    --      { desc = "2nd harpoon mark", noremap = true, silent = true },
    --    },
    --    {
    --      "<C-k>",
    --      "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",
    --      { desc = "3rd harpoon mark", noremap = true, silent = true },
    --    },
    --    {
    --      "<C-l>",
    --      "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",
    --      { desc = "4th harpoon mark", noremap = true, silent = true },
    --    },
  },
}
