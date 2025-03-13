-- Adapted from https://github.com/raymon-roos/neovim-config/blob/bc87a6adef280e0bb20fcfb6bfde37131f99b056/lua/zettelkasten.lua
--
-- Local variables
local map = vim.keymap.set
local user_func = vim.api.nvim_create_user_command
local fn = vim.fn

-- Configuration for different directories
local configs = {
  ["~/cloud/phd"] = {
    dir = "~/cloud/phd",
    sep = "-",
    index = "000-contents.tex",
    notions = "000-notation.tex",
    id_max = 4095,
    id_size = 4
  },
  ["~/cloud/notes"] = {
    dir = "~/cloud/notes",
    sep = "_",
    index = "000_index.tex",
    notions = "000_notions.tex",
    id_max = 4095,
    id_size = 4
  }
}

-- Function to get current configuration based on working directory
local function get_config()
  local cwd = fn.expand(fn.getcwd())

  -- Try to match the current working directory with our config directories
  for dir, config in pairs(configs) do
    local expanded_dir = fn.expand(dir)
    if cwd:find(expanded_dir, 1, true) then
      return config
    end
  end

  -- Default to notes
  return configs["~/cloud/notes"]
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
  local zettel_name = fn.fnameescape(
    config.dir .. "/" .. prefix .. id .. '.tex'
  )
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

  for char=first_char,last_char do
    local t_char = char
    if #current_id == 3 or tonumber(current_id:sub(-1)) then
      t_char = string.char(char)
    end

    if 0 == vim.fn.filereadable(fn.fnameescape(config.dir .. "/" .. prefix .. config.sep .. current_id .. t_char .. ".tex")) then
      next_char = t_char
      break
    end
  end

  create_zettel(prefix .. config.sep, current_id .. next_char, split) -- Create and open the new note
end

local function create_zettel_independent(prefix, split)
  local config = get_config()
  local current_id = "0001"

  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  local id = tonumber(current_id, 36)+1
  local new_id = to_base36(id, config.id_size)
  while id < config.id_max and 1 == vim.fn.filereadable(fn.expand(fn.fnameescape(config.dir .. "/" .. prefix .. config.sep .. new_id .. ".tex"))) do
    id = id + 1
    new_id = to_base36(id, config.id_size)
  end

  create_zettel(prefix .. config.sep, new_id, split) -- Create and open the new note
end

-- Commands remain the same, but now use dynamic configuration
user_func('NewZettelIndependent', function()
  create_zettel_independent(
  vim.fn.input('Prefix: '),
  'edit'
  ) end, { nargs = 0 }
)

user_func('SplitNewZettelIndependent', function()
  create_zettel_independent(
  vim.fn.input('Prefix: '),
  'vsplit'
  ) end, { nargs = 0 }
)

user_func('NewZettelBehind', function() create_zettel_behind('vsplit') end, { nargs = 0 })

user_func('NewZettelSearch', function()
    local config = get_config()
    create_zettel(
      vim.fn.input('Prefix: ') .. config.sep,
      vim.fn.input('Note ID: '),
      'edit')
  end,
  { nargs = 0 }
)

user_func('SplitZettel', function()
    local config = get_config()
    create_zettel(
      vim.fn.input('Prefix: ') .. config.sep,
      vim.fn.input('Note ID: '),
      'split'
    )
  end,
  { nargs = 0 }
)

user_func('VertZettel', function()
    local config = get_config()
    create_zettel(
      vim.fn.input('Prefix: ') .. config.sep,
      vim.fn.input('Note ID: '),
      'vsplit')
  end,
  { nargs = 0 }
)

user_func('JumpToNote', function()
    create_zettel( "", vim.fn.expand('<cword>'), 'edit')
  end,
  { nargs = 0 }
)

user_func('SplitJumpToNote', function()
    create_zettel( "", vim.fn.expand('<cword>'), 'vsplit')
  end,
  { nargs = 0 }
)

user_func('ZettelReferences', function()
    require('telescope.builtin').live_grep({ default_text = vim.fn.expand('%:t:r') })
  end,
  { nargs = 0 }
)

-- Keymaps
-- Updated to use dynamic configuration
map("n", "<leader>nn", "<cmd>NewZettelIndependent<cr>",
{ silent = false, desc="Create new independent note "})

map("n", "<leader>nN", "<cmd>SplitNewZettelIndependent<cr>",
{ silent = false, desc="Create new independent note (vsplit)"})

map("n", "<leader>nb", "<cmd>NewZettelBehind<cr>",
{ silent = false, desc="Create new note behind current"})

map("n", "<leader>ns", "<cmd>NewZettelSearch<cr>",
{ silent = false, desc="Search and open or create note"})

map("n", '<leader>nj', '<cmd>JumpToNote<cr>',
{ silent = false, desc="Jump to note under cursor"})

map("n", '<leader>nh', '<cmd>SplitJumpToNote<cr>',
{ silent = false, desc="Jump to note under cursor (vsplit)"})

-- Dynamic index and notions mappings
map("n", '<leader>ni', function()
  local config = get_config()
  vim.cmd('e ' .. config.dir .. '/' .. config.index)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc="Go to index note"})

map("n", '<leader>nk', function()
  local config = get_config()
  vim.cmd('e ' .. config.dir .. '/' .. config.notions)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc="Go to knowledges file"})

map("n", '<leader>nK', function()
  local config = get_config()
  vim.cmd('vs ' .. config.dir .. '/' .. config.notions)
  vim.cmd('cd ' .. config.dir)
  vim.cmd('pwd')
end, { desc="Go to knowledges file (vsplit)"})

map("n", '<leader>nr', '<CMD> :ZettelReferences <CR>',
{ desc="List all references to current note"})
