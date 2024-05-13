return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.ai").setup()
      require("mini.pairs").setup()
      require("mini.basics").setup()
      require("mini.surround").setup({
        mappings = {
          add = "za", -- Add surrounding in Normal and Visual modes
          delete = "zd", -- Delete surrounding
          find = "zf", -- Find surrounding (to the right)
          find_left = "zF", -- Find surrounding (to the left)
          highlight = "zh", -- Highlight surrounding
          replace = "zr", -- Replace surrounding
          update_n_lines = "zn", -- Update `n_lines`
          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
      })
      require("mini.statusline").setup()
--      require("mini.starter").setup()
    end,
  },

  {
    "echasnovski/mini.starter",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VimEnter",
    opts = function()
      local pad = string.rep(" ", 1)
      local new_section = function(name, action, section)
        return { name = name, action = action, section = pad .. section }
      end

      local starter = require("mini.starter")
      --stylua: ignore
      local config = {
        evaluate_single = true,
        header = "Hello, Bernardo.",
        items = {
          new_section("Find file",       "Telescope find_files",                "Telescope"),
          new_section("Projects",        "Telescope projects",                  "Telescope"),
          new_section("Recent files",    "Telescope oldfiles",                  "Telescope"),
          new_section("Grep text",       "Telescope live_grep",                 "Telescope"),
          new_section("New file",        "ene | startinsert",                   "Built-in"),
          new_section("Quit",            "qa",                                  "Built-in"),
          new_section("Session restore", [[lua require("persistence").load()]], "Session"),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(pad .. "░ ", false),
          starter.gen_hook.aligning("center", "center"),
        },
      }
      return config
    end,
  }
}
