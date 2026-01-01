local AddonName, NS = ...

local CopyTable = CopyTable

NS.AceConfig = {
  name = AddonName,
  type = "group",
  args = {
    generalGroup = {
      name = "General Settings",
      type = "group",
      inline = true,
      order = 1,
      args = {
        hideFrameTitles = {
          name = "Hide All Group Labels",
          desc = "Hide raid group labels and party labels above frames",
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
        hideFrameRealmNames = {
          name = "Hide All Realm Names",
          desc = "Hide the realm names on raid and party frames",
          type = "toggle",
          width = "full",
          order = 2,
          set = function(_, val)
            NS.db.hideFrameRealmNames = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hideFrameRealmNames
          end,
        },
      },
    },
    friendlyGroup = {
      name = "Friendly Frames",
      type = "group",
      inline = true,
      order = 2,
      args = {
        hideFrameNames = {
          name = "Hide Names",
          desc = "Hide the names on raid and party frames",
          type = "toggle",
          width = "full",
          order = 1,
          set = function(_, val)
            NS.db.hideFrameNames = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hideFrameNames
          end,
        },
        hideFrameRoles = {
          name = "Hide Icons",
          desc = "Hide the role icons on raid and party frames",
          type = "toggle",
          width = "full",
          order = 2,
          set = function(_, val)
            NS.db.hideFrameRoles = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hideFrameRoles
          end,
        },
      },
    },
    enemyArenaGroup = {
      name = "Enemy Arena Frames",
      type = "group",
      inline = true,
      order = 3,
      args = {
        hideEnemyArenaFrameNames = {
          name = "Hide Names",
          desc = "Hide the names on the enemy arena frame during the match",
          type = "toggle",
          width = "full",
          order = 1,
          set = function(_, val)
            NS.db.hideEnemyArenaFrameNames = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hideEnemyArenaFrameNames
          end,
        },
        hideEnemyArenaFrameRoles = {
          name = "Hide Role Icons",
          desc = "Hide the roles on the enemy arena frame during the match",
          type = "toggle",
          width = "full",
          order = 2,
          set = function(_, val)
            NS.db.hideEnemyArenaFrameRoles = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hideEnemyArenaFrameRoles
          end,
        },
      },
    },
    prematchEnemyArenaGroup = {
      name = "Prematch (Lobby) Enemy Arena Frames",
      type = "group",
      inline = true,
      order = 4,
      args = {
        hidePreMatchEnemyArenaFrameSpecs = {
          name = "Hide Spec names",
          desc = "Hide the specs on the enemy arena frame in the arena waiting room",
          type = "toggle",
          width = "full",
          order = 1,
          set = function(_, val)
            NS.db.hidePreMatchEnemyArenaFrameSpecs = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hidePreMatchEnemyArenaFrameSpecs
          end,
        },
        hidePreMatchEnemyArenaFrameClasses = {
          name = "Hide Class names",
          desc = "Hide the classes on the enemy arena frame in the arena waiting room",
          type = "toggle",
          width = "full",
          order = 2,
          set = function(_, val)
            NS.db.hidePreMatchEnemyArenaFrameClasses = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hidePreMatchEnemyArenaFrameClasses
          end,
        },
        hidePreMatchEnemyArenaFrameRoles = {
          name = "Hide Role Icons",
          desc = "Hide the roles on the enemy arena frame in the arena waiting room",
          type = "toggle",
          width = "full",
          order = 3,
          set = function(_, val)
            NS.db.hidePreMatchEnemyArenaFrameRoles = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hidePreMatchEnemyArenaFrameRoles
          end,
        },
        hidePreMatchEnemyArenaFrameSpecIcons = {
          name = "Hide Spec Icons",
          desc = "Hide the spec icons on the enemy arena frame in the arena waiting room",
          type = "toggle",
          width = "full",
          order = 4,
          set = function(_, val)
            NS.db.hidePreMatchEnemyArenaFrameSpecIcons = val
            NS.OnDbChanged()
          end,
          get = function(_)
            return NS.db.hidePreMatchEnemyArenaFrameSpecIcons
          end,
        },
      },
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
