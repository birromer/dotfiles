-- Autocmds are automatically loaded on the VeryLazy event

local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("Random", {clear = true})

vim.api.nvim_create_autocmd({"ColorScheme", "FileType"}, {
  pattern = "*",
  callback = function()
    -- Headline levels (elflord-ish palette, truecolor hex)
    vim.api.nvim_set_hl(0, "@org.headline.level1", { fg = "#ff5555", bold = true })  -- red
    vim.api.nvim_set_hl(0, "@org.headline.level2", { fg = "#ffff55", bold = true })  -- yellow
    vim.api.nvim_set_hl(0, "@org.headline.level3", { fg = "#55ff55", bold = true })  -- green
    vim.api.nvim_set_hl(0, "@org.headline.level4", { fg = "#55ffff", bold = true })  -- cyan
    vim.api.nvim_set_hl(0, "@org.headline.level5", { fg = "#ff55ff", bold = true })  -- magenta
    vim.api.nvim_set_hl(0, "@org.headline.level6", { fg = "#5555ff", bold = true })  -- blue

    -- TODO states
    vim.api.nvim_set_hl(0, "@org.keyword.todo",      { fg = "#ff5555", bold = true })
    vim.api.nvim_set_hl(0, "@org.keyword.done",      { fg = "#55ff55" })
    vim.api.nvim_set_hl(0, "OrgTODO",      { fg = "#ff5555", bold = true })
    vim.api.nvim_set_hl(0, "OrgNEXT",      { fg = "#ffaa00", bold = true })
    vim.api.nvim_set_hl(0, "OrgWAITING",   { fg = "#ff55ff" })
    vim.api.nvim_set_hl(0, "OrgMAYBE",     { fg = "#888888", italic = true })
    vim.api.nvim_set_hl(0, "OrgDONE",      { fg = "#55ff55" })
    vim.api.nvim_set_hl(0, "OrgCANCELLED", { fg = "#666666", strikethrough = true })
  end,
})

vim.cmd("doautocmd ColorScheme")

-- Trigger once now in case ColorScheme already fired
vim.cmd("doautocmd ColorScheme")

autocmd("FileType", {
  pattern = { "org", "orgagenda" },
  callback = function()
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = true, remap = true, desc = desc })
    end

    map("<leader>os", "<leader>ois", "Schedule")
    map("<leader>od", "<leader>oid", "Deadline")
    map("<leader>oe", "<leader>oxe", "Effort")
    map("<leader>oi", "<leader>oxi", "Clock in")
    map("<leader>oo", "<leader>oxo", "Clock out")
    map("<leader>oj", "<leader>oxj", "Jump to clocked")
    map("<leader>op", "<leader>o,",  "Priority")
    map("<leader>oN", "<leader>ona", "Add note")
  end,
})

autocmd("FileType", {
  pattern = "julia",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- vimtex conceal toggle
autocmd("FileType", {
  pattern = "tex",
  desc = "Setup conceal toggle for VimTeX",
  callback = function()
    -- concealing off by default
    vim.wo.conceallevel = 0

    -- keymap only for this buffer
    vim.keymap.set("n", "<leader>p", function()
      if vim.wo.conceallevel == 0 then
        vim.wo.conceallevel = 2
        vim.notify("VimTeX Conceal ON", vim.log.levels.INFO, { title = "View Mode" })
      else
        vim.wo.conceallevel = 0
        vim.notify("VimTeX Conceal OFF", vim.log.levels.INFO, { title = "View Mode" })
      end
    end, { buffer = true, silent = true, desc = "Toggle Conceal (VimTeX)" })
  end,
})

-- vim.api.nvim_create_autocmd('User', {
--     pattern = 'VimtexEventView',
--     callback = function()
--         -- Add a small delay to ensure Skim is fully opened
--         vim.fn.system('sleep 0.5 && osascript ~/Library/Scripts/ArrangeSkim.scpt')
--     end,
-- })
--
autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*-contents.tex",
  callback = function()
    vim.opt_local.wrap = false  -- Use opt_local to set it only for this buffer
  end
})

autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.kl",
  callback = function()
    vim.bo.filetype = "tex"
  end
})

autocmd("BufEnter", {
  pattern = {"*/thesis/*.tex", "*/thesis/*.kl",
  "*/Notes/*.tex","*/Notes/*.kl",
  "*/Zettel/*.tex","*/Zettel/*.kl"},
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end
}) -- "-" stays in the same word

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
  pattern = {"*.tex", "*.tree", "*.md", "org", "orgagenda"},
  command = "Wrapwidth 100",
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

