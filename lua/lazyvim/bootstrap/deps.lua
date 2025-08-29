-- Bootstrap system for mini.deps
-- This replaces the lazy.nvim bootstrap functionality

local M = {}

--- Bootstrap mini.deps if not installed
function M.bootstrap()
  local path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
  if not (vim.uv or vim.loop).fs_stat(path) then
    vim.notify("Installing mini.nvim...", "info", { title = "LazyVim" })
    local repo = "https://github.com/echasnovski/mini.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, path })
    vim.cmd([[redraw]])
    vim.notify("mini.nvim installed. Please restart Neovim.", "info", { title = "LazyVim" })
  end
end

--- Setup mini.deps with LazyVim configuration
function M.setup()
  M.bootstrap()
  
  -- Add mini.nvim to runtime path
  vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim")
  
  -- Setup mini.deps
  require('mini.deps').setup({
    path = {
      package = vim.fn.stdpath('data') .. '/site/pack/deps',
      snapshot = vim.fn.stdpath('config') .. '/deps-snapshot.json',
      log = vim.fn.stdpath('state') .. '/mini-deps.log',
    },
    job = {
      n_threads = vim.loop.available_parallelism(),
      timeout = 30000, -- 30 seconds
    },
  })
  
  -- Make MiniDeps globally available
  _G.MiniDeps = MiniDeps
end

return M