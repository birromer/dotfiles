return {
  --   "hedyhli/outline.nvim",
  --   config = function()
  --     -- Example mapping to toggle outline
  --     vim.keymap.set("n", "<leader>d", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
  --
  --     require("outline").setup({
  --       -- Your setup opts here (leave empty to use defaults)
  --       --
  --       opts = {
  --         providers = {
  --           priority = { "norg", "coc", "markdown", "lsp" },
  --         },
  --       },
  --     })
  --   end,
}

-- return {
--   "stevearc/aerial.nvim",
--
--   opts = {},
--   keys = {
--     { "<leader>d", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
--   },
-- }
