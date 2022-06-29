local M = {}
---maps the table|string of keys to the action
---@param keys table|string
---@param action string
function M.nmap(bufnr, keys, action)
  if type(keys) == 'string' then
    keys = { keys }
  end

  for _, value in ipairs(keys) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', value, action, { silent = true, noremap = true })
  end
end

--- @param  f function
--- @param  delay number
--- @return function
function M.debounce(f, delay)
  local timer = vim.loop.new_timer()

  return function(...)
    local args = { ... }

    timer:start(
      delay,
      0,
      vim.schedule_wrap(function()
        timer:stop()
        f(unpack(args))
      end)
    )
  end
end

---Determine if two deeply nested tables are deeply equal
---excluding on values indexed by "keys"
---@param a table
---@param b table
---@param keys table 
function M.table_deep_eq_exclude_keys(a, b, keys)
  if type(a) ~= type(b) then
    return false
  elseif type(a) == "table" then
    for key, _ in pairs(a) do
      if vim.tbl_contains(keys, key) then goto continue end
      if not M.table_deep_eq_exclude_keys(a[key], b[key], keys) then 
        return false
      end
      ::continue::
    end
  else
    return a == b
  end

  return true
end

return M
