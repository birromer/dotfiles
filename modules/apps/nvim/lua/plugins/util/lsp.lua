return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we want manual control
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
--  { "barreiroleo/ltex_extra.nvim" },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
    },
    config = function()
      local cmp = require("cmp")
  
      -- Helper function from your original config
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end
  
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip", option = { show_autosnippets = true, use_show_condition = false } },
          { name = "buffer" },
          { name = "path" },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          -- Disable Enter for completion
          ["<CR>"] = vim.NIL,
          -- Arrow keys navigate the completion menu
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Tab confirms selection or triggers completion
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
            elseif require("luasnip").expand_or_locally_jumpable() then
              require("luasnip").expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Shift-Tab selects previous item or jumps back in snippet
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      -- This is where you setup your on_attach function
      lsp_zero.on_attach(function(client, bufnr)
        -- Disable semantic tokens
        client.server_capabilities.semanticTokensProvider = nil

        local opts = { buffer = bufnr }

        -- LSP keymaps
        vim.keymap.set({ "n", "x" }, "<leader>lf", function()
          vim.lsp.buf.format({ async = true, timeout_ms = 10000 })
        end, vim.tbl_extend("force", opts, { desc = "LSP format" }))

        vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP action" }))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP definition" }))
        vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP declaration" }))
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP implementation" }))
        vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP signature" }))
        vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "LSP type def" }))
        vim.keymap.set("n", "<leader>le", function()
          require("trouble").open("lsp_references")
        end, vim.tbl_extend("force", opts, { desc = "LSP references" }))

        vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        vim.keymap.set("n", "<leader>lwl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

        -- Diagnostic keymaps
        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Diagnostic float" })
        vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
        vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
      end)

      vim.lsp.enable("julials")

      -- Setup neodev before lspconfig
      require("neodev").setup({})

      local lspconfig = require("lspconfig")
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "marksman",
          "pyright",
          "neocmake",
          "clangd",
          "jsonls",
          "texlab",
--          "ltex",
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = lsp_capabilities,
            })
        end,

        julials = function()
          lspconfig.julials.setup({
            capabilities = lsp_capabilities,
          })
        end,

        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = lsp_capabilities,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                  maxPreload = 10000,
                  preloadFileSize = 10000,
                },
                telemetry = { enable = false },
              },
            },
            })
          end,

          clangd = function()
            lspconfig.clangd.setup({
              capabilities = vim.tbl_extend("force", lsp_capabilities, {
                offsetEncoding = { "utf-16" },
              }),
              cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
              },
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
            })
          end,

          jsonls = function()
            lspconfig.jsonls.setup({
              capabilities = lsp_capabilities,
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            })
          end,

          texlab = function()
            lspconfig.texlab.setup({
              capabilities = lsp_capabilities,
              settings = {
                texlab = {
                  build = {
                    executable = "latexmk",
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                    onSave = false,
                    forwardSearchAfter = false,
                  },
                  auxDirectory = "build",
                  chktex = {
                    onOpenAndSave = false,
                    onEdit = false,
                  },
                  diagnosticsDelay = 300,
                  diagnostics = {
                    ignoredPatterns = { 
                      "^Undefined reference",
                      "^Reference .* undefined",
--                      "^Citation .* undefined",
                    },
                  },
                },
              },
            })
          end,

--          ltex = function()
--            lspconfig.ltex.setup({
--              capabilities = lsp_capabilities,
--              -- This 'on_attach' is the magic fix. It enables the commands.
--              on_attach = function(client, bufnr)
--                require("ltex_extra").setup({
--                  load_langs = { "en-US" }, 
--                  init_check = true,
--                  path = ".ltex", -- This creates a hidden folder in your project to store ignored words
--                })
--              end,
--              filetypes = { "latex", "tex", "bib", "markdown" },
--              settings = {
--                ltex = {
--                  language = "en-US",
--                  checkFrequency = "save",
--                  additionalRules = {
--                    enablePickyRules = true,
--                    motherTongue = "en-US",
--                  },
--                  hiddenFalsePositives = {
--                    "transclude", 
--                    "executemetadata",
--                  },
--                },
--              },
--            })
--          end,

          -- Skip rust_analyzer - rustaceanvim handles it
          rust_analyzer = function() end,
        },
      })
    end,
  },
}
