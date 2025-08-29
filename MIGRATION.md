# LazyVim Migration to mini.deps

This document describes the migration of LazyVim from lazy.nvim to mini.deps for plugin management.

## Overview

LazyVim has been refactored to use [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/deps.lua) instead of [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Key Changes

### Plugin Manager
- **Before**: Used lazy.nvim with sophisticated lazy loading, UI, and declarative configuration
- **After**: Uses mini.deps with simple imperative plugin loading

### Plugin Declaration Format

#### lazy.nvim Format (Before)
```lua
return {
  {
    "plugin/name",
    dependencies = { "dep1", "dep2" },
    event = "VeryLazy",
    opts = { option = "value" },
    config = function(_, opts)
      require("plugin").setup(opts)
    end,
  }
}
```

#### mini.deps Format (After)
```lua
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add({
    source = "plugin/name",
    depends = { "dep1", "dep2" }
  })
  require("plugin").setup({ option = "value" })
end)
```

### Loading Strategy
- **Before**: Automatic lazy loading based on events, commands, keys, filetypes
- **After**: Manual two-stage loading with `now()` and `later()`

### Bootstrap Process
- **Before**: `lazy.nvim` bootstrap from GitHub
- **After**: `mini.nvim` bootstrap and `mini.deps` setup

## What's Different

### Removed Features
- Lazy loading by events/commands/keys (must be implemented manually)
- Plugin management UI
- Version pinning by default
- Automatic dependency resolution
- Plugin profiling and debugging tools
- Lock file management

### Simplified Features  
- Basic plugin installation and loading
- Git-based plugin management
- Simple dependency specification
- Two-stage loading system

## Migration Steps for Users

1. **Update your config structure**: Plugin files now use imperative loading instead of returning tables
2. **Manual lazy loading**: Replace event-based loading with manual `later()` calls
3. **Configuration changes**: Plugin setup calls are now inline with `add()` calls
4. **Dependencies**: Use `depends = {}` instead of `dependencies = {}`

## Example Migration

### Before (lazy.nvim)
```lua
-- In lua/plugins/example.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = { "<leader>ff" },
    opts = {},
  }
}
```

### After (mini.deps)
```lua
-- In lua/plugins/example.lua
local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add({
    source = "nvim-telescope/telescope.nvim", 
    depends = { "nvim-lua/plenary.nvim" }
  })
  require("telescope").setup({})
  
  -- Manual keymap setup
  vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
end)
```

## Current Status

This migration is a work in progress. Currently converted:
- [x] Bootstrap system
- [x] Core configuration  
- [x] Plugin loader system
- [x] Colorscheme plugins
- [x] Coding plugins  
- [ ] Editor plugins
- [ ] UI plugins
- [ ] LSP plugins
- [ ] Other core plugins
- [ ] Extras system

## Impact on Users

This change significantly simplifies LazyVim but removes many advanced features:
- No automatic lazy loading
- No plugin management UI
- Manual dependency and configuration management required
- Simpler but less powerful overall system

Consider whether this trade-off aligns with your needs before migrating.