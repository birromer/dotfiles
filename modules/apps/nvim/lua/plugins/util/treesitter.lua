return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "lua",
          "bibtex",
          "latex",
          "python",
          "ninja",
          "yaml",
          "ron",
          "toml",
          "rst",
          "haskell",
          "rust",
          "markdown",
          "markdown_inline",
          "json",
          "json5",
          "jsonc",
          "cmake",
          "c",
          "cpp"
        },
        highlight = {
          enable = true,
          disable = { "latex" },
        },
      })
      vim.treesitter.language.register("tree", "forester")
      vim.filetype.add({ extension = { tree = "tree" } })
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.forester = {
      	install_info = {
      		url = "~/repos/tree-sitter-forester/",
      		files = { "src/parser.c" },
      		branch = "main",
      		generate_requires_npm = false,
      		requires_generate_from_grammar = false,
      	},
      	filetype = "tree",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "InsertEnter",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring"
  },
}
