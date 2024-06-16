--  Note that $NOTES_DIR is a shell environment variable pointing to
--  the single flat directory holding all the notes or "zettels"
-- Adapted from https://github.com/raymon-roos/neovim-config/blob/bc87a6adef280e0bb20fcfb6bfde37131f99b056/lua/zettelkasten.lua

-- Local variables
local map = vim.keymap.set
local user_func = vim.api.nvim_create_user_command
local fn = vim.fn
local NOTES_DIR = "/Users/bernardo/mega/notes"

-- Function definitions
local function create_zettel(prefix, filename, split)
  local zettel_name = fn.fnameescape(
    fn.expand('$NOTES_DIR/') .. prefix .. filename .. '.tex'
  )

  if split ~= 'split' and split ~= 'vsplit' and split ~= 'edit' then
    split = 'edit'
  end

  vim.cmd(split .. ' ' .. zettel_name)
  print(fn.expand('%:p:~'))
end

user_func('NewZettel', function()
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
    create_zettel(
      "",
      vim.fn.expand('<cword>'),
      'edit'
    )
  end,
  { nargs = 0 }
)

user_func('SplitJumpToNote', function()
    create_zettel(
      "",
      vim.fn.expand('<cword>'),
      'slip'
    )
  end,
  { nargs = 0 }
)


user_func('ZettelReferences', function()
    require('telescope.builtin').live_grep({ default_text = vim.fn.expand('%:t:r') })
  end,
  { nargs = 0 }
)

-- Keymaps
map("n", "<leader>nn", "<cmd>NewZettel<cr>",
{ silent = false, desc="Create new note (same prefix)"})

map("n", '<leader>ns', '<cmd> SplitZettel <cr>',
{ silent = false, desc="Create new note (same prefix) (hsplit)"})

map("n", '<leader>nv', '<cmd>VertZettel<cr>',
{ silent = false, desc="Create new note (same prefix) (vsplit)"})

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
