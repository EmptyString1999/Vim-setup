local function open_url(url)
    local os_name = vim.loop.os_uname().sysname  -- Renamed variable
    local cmd
    
    if os_name == 'Linux' then
        cmd = 'xdg-open "' .. url .. '"'
    elseif os_name == 'Darwin' then
        cmd = 'open "' .. url .. '"'
    elseif os_name == 'Windows_NT' then
        cmd = 'start "" "' .. url .. '"'
    else
        vim.notify('Unsupported OS', vim.log.levels.WARN)
        return
    end

    vim.fn.jobstart(cmd, { detach = true })  -- Better Neovim API for commands
end

local function get_header()
	local header_path = debug.getinfo(1, "S").source:sub(2)
      header_path = vim.fn.fnamemodify(header_path, ":p:h") .. "/dashboard_header.txt"
      
      local file = io.open(header_path, "r")
      if not file then return {} end
      
      local header = {}
      for line in file:lines() do
        table.insert(header, (line:gsub("\\", "\\\\"):gsub("'", "\\'")))
      end
      file:close()
      
      return header
    end


return {
	'nvimdev/dashboard-nvim',
	enabled = false,
	event = 'VimEnter',
	config = function()
	require('dashboard').setup {
		-- config
		theme = 'hyper',
		config = {
			header = get_header(),
			shortcut = {
					{desc = 'Github', group = 'DashboardSocial', action = function() open_url('https://github.com/EmptyString1999') end, key = 'g' },
			},
		}
	}
	-- custom header colors
	vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#52ddf2', bg = 'NONE', bold = true })
end,
	dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
