lua << EOF

-------------
-- Nvim-qt --
-------------


if vim.g.GuiLoaded then
	local font_name = "JetBrains Mono NF"
	local font_size = 10
	local not_transparent = false

	local function toggle_transparency()
		not_transparent = not not_transparent
		if not_transparent then
			vim.cmd("GuiWindowOpacity " .. (0.9))
		else
			vim.cmd("GuiWindowOpacity " .. (1.0))
		end
	end

	vim.keymap.set("n", "<F10>", toggle_transparency, { silent = true })

	local function toggle_fullscreen()
		if vim.g.GuiWindowFullScreen == 0 then
			vim.cmd("call GuiWindowFullScreen(" .. 1 .. ")")
		else
			vim.cmd("call GuiWindowFullScreen(" .. 0 .. ")")
		end
	end

	vim.keymap.set("n", "<F11>", toggle_fullscreen, { silent = true })

	vim.cmd [[
	GuiTabline 0
	GuiPopupmenu 0
	]]
	vim.cmd("GuiFont! " .. font_name .. ":h" .. font_size)
end

-------------
-- Neovide --
-------------

if vim.g.neovide then
	vim.opt.guifont = "JetBrainsMono Nerd Font:h8.0"
	vim.opt.linespace = 8
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_cursor_animation_length = 0.2
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_animate_in_insert_mode = true
	vim.g.neovide_cursor_animate_command_line = true
	vim.g.neovide_cursor_vfx_mode = "ripple"
	vim.g.remember_window_size = true
	vim.g.remember_window_position = true
	vim.g.neovide_padding_top = 2
	vim.g.neovide_padding_bottom = 2
	vim.g.neovide_padding_right = 2
	vim.g.neovide_padding_left = 2
	vim.g.neovide_confirm_quit = false

	local function toggle_transparency()
		if vim.g.neovide_transparency == 1.0 then
			vim.g.neovide_transparency = 0.8
		else
			vim.g.neovide_transparency = 1
		end
	end

	local function toggle_fullscreen()
		if vim.g.neovide_fullscreen == false then
			vim.g.neovide_fullscreen = true
		else
			vim.g.neovide_fullscreen = false
		end
	end

	vim.keymap.set("n", "<F11>", toggle_fullscreen, { silent = true })
	vim.keymap.set("n", "<F10>", toggle_transparency, { silent = true })
end



EOF
