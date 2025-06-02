local M = {}

-- Default configuration
local default_config = {
  -- How often to check for reminders (in ms)
  check_interval = 60000,  -- Every minute
  
  -- File to store reminders
  data_file = vim.fn.stdpath("data") .. "/event_reminders.json",
  
  -- Format for displaying timestamps
  time_format = "%Y-%m-%d %H:%M",
}

-- User configuration
local user_config = {}

-- Setup function to initialize config
function M.setup(opts)
  opts = opts or {}
  user_config = vim.tbl_deep_extend("force", {}, default_config, opts)
end

-- Get current config (merged with defaults)
function M.get_config()
  return user_config
end

-- Initialize with default config
M.setup({})

return M
