return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = true,
    config = function()
      require("lsp-zero.settings").preset({})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "williamboman/mason.nvim" },
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        marksman = {},
        pyright = { enabled = true },
        neocmake = {},
        rust_analyzer = {},
        clangd = {
          keys = {
            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
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
        },
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require("lsp-zero")

      lsp.on_attach(function(client, bufnr)
        -- Do not provide highlighting for semantic tokens
        client.server_capabilities.semanticTokensProvider = nil

        lsp.default_keymaps({ buffer = bufnr })
        local generate_opts = function(desc)
          return { desc = desc, buffer = bufnr }
        end

        vim.keymap.set({ "n", "x" }, "<leader>lf", function() vim.lsp.buf.format({ async = true, timeout_ms = 10000 }) end, generate_opts("LSP format"))

        vim.keymap.set({ "n" }, "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, generate_opts("LSP list_workspace_folders"))

        vim.keymap.set({ "n" }, "<leader>lh", vim.lsp.buf.hover, generate_opts("LSP hover"))
        vim.keymap.set({ "n" }, "<leader>la", vim.lsp.buf.code_action, generate_opts("LSP action"))
        vim.keymap.set({ "n" }, "<leader>lr", vim.lsp.buf.rename, generate_opts("LSP rename"))
        vim.keymap.set({ "n" }, "<leader>ld", vim.lsp.buf.definition, generate_opts("LSP definition"))
        vim.keymap.set({ "n" }, "<leader>lD", vim.lsp.buf.declaration, generate_opts("LSP declaration"))
        vim.keymap.set( { "n" }, "<leader>li", vim.lsp.buf.implementation, generate_opts("LSP implementation"))
        vim.keymap.set( { "n" }, "<leader>ls", vim.lsp.buf.signature_help, generate_opts("LSP signature_help"))
        vim.keymap.set( { "n" }, "<leader>lwa", vim.lsp.buf.add_workspace_folder, generate_opts("LSP add_workspace_folder"))
        vim.keymap.set( { "n" }, "<leader>lwr", vim.lsp.buf.remove_workspace_folder, generate_opts("LSP remove_workspace_folder"))
        vim.keymap.set("n", "<leader>le", function() require("trouble").open("lsp_references") end, generate_opts("LSP references"))
        vim.keymap.set( { "n" }, "<leader>lD", vim.lsp.buf.type_definition, generate_opts("LSP type_definition"))

        -- Disgnostics
        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Diagnostics open_float" })
        vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "Diagnostics goto_prev" })
        vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "Diagnostics goto_next" })
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics setloclist" })
      end)

      -- (Optional) Configure lua language server for neovim
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()
    end,
  },
  { 
    "folke/neodev.nvim" 
  },
}
