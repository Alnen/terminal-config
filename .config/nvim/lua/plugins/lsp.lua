return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"bash-language-server",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
				"bash-language-server",
			})
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
			---@type lspconfig.options
			servers = {
				cssls = {},
				tailwindcss = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				tsserver = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				html = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					-- enabled = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									-- "--log-level=trace",
								},
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
			},
			setup = {},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local Keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(Keys, {
				{ "gd", false },
				{ "gr", false },
				{ "gI", false },
				{ "gy", false },
				{ "<leader>ss", false },
				{ "<leader>sS", false },
				{
					"<leader>gd",
					function()
						Snacks.picker.lsp_definitions()
					end,
					desc = "Goto Definition",
					has = "definition",
				},
				{
					"<leader>su",
					function()
						Snacks.picker.lsp_references()
					end,
					nowait = true,
					desc = "References",
				},
				{
					"<leader>gi",
					function()
						Snacks.picker.lsp_implementations()
					end,
					desc = "Goto Implementation",
				},
				{
					"<leader>gy",
					function()
						Snacks.picker.lsp_type_definitions()
					end,
					desc = "Goto T[y]pe Definition",
				},
				{
					"<leader>fs",
					function()
						Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter })
					end,
					desc = "LSP Symbols",
					has = "documentSymbol",
				},
				{
					"<leader>fS",
					function()
						Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter })
					end,
					desc = "LSP Workspace Symbols",
					has = "workspace/symbols",
				},
				--#region
				{ "<leader>cl", false },
				{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
				{ "gr", vim.lsp.buf.references, desc = "References", nowait = true },
				{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
				{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
				{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
				{ "K", false },
				{ "gK", false },
				{ "<c-k>", false },
				{ "<leader>ca", false },
				{ "<leader>cc", false },
				{ "<leader>cC", false },
				{ "<leader>cR", false },
				{ "<leader>cr", false },
				{ "<leader>cA", false },
				{ "]]", false },
				{ "[[", false },
				{ "<a-n>", false },
				{ "<a-p>", false },
				{
					"<leader>qL",
					function()
						Snacks.picker.lsp_config()
					end,
					desc = "Lsp Info",
				},
				{
					"gH",
					function()
						return vim.lsp.buf.hover()
					end,
					desc = "Hover",
				},
				{
					"<leader>gp",
					function()
						return vim.lsp.buf.signature_help()
					end,
					desc = "Signature Help",
					has = "signatureHelp",
				},
				{
					"<c-p>",
					function()
						return vim.lsp.buf.signature_help()
					end,
					mode = "i",
					desc = "Signature Help",
					has = "signatureHelp",
				},
				{
					"<leader>qf",
					vim.lsp.buf.code_action,
					desc = "Code Action",
					mode = { "n", "v" },
					has = "codeAction",
				},
				{
					"<leader>qc",
					vim.lsp.codelens.run,
					desc = "Run Codelens",
					mode = { "n", "v" },
					has = "codeLens",
				},
				{
					"<leader>qC",
					vim.lsp.codelens.refresh,
					desc = "Refresh & Display Codelens",
					mode = { "n" },
					has = "codeLens",
				},
				{
					"<leader>qR",
					function()
						Snacks.rename.rename_file()
					end,
					desc = "Rename File",
					mode = { "n" },
					has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
				},
				{ "<leader>qr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
				{ "<leader>qF", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
				-- { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
				--   desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
				-- { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
				--   desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
				-- { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
				--   desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
				-- { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
				--   desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
				-- })
				--l
				--
			})
		end,
	},
}
