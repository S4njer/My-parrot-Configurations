return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { "nvzone/volt", lazy = true },
  {
    "nvzone/menu" , lazy = true,
    vim.keymap.set("n", "<C-t>", function()
      require("menu").open("default")
    end, {}),

    vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
      require('menu.utils').delete_old_menus()

    vim.cmd.exec '"normal! \\<RightMouse>"'
    local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
    local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

    require("menu").open(options, { mouse = true })
    end, {})
  },

  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },

{
  "nvzone/minty",
  cmd = { "Shades", "Huefy" },
},




  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },
}
