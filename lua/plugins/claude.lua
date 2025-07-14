-- This configures and eagerly loads augment.vim for Claude support
return {
  "augmentcode/augment.vim",
  lazy = false, -- load on startup
  init = function()
    -- Set your Claude workspace folders here
    vim.g.augment_workspace_folders = {
      "/absolute/path/to/your/project",
      "/another/project/path",
    }
  end,
}
