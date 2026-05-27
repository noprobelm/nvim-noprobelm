local function python_path(root)
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= "" then
    return venv .. "/bin/python"
  end

  local cwd = root or vim.uv.cwd() or vim.fn.getcwd()
  for _, name in ipairs({ ".venv", "venv" }) do
    local path = cwd .. "/" .. name .. "/bin/python"
    if vim.uv.fs_stat(path) then
      return path
    end
  end

  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "basedpyright",
        "debugpy",
        "ruff",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              lineLength = 88,
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = python_path,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.python = dap.configurations.python or {}
      vim.list_extend(dap.configurations.python, {
        {
          type = "python",
          request = "launch",
          name = "Python: file",
          program = "${file}",
          pythonPath = python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Python: module",
          module = function()
            return vim.fn.input("Module: ")
          end,
          pythonPath = python_path,
          console = "integratedTerminal",
        },
      })
    end,
  },
}
