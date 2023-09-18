return {
  "lervag/vimtex",
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
  end,
}
