local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local sorters = require("telescope.sorters")

local M = {}
local themes = {}
local files = vim.fn.stdpath("config") .. "/colors/"

for _, file in ipairs(vim.fn.readdir(files)) do
	local f = vim.fn.fnamemodify(file, ":r")
	table.insert(themes, f)
end

M.settheme = function(theme)
	vim.g.currentTheme = theme
	vim.cmd("colorscheme " .. theme)
	local file = vim.fn.stdpath("config") .. "/lua/drxvim/user/options.lua"
	local lines = vim.fn.readfile(file)
	local newlines = {}
	local found = false
	for _, line in ipairs(lines) do
		if line:find("vim.g.currentTheme") then
			table.insert(newlines, 'vim.g.currentTheme = "' .. theme .. '"')
			found = true
		else
			table.insert(newlines, line)
		end
	end
	if not found then
		table.insert(newlines, 'vim.g.currentTheme = "' .. theme .. '"')
	end
	vim.fn.writefile(newlines, file)
end

local picker_opts = {
	prompt_title = "DRXVIM THEMES",
	finder = finders.new_table({ results = themes }),
	sorter = sorters.get_generic_fuzzy_sorter({}),
	attach_mappings = function(bufnr, map)
		map("i", "<CR>", function()
			M.settheme(action_state.get_selected_entry()[1])
			actions.close(bufnr)
		end)

		map("i", "<Down>", function()
			actions.move_selection_next(bufnr)
			M.settheme(action_state.get_selected_entry()[1])
		end)
		map("i", "<C-j>", function()
			actions.move_selection_next(bufnr)
			M.settheme(action_state.get_selected_entry()[1])
		end)

		map("i", "<Up>", function()
			actions.move_selection_previous(bufnr)
			M.settheme(action_state.get_selected_entry()[1])
		end)
		map("i", "<C-k>", function()
			actions.move_selection_previous(bufnr)
			M.settheme(action_state.get_selected_entry()[1])
		end)
		return true
	end,
}

M.setup = function()
	local picker = pickers.new({ layout_config = { height = 0.5, width = 0.25 } }, picker_opts)
	picker:find()
end

M.toggleTheme = function()
	local theme = themes[math.random(#themes)]
	M.settheme(theme)
end

return M
