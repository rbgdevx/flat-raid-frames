local AddonName, NS = ...

local CopyTable = CopyTable

NS.AceConfig = {
  name = AddonName,
  type = "group",
  args = {
    hideFrameTitles = {
      name = "Hide Frame Titles",
      desc = "Hide raid group titles and party title above frames",
      type = "toggle",
      width = "full",
      order = 1,
      set = function(_, val)
        NS.db.hideFrameTitles = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideFrameTitles
      end,
    },
    hideFrameNames = {
      name = "Hide Frame Names",
      desc = "Hide the names on raid and party frames",
      type = "toggle",
      width = "full",
      order = 2,
      set = function(_, val)
        NS.db.hideFrameNames = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideFrameNames
      end,
    },
    hideFrameRoles = {
      name = "Hide Frame Roles",
      desc = "Hide the role icons on raid and party frames",
      type = "toggle",
      width = "full",
      order = 3,
      set = function(_, val)
        NS.db.hideFrameRoles = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideFrameRoles
      end,
    },
    reset = {
      name = "Reset Everything",
      type = "execute",
      width = "normal",
      order = 100,
      func = function()
        FRFDB = CopyTable(NS.DefaultDatabase)
        NS.db = CopyTable(NS.DefaultDatabase)
        NS.OnDbChanged()
      end,
    },
  },
}
