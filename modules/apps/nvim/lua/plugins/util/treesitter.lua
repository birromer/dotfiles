return {
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
        "cpp",
      },
      highlight = {
        enable = true,
        disable = { "latex" },
      },
    })
  end,
}
