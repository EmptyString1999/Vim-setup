local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
-- local vars
local gls = gl.section

-- First configure the theme/colors
gl.colorscheme = 'witch'  -- Use a valid colorscheme name you have installed

-- Define colors for the theme
local colors = {
	bg = "#161f31",
	bg_dark = "#121928",
	bg_bar = "#0d1829",
	bg_visual = "#253557",
	bg_highlight = "#1f2b49",
	bg_gutter = "#1b305d",

	fg = "#c9d8ee",
	fg_dark = "#a9bad6",

	yellow = "#f0a421",
	yellow1 = "#e6cc4c",
	bright_yellow = "#ffc021",

	red = "#dc4154",
	red1 = "#ff5874",
	red2 = "#ee4c96",

	cyan = "#7dcfff",
	cyan1 = "#75c8cc",

	black = "#000000",
	white = "#ffffff",

	green = "#5bcf75",

	orange = "#f99635",
	orange1 = "#f78c6c",
	orange2 = "#f78782",
	light_orange = "#ffd59d",

	blue = "#50bcef",
	blue1 = "#629df2",
	blue2 = "#698ff1",

	link = "#90d2fa",

	teal = "#5cd0a0",

	gray = "#596683",
	graphite = "#738eaf",
	light_gray = "#64739a",

	pink = "#f36cde",
	pink1 = "#e95cc2",

	purple = "#b278ea",

	brown = "#c17e70",

	magenta = "#da87ea",
	magenta1 = "#ff3483",

	border = "#3d88c4",
	dark_border = "#37518d",
	graphite_border = "#465968",

	comment = "#6675ae",
	string = "#ffd39b",
	operator = "#7bc0cc",

	error = "#e64152",
	info = "#59d1f2",
	warn = "#ffcb44",
	hint = "#1abc9c",
	todo = "#f78c6c",
	unnecessary = "#375172",

	term_green = "#4ad860",
}

local mode_colors = {
	n = colors.green,  -- Normal mode background
	i = colors.blue,   -- Insert mode background
	v = colors.purple, -- Visual mode background
	V = colors.purple,
	[''] = colors.purple,
	R = colors.red,
	c = colors.orange,
}

local alias = {
	n = 'NORMAL',
	i = 'INSERT',
	c = 'COMMAND',
	V = 'VISUAL',
	[''] = 'V-BLOCK',
	v = 'VISUAL',
	R = 'REPLACE'
}


-- ======================================= Left section ========================================
gls.left[1] = {
    ViMode = {
        provider = function()
            local reg_recording = vim.fn.reg_recording()
            if reg_recording ~= '' then
                return '  RECORDING @' .. reg_recording .. ' '
            end
            
            local mode = vim.fn.mode()
            return '  ' .. (alias[mode] or mode) .. ' '
        end,
        highlight = function()
			local recording = vim.fn.reg_recording()
            if recording ~= '' then
                return { colors.bg, colors.red }
            end
            local mode = vim.fn.mode()
            return { colors.bg, mode_colors[mode] or colors.fg }
        end,
        separator = '',
        separator_highlight = function()
            if vim.fn.reg_recording() ~= '' then
                return { colors.red, colors.bg }
            end
            local mode = vim.fn.mode()
            return { mode_colors[mode] or colors.fg, colors.bg }
        end,
    }
}
-- ========================================= Mid section ========================================
-- Left separator
gls.mid[1] = {
	LeftMidLeftSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.cyan, colors.bg },
	}
}
-- file name
gls.mid[2] = {
	LineColumn = {
		provider = function()
			return fileinfo.line_column()
		end,
		highlight = { colors.bg, colors.cyan},
	}
}
-- Right separator
gls.mid[3] = {
	RightMidRightSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.cyan, colors.bg },
	}
}

-- Left separator
gls.mid[4] = {
	LeftMidSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.cyan, colors.bg },
	}
}
-- filetype icon
gls.mid[5] = {
	FileType = {
		provider = function()
			local ft_icon = require("nvim-web-devicons").get_icon(
				vim.fn.expand("%:t"),  -- filename
				vim.bo.filetype,       -- filetype
				{ default = true }      -- fallback to default icon
			) or " "  -- double fallback if no icon found

			return ' ' .. ft_icon .. ' '
		end,
		highlight = { colors.bg, colors.cyan },
		separator = ' ',
		separator_highlight = { colors.cyan, colors.bg }
	}
}
-- file name
gls.mid[6] = {
	FileName = {
		provider = function()
			return fileinfo.get_current_file_name()
		end,
		highlight = { colors.bg, colors.cyan},
	}
}
-- Right separator
gls.mid[7] = {
	RightMidSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.cyan, colors.bg },
	}
}
gls.mid[8] = {
	LeftMidTwoSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.cyan, colors.bg },
	}
}
gls.mid[9] = {
	FileSize = {
		provider = function()
			local file = vim.fn.expand('%:p')
			if file == '' or vim.fn.getfsize(file) <= 0 then return '' end

			local size = vim.fn.getfsize(file)
			-- Convert bytes to KB/MB
			if size > 1024 * 1024 then
				return string.format(' %.2f MB ', size / 1024 / 1024)
			end
			return string.format(' %.2f KB ', size / 1024)
		end,
		condition = condition.buffer_not_empty,
		highlight = { colors.bg, colors.cyan},
	}
}	gls.mid[10] = {
	RightMidTwoSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.cyan, colors.bg },
	}
}
-- ======================================= Right section ========================================
gls.right[1] = {
	LeftRightSeparator = {
		provider = function()
			return ''
		end,
		highlight = { colors.purple, colors.bg },
	}
}
gls.right[2] = {
	GitIcon = {
		provider = function()
			return ' '
		end,
		condition = condition.check_git_workspace,
		highlight = { colors.bg, colors.purple},
	}
}
gls.right[3] = {
	GitBranch = {
		provider = vcs.get_git_branch,
		condition = condition.check_git_workspace,
		highlight = { colors.bg, colors.purple},
	}
}

-- Initialize Galaxyline (IMPORTANT!)
gl.load_galaxyline()

-- ======================================= Hide default UI elements ========================================
-- Hide default UI elements
vim.opt.laststatus = 3
vim.opt.statusline = " "
vim.opt.winbar = " "
vim.opt.showmode = false
vim.opt.cmdheight = 0
