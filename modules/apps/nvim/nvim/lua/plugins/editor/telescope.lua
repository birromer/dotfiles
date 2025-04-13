return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = {
      "ahmedkhalf/project.nvim",
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
          require("telescope").load_extension("file_browser")
          require("telescope").load_extension("projects")
        end,
      },
    },
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        -- set flash labels to be abc
        require("flash").jump({
          pattern = "^",
          labels = "asdfghjklqwertyuiopzxcvbnm",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          n = {
            s = flash,
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
          i = { ["<c-s>"] = flash },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
        require("telescope").load_extension("frecency")
    end,
    dependencies = {"kkharji/sqlite.lua"}
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  {
    "ggvgc/vim-fuzzysearch",
  },

  {
    "mihaifm/bufstop",
    cmd = "BufstopSpeedToggle",
    event = "VeryLazy",
  },
}
