return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      require('orgmode').setup({
        -- Files and defaults
        org_agenda_files = '~/cloud/Notes/org/**/*.org',
        org_default_notes_file = '~/cloud/Notes/org/inbox.org',

        -- Display
        win_split_mode = 'tabnew',

        -- States
        -- NOTE: WEEK and WAIT both bind the access key `w` (collision). You said
        -- earlier you only use TODO. To drop WEEK, delete 'WEEK(w)' from this list.
        org_todo_keywords = {
          'TODO(t)', 'WEEK(w)', 'WAIT(w@/!)', 'LATER(l)',
          '|',
          'DONE(d!)', 'CANCELLED(c@)',
        },

        org_blank_before_new_entry = {
          heading = false,
          plain_list_item = false,
        },

        org_priority_highest = 'A',
        org_priority_lowest = 'D',
        org_priority_default = 'C',

        -- Don't log repeating tasks, only when it is done.
        org_log_repeat = false,
        org_log_done = true,

        -- Log transitions into a drawer so they don't clutter the headline body
        -- org_log_into_drawer = 'LOGBOOK',

        -- Effort estimate defaults
        org_global_properties = {
          Effort_ALL = '0:15 0:30 0:45 1:00 2:00 3:00 4:00 1d 2d 1w',
        },

        org_agenda_remove_tags = false,

        org_agenda_tags_column = -120,

        -- Archive location (default, explicit for clarity)
        org_archive_location = '%s_archive::',

        -- Right-align tags. Negative = from right edge. Adjust to your terminal width.
        org_tags_column = -120,

        -- Start files with level-1 and level-2 visible, level-3 (tasks) folded
        org_startup_folded = 'content',

        -- Capture templates
        org_capture_templates = {
          i = {
            description = 'Inbox',
            template = '* TODO %?',
            target = '~/cloud/Notes/org/inbox.org',
          },
          w = {
            description = 'Work',
            template = '* TODO %?',
            target = '~/cloud/Notes/org/work.org',
            headline = 'Inbox',
          },
          p = {
            description = 'Perso',
            template = '* TODO %?',
            target = '~/cloud/Notes/org/perso.org',
            headline = 'Inbox',
          },
        },

        org_agenda_start_on_weekday = 1,  -- Monday

        org_deadline_warning_days = 0,

        org_startup_indented = true,

        -- Agenda custom commands
        -- Activity tags: personal -> a_chore_🧹 a_fun_🌈 a_read_📖 a_talk_🤙
        --                work     -> a_deep_⛔ a_small_💧
        -- D is the Day view: inbox, then one day-agenda per activity bucket
        -- (today's scheduled tasks, with times). No global timeline on top.
        -- p and w are the plan-ahead views: Today on top, inbox, the week
        -- buckets by TODO state, then the unplanned Later backlog.
        org_agenda_custom_commands = {
          D = {
            description = 'Day',
            types = {
              { type = 'tags_todo', match = '+📥',
                org_agenda_overriding_header = '📥 Inbox' },
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = 'a_chore_🧹-⏰',
                org_agenda_overriding_header = '🧹 Chore' },
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = 'a_fun_🌈-⏰',
                org_agenda_overriding_header = '🌈 Fun' },
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = 'a_read_📖-⏰',
                org_agenda_overriding_header = '📖 Read' },
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = 'a_talk_🤙-⏰',
                org_agenda_overriding_header = '🤙 Talk' },
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = 'a_deep_⛔-⏰',
                org_agenda_overriding_header = '⛔ Deep' },
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = 'a_small_💧-⏰',
                org_agenda_overriding_header = '💧 Small',
              },
            },
          },
          p = {
            description = 'Perso',
            types = {
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = '🙋',
                org_agenda_todo_ignore_scheduled = 'future',
                org_agenda_overriding_header = 'Today' },
              { type = 'tags_todo', match = '+📥',
                org_agenda_overriding_header = 'Inbox' },
              { type = 'tags_todo', match = '+🙋-a_chore_🧹-a_fun_🌈-⏰-a_talk_🤙-a_read_📖',
                org_agenda_overriding_header = 'Fix' },
              { type = 'tags_todo', match = '-⏰+🙋+a_chore_🧹/TODO',
                org_agenda_overriding_header = '🧹 Chore (this week)' },
              { type = 'tags_todo', match = '-⏰+🙋+a_fun_🌈/TODO',
                org_agenda_overriding_header = '🌈 Fun (this week)' },
              { type = 'tags_todo', match = '-⏰+🙋+a_read_📖/TODO',
                org_agenda_overriding_header = '📖 Read (this week)' },
              { type = 'tags_todo', match = '-⏰+🙋+a_talk_🤙/TODO',
                org_agenda_overriding_header = '🤙 Talk (this week)' },
              { type = 'tags_todo', match = '-⏰+🙋+a_chore_🧹/LATER',
                org_agenda_overriding_header = '🧹 Chore (unplanned)',
                org_agenda_todo_ignore_scheduled = 'all' },
              { type = 'tags_todo', match = '-⏰+🙋+a_fun_🌈/LATER',
                org_agenda_overriding_header = '🌈 Fun (unplanned)',
                org_agenda_todo_ignore_scheduled = 'all' },
              { type = 'tags_todo', match = '-⏰+🙋+a_read_📖/LATER',
                org_agenda_overriding_header = '📖 Read (unplanned)',
                org_agenda_todo_ignore_scheduled = 'all' },
              { type = 'tags_todo', match = '-⏰+🙋+a_talk_🤙/LATER',
                org_agenda_overriding_header = '🤙 Talk (unplanned)',
                org_agenda_todo_ignore_scheduled = 'all' },
            },
          },
          w = {
            description = 'Work',
            types = {
              { type = 'agenda', org_agenda_span = 'day',
                org_agenda_tag_filter_preset = '🛠️',
                org_agenda_overriding_header = 'Today' },
              { type = 'tags_todo', match = '+📥',
                org_agenda_overriding_header = 'Inbox' },
              { type = 'tags_todo', match = '+🛠️-a_deep_⛔-a_small_💧-⏰',
                org_agenda_overriding_header = 'Fix' },
              { type = 'tags_todo', match = '-⏰+🛠️+a_deep_⛔/TODO',
                org_agenda_overriding_header = '⛔ Deep (this week)' },
              { type = 'tags_todo', match = '-⏰+🛠️+a_small_💧/TODO',
                org_agenda_overriding_header = '💧 Small (this week)' },
              { type = 'tags_todo', match = '-⏰+🛠️+a_deep_⛔/LATER',
                org_agenda_overriding_header = '⛔ Deep (unplanned)',
                org_agenda_todo_ignore_scheduled = 'all' },
              { type = 'tags_todo', match = '-⏰+🛠️+a_small_💧/LATER',
                org_agenda_overriding_header = '💧 Small (unplanned)',
                org_agenda_todo_ignore_scheduled = 'all' },
            },
          },
        },
      })

      vim.api.nvim_set_hl(0, '@org.agenda.scheduled', { link = 'Normal' })

      vim.api.nvim_set_hl(0, '@org.priority.highest', { fg = '#ff5555', bold = true }) -- A  red
      vim.api.nvim_set_hl(0, '@org.priority.high',    { fg = '#5599ff', bold = true }) -- B  blue
      vim.api.nvim_set_hl(0, '@org.priority.lowest',  { fg = '#bd93f9' })              -- D  purple

      vim.lsp.enable('org')

      -- Per-filetype editor settings for .org files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'org',
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = 'nc'
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
        end,
      })
    end,
  },

  -- Pretty headline bullets instead of raw asterisks
  {
    'akinsho/org-bullets.nvim',
    ft = { 'org' },
    config = function()
      require('org-bullets').setup({
        concealcursor = false,
        symbols = {
          headlines = { '🔴', '⭕', '🟥', '♦️', '🔺' },
          checkboxes = {
            half = { '', 'OrgTSCheckboxHalfChecked' },
            done = { '✓', 'OrgDone' },
            todo = { ' ', 'OrgTODO' },
          },
        },
      })
    end,
  },

  -- Telescope pickers for orgmode (fuzzy refile, headline search)
  {
    'nvim-orgmode/telescope-orgmode.nvim',
    dependencies = {
      'nvim-orgmode/orgmode',
      'nvim-telescope/telescope.nvim',
    },
    event = 'VeryLazy',
    config = function()
      require('telescope').load_extension('orgmode')

      -- Override default refile with fuzzy version
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'org', 'orgagenda' },
        callback = function()
          vim.keymap.set('n', '<leader>oh', require('telescope').extensions.orgmode.search_headings,
            { buffer = true, desc = 'Search headlines' })
          vim.keymap.set('n', '<leader>oT', require('telescope').extensions.orgmode.search_tags,
            { buffer = true, desc = 'Insert tag' })
        end,
      })
    end,
  },

  -- Completion source for orgmode
  {
    'hrsh7th/nvim-cmp',
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = 'orgmode' })
    end,
  },
}
