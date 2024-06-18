-- Adapted from https://github.com/raymon-roos/neovim-config/blob/bc87a6adef280e0bb20fcfb6bfde37131f99b056/lua/zettelkasten.lua
--
-- Local variables
local map = vim.keymap.set
local user_func = vim.api.nvim_create_user_command
local fn = vim.fn
local NOTES_DIR = "/Users/bernardo/mega/zk-notes"
-- local NOTES_DIR = "/Users/bernardo/mega/notes"
-- Alternatively, it can use an environment variable with fn.expand('$NOTES_DIR/')

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

local function create_next_sequential_zettel(split)
  -- get filename without path nor extension
  local current_file = vim.fn.expand("%:t:r")
  -- get prefix and id
  local prefix, current_id = current_file:match("^(.*)_(.*)")
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

    if 0 == vim.fn.filereadable(fn.fnameescape(NOTES_DIR .. "/" .. prefix .. "_" .. current_id .. t_char .. ".tex")) then
      next_char = t_char
      break
    end
  end

  create_zettel(prefix .. "_", current_id .. next_char, split) -- Create and open the new note
end


user_func('NewZettelIndependent', function() create_next_sequential_zettel('edit') end, { nargs = 0 })

user_func('NewZettelBehind', function() create_next_sequential_zettel('vsplit') end, { nargs = 0 })

user_func('NewZettelSearch', function()
    create_zettel(
      vim.fn.input('Prefix: ') .. "_",
      vim.fn.input('Note ID: '),
      'edit')
  end,
  { nargs = 0 }
)

user_func('SplitZettel', function()
    create_zettel(
      vim.fn.input('Prefix: ') .. "_",
      vim.fn.input('Note ID: '),
      'split'
    )
  end,
  { nargs = 0 }
)

user_func('VertZettel', function()
    create_zettel(
      vim.fn.input('Prefix: ') .. "_",
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

map("n", '<leader>nk', '<cmd>SplitJumpToNote<cr>',
{ silent = false, desc="Jump to note under cursor (vsplit)"})

map("n",  -- Change working directory to zettelkasten and open index
  '<leader>ni',
  '<CMD> e ' .. NOTES_DIR .. '/0-index.tex <CR>'
  .. '<CMD> cd '.. NOTES_DIR .. ' <CR>'
  .. '<CMD> pwd <CR>',
  { desc="Go to index note"})

map("n", '<leader>nr', '<CMD> :ZettelReferences <CR>',
{ desc="List all references to current note"})
