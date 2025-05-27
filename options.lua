local AddonName, NS = ...

local CopyTable = CopyTable

NS.AceConfig = {
  name = AddonName,
  type = "group",
  args = {
    hideFrameTitles = {
      name = "Hide All Frame Titles",
      desc = "Hide raid group titles and party titles above frames",
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
      name = "Hide Friendly Frame Names",
      desc = "Hide the names on raid and party frames",
      type = "toggle",
      width = 1.2,
      order = 2,
      set = function(_, val)
        NS.db.hideFrameNames = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideFrameNames
      end,
    },
    hideFrameRealmNames = {
      name = "Hide Friendly Frame Realm Names",
      desc = "Hide the realm names on raid and party frames",
      type = "toggle",
      width = 1.5,
      order = 3,
      disabled = function()
        return NS.db.hideFrameNames
      end,
      set = function(_, val)
        NS.db.hideFrameRealmNames = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideFrameRealmNames
      end,
    },
    spacer1 = {
      name = "",
      type = "description",
      order = 4,
      width = "full",
    },
    hideFrameRoles = {
      name = "Hide Friendly Frame Roles",
      desc = "Hide the role icons on raid and party frames",
      type = "toggle",
      width = "full",
      order = 5,
      set = function(_, val)
        NS.db.hideFrameRoles = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideFrameRoles
      end,
    },
    hideEnemyArenaFrameNames = {
      name = "Hide Enemy Arena Frame Names",
      desc = "Hide the names on the enemy arena frame during the match",
      type = "toggle",
      width = "full",
      order = 6,
      set = function(_, val)
        NS.db.hideEnemyArenaFrameNames = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideEnemyArenaFrameNames
      end,
    },
    hideEnemyArenaFrameRoles = {
      name = "Hide Enemy Arena Frame Roles",
      desc = "Hide the roles on the enemy arena frame during the match",
      type = "toggle",
      width = "full",
      order = 7,
      set = function(_, val)
        NS.db.hideEnemyArenaFrameRoles = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hideEnemyArenaFrameRoles
      end,
    },
    hidePreMatchEnemyArenaFrameSpecs = {
      name = "Hide Pre-Match Enemy Arena Frame Specs",
      desc = "Hide the specs on the enemy arena frame in the arena waiting room",
      type = "toggle",
      width = "full",
      order = 8,
      set = function(_, val)
        NS.db.hidePreMatchEnemyArenaFrameSpecs = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hidePreMatchEnemyArenaFrameSpecs
      end,
    },
    hidePreMatchEnemyArenaFrameClasses = {
      name = "Hide Pre-Match Enemy Arena Frame Classes",
      desc = "Hide the classes on the enemy arena frame in the arena waiting room",
      type = "toggle",
      width = "full",
      order = 9,
      set = function(_, val)
        NS.db.hidePreMatchEnemyArenaFrameClasses = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hidePreMatchEnemyArenaFrameClasses
      end,
    },
    hidePreMatchEnemyArenaFrameRoles = {
      name = "Hide Pre-Match Enemy Arena Frame Roles",
      desc = "Hide the roles on the enemy arena frame in the arena waiting room",
      type = "toggle",
      width = "full",
      order = 10,
      set = function(_, val)
        NS.db.hidePreMatchEnemyArenaFrameRoles = val
        NS.OnDbChanged()
      end,
      get = function(_)
        return NS.db.hidePreMatchEnemyArenaFrameRoles
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
