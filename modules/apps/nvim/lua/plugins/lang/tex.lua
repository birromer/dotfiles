return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_progname = "nvr"

      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        aux_dir = "build",
        out_dir = "build",
        options = {
          "-file-line-error",
          "-synctex=1",
          "-shell-escape",
          "-verbose",
          "-interaction=nonstopmode",
          "-auxdir=build",
          "-outdir=build",
        },
      }

      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_general_viewer = "sioyek"

      vim.g.vimtex_view_skim_reading_bar = 1
      vim.g.vimtex_view_skim_activate = 0
      vim.g.vimtex_view_skim_sync = 0
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_toc_config = { split_pos = ":vert :botright" }

      -- vim.g.vimtex_view_sioyek_options = string.format(
      --   '--reuse-window --inverse-search="nvr --servername %s +%%2 %%1" --forward-search-file @tex --forward-search-line @line @pdf',
      --   vim.v.servername
      -- )

      vim.g.vimtex_view_reverse_search_edit_cmd = "split"
      vim.g.vimtex_fold_manual = true

      vim.g.vimtex_view_automatic = false
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
  },
}
