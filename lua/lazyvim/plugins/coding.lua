-- LazyVim coding plugins for mini.deps
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  -- auto pairs
  add("echasnovski/mini.pairs")
  LazyVim.mini.pairs({
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  })
end)

later(function()
  -- comments
  add("folke/ts-comments.nvim")
  require("ts-comments").setup({})
end)

later(function()
  -- Better text-objects
  add("echasnovski/mini.ai")
  local ai = require("mini.ai")
  local opts = {
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({ -- code block
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
      d = { "%f[%d]%d+" }, -- digits
      e = { -- Word with case
        { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
        "^().*()$",
      },
      g = LazyVim.mini.ai_buffer, -- buffer
      u = ai.gen_spec.function_call(), -- u for "Usage"
      U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
    },
  }
  
  require("mini.ai").setup(opts)
  
  -- Setup which-key integration when available
  LazyVim.on_load("which-key.nvim", function()
    vim.schedule(function()
      LazyVim.mini.ai_whichkey(opts)
    end)
  end)
end)

-- Lua development support (only for lua files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    add("folke/lazydev.nvim")
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        -- Note: removed lazy.nvim reference since we're using mini.deps
      },
    })
  end,
})
