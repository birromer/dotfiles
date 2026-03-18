-- Adapted from https://github.com/raymon-roos/neovim-config/blob/bc87a6adef280e0bb20fcfb6bfde37131f99b056/lua/zettelkasten.lua
--
-- Local variables
local map = vim.keymap.set
local user_func = vim.api.nvim_create_user_command
local fn = vim.fn

-- Config filename to look for in project directories
local CONFIG_FILENAME = ".zettel.lua"

-- Default notes directory (fallback when no .zettelkasten.lua found)
local DEFAULT_NOTES_DIR = "~/cloud/Research/notes"

-- Default/fallback configuration (used if no local config found)
local default_config = {
  sep = "-",
  ext = ".tex",
  index = "000-contents.kl",
  notions = "000-notions.kl",
  notations = "000-macros.sty",
  scratchpad = "tmp.tex",
  id_max = 4095,
  id_size = 4
}

-- Cache for loaded configs (avoids re-reading file on every call)
local config_cache = {}

-- Find config file by walking up directory tree from current buffer's directory
local function find_config_file(start_dir)
  -- Use current buffer's directory, not cwd
  local dir = fn.expand(start_dir or fn.expand("%:p:h"))
  if dir == "" or dir == "." then
    dir = fn.getcwd()
  end


  local root = fn.has("win32") == 1 and dir:match("^%a:\\") or "/"

  while dir and dir ~= "" and dir ~= root do
    local config_path = dir .. "/" .. CONFIG_FILENAME
    if fn.filereadable(config_path) == 1 then
      return config_path, dir
    end
    dir = fn.fnamemodify(dir, ":h")
  end

  -- Check root as well
  local config_path = root .. CONFIG_FILENAME
  if fn.filereadable(config_path) == 1 then
    return config_path, root
  end

  return nil, nil
end

-- Load configuration from a .zettelkasten.lua file
local function load_config_file(config_path, project_dir)
  -- Check cache first
  if config_cache[config_path] then
    return config_cache[config_path]
  end

  local ok, config = pcall(dofile, config_path)
  if not ok or type(config) ~= "table" then
    vim.notify("Error loading " .. config_path .. ": " .. tostring(config), vim.log.levels.WARN)
    return nil
  end

  -- Use explicit dir from config, otherwise use where the file was found
  if config.dir then
    config.dir = fn.expand(config.dir)
  else
    config.dir = project_dir
  end

  -- Merge with defaults for any missing fields
  for key, value in pairs(default_config) do
    if config[key] == nil then
      config[key] = value
    end
  end

  -- Cache it
  config_cache[config_path] = config
  return config
end

-- Function to get current configuration based on working directory
local function get_config()
  local config_path, project_dir = find_config_file()

  if config_path then
    return load_config_file(config_path, project_dir)
  end

  -- No config file found - fall back to default notes directory
  local fallback_dir = fn.expand(DEFAULT_NOTES_DIR)
  local fallback_config_path = fallback_dir .. "/" .. CONFIG_FILENAME

  -- Check if the default notes dir has a config file
  if fn.filereadable(fallback_config_path) == 1 then
    return load_config_file(fallback_config_path, fallback_dir)
  end

  -- Otherwise return default config with default notes dir
  local config = vim.tbl_extend("force", {}, default_config)
  config.dir = fallback_dir
  return config
end

-- Clear config cache (useful if you edit .zettelkasten.lua and want to reload)
local function clear_config_cache()
  config_cache = {}
  vim.notify("Zettelkasten config cache cleared", vim.log.levels.INFO)
end

-- Toggle scratchpad function
local function toggle_scratchpad()
  local config = get_config()
  if not config or not config.scratchpad then
    print("No scratchpad defined for this project.")
    return
  end

  local scratchpad_path = fn.expand(config.dir .. "/" .. config.scratchpad)
  local current_buf_path = fn.expand("%:p")

  if current_buf_path == scratchpad_path then
    vim.cmd("e #") -- Go back to the previous buffer
  else
    vim.cmd("e " .. scratchpad_path)
  end
end

-- Helper function
local function to_base36(number, digits)
  local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local result = ""

  while number > 0 do
    local remainder = number % 36
    result = string.sub(chars, remainder + 1, remainder + 1) .. result
    number = math.floor(number / 36)
  end

  while #result < digits do
    result = "0" .. result
  end

  return result:sub(-digits)
end

-- Function definitions
local function create_zettel(prefix, id, split)
  local config = get_config()

  local zettel_name = fn.fnameescape(config.dir .. "/" .. prefix .. id .. config.ext)
  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  vim.cmd(split .. ' ' .. zettel_name)
  print(fn.expand('%:p:~'))
end

local function create_zettel_behind(split)
  local config = get_config()

  -- get id without path nor extension
  local current_file = vim.fn.expand("%:t:r")
  -- get prefix and id
  local prefix, current_id = current_file:match("^(.*)" .. config.sep .. "(.*)")
  local next_char, first_char, last_char

  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  -- case 1: Exactly 3 characters after the underscore
  -- OR case 2: Last character is a number
  if #current_id == 3 or tonumber(current_id:sub(-1)) then
    first_char, last_char = string.byte('a'), string.byte('z')
  -- case 3: last character is a letter
  else
    first_char, last_char = 1, 9
  end

  for char = first_char, last_char do
    local t_char = char
    if #current_id == 3 or tonumber(current_id:sub(-1)) then
      t_char = string.char(char)
    end

    if 0 == vim.fn.filereadable(fn.fnameescape(config.dir .. "/" .. prefix .. config.sep .. current_id .. t_char .. config.ext)) then
      next_char = t_char
      break
    end
  end

  create_zettel(prefix .. config.sep, current_id .. next_char, split)
end

local function create_zettel_independent(prefix, split)
  local config = get_config()

  local current_id = "0001"

  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  local id = tonumber(current_id, 36) + 1
  local new_id = to_base36(id, config.id_size)
  while id < config.id_max and 1 == vim.fn.filereadable(fn.expand(fn.fnameescape(config.dir .. "/" .. prefix .. config.sep .. new_id .. config.ext))) do
    id = id + 1
    new_id = to_base36(id, config.id_size)
  end

  create_zettel(prefix .. config.sep, new_id, split)
end

local function get_note_ref_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  for match_start, ref, match_end in line:gmatch("()(%w+-%w+)()") do
    if col >= match_start and col < match_end then
      return ref
    end
  end

  return vim.fn.expand('<cword>')
end

-- Commands
user_func('NewZettelIndependent', function()
  create_zettel_independent(vim.fn.input('Prefix: '), 'edit')
end, { nargs = 0 })

user_func('SplitNewZettelIndependent', function()
  create_zettel_independent(vim.fn.input('Prefix: '), 'vsplit')
end, { nargs = 0 })

user_func('NewZettelBehind', function()
  create_zettel_behind('vsplit')
end, { nargs = 0 })

user_func('NewZettelSearch', function()
  local config = get_config()
  create_zettel(vim.fn.input('Prefix: ') .. config.sep, vim.fn.input('Note ID: '), 'edit')
end, { nargs = 0 })

user_func('SplitZettel', function()
  local config = get_config()
  create_zettel(vim.fn.input('Prefix: ') .. config.sep, vim.fn.input('Note ID: '), 'split')
end, { nargs = 0 })

user_func('VertZettel', function()
  local config = get_config()
  create_zettel(vim.fn.input('Prefix: ') .. config.sep, vim.fn.input('Note ID: '), 'vsplit')
end, { nargs = 0 })

user_func('JumpToNote', function()
--  create_zettel("", vim.fn.expand('<cword>'), 'edit')
  create_zettel("", get_note_ref_under_cursor(), 'edit')
end, { nargs = 0 })

user_func('SplitJumpToNote', function()
--  create_zettel("", vim.fn.expand('<cword>'), 'vsplit')
  create_zettel("", get_note_ref_under_cursor(), 'vsplit')
end, { nargs = 0 })

user_func('ZettelReferences', function()
  require('telescope.builtin').live_grep({ default_text = vim.fn.expand('%:t:r') })
end, { nargs = 0 })

user_func('ZettelClearCache', function()
  clear_config_cache()
end, { nargs = 0 })

-- Keymaps
map("n", "<leader>nn", "<cmd>NewZettelIndependent<cr>",
  { silent = false, desc = "Create new independent note" })

map("n", "<leader>nN", "<cmd>SplitNewZettelIndependent<cr>",
  { silent = false, desc = "Create new independent note (vsplit)" })

map("n", "<leader>nb", "<cmd>NewZettelBehind<cr>",
  { silent = false, desc = "Create new note behind current" })

map("n", "<leader>ns", "<cmd>NewZettelSearch<cr>",
  { silent = false, desc = "Search and open or create note" })

map("n", '<leader>nj', '<cmd>JumpToNote<cr>',
  { silent = false, desc = "Jump to note under cursor" })

map("n", '<leader>nJ', '<cmd>SplitJumpToNote<cr>',
  { silent = false, desc = "Jump to note under cursor (vsplit)" })

-- Dynamic index and notions mappings
map("n", '<leader>ni', function()
  local config = get_config()
  vim.cmd('e ' .. config.dir .. '/' .. config.index)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to index note" })

map("n", '<leader>nm', function()
  local config = get_config()
  if not config or not config.main then
    vim.notify("No main file defined", vim.log.levels.ERROR)
    return
  end
  vim.cmd('e ' .. config.dir .. '/' .. config.main)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to main note" })

map("n", '<leader>nM', function()
  local config = get_config()
  if not config or not config.main then
    vim.notify("No main file defined", vim.log.levels.ERROR)
    return
  end
  vim.cmd('vs ' .. config.dir .. '/' .. config.main)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to main note (vsplit)" })

map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("w")
  if vim.api.nvim_get_mode().mode:find("[ixs]") then
    vim.api.nvim_input("<Esc>")
  end
  toggle_scratchpad()
end, { desc = "Save and Toggle Scratchpad" })

map("n", '<leader>nk', function()
  local config = get_config()
  if not config.notions then
    vim.notify("No notions file defined", vim.log.levels.WARN)
    return
  end
  vim.cmd('e ' .. config.dir .. '/' .. config.notions)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to knowledges file" })

map("n", '<leader>nK', function()
  local config = get_config()
  if not config.notions then
    vim.notify("No notions file defined", vim.log.levels.WARN)
    return
  end
  vim.cmd('vs ' .. config.dir .. '/' .. config.notions)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to knowledges file (vsplit)" })

map("n", '<leader>nl', function()
  local config = get_config()
  if not config.notations then
    vim.notify("No notations file defined", vim.log.levels.WARN)
    return
  end
  vim.cmd('e ' .. config.dir .. '/' .. config.notations)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to notations file" })

map("n", '<leader>nL', function()
  local config = get_config()
  if not config.notations then
    vim.notify("No notations file defined", vim.log.levels.WARN)
    return
  end
  vim.cmd('vs ' .. config.dir .. '/' .. config.notations)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc = "Go to notations file (vsplit)" })

map("n", '<leader>nr', '<CMD> :ZettelReferences <CR>',
  { desc = "List all references to current note" })
