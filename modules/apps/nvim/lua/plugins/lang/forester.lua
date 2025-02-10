return {
  "kentookura/forester.nvim",
  event = "VeryLazy",
  ft = {"tree", "forester"},
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-lua/plenary.nvim" },
    },
  config = function()
    -- optionally, configure the cmp source:
    local foresterCompletionSource = require("forester.completion")
  
    require("cmp").register_source("forester", foresterCompletionSource)
    require("cmp").setup.filetype("forester", { sources = { { name = "forester", dup = 0 } } })
  end,
  }
