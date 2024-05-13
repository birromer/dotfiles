return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/snippets/" } })
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },

    date = function()
      return { os.date("%Y-%m-%d") }
    end,

    filename = function()
      return { vim.fn.expand("%:p") }
    end,

    keys = function()
      return {}
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
