local AddonName, NS = ...

local next = next

---@type FlatRaidFrames
local FlatRaidFrames = NS.FlatRaidFrames
local FlatRaidFramesFrame = NS.FlatRaidFrames.frame

local Options = {}
NS.Options = Options

function Options:SlashCommands(_)
  Settings.OpenToCategory(NS.settingsCategory:GetID())
end

local function OnSettingChanged(_setting, _value)
  local _key = _setting:GetVariable()
  FRFDB[_key] = _value

  NS.OnDbChanged()
end

function Options:Setup()
  local category = Settings.RegisterVerticalLayoutCategory(AddonName)
  Settings.RegisterAddOnCategory(category)
  NS.settingsCategory = category

  do
    local key = "hideFrameTitles"
    local defaultValue = NS.DefaultDatabase[key]

    local setting =
      Settings.RegisterAddOnSetting(category, "Hide All Frame Titles", key, FRFDB, "boolean", defaultValue)
    setting.name = "Hide All Frame Group Titles"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide raid group titles and party titles above frames"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hideFrameNames"
    local defaultValue = NS.DefaultDatabase[key]

    local setting =
      Settings.RegisterAddOnSetting(category, "Hide Friendly Frame Names", key, FRFDB, "boolean", defaultValue)
    setting.name = "Hide Friendly Frame Names"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the names on raid and party frames"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hideFrameRealmNames"
    local defaultValue = NS.DefaultDatabase[key]

    local setting =
      Settings.RegisterAddOnSetting(category, "Hide Friendly Frame Realm Names", key, FRFDB, "boolean", defaultValue)
    setting.name = "Hide Friendly Frame Realm Namess"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the realm names on raid and party frames"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hideFrameRoles"
    local defaultValue = NS.DefaultDatabase[key]

    local setting =
      Settings.RegisterAddOnSetting(category, "Hide Friendly Frame Role Icons", key, FRFDB, "boolean", defaultValue)
    setting.name = "Hide Friendly Frame Role Icons"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the role icons on raid and party frames"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hideEnemyArenaFrameNames"
    local defaultValue = NS.DefaultDatabase[key]

    local setting =
      Settings.RegisterAddOnSetting(category, "Hide Enemy Arena Frame Names", key, FRFDB, "boolean", defaultValue)
    setting.name = "Hide Enemy Arena Frame Names"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the names on the enemy arena frame during the match"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hideEnemyArenaFrameRoles"
    local defaultValue = NS.DefaultDatabase[key]

    local setting =
      Settings.RegisterAddOnSetting(category, "Hide Enemy Arena Frame Role Icons", key, FRFDB, "boolean", defaultValue)
    setting.name = "Hide Enemy Arena Frame Role Icons"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the roles on the enemy arena frame during the match"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hidePreMatchEnemyArenaFrameSpecs"
    local defaultValue = NS.DefaultDatabase[key]

    local setting = Settings.RegisterAddOnSetting(
      category,
      "Hide Pre-Match Enemy Arena Frame Specs",
      key,
      FRFDB,
      "boolean",
      defaultValue
    )
    setting.name = "Hide Pre-Match Enemy Arena Frame Specs"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the specs on the enemy arena frame in the arena waiting room"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hidePreMatchEnemyArenaFrameClasses"
    local defaultValue = NS.DefaultDatabase[key]

    local setting = Settings.RegisterAddOnSetting(
      category,
      "Hide Pre-Match Enemy Arena Frame Classes",
      key,
      FRFDB,
      "boolean",
      defaultValue
    )
    setting.name = "Hide Pre-Match Enemy Arena Frame Classes"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the classes on the enemy arena frame in the arena waiting room"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  do
    local key = "hidePreMatchEnemyArenaFrameRoles"
    local defaultValue = NS.DefaultDatabase[key]

    local setting = Settings.RegisterAddOnSetting(
      category,
      "Hide Pre-Match Enemy Arena Frame Role Icons",
      key,
      FRFDB,
      "boolean",
      defaultValue
    )
    setting.name = "Hide Pre-Match Enemy Arena Frame Role Icons"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Hide the roles on the enemy arena frame in the arena waiting room"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  SLASH_FRF1 = "/flatraidframes"
  SLASH_FRF2 = "/frf"

  function SlashCmdList.FRF(message)
    self:SlashCommands(message)
  end
end

function FlatRaidFrames:ADDON_LOADED(addon)
  if addon == AddonName then
    FlatRaidFramesFrame:UnregisterEvent("ADDON_LOADED")
    FlatRaidFramesFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    FRFDB = FRFDB and next(FRFDB) ~= nil and FRFDB or {}

    -- Copy any settings from default if they don't exist in current profile
    NS.CopyDefaults(NS.DefaultDatabase, FRFDB)

    -- Reference to active db profile
    -- Always use this directly or reference will be invalid
    NS.db = FRFDB

    -- Remove table values no longer found in default settings
    NS.CleanupDB(FRFDB, NS.DefaultDatabase)

    Options:Setup()
  end
end
FlatRaidFramesFrame:RegisterEvent("ADDON_LOADED")
