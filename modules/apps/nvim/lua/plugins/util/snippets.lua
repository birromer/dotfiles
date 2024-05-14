return {
  { "rafamadriz/friendly-snippets", },
  {
    "L3MON4D3/LuaSnip",
  	version = "v2.3",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets", },
    config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({paths = {"~/.config/nvim/snippets"}})
		end,
    date = function()
      return { os.date("%Y-%m-%d") }
    end,
    filename = function()
      return { vim.fn.expand("%:p") }
    end,
  },

}
