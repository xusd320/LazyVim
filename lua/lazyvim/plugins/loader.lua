-- Plugin loader for mini.deps
-- This replaces the lazy.nvim automatic loading system

local M = {}

--- Load all LazyVim plugins using mini.deps
function M.load_all()
  -- Core plugins
  require("lazyvim.plugins.colorscheme")
  require("lazyvim.plugins.coding")
  
  -- Additional core plugins would be loaded here
  -- Note: Each plugin file needs to be converted to mini.deps format
  -- TODO: Convert remaining core plugin files:
  -- - require("lazyvim.plugins.editor")
  -- - require("lazyvim.plugins.ui") 
  -- - require("lazyvim.plugins.lsp")
  -- - require("lazyvim.plugins.treesitter")
  -- - require("lazyvim.plugins.formatting")
  -- - require("lazyvim.plugins.linting")
  -- - require("lazyvim.plugins.util")
  
  -- Load user plugins from config/plugins/ if they exist
  M.load_user_plugins()
end

--- Load user plugins directory
function M.load_user_plugins()
  local config_path = vim.fn.stdpath("config")
  local plugins_path = config_path .. "/lua/plugins"
  
  if vim.fn.isdirectory(plugins_path) == 1 then
    -- Get all lua files in plugins directory
    local files = vim.fn.glob(plugins_path .. "/*.lua", false, true)
    for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ":t:r")
      local ok, _ = pcall(require, "plugins." .. name)
      if not ok then
        vim.notify("Failed to load plugin file: " .. name, vim.log.levels.WARN)
      end
    end
  end
end

--- Load extras based on lazyvim.json configuration
function M.load_extras()
  if not LazyVim.config.json.loaded then
    return
  end
  
  for _, extra in ipairs(LazyVim.config.json.data.extras or {}) do
    local ok, _ = pcall(require, "lazyvim.plugins.extras." .. extra)
    if not ok then
      vim.notify("Failed to load extra: " .. extra, vim.log.levels.WARN)
    end
  end
end

return M