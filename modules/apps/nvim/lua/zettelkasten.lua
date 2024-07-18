-- Adapted from https://github.com/raymon-roos/neovim-config/blob/bc87a6adef280e0bb20fcfb6bfde37131f99b056/lua/zettelkasten.lua
--
-- Local variables
local map = vim.keymap.set
local user_func = vim.api.nvim_create_user_command
local fn = vim.fn

--local NOTES_DIR = "~/mega/test-notes"
local NOTES_DIR = "~/mega/notes"
local NOTES_SEP = "_"
local NOTES_INDEX = "000_index.tex"
local NOTES_NOTIONS = "000_notions.tex"
local NOTE_ID_MAX = 4095
local NOTE_ID_SIZE = 4

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
  local zettel_name = fn.fnameescape(
    NOTES_DIR .. "/" .. prefix .. id .. '.tex'
  )
  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  vim.cmd(split .. ' ' .. zettel_name)
  print(fn.expand('%:p:~'))
end

local function create_zettel_behind(split)
  -- get id without path nor extension
  local current_file = vim.fn.expand("%:t:r")
  -- get prefix and id
  local prefix, current_id = current_file:match("^(.*)-(.*)")
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

    if 0 == vim.fn.filereadable(fn.fnameescape(NOTES_DIR .. "/" .. prefix .. NOTES_SEP .. current_id .. t_char .. ".tex")) then
      next_char = t_char
      break
    end
  end

  create_zettel(prefix .. NOTES_SEP, current_id .. next_char, split) -- Create and open the new note
end

local function create_zettel_independent(prefix, split)
  -- get id without path nor extension
  local current_file = vim.fn.expand("%:t:r")
  -- get prefix and id -- HACK: Fixed for note id of 3 characters.
  --  local prefix, current_id, current_children_id = current_file:match("^(.*)_(...)(.*)")
    local current_id = "0001"

  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  local id = tonumber(current_id, 36)+1
  local new_id = to_base36(id, NOTE_ID_SIZE)
  while id < NOTE_ID_MAX and 1 == vim.fn.filereadable(fn.fnameescape(NOTES_DIR .. "/" .. prefix .. NOTES_SEP .. new_id .. ".tex")) do
    id = id + 1
    new_id = to_base36(id, NOTE_ID_SIZE)
  end

  create_zettel(prefix .. NOTES_SEP, new_id, split) -- Create and open the new note
end


-- Create new independent note in the prefix specified by the user.
user_func('NewZettelIndependent', function()
  create_zettel_independent(
  vim.fn.input('Prefix: '),
  'edit'
  ) end, { nargs = 0 }
)

-- Create new note "behind" the current note (adding next letter or number available)
user_func('NewZettelBehind', function() create_zettel_behind('vsplit') end, { nargs = 0 })

user_func('NewZettelSearch', function()
    create_zettel(
      vim.fn.input('Prefix: ') .. NOTES_SEP,
      vim.fn.input('Note ID: '),
      'edit')
  end,
  { nargs = 0 }
)

user_func('SplitZettel', function()
    create_zettel(
      vim.fn.input('Prefix: ') .. NOTES_SEP,
      vim.fn.input('Note ID: '),
      'split'
    )
  end,
  { nargs = 0 }
)

user_func('VertZettel', function()
    create_zettel(
      vim.fn.input('Prefix: ') .. NOTES_SEP,
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
-- nn : new independent note
-- nb : new note behind current note
-- ns : search for note and  open if exists, create otherwise
--
map("n", "<leader>nn", "<cmd>NewZettelIndependent<cr>",
{ silent = false, desc="Create new independent note "})

map("n", "<leader>nb", "<cmd>NewZettelBehind<cr>",
{ silent = false, desc="Create new note behind current"})

map("n", "<leader>ns", "<cmd>NewZettelSearch<cr>",
{ silent = false, desc="Search and open or create note"})

-- map("n", '<leader>ns', '<cmd>SplitZettel <cr>',
-- { silent = false, desc="Create new note (same prefix) (hsplit)"})

-- map("n", '<leader>nv', '<cmd>VertZettel<cr>',
-- { silent = false, desc="Create new note (same prefix) (vsplit)"})

map("n", '<leader>nj', '<cmd>JumpToNote<cr>',
{ silent = false, desc="Jump to note under cursor"})

map("n", '<leader>nh', '<cmd>SplitJumpToNote<cr>',
{ silent = false, desc="Jump to note under cursor (vsplit)"})

map("n",  -- Change working directory to zettelkasten and open index
  '<leader>ni',
  '<CMD> e ' .. NOTES_DIR .. '/' .. NOTES_INDEX .. '<CR>'
  .. '<CMD> cd '.. NOTES_DIR .. ' <CR>'
  .. '<CMD> pwd <CR>',
  { desc="Go to index note"})

map("n",  -- Change working directory to zettelkasten and open index
  '<leader>nk',
  '<CMD> e ' .. NOTES_DIR .. '/' .. NOTES_NOTIONS .. '<CR>'
  .. '<CMD> cd '.. NOTES_DIR .. ' <CR>'
  .. '<CMD> pwd <CR>',
  { desc="Go to knowledges file"})

map("n", '<leader>nr', '<CMD> :ZettelReferences <CR>',
{ desc="List all references to current note"})
