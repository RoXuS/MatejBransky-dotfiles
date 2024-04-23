local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local use_coc_suite = vim.env.NVIM_SUITE_COC == "true"

local log_mode = vim.env.NVIM_LOG_MODE == "true"

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript", enabled = not use_coc_suite or not log_mode },
    { import = "lazyvim.plugins.extras.linting.eslint", enabled = not use_coc_suite or not log_mode },
    { import = "lazyvim.plugins.extras.formatting.prettier", enabled = not use_coc_suite or not log_mode },
    { import = "lazyvim.plugins.extras.lang.json", enabled = not use_coc_suite },
    -- { import = "lazyvim.plugins.extras.lang.go" },
    -- { import = "lazyvim.plugins.extras.coding.copilot" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
    { import = "suite-coc", enabled = use_coc_suite },
    { import = "suite-native", enabled = not use_coc_suite },
    { import = "log-mode", enabled = log_mode },
    -- this allows to override nvim/plugins configs locally with the `<project-dir>/.lazy.lua` file
    { import = "lazyvim.plugins.extras.lazyrc" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
