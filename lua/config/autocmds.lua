-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- Auto-change directory to project root when entering a buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("AutoProjectRoot", { clear = true }),
  callback = function()
    -- Get the current buffer's file path
    local current_file = vim.fn.expand("%:p")

    -- Skip if it's not a real file (empty, scratch buffers, etc.)
    if current_file == "" or vim.bo.buftype ~= "" then
      return
    end

    -- Project root markers in order of priority
    local root_markers = {
      ".git",
      "package.json",
      "Cargo.toml",
      "pyproject.toml",
      "go.mod",
      "composer.json",
      "Makefile",
      "CMakeLists.txt",
      "pom.xml",
      "build.gradle",
      "tsconfig.json",
      "yarn.lock",
      "pnpm-lock.yaml",
      ".gitignore",
      "README.md",
    }

    -- Find the project root
    local root = vim.fs.find(root_markers, {
      upward = true,
      path = vim.fn.fnamemodify(current_file, ":h"),
    })[1]

    if root then
      local root_dir = vim.fn.fnamemodify(root, ":h")
      local current_dir = vim.fn.getcwd()

      -- Only change directory if we're not already in the project root
      if root_dir ~= current_dir then
        vim.cmd("cd " .. root_dir)
        -- Optional: show a message when changing directories
        -- vim.notify("Changed to project root: " .. root_dir, vim.log.levels.INFO)
      end
    end
  end,
})

-- Alternative: More conservative approach that only changes on specific file types
-- Uncomment this and comment out the above if you prefer this behavior
--[[
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("AutoProjectRoot", { clear = true }),
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.rs", "*.go", "*.java", "*.c", "*.cpp", "*.h" },
  callback = function()
    local current_file = vim.fn.expand("%:p")
    
    if current_file == "" then
      return
    end
    
    local root_markers = { ".git", "package.json", "Cargo.toml", "pyproject.toml", "go.mod" }
    
    local root = vim.fs.find(root_markers, {
      upward = true,
      path = vim.fn.fnamemodify(current_file, ":h")
    })[1]
    
    if root then
      local root_dir = vim.fn.fnamemodify(root, ":h")
      local current_dir = vim.fn.getcwd()
      
      if root_dir ~= current_dir then
        vim.cmd("cd " .. root_dir)
      end
    end
  end,
})
--]]
