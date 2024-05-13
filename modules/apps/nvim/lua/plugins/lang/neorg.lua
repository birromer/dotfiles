return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- We'd like this plugin to load first out of the rest
    config = true, -- This automatically runs `require("luarocks-nvim").setup()`
  },
  {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim", "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
    -- put any other flags you wanted to pass to lazy here!
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            config = {
              icon_preset = "varied",
              icons = {
                delimiter = {
                  horizontal_line = {
                    highlight = "@neorg.delimiters.horizontal_line",
                  },
                },
                code_block = {
                  -- If true will only dim the content of the code block (without the
                  -- `@code` and `@end` lines), not the entirety of the code block itself.
                  content_only = true,

                  -- The width to use for code block backgrounds.
                  --
                  -- When set to `fullwidth` (the default), will create a background
                  -- that spans the width of the buffer.
                  --
                  -- When set to `content`, will only span as far as the longest line
                  -- within the code block.
                  width = "content",

                  -- Additional padding to apply to either the left or the right. Making
                  -- these values negative is considered undefined behaviour (it is
                  -- likely to work, but it's not officially supported).
                  padding = {
                    -- left = 20,
                    -- right = 20,
                  },

                  -- If `true` will conceal (hide) the `@code` and `@end` portion of the code
                  -- block.
                  conceal = true,

                  nodes = { "ranged_verbatim_tag" },
                  highlight = "CursorLine",
                  -- render = module.public.icon_renderers.render_code_block,
                  insert_enabled = true,
                },
              },
            },
          },
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                home = "~/mega/notes",
                work = "~/mega/phd/notes",
              },
              index = "index.norg",
              default_workspaces = "work",
            },
          },
          ["core.export"] = {},
          ["core.summary"] = {},
          ["core.integrations.telescope"] = {},
          ["core.keybinds"] = {
            config = {
              neorg_leader = " ",
            },
          },
        },
      })
    end,
  },
}
