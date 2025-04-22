return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		-- opts = {},
		config = function()
			require("refactoring").setup({
				prompt_func_return_type = {
					go = false,
					java = false,

					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				prompt_func_param_type = {
					go = false,
					java = false,

					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				printf_statements = {},
				print_var_statements = {},
				show_success_message = true, -- shows a message with information about the refactor on success
				-- i.e. [Refactor] Inlined 3 variable occurrences
			})

			vim.keymap.set("x", "<leader>ee", ":Refactor extract ")
			vim.keymap.set("x", "<leader>ef", ":Refactor extract_to_file ")

			vim.keymap.set("x", "<leader>ev", ":Refactor extract_var ")
			vim.keymap.set("x", "<leader>ec", ":Refactor extract_var ")

			vim.keymap.set({ "n", "x" }, "<leader>ei", ":Refactor inline_var")
			vim.keymap.set("n", "<leader>eI", ":Refactor inline_func")

			vim.keymap.set("n", "<leader>em", ":Refactor extract_block")
			vim.keymap.set("n", "<leader>emf", ":Refactor extract_block_to_file")
		end,
	},
}
