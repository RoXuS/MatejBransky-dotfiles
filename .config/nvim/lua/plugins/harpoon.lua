local myKeys = require("myKeys")

return {
  {
    -- Master the navigation between main files
    -- https://youtu.be/Qnos8aApa9g
    --
    -- I forked it because of the important PR which fixes removing the file
    -- https://github.com/MatejBransky/harpoon/pull/1
    "MatejBransky/harpoon",
    keys = function(_, keys)
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      table.insert(keys, {
        myKeys.harpoon.list.shortcut,
        ui.toggle_quick_menu,
        desc = myKeys.harpoon.list.desc,
      })

      table.insert(keys, {
        myKeys.harpoon.clear.shortcut,
        function()
          mark.clear_all()
          print("Harpoon marks removed.")
        end,
        desc = myKeys.harpoon.clear.desc,
      })

      table.insert(keys, {
        myKeys.harpoon.mark.shortcut,
        mark.toggle_file,
        desc = myKeys.harpoon.mark.desc,
      })

      local navKeys = myKeys.harpoon.shortcuts

      for index, navKey in ipairs(navKeys) do
        table.insert(keys, {
          navKey,
          function()
            ui.nav_file(index)
          end,
          desc = "Harpoon file (" .. index .. ")",
        })
      end
    end,
    opts = {
      tabline = false,
      menu = {
        width = 100,
      },
    },
  },
}
