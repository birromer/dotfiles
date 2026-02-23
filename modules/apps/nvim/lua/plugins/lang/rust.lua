return {
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = { enabled = true },
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = { "rust" },
		opts = {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<leader>cR", function()
						vim.cmd.RustLsp("codeAction")
					end, { desc = "Code Action", buffer = bufnr })
					vim.keymap.set("n", "<leader>dr", function()
						vim.cmd.RustLsp("debuggables")
					end, { desc = "Rust Debuggables", buffer = bufnr })
				end,
        default_settings = {
        	["rust-analyzer"] = {
        		cargo = {
        			allFeatures = true,
        			loadOutDirsFromCheck = true,
        			buildScripts = {
        				enable = true,
        			},
        		},
        		checkOnSave = true,
        		check = {
        			allFeatures = true,
        			command = "clippy",
        			extraArgs = { "--no-deps" },
        		},
        		procMacro = {
        			enable = true,
        			ignored = {
        				["async-trait"] = { "async_trait" },
        				["napi-derive"] = { "napi" },
        				["async-recursion"] = { "async_recursion" },
        			},
        		},
        	},
        },
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		end,
	},
}
