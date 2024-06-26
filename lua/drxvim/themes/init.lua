local M = {}
local hl_files = vim.fn.stdpath("config") .. "/lua/drxvim/themes/integrations"

M.getCurrentTheme = function()
	local path = "drxvim.themes.schemes." .. vim.g.currentTheme
	local theme = require(path).get_colors()
	return theme
end

M.loadTb = function(g)
	g = require("drxvim.themes.integrations." .. g)
	return g
end

M.merge_tb = function(...)
	return vim.tbl_deep_extend("force", ...)
end

M.setTrans = function(highlights)
	local glassy = require("drxvim.themes.trans")
	for key, value in pairs(glassy) do
		if highlights[key] then
			highlights[key] = M.merge_tb(highlights[key], value)
		end
	end
end

M.tableToStr = function(tb)
	local result = ""
	if vim.g.transparency then
		M.setTrans(tb)
	end
	for hlgroupName, hlgroup_vals in pairs(tb) do
		local hlname = "'" .. hlgroupName .. "',"
		local opts = ""
		for optName, optVal in pairs(hlgroup_vals) do
			local valueInStr = ((type(optVal)) == "boolean" or type(optVal) == "number") and tostring(optVal)
				or '"' .. optVal .. '"'
			opts = opts .. optName .. "=" .. valueInStr .. ","
		end
		result = result .. "vim.api.nvim_set_hl(0," .. hlname .. "{" .. opts .. "})"
	end
	return result
end

M.setTermColors = function()
	local colors = M.getCurrentTheme()
	vim.g.terminal_color_0 = colors.base01
	vim.g.terminal_color_1 = colors.base08
	vim.g.terminal_color_2 = colors.base0B
	vim.g.terminal_color_3 = colors.base0A
	vim.g.terminal_color_4 = colors.base0D
	vim.g.terminal_color_5 = colors.base0E
	vim.g.terminal_color_6 = colors.base0C
	vim.g.terminal_color_7 = colors.base05
	vim.g.terminal_color_8 = colors.base03
	vim.g.terminal_color_9 = colors.base08
	vim.g.terminal_color_10 = colors.base0B
	vim.g.terminal_color_11 = colors.base0A
	vim.g.terminal_color_12 = colors.base0D
	vim.g.terminal_color_13 = colors.base0E
	vim.g.terminal_color_14 = colors.base0C
	vim.g.terminal_color_15 = colors.base07
end

M.toCache = function(filename, tb)
	local lines = "return string.dump(function()" .. M.tableToStr(tb) .. "end, true)"
	local file = io.open(vim.g.theme_cache .. filename, "wb")
	if file then
		---@diagnostic disable-next-line: deprecated
		file:write(loadstring(lines)())
		file:close()
	end
end

M.compile = function()
	if not vim.loop.fs_stat(vim.g.theme_cache) then
		vim.fn.mkdir(vim.g.theme_cache, "p")
	end
	for _, file in ipairs(vim.fn.readdir(hl_files)) do
		local filename = vim.fn.fnamemodify(file, ":r")
		M.toCache(filename, M.loadTb(filename))
	end
end

M.load = function()
	M.compile()
	for _, file in ipairs(vim.fn.readdir(vim.g.theme_cache)) do
		dofile(vim.g.theme_cache .. file)
	end
	M.setTermColors()
end

vim.api.nvim_create_user_command("DrxThemes", function()
	vim.cmd("lua require('drxvim.themes.switch').setup()")
end, {})

vim.api.nvim_create_user_command("DrxThemesToggle", function()
	vim.cmd("lua require('drxvim.themes.switch').toggleTheme()")
end, {})

return M
