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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      opts = nil,
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        --        ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = vim.NIL,

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
            -- Alternative behavior, select next item
            -- cmp.select_next_item()
            --  elseif luasnip.expand_or_jumpable() then
          elseif luasnip.expand_or_locally_jumpable() then -- this way you will only jump inside the snippet region
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      opts.preselect = cmp.PreselectMode.None

      local sources = {
        { name = "emoji" },
        { name = "luasnip" },
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, sources))

      -- debug
      -- vim.api.nvim_echo({ { "opts.sources: " .. vim.inspect(opts.sources), "Normal" } }, true, {})
    end,
  },
}