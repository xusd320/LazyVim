---@class lazyvim.util.plugin
local M = {}

---@type string[]
M.core_imports = {}
M.handle_defaults = true

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {
  ["lazyvim.plugins.extras.formatting.conform"] = "`conform.nvim` is now the default **LazyVim** formatter.",
  ["lazyvim.plugins.extras.linting.nvim-lint"] = "`nvim-lint` is now the default **LazyVim** linter.",
  ["lazyvim.plugins.extras.ui.dashboard"] = "`dashboard.nvim` is now the default **LazyVim** starter.",
  ["lazyvim.plugins.extras.coding.native_snippets"] = "Native snippets are now the default for **Neovim >= 0.10**",
  ["lazyvim.plugins.extras.ui.treesitter-rewrite"] = "Disabled `treesitter-rewrite` extra for now. Not ready yet.",
  ["lazyvim.plugins.extras.coding.mini-ai"] = "`mini.ai` is now a core LazyVim plugin (again)",
  ["lazyvim.plugins.extras.lazyrc"] = "local spec files are now a lazy.nvim feature",
  ["lazyvim.plugins.extras.editor.trouble-v3"] = "Trouble v3 has been merged in main",
  ["lazyvim.plugins.extras.lang.python-semshi"] = [[The python-semshi extra has been removed,
  because it's causing too many issues.
  Either use `basedpyright`, or copy the [old extra](https://github.com/LazyVim/LazyVim/blob/c1f5fcf9c7ed2659c9d5ac41b3bb8a93e0a3c6a0/lua/lazyvim/plugins/extras/lang/python-semshi.lua#L1) to your own config.
  ]],
}

M.deprecated_modules = {}

---@type table<string, string>
M.renames = {
  ["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
  ["jose-elias-alvarez/null-ls.nvim"] = "nvimtools/none-ls.nvim",
  ["null-ls.nvim"] = "none-ls.nvim",
  ["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
  ["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
  ["markdown.nvim"] = "render-markdown.nvim",
  ["williamboman/mason.nvim"] = "mason-org/mason.nvim",
  ["williamboman/mason-lspconfig.nvim"] = "mason-org/mason-lspconfig.nvim",
}

function M.save_core()
  if vim.v.vim_did_enter == 1 then
    return
  end
  -- Note: mini.deps doesn't have a central spec like lazy.nvim
  -- We'll track this differently if needed
  M.core_imports = {}
end

function M.setup()
  M.fix_imports()
  M.fix_renames()
  M.lazy_file()
  table.insert(package.loaders, function(module)
    if M.deprecated_modules[module] then
      LazyVim.warn(
        ("`%s` is no longer included by default in **LazyVim**.\nPlease install the `%s` extra if you still want to use it."):format(
          module,
          M.deprecated_modules[module]
        ),
        { title = "LazyVim" }
      )
      return function() end
    end
  end)
end

function M.extra_idx(name)
  -- Note: mini.deps doesn't have a central module tracking system like lazy.nvim
  -- This function may need to be reimplemented or removed
  return nil
end

function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.fix_imports()
  -- Note: mini.deps doesn't use the same import system as lazy.nvim
  -- This function would need to be reimplemented to work with the new plugin loading system
  -- For now, we'll disable this functionality
end

function M.fix_renames()
  -- Note: mini.deps doesn't have Plugin.Spec like lazy.nvim
  -- Plugin renaming would need to be handled differently in the conversion process
  -- For now, we'll disable this functionality
end

return M
