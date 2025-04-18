return {
--  {
--    "iamcco/markdown-preview.nvim",
--    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--    build = function()
--      vim.fn["mkdp#util#install"]()
--    end,
--    keys = {
--      {
--        "<leader>cp",
--        ft = "markdown",
--        "<cmd>MarkdownPreviewToggle<cr>",
--        desc = "Markdown Preview",
--      },
--    },
--    config = function()
--      vim.cmd([[do FileType]])
--    end,
--  },
--  {
--    "lukas-reineke/headlines.nvim",
--    opts = function()
--      local opts = {}
--      for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
--        opts[ft] = {
--          headline_highlights = {},
--          -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
--          bullets = {},
--        }
--        for i = 1, 6 do
--          local hl = "Headline" .. i
--          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
--          table.insert(opts[ft].headline_highlights, hl)
--        end
--      end
--      return opts
--    end,
--    ft = { "markdown", "norg", "rmd", "org" },
--    config = function(_, opts)
--      -- PERF: schedule to prevent headlines slowing down opening a file
--      vim.schedule(function()
--        require("headlines").setup(opts)
--        require("headlines").refresh()
--      end)
--    end,
--  },
{
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
}
