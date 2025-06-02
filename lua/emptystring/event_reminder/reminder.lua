local M = {}

local config = require('emptystring.event_reminder.config')
local ui = require('emptystring.event_reminder.ui')

-- Store reminders in memory
M.reminders = {}
M.timer = nil

-- Save reminders to a file
local function save_reminders()
  local data_file = config.get_config().data_file
  local file = io.open(data_file, 'w')
  if file then
    file:write(vim.fn.json_encode(M.reminders))
    file:close()
  else
    vim.notify("Failed to save reminders to " .. data_file, vim.log.levels.ERROR)
  end
end

-- Load reminders from file
local function load_reminders()
  local data_file = config.get_config().data_file
  local file = io.open(data_file, 'r')
  if file then
    local content = file:read("*all")
    file:close()
    if content and content ~= "" then
      local success, result = pcall(vim.fn.json_decode, content)
      if success then
        M.reminders = result
      else
        vim.notify("Failed to parse reminders data: " .. tostring(result), vim.log.levels.ERROR)
      end
    end
  end
end

-- Check if any reminders are due
local function check_reminders()
  local now = os.time()
  local triggered_reminders = {}
  
  for idx, reminder in ipairs(M.reminders) do
    local reminder_time = reminder.time
    if reminder_time <= now and not reminder.triggered then
      table.insert(triggered_reminders, idx)
      reminder.triggered = true
    end
  end
  
  -- Show notifications for triggered reminders
  if #triggered_reminders > 0 then
    for _, idx in ipairs(triggered_reminders) do
      local reminder = M.reminders[idx]
      ui.notify_reminder(reminder)
    end
    save_reminders()
  end
end

-- Initialize the reminder system
function M.init()
  -- Create data directory if it doesn't exist
  local data_dir = vim.fn.fnamemodify(config.get_config().data_file, ":h")
  if vim.fn.isdirectory(data_dir) == 0 then
    vim.fn.mkdir(data_dir, "p")
  end

  -- Load existing reminders
  load_reminders()
  
  -- Set up timer to check for reminders
  if M.timer then
    M.timer:stop()
  end
  
  M.timer = vim.loop.new_timer()
  local check_interval = config.get_config().check_interval
  M.timer:start(1000, check_interval, vim.schedule_wrap(check_reminders))
  
  -- Also do an immediate check
  vim.schedule(check_reminders)
end

-- Parse date/time string into a timestamp
-- Supports formats like "2023-06-01 14:30" or relative times like "10m", "2h", "1d"
local function parse_time(time_str)
  -- Check for relative time format
  local amount, unit = time_str:match("^(%d+)([mhdwMy])$")
  if amount and unit then
    amount = tonumber(amount)
    local now = os.time()
    
    if unit == "m" then
      return now + amount * 60  -- minutes
    elseif unit == "h" then
      return now + amount * 3600  -- hours
    elseif unit == "d" then
      return now + amount * 86400  -- days
    elseif unit == "w" then
      return now + amount * 604800  -- weeks
    elseif unit == "M" then
      -- Approximate a month as 30 days
      return now + amount * 2592000  -- months
    elseif unit == "y" then
      return now + amount * 31536000  -- years
    end
  end
  
  -- Try format YYYY-MM-DD HH:MM
  local year, month, day, hour, min = time_str:match("(%d%d%d%d)-(%d%d?)-(%d%d?) (%d%d?):(%d%d)")
  if year and month and day and hour and min then
    return os.time({
      year = tonumber(year),
      month = tonumber(month),
      day = tonumber(day),
      hour = tonumber(hour),
      min = tonumber(min),
      sec = 0
    })
  end
  
  -- If all parsing attempts fail
  return nil
end

-- Add a new reminder
-- Format: add_reminder("Title", "2023-06-01 14:30", "Optional description")
-- Or: add_reminder("Title", "30m", "Reminder in 30 minutes")
function M.add_reminder(...)
  local args = {...}
  if #args == 0 then
    vim.notify("Usage: EventReminderAdd title time [description]", vim.log.levels.ERROR)
    return
  end
  
  if type(args[1]) == "string" and args[1]:find(" ") then
    args = vim.split(args[1], " ", { plain = false, trimempty = true })
  end
  
  if #args < 2 then
    vim.notify("Usage: EventReminderAdd title time [description]", vim.log.levels.ERROR)
    return
  end
  
  local title = args[1]
  local time_str = args[2]
  local description = args[3] or ""
  
  local time = parse_time(time_str)
  if not time then
    vim.notify("Invalid time format. Use 'YYYY-MM-DD HH:MM' or relative format like '10m', '2h', '1d'", vim.log.levels.ERROR)
    return
  end
  
  -- Create reminder
  local reminder = {
    id = vim.fn.strftime("%Y%m%d%H%M%S") .. "_" .. math.random(1000, 9999),
    title = title,
    time = time,
    description = description,
    triggered = false,
    created_at = os.time(),
  }
  
  -- Add to table and save
  table.insert(M.reminders, reminder)
  save_reminders()
  
  -- Notify user
  local time_display = os.date("%Y-%m-%d %H:%M", time)
  vim.notify("Reminder added: " .. title .. " at " .. time_display, vim.log.levels.INFO)
  
  return reminder.id
end

-- Delete a reminder
function M.delete_reminder(id_or_index)
  if not id_or_index or id_or_index == "" then
    -- If called with no arguments, show UI for deletion
    ui.delete_reminder_ui()
    return
  end
  
  local index = tonumber(id_or_index)
  if index then
    -- Delete by index
    if index > 0 and index <= #M.reminders then
      local reminder = table.remove(M.reminders, index)
      save_reminders()
      vim.notify("Deleted reminder: " .. reminder.title, vim.log.levels.INFO)
    else
      vim.notify("Invalid reminder index", vim.log.levels.ERROR)
    end
  else
    -- Delete by ID
    for i, reminder in ipairs(M.reminders) do
      if reminder.id == id_or_index then
        table.remove(M.reminders, i)
        save_reminders()
        vim.notify("Deleted reminder: " .. reminder.title, vim.log.levels.INFO)
        return
      end
    end
    vim.notify("Reminder not found with ID: " .. id_or_index, vim.log.levels.ERROR)
  end
end

-- Get all reminders
function M.get_reminders()
  return M.reminders
end

return M
