return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
			opts.presets.inc_rename = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	{
		"folke/snacks.nvim",
		opts = {
			toggle = {},
			bigfile = {
				enabled = true,
			},
			scroll = { enabled = false },
			scope = {
				enabled = true,
				-- what buffers to attach to
				filter = function(buf)
					return vim.bo[buf].buftype == ""
						and vim.b[buf].snacks_scope ~= false
						and vim.g.snacks_scope ~= false
				end,
				-- debounce scope detection in ms
				debounce = 30,
				treesitter = {
					-- detect scope based on treesitter.
					-- falls back to indent based detection if not available
					enabled = true,
					injections = true, -- include language injections when detecting scope (useful for languages like `vue`)
					---@type string[]|{enabled?:boolean}
					blocks = {
						enabled = true, -- enable to use the following blocks
						"function_declaration",
						"function_definition",
						"method_declaration",
						"method_definition",
						"class_declaration",
						"class_definition",
						"do_statement",
						"while_statement",
						"repeat_statement",
						"if_statement",
						"for_statement",
					},
					-- these treesitter fields will be considered as blocks
					field_blocks = {
						"local_declaration",
					},
				},
				-- These keymaps will only be set if the `scope` plugin is enabled.
				-- Alternatively, you can set them manually in your config,
				-- using the `Snacks.scope.textobject` and `Snacks.scope.jump` functions.
				keys = {
					---@type table<string, snacks.scope.TextObject|{desc?:string}>
					textobject = {
						ii = {
							min_size = 2, -- minimum size of the scope
							edge = false, -- inner scope
							cursor = false,
							treesitter = { blocks = { enabled = false } },
							desc = "inner scope",
						},
						ai = {
							cursor = false,
							min_size = 2, -- minimum size of the scope
							treesitter = { blocks = { enabled = false } },
							desc = "full scope",
						},
					},
					---@type table<string, snacks.scope.Jump|{desc?:string}>
					jump = {
						["[m"] = {
							min_size = 1, -- allow single line scopes
							bottom = false,
							cursor = false,
							edge = true,
							treesitter = { blocks = { enabled = false } },
							desc = "jump to top edge of scope",
						},
						["]m"] = {
							min_size = 1, -- allow single line scopes
							bottom = true,
							cursor = false,
							edge = true,
							treesitter = { blocks = { enabled = false } },
							desc = "jump to bottom edge of scope",
						},
					},
				},
			},
		},
		keys = {
			-- Top Pickers & Explorer
			{
				"<leader>gf",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
				mode = { "n", "v" },
			},
			{
				"<leader>gb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
				mode = { "n", "v" },
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>'",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},
			{
				"<C-n>",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
			-- find
			{
				"<leader>rf",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>gC",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>vf",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>lp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
			{
				"<leader>rl",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			-- git
			{
				"<leader>vb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>vl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>vL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<leader>vs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>vS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<leader>vd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>vf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},
			-- Grep
			{
				"<leader>fiB",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>fib",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},
			-- {
			-- 	"<leader>gF",
			-- 	function()
			-- 		Snacks.picker.grep()
			-- 	end,
			-- 	desc = "Grep",
			-- },
			{
				"<leader>fP",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			-- search
			{
				'<leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>s/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>gE",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>ge",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>sI",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					Snacks.picker.loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>mm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Man Pages",
			},
			-- {
			-- 	"<leader>sp",
			-- 	function()
			-- 		Snacks.picker.lazy()
			-- 	end,
			-- 	desc = "Search for Plugin Spec",
			-- },
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>uu",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>uC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
			},
			-- LSP
			-- {
			-- 	"<leader>gd",
			-- 	function()
			-- 		Snacks.picker.lsp_definitions()
			-- 	end,
			-- 	desc = "Goto Definition",
			-- },
			-- {
			-- 	"gd",
			-- 	function()
			-- 		Snacks.picker.lsp_declarations()
			-- 	end,
			-- 	desc = "Goto Declaration",
			-- },
			-- {
			-- 	"<leader>su",
			-- 	function()
			-- 		Snacks.picker.lsp_references()
			-- 	end,
			-- 	nowait = true,
			-- 	desc = "References",
			-- },
			-- {
			-- 	"<leader>si",
			-- 	function()
			-- 		Snacks.picker.lsp_implementations()
			-- 	end,
			-- 	desc = "Goto Implementation",
			-- },
			-- {
			-- 	"<leader>gD",
			-- 	function()
			-- 		Snacks.picker.lsp_type_definitions()
			-- 	end,
			-- 	desc = "Goto T[y]pe Definition",
			-- },
			-- {
			-- 	"<leader>fs",
			-- 	function()
			-- 		Snacks.picker.lsp_symbols()
			-- 	end,
			-- 	desc = "LSP Symbols",
			-- },
			-- {
			-- 	"<leader>gs",
			-- 	function()
			-- 		Snacks.picker.lsp_workspace_symbols()
			-- 	end,
			-- 	desc = "LSP Workspace Symbols",
			-- },
			{ "<leader>fc", false },
			-- Other
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen Mode",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>sb",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>sbs",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>shn",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<leader>vB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
				mode = { "n", "v" },
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
			{
				"<leader>N",
				desc = "Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
					-- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>uzs")
					-- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uzw")
					-- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uzL")
					-- Snacks.toggle.diagnostics():map("<leader>uzd")
					-- Snacks.toggle.line_number():map("<leader>uzl")
					-- Snacks.toggle
					-- 	.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					-- 	:map("<leader>uzc")
					-- Snacks.toggle.treesitter():map("<leader>uzT")
					-- Snacks.toggle
					-- 	.option("background", { off = "light", on = "dark", name = "Dark Background" })
					-- 	:map("<leader>uzb")
					-- Snacks.toggle.inlay_hints():map("<leader>uzh")
					-- Snacks.toggle.indent():map("<leader>uzg")
					-- Snacks.toggle.dim():map("<leader>uzD")
				end,
			})
		end,
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "]e", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "[e", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	-- {
	-- 	"SmiteshP/nvim-navic",
	-- 	dependencies = { "neovim/nvim-lspconfig" },
	-- },
	{
		"b0o/incline.nvim",
		dependencies = {
			-- "SmiteshP/nvim-navic",
		},
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("catppuccin.palettes").get_palette("frappe")
			-- require("nvim-navic").setup({})
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.flamingo, guifg = colors.base },
						InclineNormalNC = { guifg = colors.lavender, guibg = colors.base },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)

					local res = {
						{ icon, guifg = color },
						{ " " },
						{ filename },
					}
					-- if props.focused then
					-- 	for _, item in ipairs(navic.get_data(props.buf) or {}) do
					-- 		table.insert(res, {
					-- 			{ " > ", group = "NavicSeparator" },
					-- 			{ item.icon, group = "NavicIcons" .. item.type },
					-- 			{ item.name, group = "NavicText" },
					-- 		})
					-- 	end
					-- end
					-- table.insert(res, " ")
					return res
				end,
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},

	-- {
	-- 	"folke/snacks.nvim",
	-- 	--@type snacks.Config
	-- 	opts = {
	-- 		dashboard = {
	-- 			preset = {
	-- 				header = [[
	--         ██████╗ ███████╗██╗   ██╗ █████╗ ███████╗██╗     ██╗███████╗███████╗
	--         ██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██║     ██║██╔════╝██╔════╝
	--         ██║  ██║█████╗  ██║   ██║███████║███████╗██║     ██║█████╗  █████╗
	--         ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══██║╚════██║██║     ██║██╔══╝  ██╔══╝
	--         ██████╔╝███████╗ ╚████╔╝ ██║  ██║███████║███████╗██║██║     ███████╗
	--         ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝     ╚══════╝
	--   ]],
	-- 			},
	-- 		},
	-- 	},
	-- },
}
