return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.forester = {
        install_info = {
          url = "https://github.com/kentookura/tree-sitter-forester",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "forester",
      }

      vim.filetype.add({
        extension = {
          tree = "forester",
        },
      })

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "bibtex", "python", "ninja", "yaml", "ron",
          "toml", "rst", "haskell", "rust", "markdown", "markdown_inline",
          "json", "json5", "jsonc", "cmake", "c", "cpp", "forester", 
        },
        highlight = {
          enable = true,
          disable = { "latex" },
        },
      })

      vim.lsp.config["forester-lsp"] = {
        cmd = { "forester", "lsp", "forest.toml" },
        filetypes = { "forester" },
        root_markers = { "forest.toml" },
      }
      vim.lsp.enable("forester-lsp")
    end,
  },

  { "nvim-treesitter/nvim-treesitter-textobjects", event = "InsertEnter" },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
      -- hook into native gc
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
          and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
}
