-- Autocmds are automatically loaded on the VeryLazy event

local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("Random", {clear = true})

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

