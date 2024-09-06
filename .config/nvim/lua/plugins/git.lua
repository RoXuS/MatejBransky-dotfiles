local my_keys = require("my_keys")

local gstatus = { ok = false, ahead = 0, behind = 0 }
local function update_gstatus()
  local Job = require("plenary.job")
  Job:new({
    command = "git",
    -- git rev-list --count --left-right HEAD...@{upstream}
    args = { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
    on_exit = function(job, _)
      local res = job:result()[1]
      if type(res) ~= "string" then
        gstatus = { ahead = 0, behind = 0 }
        return
      end
      local ok, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")
      if not ok then
        ahead, behind = 0, 0
      end
      gstatus = { ok = ok, ahead = ahead, behind = behind }
    end,
  }):start()
end

if _G.Gstatus_timer == nil then
  _G.Gstatus_timer = vim.loop.new_timer()
else
  _G.Gstatus_timer:stop()
end
_G.Gstatus_timer:start(0, 2000, vim.schedule_wrap(update_gstatus))

return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set(my_keys.references.copyFilepath.mode, my_keys.references.copyFilepath.shortcut, function()
        local git_root = vim.fn.FugitiveWorkTree()
        local relative_path = vim.fn.expand("%:.")

        if git_root ~= "" then
          local abs_path = vim.fn.expand("%:p")
          relative_path = require("plenary.path"):new(abs_path):make_relative(git_root)
        end

        vim.fn.setreg("*", relative_path)
      end, { desc = my_keys.references.copyFilepath.desc, silent = true })

      vim.keymap.set(
        my_keys.references.openInBrowser.mode,
        my_keys.references.openInBrowser.shortcut,
        "<Cmd>GBrowse<CR>",
        { desc = my_keys.references.openInBrowser.desc }
      )

      vim.keymap.set(
        my_keys.references.copyFileLink.mode,
        my_keys.references.copyFileLink.shortcut,
        "<Cmd>GBrowse!<CR>",
        { desc = my_keys.references.copyFileLink.desc }
      )

      vim.keymap.set(
        my_keys.references.copyLineLink.mode,
        my_keys.references.copyLineLink.shortcut,
        ":.GBrowse!<CR>",
        { desc = my_keys.references.copyLineLink.desc, silent = true }
      )

      vim.keymap.set(
        my_keys.git.fastForward.mode,
        my_keys.git.fastForward.shortcut,
        ":G pull --ff-only<CR>",
        { desc = my_keys.git.fastForward.desc }
      )
    end,
  },
  -- supports Gitlab connection
  {
    "shumphrey/fugitive-gitlab.vim",
    config = function()
      vim.g.fugitive_gitlab_domains = {
        "https://gitlab.ataccama.dev",
      }
      vim.g.gitlab_api_keys = {
        ["https://gitlab.ataccama.dev"] = vim.env.GITLAB_ACCESS_TOKEN,
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        my_keys.git.branchHistory.shortcut,
        ":DiffviewFileHistory<CR>",
        desc = my_keys.git.branchHistory.desc,
      },
      {
        my_keys.git.fileHistory.shortcut,
        ":DiffviewFileHistory --no-merges %<CR>",
        desc = my_keys.git.fileHistory.desc,
      },
      { my_keys.git.closeHistory.shortcut, ":tabclose<CR>", desc = my_keys.git.closeHistory.desc },
      {
        my_keys.git.uncommitedChanges.shortcut,
        ":DiffviewOpen --imply-local<CR>",
        desc = my_keys.git.uncommitedChanges.desc,
      },
      { my_keys.git.review.shortcut, ":DiffviewOpen origin/", desc = my_keys.git.review.desc },
      {
        my_keys.git.branchChanges.shortcut,
        ":DiffviewOpen origin/HEAD...HEAD<CR>",
        desc = my_keys.git.branchChanges.desc,
      },
      {
        my_keys.git.traceLineEvolution.shortcut,
        ":'<,'>DiffviewFileHistory<CR>",
        desc = my_keys.git.traceLineEvolution.desc,
        mode = my_keys.git.traceLineEvolution.mode,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gl",
        function()
          require("gitsigns.actions").toggle_current_line_blame()
        end,
        desc = "Toggle current line blame",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, function()
        if not gstatus.ok then
          return ""
        end
        return gstatus.ahead .. " " .. gstatus.behind .. ""
      end)
    end,
  },
}
