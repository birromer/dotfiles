return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      require('orgmode').setup({
        -- Files and defaults
        org_agenda_files = '~/cloud/org/**/*.org',
        org_default_notes_file = '~/cloud/org/inbox.org',

        -- States
        org_todo_keywords = {
          'TODO(t)', 'NEXT(n)', 'WAIT(w@/!)', 'LATER(l)',
          '|',
          'DONE(d!)', 'CANCELLED(c@)',
        },

        org_blank_before_new_entry = {
          heading = false,
          plain_list_item = false,
        },

        -- Log transitions into a drawer so they don't clutter the headline body
        org_log_into_drawer = 'LOGBOOK',

        -- Effort estimate defaults
        org_global_properties = {
          Effort_ALL = '0:15 0:30 0:45 1:00 2:00 3:00 4:00 1d 2d 1w',
        },

        org_agenda_remove_tags = false,

        org_agenda_tags_column = -100,

        -- Archive location (default, explicit for clarity)
        org_archive_location = '%s_archive::',

        -- Right-align tags. Negative = from right edge. Adjust to your terminal width.
        org_tags_column = -100,

        -- Start files with level-1 and level-2 visible, level-3 (tasks) folded
        org_startup_folded = 'content',

        -- Capture templates
        org_capture_templates = {
          i = {
            description = 'Inbox',
            template = '* TODO %?',
            target = '~/cloud/org/inbox.org',
          },
          w = {
            description = 'Work',
            template = '* TODO %?',
            target = '~/cloud/org/work.org',
            headline = 'Tasks',
          },
          p = {
            description = 'Perso',
            template = '* TODO %?',
            target = '~/cloud/org/perso.org',
            headline = 'Tasks',
          },
        },

        org_agenda_start_on_weekday = 1,  -- Monday

        org_deadline_warning_days = 7,

        org_startup_indented = true,

        -- Agenda custom commands
        org_agenda_custom_commands = {
          w = {
            description = 'Work',
            types = {
              { type = 'tags_todo', match = '+work/NEXT',
                org_agenda_overriding_header = 'Active' },
              { type = 'tags_todo', match = '+work/TODO',
                org_agenda_overriding_header = 'Soon' },
              { type = 'tags_todo', match = '+work/LATER',
                org_agenda_overriding_header = 'Later' },
              { type = 'tags_todo', match = '+work/WAIT',
                org_agenda_overriding_header = 'Waiting' },
            },
          },
          p = {
            description = 'Perso',
            types = {
              { type = 'tags_todo', match = '+perso/NEXT',
                org_agenda_overriding_header = 'Active' },
              { type = 'tags_todo', match = '+perso/TODO',
                org_agenda_overriding_header = 'Soon' },
              { type = 'tags_todo', match = '+perso/LATER',
                org_agenda_overriding_header = 'Later' },
              { type = 'tags_todo', match = '+perso/WAIT',
                org_agenda_overriding_header = 'Waiting' },
            },
          },
          h = {
            description = 'Habits',
            types = {
              { type = 'tags_todo', match = '+habits',
                org_agenda_overriding_header = 'Habits' },
            },
          },
          i = {
            description = 'Inbox',
            types = {
              { type = 'tags_todo', match = '+inbox',
                org_agenda_overriding_header = 'Inbox' },
            },
          },
          D = {
            description = 'Day',
            types = {{ type = 'agenda', org_agenda_span = 'day' }},
          },
          W = {
            description = 'Week',
            types = {{ type = 'agenda', org_agenda_span = 'week' }},
          },
        },
      })

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
