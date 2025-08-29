#!/usr/bin/env -S nvim -l

vim.env.LAZY_STDPATH = ".tests"

-- Bootstrap mini.deps instead of lazy.nvim
local bootstrap_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not (vim.uv or vim.loop).fs_stat(bootstrap_path) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim.git",
    bootstrap_path
  })
end
vim.opt.rtp:prepend(bootstrap_path)

-- Setup mini.deps
require('mini.deps').setup({
  path = {
    package = vim.fn.stdpath('data') .. '/site/pack/deps',
  }
})

-- Test setup using mini.deps
local add = MiniDeps.add

add({ source = vim.uv.cwd() }) -- Current LazyVim repository
add("LazyVim/starter")
add("nvim-treesitter/nvim-treesitter")
add("mason-org/mason-lspconfig.nvim")
add("mason-org/mason.nvim")
add("echasnovski/mini.icons")
