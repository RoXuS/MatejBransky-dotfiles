local my_keys = require("my_keys")

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
        my_keys.harpoon.list.shortcut,
        ui.toggle_quick_menu,
        desc = my_keys.harpoon.list.desc,
      })

      table.insert(keys, {
        my_keys.harpoon.clear.shortcut,
        function()
          mark.clear_all()
          print("Harpoon marks removed.")
        end,
        desc = my_keys.harpoon.clear.desc,
      })

      table.insert(keys, {
        my_keys.harpoon.mark.shortcut,
        mark.toggle_file,
        desc = my_keys.harpoon.mark.desc,
      })

      table.insert(keys, {
        my_keys.harpoon.prev.shortcut,
        ui.nav_prev,
        desc = my_keys.harpoon.prev.desc,
      })

      table.insert(keys, {
        my_keys.harpoon.next.shortcut,
        ui.nav_next,
        desc = my_keys.harpoon.next.desc,
      })

      local navKeys = my_keys.harpoon.shortcuts

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
