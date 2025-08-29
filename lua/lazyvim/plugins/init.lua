if vim.fn.has("nvim-0.9.0") == 0 then
  vim.api.nvim_echo({
    { "LazyVim requires Neovim >= 0.9.0\n", "ErrorMsg" },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd([[quit]])
  return
end

-- Bootstrap and setup mini.deps
require("lazyvim.bootstrap.deps").setup()

-- Initialize LazyVim configuration
require("lazyvim.config").init()

-- Core plugin setup using mini.deps
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  -- Essential plugins that need to be loaded immediately
  add("echasnovski/mini.nvim")
  
  -- Core LazyVim functionality (this repository)
  -- Note: For local development, this would be handled differently
  -- add("LazyVim/LazyVim")
end)

now(function()
  -- Snacks.nvim for essential UI components
  add("folke/snacks.nvim")
  local notify = vim.notify
  require("snacks").setup({})
  -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
  -- this is needed to have early notifications show up in noice history
  if LazyVim.has("noice.nvim") then
    vim.notify = notify
  end
end)

-- Load all plugins after the VeryLazy event
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("LazyVimPlugins", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    -- Load all LazyVim plugins
    require("lazyvim.plugins.loader").load_all()
    
    -- Load extras based on configuration
    require("lazyvim.plugins.loader").load_extras()
  end,
})
