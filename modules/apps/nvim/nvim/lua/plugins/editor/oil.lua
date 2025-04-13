local default_coloumns = function(detailed)
  return detailed
      and {
        { "permissions", highlight = "String" },
        { "mtime", highlight = "Comment" },
        { "size", highlight = "Type" },
        "icon",
      }
    or { "icon" }
end

local M = {
  "stevearc/oil.nvim",
  cmd = "Oil",
  opts = function(_, o)
    o.columns = default_coloumns(true)

    o.keymaps = {
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-k>"] = "k",
      ["<C-j>"] = "j",
      ["<C-l>"] = "actions.select",
      ["<C-s>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-t>"] = "actions.select_tab",
      ["gp"] = "actions.preview",
      ["<C-x>"] = "actions.open_external",
      ["<C-T>"] = "actions.open_terminal",
      ["<leader>e"] = "actions.close",
      ["<C-b>"] = {
        desc = "Open UserDir",
        callback = function()
          require("oil").close()
          local home_dir = tostring(vim.fn.expand("$HOME"))
          require("oil").open_float(home_dir)
        end,
      },
      ["q"] = "actions.close",
      ["<Esc><Esc>"] = "actions.close",
      ["<C-h>"] = "actions.parent",
      ["<C-.>"] = "actions.toggle_hidden",
      ["g."] = "actions.toggle_hidden",
      ["-"] = "actions.parent",
      ["<C-w>"] = "actions.open_cwd",
      ["<C-c>"] = "actions.cd",
      ["g\\"] = "actions.toggle_trash",
      ["~"] = "actions.tcd",
      ["gs"] = {
        desc = "Save",
        callback = function()
          require("oil").save()
        end,
      },
      ["gr"] = "actions.refresh",
      ["gd"] = {
        desc = "Toggle detail view",
        callback = function()
          local oil = require("oil")
          local config = require("oil.config")
          if #config.columns == #default_coloumns(false) then
            oil.set_columns(default_coloumns(true))
          else
            oil.set_columns(default_coloumns(false))
          end
        end,
      },
    }
    o.use_default_keymaps = false
    o.silence_scp_warning = true -- disable scp warn to use oil-ssh since I'm using a remap
    o.view_options = {
      show_hidden = false,
      is_hidden_file = function(name, _)
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function(name, _)
        local file_to_exclude = {
          [".DS_Store"] = true,
          ["Icon\r"] = true,
        }
        return file_to_exclude[name]
      end,
    }
    -- Configuration for the floating window in oil.open_float
    o.float = {
      -- Padding around the floating window
      padding = 0,
      max_width = 0,
      max_height = 16,
      border = "rounded",
      win_options = {
        winblend = 8,
      },
      override = function(conf)
        conf.row = (vim.o.lines - conf.height - 3)
        return conf
      end,
    }

    o.progress = {
      win_options = {
        winblend = 6,
      },
    }
    -- This are defaults for now, no need to override
    -- adapters = {
    --   ["oil://"] = "files",
    --   ["oil-ssh://"] = "ssh",
    -- },
    -- When opening the parent of a file, substitute these url schemes
    -- HACK:
    -- https://github.com/stevearc/oil.nvim/blob/931453fc09085c09537295c991c66637869e97e1/lua/oil/config.lua#L102~110
    -- Using this to remap url-scheme from args with oil-ssh schemes
    o.adapter_aliases = {
      ["ssh://"] = "oil-ssh://",
      ["scp://"] = "oil-ssh://",
      ["sftp://"] = "oil-ssh://",
    }
  end,
  init = function(p)
    if vim.fn.argc() == 1 then
      local argv = tostring(vim.fn.argv(0))
      local stat = vim.loop.fs_stat(argv)

      local remote_dir_args = vim.startswith(argv, "ssh") or vim.startswith(argv, "sftp") or vim.startswith(argv, "scp")

      if stat and stat.type == "directory" or remote_dir_args then
        require("lazy").load({ plugins = { p.name } })
      end
    end
    if not require("lazy.core.config").plugins[p.name]._.loaded then
      vim.api.nvim_create_autocmd("BufNew", {
        callback = function()
          if vim.fn.isdirectory(vim.fn.expand("<afile>")) == 1 then
            require("lazy").load({ plugins = { "oil.nvim" } })
            -- Once oil is loaded, we can delete this autocmd
            return true
          end
        end,
      })
    end
  end,
}

return M
