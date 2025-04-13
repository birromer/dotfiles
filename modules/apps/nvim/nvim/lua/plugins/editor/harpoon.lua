return {
  "ThePrimeagen/harpoon",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon").setup({
      global_settings = {
        enter_on_sendcmd = true,
      },
    })
  end,
}
