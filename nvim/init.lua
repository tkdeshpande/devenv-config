vim.opt.number = true -- line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- spaces, not tabs
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.cmd.colorscheme("wildcharm")
vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Mason: installs & manages LSP servers
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "ts_ls", "pyright" },
			automatic_installation = true,
		},
	},

	-- Neovim Lua API completions
	{
		"folke/lazydev.nvim",
		dependencies = { "Bilal2453/luvit-meta" },
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Core LSP config
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			for _, server in ipairs({ "lua_ls", "ts_ls", "pyright" }) do
				vim.lsp.config(server, { capabilities = capabilities })
			end
			vim.lsp.enable({ "lua_ls", "ts_ls", "pyright" })
		end,
	},

	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "javascript", "typescript", "python", "markdown", "markdown_inline" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Markdown rendering
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown" },
		config = true,
	},

	-- Markdown list continuation and checkbox toggling
	{
		"bullets-vim/bullets.vim",
		ft = { "markdown" },
	},

	-- Markdown bold, italic, code, strikethrough keymaps
	{
		"antonk52/markdowny.nvim",
		ft = { "markdown" },
		config = true,
	},

	-- Autocomplete engine
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "v0.*",
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			signature = { enabled = true },
		},
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					--	python = { "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true, -- use LSP if no formatter defined
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP servers
					"lua_ls",
					"pyright",
					"ts_ls",
					-- Formatters
					"stylua",
					--					"black",
					"prettier",
				},
				auto_update = true,
			})
		end,
	},

	-- Debug Adapter Protocol (DAP): JS/TS, Python, C++, Rust, Go, Shell
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
			"theHamsta/nvim-dap-virtual-text",
			{ "jay-babu/mason-nvim-dap.nvim", dependencies = { "williamboman/mason.nvim" } },
			"mfussenegger/nvim-dap-python",
			"leoluz/nvim-dap-go",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local mason_root = vim.fn.stdpath("data") .. "/mason/packages"

			-- Mason: only used to install the debug adapter binaries below.
			-- Adapters/configurations are wired up manually for predictable paths.
			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "delve", "codelldb", "bash", "js" },
				automatic_installation = true,
			})

			-- Python (debugpy)
			require("dap-python").setup(mason_root .. "/debugpy/venv/bin/python")

			-- Go (delve) - mason puts dlv on PATH automatically
			require("dap-go").setup()

			-- C, C++, Rust (codelldb)
			local codelldb_root = mason_root .. "/codelldb/extension"
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_root .. "/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}
			for _, lang in ipairs({ "c", "cpp", "rust" }) do
				dap.configurations[lang] = {
					{
						name = "Launch",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				}
			end

			-- Shell scripts (bashdb via bash-debug-adapter)
			local bashdb_root = mason_root .. "/bash-debug-adapter"
			dap.adapters.bashdb = {
				type = "executable",
				command = bashdb_root .. "/bash-debug-adapter",
				name = "bashdb",
			}
			dap.configurations.sh = {
				{
					type = "bashdb",
					request = "launch",
					name = "Launch file",
					showDebugOutput = true,
					pathBashdb = bashdb_root .. "/extension/bashdb_dir/bashdb",
					pathBashdbLib = bashdb_root .. "/extension/bashdb_dir",
					trace = true,
					file = "${file}",
					program = "${file}",
					cwd = "${workspaceFolder}",
					pathCat = "cat",
					pathBash = "/bin/bash",
					pathMkfifo = "mkfifo",
					pathPkill = "pkill",
					args = {},
					env = {},
					terminalKind = "integrated",
				},
			}

			-- JavaScript / TypeScript (js-debug-adapter, installed by Mason - no manual build needed)
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { mason_root .. "/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
				},
			}
			for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
				dap.configurations[lang] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end

			-- UI
			dapui.setup()
			require("nvim-dap-virtual-text").setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Keymaps
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
		end,
	},
})
