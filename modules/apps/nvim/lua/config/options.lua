-- Options are automatically loaded before lazy.nvim startup

-- Latex option
vim.g.latex_to_unicode_keymap = 1
vim.g.vimtex_syntax_conceal_disable = 1

-- Python options
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff_lsp"

-- UI options
vim.g.base16colorspace = 256
vim.opt.termguicolors = true -- Truecolor
vim.opt.conceallevel = 2     -- conceal
vim.opt.cursorline = true    -- enable highlighting of the current line
vim.opt.laststatus = 3       -- global statusline
vim.opt.list = true          -- show some invisible characters
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false  -- don't show mode since we have a statusline
vim.opt.scrolloff = 4     -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 2

-- Disable netew
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line wrap options
vim.opt.linebreak = true
vim.g.wrapwidth_sign = '|'
vim.g.wrapwidth_number = 1
vim.opt.wrap = true
-- vim.opt.cc = "80"
-- vim.opt.wrapmargin = 0
-- vim.opt.textwidth = 0
-- vim.opt_local.columns = 120

-- Sync with system clipboard
vim.opt.clipboard = "unnamedplus"

-- Confirm to save changes before exiting modified buffer
vim.opt.confirm = true

-- Grep and search options
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.ignorecase = true
vim.opt.smartcase = true       -- don't ignore case with capitals

-- Enable mouse mode
vim.opt.mouse = "a"

-- Popup options
vim.opt.pumblend = 10  -- popup blend
vim.opt.pumheight = 10 -- maximum number of entries in a popup
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Indentation options
vim.opt.expandtab = true   -- use spaces instead of tabs
vim.opt.shiftround = true  -- sound indent
vim.opt.shiftwidth = 2     -- size of an indent
vim.opt.smartindent = true -- insert indents automatically
vim.opt.tabstop = 2        -- number of spaces tabs count for

-- Split screen options
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true

-- Timeout
vim.opt.timeoutlen = 300

-- Undo
vim.opt.undofile = true
vim.opt.undolevels = 10000
-- Save swap file and trigger CursorHold
vim.opt.updatetime = 200

-- Allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = "block"


if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
