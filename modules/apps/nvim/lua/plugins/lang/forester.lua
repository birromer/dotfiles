return {
	"kentookura/forester.nvim",
  ft = {"tree", "forester"},
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    { "hrsh7th/nvim-cmp" },
  },
	config = function()
		local forester = require("forester").setup()
	end,
}
