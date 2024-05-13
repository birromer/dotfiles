return {
	"jam1015/vim-slime",
	init = function()
		-- these two should be set before the plugin loads
		vim.g.slime_target = "tmux"
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_default_config = { { "socket_name", "default" }, { "target_pane", ":1.1" } }
	end,
}
