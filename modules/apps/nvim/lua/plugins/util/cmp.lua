return{
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    config = function()
      require('lsp-zero.settings').preset({})
    end
  },
  {
    'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        "L3MON4D3/LuaSnip",
      },
      config = function()
        require('lsp-zero.cmp').extend()

        local cmp = require('cmp')

        local has_words_before = function()
          if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and
              vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") ==
              nil
        end

        cmp.setup({
          sources = {
            { name = 'nvim_lsp' },
            { name = 'omni' },
            { name = 'luasnip', option = { show_autosnippets = true, use_show_condition = false } },
            { name = "buffer" },
            { name = "path" },
            { name = 'emoji' },
          },
          snippet = {
            expand = function(args)
              print(args.body)
              require 'luasnip'.lsp_expand(args.body)
            end
          },
          mapping = {
            ["<CR>"] = vim.NIL,
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              elseif require("luasnip").expand_or_locally_jumpable() then
                require("luasnip").expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
--            ['<CR>'] = completion,
--            ['<C-Space>'] = cmp.mapping.complete(),
--            ["<C-j>"] = vim.schedule_wrap(function(fallback)
--              if cmp.visible() and has_words_before() then
--                cmp.select_next_item({
--                  behavior = cmp.SelectBehavior.Select })
--              else
--                fallback()
--              end
--            end),
--            ["<C-k>"] = vim.schedule_wrap(function(fallback)
--              if cmp.visible() and has_words_before() then
--                cmp.select_prev_item({
--                  behavior = cmp.SelectBehavior.Select })
--              else
--                fallback()
--              end
--            end)
          },
        })
    end
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = {
      { "lervag/vimtex" },
    },
  },

  { "hrsh7th/cmp-buffer" },
}
