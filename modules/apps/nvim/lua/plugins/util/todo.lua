return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  config = true,
  opts = {
    keywords = {
      TODO = { icon = " ", color = "info", alt = { "todoi", "todom" } },
      WARN = { icon = "! ", color = "warning", alt = { "WARNING", "XXX", "verify", "replace"} },
    },
    highlight = {
      comments_only = false,
--      pattern = [[.*<(KEYWORDS)\s*(:|\[|{)]],
    },
    search = {
      command = "rg",
      pattern = [[\b(KEYWORDS)(:|\{|\[)]],
    },
  },
  lazy = false,
}
