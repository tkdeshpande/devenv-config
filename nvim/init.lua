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
})
