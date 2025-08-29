-- Compatibility layer to help transition from lazy.nvim to mini.deps
-- This provides some utilities to ease the migration

local M = {}

--- Convert a lazy.nvim style plugin spec to mini.deps calls
--- This is a basic conversion helper, not a complete replacement
---@param spec table The lazy.nvim plugin specification
function M.convert_plugin(spec)
  local add = MiniDeps.add
  
  if type(spec) == "string" then
    -- Simple plugin name
    add(spec)
    return
  end
  
  if type(spec) ~= "table" then
    error("Plugin spec must be a string or table")
  end
  
  local plugin_spec = {
    source = spec[1] or spec.url or spec.dir,
  }
  
  -- Convert dependencies
  if spec.dependencies then
    plugin_spec.depends = {}
    for _, dep in ipairs(spec.dependencies) do
      if type(dep) == "string" then
        table.insert(plugin_spec.depends, dep)
      elseif type(dep) == "table" and dep[1] then
        table.insert(plugin_spec.depends, dep[1])
      end
    end
  end
  
  -- Add the plugin
  add(plugin_spec)
  
  -- Handle configuration
  if spec.config then
    if type(spec.config) == "function" then
      spec.config(spec, spec.opts or {})
    else
      -- Boolean true means use defaults
      if spec.opts then
        local plugin_name = spec[1]:match("([^/]+)$")
        local ok, plugin = pcall(require, plugin_name)
        if ok and plugin.setup then
          plugin.setup(spec.opts)
        end
      end
    end
  elseif spec.opts then
    -- Auto-setup with opts
    local plugin_name = spec[1]:match("([^/]+)$")
    local ok, plugin = pcall(require, plugin_name)
    if ok and plugin.setup then
      plugin.setup(spec.opts)
    end
  end
  
  -- Handle keys (basic conversion)
  if spec.keys then
    for _, key in ipairs(spec.keys) do
      if type(key) == "table" and key[1] and key[2] then
        vim.keymap.set(key.mode or "n", key[1], key[2], {
          desc = key.desc,
          silent = key.silent ~= false,
        })
      end
    end
  end
  
  -- Handle commands (basic conversion)
  if spec.cmd then
    -- Note: This doesn't provide lazy loading, just basic setup
    -- The commands will be available after the plugin is loaded
  end
end

--- Helper to convert a list of lazy.nvim specs
---@param specs table List of plugin specifications
function M.convert_plugins(specs)
  for _, spec in ipairs(specs) do
    M.convert_plugin(spec)
  end
end

--- Provide a lazy-compatible interface for easier migration
---@param specs table Plugin specifications in lazy.nvim format
function M.setup(specs)
  local later = MiniDeps.later
  
  later(function()
    M.convert_plugins(specs)
  end)
end

--- Add some lazy.nvim-style utility functions
M.has = function(plugin)
  -- Simple check if plugin is available
  local ok, _ = pcall(require, plugin)
  return ok
end

return M