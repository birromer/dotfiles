-- Autocmds are automatically loaded on the VeryLazy event

local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("Random", {clear = true})

-- vim.api.nvim_create_autocmd('User', {
--     pattern = 'VimtexEventView',
--     callback = function()
--         -- Add a small delay to ensure Skim is fully opened
--         vim.fn.system('sleep 0.5 && osascript ~/Library/Scripts/ArrangeSkim.scpt')
--     end,
-- })
--
autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*_notions.tex",
  callback = function()
    vim.opt_local.wrap = false  -- Use opt_local to set it only for this buffer
  end
})

autocmd("VimResized", {
    group = "Random",
    desc = "Keep windows equally resized",
    command = "tabdo wincmd ="
})

autocmd("TermOpen", {
    group = "Random",
    command = "setlocal nonumber norelativenumber signcolumn=no"
})

autocmd("InsertEnter", {group = "Random", command = "set timeoutlen=100"})
autocmd("InsertLeave", {group = "Random", command = "set timeoutlen=1000"})

-- vimtex

autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.tex", "*.tree", "*.md"},
  command = "Wrapwidth 80",
})

vim.g.tex_compiles_successfully = false
vim.g.term_pdf_vierer_open = false

vim.api.nvim_create_augroup("CustomTex", {})
autocmd("User", {
    group = "CustomTex",
    pattern = "VimtexEventCompileSuccess",
    callback = function()
        vim.g.tex_compiles_successfully = true

        -- a hacky way to reload the pdf in the terminal
        -- when it has changed
        if vim.g.term_pdf_vierer_open and vim.g.tex_compiles_successfully then
            local command = "termpdf.py " .. vim.fn.getcwd() .. "/slipbox/" .. vim.api.nvim_call_function("expand", {"%:r"}) .. ".pdf" .. "'\r'"
            local kitty = "kitty @ --to $KITTY_LISTEN_ON send-text --match title:termpdf "
            vim.fn.system(kitty .. command)
        end
    end,
})

        local command = "termpdf.py " .. vim.fn.getcwd() .. "/slipbox/" .. vim.api.nvim_call_function("expand", {"%:r"}) .. ".pdf" .. "'\r'"

autocmd("User", {
    group = "CustomTex",
    pattern = "VimtexEventCompileFailed",
    callback = function()
        vim.g.tex_compiles_successfully = false
    end,
})

autocmd("User", {
    group = "CustomTex",
    pattern = "VimtexEventQuit",
    callback = function()
        vim.fn.system("kitty @ --to $KITTY_LISTEN_ON close-window --match title:termpdf")
    end,
})

