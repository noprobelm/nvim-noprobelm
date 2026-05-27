-- ~/.config/nvim/lua/plugins/wgsl.lua
return {
  -- Tree-sitter support for WGSL
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "wgsl" })
      end
    end,
  },

  -- LSP support for WGSL
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "wgsl-analyzer",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wgsl_analyzer = {
          cmd = { "wgsl-analyzer" },
          filetypes = { "wgsl" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.find_git_ancestor(fname) or util.path.dirname(fname)
          end,
          settings = {},
        },
      },
    },
  },

  -- Formatting support
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        wgsl = { "wgsl_analyzer" },
      },
    },
  },

  -- Optional: Alternative syntax highlighting fallback
  {
    "DingDean/wgsl.vim",
    ft = "wgsl",
    enabled = function()
      -- Only enable if tree-sitter WGSL is not available
      local parsers = require("nvim-treesitter.parsers")
      return not parsers.has_parser("wgsl")
    end,
  },
}
