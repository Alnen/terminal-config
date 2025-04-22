return {
	{
		"alexghergh/nvim-tmux-navigation",
		-- config = function()
		-- 	local nvim_tmux_nav = require("nvim-tmux-navigation")
		--
		-- 	nvim_tmux_nav.setup({
		-- 		-- disable_when_zoomed = true, -- defaults to false
		-- 	})
		--
		-- 	-- vim.keymap.set("n", "sth", nvim_tmux_nav.NvimTmuxNavigateLeft)
		-- 	-- vim.keymap.set("n", "stj", nvim_tmux_nav.NvimTmuxNavigateDown)
		-- 	-- vim.keymap.set("n", "stk", nvim_tmux_nav.NvimTmuxNavigateUp)
		-- 	-- vim.keymap.set("n", "stl", nvim_tmux_nav.NvimTmuxNavigateRight)
		-- 	-- vim.keymap.set("n", "st\\", nvim_tmux_nav.NvimTmuxNavigateLastActive)
		-- 	-- vim.keymap.set("n", "st<leader>", nvim_tmux_nav.NvimTmuxNavigateNext)
		-- end;
		config = true,
		keys = {
			{
				"<M-h>",
				"<Cmd>NvimTmuxNavigateLeft<cr>",
				desc = "Navigate left",
			},
			{
				"<M-j>",
				"<Cmd>NvimTmuxNavigateDown<cr>",
				desc = "Navigate down",
			},
			{
				"<M-k>",
				"<Cmd>NvimTmuxNavigateUp<cr>",
				desc = "Navigate up",
			},
			{
				"<M-l>",
				"<Cmd>NvimTmuxNavigateRight<cr>",
				desc = "Navigate right",
			},
		},
	},
}
