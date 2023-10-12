return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "./out",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-shell-escape",
          "-interaction=nonstopmode",
          "-outdir=out",
        },
      }
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_general_viewer = "zathura"
      vim.g.vimtex_view_skim_reading_bar = true
      vim.g.vimtex_view_skim_activate = true
      vim.g.vimtex_view_skim_sync = true
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
  },
}
