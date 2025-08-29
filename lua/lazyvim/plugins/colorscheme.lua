-- LazyVim colorscheme plugins for mini.deps
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  -- tokyonight
  add("folke/tokyonight.nvim")
  require("tokyonight").setup({ style = "moon" })
end)

later(function()
  -- catppuccin
  add("catppuccin/nvim")
  require("catppuccin").setup({
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      snacks = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  })
  
  -- bufferline integration for catppuccin
  -- Note: This replaces the lazy.nvim "specs" functionality
  later(function()
    add("akinsho/bufferline.nvim")
    if (vim.g.colors_name or ""):find("catppuccin") then
      -- Apply catppuccin bufferline integration
      local ok, bufferline = pcall(require, "bufferline")
      if ok then
        bufferline.setup({
          highlights = require("catppuccin.groups.integrations.bufferline").get()
        })
      end
    end
  end)
end)
