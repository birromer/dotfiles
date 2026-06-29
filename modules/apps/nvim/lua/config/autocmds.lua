-- Autocmds are automatically loaded on the VeryLazy event

local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("Random", {clear = true})

-- Tag namespace coloring via extmark post-processing
local tag_prefix_hl = {
  t_ = 'OrgTagWorkType',
  i_ = 'OrgTagInterest',
  c_ = 'OrgTagContext',
  w_ = 'OrgTagWrite',
  d_ = 'OrgTagDev',
  r_ = 'OrgTagRead',
  q_ = 'OrgTagQuestion',
  p_ = 'OrgTagProject',
}

-- Filetag emojis (single-emoji, file-level tags) get their own colors.
-- These are matched exactly, before the prefix lookup.
local tag_exact_hl = {
  ['📥'] = 'OrgTagInbox',
  ['🛠️'] = 'OrgTagWork',
  ['🙋'] = 'OrgTagPerso',
  ['⏰'] = 'OrgTagHabit',
}

for group, fg in pairs({
  OrgTagWorkType = '#f7768e',
  OrgTagInterest = '#bb9af7',
  OrgTagContext  = '#7aa2f7',
  OrgTagWrite    = '#9ece6a',
  OrgTagDev      = '#7dcfff',
  OrgTagRead     = '#ff9e64',
  OrgTagQuestion = '#e0af68',
  OrgTagProject  = '#565f89',
  OrgTagInbox    = '#e0af68',
  OrgTagWork     = '#f7768e',
  OrgTagPerso    = '#9ece6a',
  OrgTagHabit    = '#565f89',
}) do
  vim.api.nvim_set_hl(0, group, { fg = fg })
end

local function recolor_agenda_tags(buf)
  local ns = vim.api.nvim_get_namespaces()['org_agenda']
  if not ns then return end
  local marks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, { details = true })
  for _, mark in ipairs(marks) do
    local id, row, col, opts = mark[1], mark[2], mark[3], mark[4]
    if opts.virt_text then
      local changed = false
      local new_vt = {}
      for _, chunk in ipairs(opts.virt_text) do
        local text, hl = chunk[1], chunk[2]
        -- Tag column: ':tag:tag:' with no internal whitespace.
        -- %S (not [%a_:]) so emoji bytes in tags are accepted.
        if type(text) == 'string' and text:match('^:%S+:$') then
          new_vt[#new_vt+1] = { ':', '@org.agenda.tag' }
          for tag in text:gmatch(':([^:]+)') do
            local tag_hl = tag_exact_hl[tag] or tag_prefix_hl[tag:sub(1, 2)] or '@org.agenda.tag'
            new_vt[#new_vt+1] = { tag, tag_hl }
            new_vt[#new_vt+1] = { ':', '@org.agenda.tag' }
          end
          changed = true
        else
          new_vt[#new_vt+1] = chunk
        end
      end
      if changed then
        local clean = vim.tbl_extend('force', opts, { virt_text = new_vt, id = id })
        clean.ns_id = nil
        vim.api.nvim_buf_set_extmark(buf, ns, row, col, clean)
      end
    end
  end
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = 'orgagenda',
  callback = function(ev)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(ev.buf) then return end
      recolor_agenda_tags(ev.buf)
      -- set up r remap once per buffer
      if not vim.b[ev.buf].org_tag_remap then
        vim.b[ev.buf].org_tag_remap = true
        vim.keymap.set('n', 'r', function()
          require('orgmode').action('agenda.redo', 'mapping')
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              recolor_agenda_tags(ev.buf)
            end
          end, 100)
        end, { buffer = ev.buf })
      end
    end, 100)
  end,
})

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
    vim.api.nvim_set_hl(0, "OrgWEEK",      { fg = "#ffaa00", bold = true })
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
  command = "Wrapwidth 95",
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

