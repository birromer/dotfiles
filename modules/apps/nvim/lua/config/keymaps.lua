-- Keymaps are automatically loaded on the VeryLazy event
local map = vim.keymap.set
local wk = require("which-key")

-- New tmux session
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Better replace
map("x", "<leader>p", "\"_dP", { desc = "Paste preserving clipboard"})

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- Keep cursor at the beginning of the line
map("n", "J", "mzJ`z")

-- Keep cursor at the middle of the screen when jumping half screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Windows
-- map("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close current buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
-- stylua: ignore start
map( "n", "<leader>r", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Formatting
map({ "n", "v" }, "<leader>cf", function()
  require("lazyvim.util").format({ force = true })
end, { desc = "Format" })

-- Highlights under cursor
map("n", "<leader>i", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>pv", vim.cmd.Ex)

-- -- Plugins --

-- Lazygit
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
map("n", "<leader>gd", "<cmd>Git difftool --name-only<cr>", { desc = "Previous in quickfix list" })
--map("n", "<leader>gf", function() local git_path = vim.api.nvim_buf_get_name(0) LazyVim.lazygit({args = { "-f", vim.trim(git_path) }}) end, { desc = "Lazygit Current File History" })

-- Telescope
local builtin_telescope = require("telescope.builtin")
wk.register({
  ["<leader>f"] = { name = "Telescope", }
})
local find_buffer_description = "Telescope find buffer"
map("n", "<leader>fp", "<Cmd>Telescope projects<CR>", {desc = "Projects"})
map("n", "<leader>fd", builtin_telescope.git_bcommits, { desc = "Telecope commits for current buffer" })
map("n", "<leader>fs", builtin_telescope.git_status, { desc = "Telecope git status" })
map("n", "<leader>ff", builtin_telescope.find_files, { desc = find_buffer_description })
map("n", "<leader><space>", builtin_telescope.find_files, { desc = find_buffer_description })
map("n", "<leader>,", builtin_telescope.buffers, { desc = find_buffer_description })
map("n", "<leader>fg", builtin_telescope.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fm", builtin_telescope.keymaps, { desc = "Telescope find mapping/keybinding" })
map("n", "<leader>fu", builtin_telescope.current_buffer_fuzzy_find, { desc = "Fuzzy find in the current buffer" })
map("n", "<leader>ft", builtin_telescope.treesitter, { desc = "Treesitter" })
map( "n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true, desc = "Telescope file browser" })
map("n", "<leader>fh", builtin_telescope.help_tags, { desc = "Telescope find help" })

-- Harpoon
map("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Mark file with harpoon" })
map("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "Show harpoon marks", noremap = true, silent = true })

-- Oil
map("n", "<leader>E", function() require("oil").open(); require("oil").open_preview() end, {desc = "File Explorer"})
map("n", "<leader>e", function() require("oil").open_float() end, {desc = "File Browser"})
map("n", "<leader>fb", function() require("oil").toggle_float(vim.fn.getcwd()) end, {desc = "File Browser (CWD)"})
map("n", "<leader>fN", function() require("oil").toggle_float("~/mega/notes/") end, {desc = "Notes folder"})

-- Spectre
map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre", })
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word", })
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word", })
map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file", })

-- Tmux
map("n", "<C-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
map("n", "<C-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
map("n", "<C-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)
map("n", "<C-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
map("n", "<C-\\>", require("nvim-tmux-navigation").NvimTmuxNavigateLastActive)
map("n", "<C-Space>", require("nvim-tmux-navigation").NvimTmuxNavigateNext)

-- Forester
-- map("n", "<leader>n.", "<cmd>Forester browse<CR>", { silent = true })
-- map("n", "<leader>nn", "<cmd>Forester new<CR>", { silent = true })
-- map("n", "<leader>nr", "<cmd>Forester new_random<CR>", { silent = true })
-- map("i", "<C-t>", "<cmd>Forester transclude<CR>", { silent = true })
-- map("i", "<C-l>", "<cmd>Forester link<CR>", { silent = true })

-- Vimtex
map("n", "<leader>d", "<cmd>:VimtexTocToggle<cr>", { desc = "Toggle ToC" } )

vim.g.tex_compiles_successfully = false
vim.g.term_pdf_vierer_open = false

function VimtexPDFToggle()
    if vim.g.term_pdf_vierer_open then
        vim.print("Case pdf open")
        vim.fn.system("kitty @ --to $KITTY_LISTEN_ON close-window --match title:termpdf")
        vim.g.term_pdf_vierer_open = false
    elseif vim.g.tex_compiles_successfully then
        vim.print("case pdf not open")
        vim.fn.system("kitty @ --to $KITTY_LISTEN_ON launch --location=vsplit --cwd=current --title=termpdf")
        local command = "termpdf.py " .. vim.fn.getcwd() .. "/slipbox/" .. vim.api.nvim_call_function("expand", {"%:r"}) .. ".pdf" .. "'\r'"
        local kitty = "kitty @ --to $KITTY_LISTEN_ON send-text --match title:termpdf "
        vim.fn.system(kitty .. command)
        vim.g.term_pdf_vierer_open = true
    end
end

map("n", "<leader>p", ":lua VimtexPDFToggle()<cr>")

-- Maximizer
map("n", "<leader>wm", "<cmd>MaximizerToggle<cr>", {desc = "Toggle maximizer"} )

-- Wrapwidth
map("n", "<leader>ww", "<cmd>Wrapwidth 80<cr>", {desc = "Enable wrap"})
map("n", "<leader>wf", "<cmd>Wrapwidth! <cr>", {desc = "Fix wrap"})

-- Flash
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, {desc = "Flash"})
map({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, {desc = "Flash Treesitter"})
map("o", "r", function() require("flash").remote() end, {desc = "Remote Flash"})
map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, {desc = "Treesitter Search"})
map("c", "<c-s>", function() require("flash").toggle() end, {desc = "Toggle Flash Search"})

-- Todo-comments
map("n", "]t", function() require("todo-comments").jump_next() end, {desc = "Next Todo Comment" })
map("n", "[t", function() require("todo-comments").jump_prev() end, {desc = "Previous Todo Comment" })
map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", {desc = "Todo (Trouble)" })
map("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", {desc = "Todo/Fix/Fixme (Trouble)" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", {desc = "Todo" })
map("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", {desc = "Todo/Fix/Fixme" })

-- Todo list
--map("n", "<leader>t", "<cmd>TodoLocList<cr>", { desc = "Todo telescope" })
map("n", "<leader>t", "<cmd>TodoTelescope<cr>", {desc = "Todo" })


-- Undotree
map("n",  "<leader>u", vim.cmd.UndotreeToggle, {desc = "Undotree toggle"})

-- Fold
map('n', '<tab>', function() return require('fold-cycle').open() end, {silent = true, desc = 'Fold-cycle: open folds'})
map('n', '<s-tab>', function() return require('fold-cycle').close() end, {silent = true, desc = 'Fold-cycle: close folds'})
map('n', 'zC', function() return require('fold-cycle').close_all() end, {remap = true, silent = true, desc = 'Fold-cycle: close all folds'})
