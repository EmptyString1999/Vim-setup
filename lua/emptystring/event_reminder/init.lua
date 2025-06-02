local M = {}

-- Import the other modules
local reminder = require('emptystring.event_reminder.reminder')
local ui = require('emptystring.event_reminder.ui')
local config = require('emptystring.event_reminder.config')

-- Setup function to initialize the plugin
function M.setup(opts)
  -- Merge user config with default config
  config.setup(opts)
  
  -- Initialize the reminder system
  reminder.init()
  
  -- Set up commands
  vim.api.nvim_create_user_command('EventReminderAdd', function(args)
    reminder.add_reminder(args.args)
  end, { nargs = '+', desc = 'Add a new event reminder' })
  
  vim.api.nvim_create_user_command('EventReminderList', function()
    ui.show_reminders()
  end, { desc = 'List all event reminders' })
  
  vim.api.nvim_create_user_command('EventReminderDelete', function(args)
    reminder.delete_reminder(args.args)
  end, { nargs = '?', desc = 'Delete an event reminder' })
  
  -- Return the module for chaining
  return M
end

-- Expose key functions
M.add_reminder = reminder.add_reminder
M.delete_reminder = reminder.delete_reminder
M.show_reminders = ui.show_reminders

return M
