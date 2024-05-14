return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        integrations = {
        cmp = true,
          gitsigns = true,
          treesitter = true,
          notify = false,
          harpoon = true,
          window_picker = true,
          which_key = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        }
      })
      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end,
  }
--  { "chriskempson/base16-vim" },
}
