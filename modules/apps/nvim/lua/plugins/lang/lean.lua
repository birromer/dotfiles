return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },

  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    -- you also will likely want nvim-cmp or some completion engine
  },

  opts = {
    lsp = {
      on_attach = on_attach,
    },
    mappings = true,
  },
}
