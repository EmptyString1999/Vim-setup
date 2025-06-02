local M = {}

local config = require('emptystring.event_reminder.config')

-- Dependencies check
local has_notify = pcall(require, "notify")

-- Function to display a reminder notification
function M.notify_reminder(reminder)
  local title = reminder.title
  local description = reminder.description or ""
  local message = description ~= "" and (title .. "\n" .. description) or title
  
  if has_notify then
    -- Use nvim-notify if available
    local notify = require("notify")
    notify(message, "info", {
      title = "Event Reminder",
      timeout = 10000,
      icon = "⏰",
    })
  else
    -- Fallback to vim.notify
    vim.notify("Event Reminder: " .. message, vim.log.levels.INFO)
  end
end

-- Show floating window with all reminders
function M.show_reminders()
  local reminders = require('emptystring.event_reminder.reminder').get_reminders()
  
  if #reminders == 0 then
    vim.notify("No reminders set", vim.log.levels.INFO)
    return
  end
  
  local lines = {"Reminders:", ""}
  
  for idx, reminder in ipairs(reminders) do
    local time_display = os.date("%Y-%m-%d %H:%M", reminder.time)
    local status = reminder.triggered and "[✓]" or "[ ]"
    local title_line = string.format("%d. %s %s - %s", idx, status, time_display, reminder.title)
    table.insert(lines, title_line)
    
    if reminder.description and reminder.description ~= "" then
      table.insert(lines, "   " .. reminder.description)
      table.insert(lines, "")
    else
      table.insert(lines, "")
    end
  end
  
  -- Create a floating window
  local width = 60
  local height = #lines
  local buf = vim.api.nvim_create_buf(false, true)
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  
  local ui = vim.api.nvim_list_uis()[1]
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = (ui.width - width) / 2,
    row = (ui.height - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " Event Reminders ",
    title_pos = "center",
  }
  
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  
  -- Add mappings for the window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
  
  return win
end

-- UI for deleting a reminder
function M.delete_reminder_ui()
  local reminder_mod = require('emptystring.event_reminder.reminder')
  local reminders = reminder_mod.get_reminders()
  
  if #reminders == 0 then
    vim.notify("No reminders to delete", vim.log.levels.INFO)
    return
  end
  
  local items = {}
  for idx, reminder in ipairs(reminders) do
    local time_display = os.date("%Y-%m-%d %H:%M", reminder.time)
    local status = reminder.triggered and "[✓]" or "[ ]"
    local display = string.format("%s %s - %s", status, time_display, reminder.title)
    table.insert(items, { idx = idx, display = display })
  end
  
  -- Check if telescope is available
  local has_telescope, telescope = pcall(require, "telescope.builtin")
  if has_telescope then
    -- Use telescope for selection
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    
    pickers.new({}, {
      prompt_title = "Select reminder to delete",
      finder = finders.new_table({
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.display,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          reminder_mod.delete_reminder(selection.value.idx)
        end)
        return true
      end,
    }):find()
  else
    -- Fallback to simpler UI if telescope is not available
    local lines = {}
    for _, item in ipairs(items) do
      table.insert(lines, string.format("%d. %s", item.idx, item.display))
    end
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    
    local ui = vim.api.nvim_list_uis()[1]
    local width = 60
    local height = #lines + 1
    
    local win_opts = {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = "minimal",
      border = "rounded",
      title = " Delete Reminder ",
      title_pos = "center",
    }
    
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    
    -- Make it a prompt buffer
    vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
    vim.fn.prompt_setprompt(buf, "Enter number to delete: ")
    
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = buf,
      callback = function()
        vim.api.nvim_win_close(win, true)
      end,
      once = true,
    })
    
    -- Start insert mode
    vim.cmd("startinsert!")
    
    -- Handle deletion on <CR>
    vim.keymap.set("i", "<CR>", function()
      local input = vim.fn.getline("."):sub(#"Enter number to delete: " + 1)
      vim.api.nvim_win_close(win, true)
      
      local idx = tonumber(input)
      if idx and idx > 0 and idx <= #reminders then
        reminder_mod.delete_reminder(idx)
      else
        vim.notify("Invalid reminder number", vim.log.levels.ERROR)
      end
      
      return "<Esc>"
    end, { buffer = buf, expr = true })
  end
end

return M
