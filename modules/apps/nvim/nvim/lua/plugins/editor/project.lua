return {
  "ahmedkhalf/project.nvim",
  opts = { manual_mode = true, },
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup {}
  end,
}
