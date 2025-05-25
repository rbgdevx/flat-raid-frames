local AddonName, NS = ...

local _G = _G
local next = next
local LibStub = LibStub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local GetUnitName = GetUnitName
local DefaultCompactUnitFrameOptions = DefaultCompactUnitFrameOptions
-- local GetArenaOpponentSpec = GetArenaOpponentSpec
-- local GetSpecializationInfoByID = GetSpecializationInfoByID

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local texture = [[Interface\Addons\FlatRaidFrames\texture.blp]]
local backdrop = {
  edgeFile = "Interface\\Buttons\\WHITE8X8",
  tile = false,
  tileEdge = true,
  edgeSize = 1,
  insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

---@type FlatRaidFrames
local FlatRaidFrames = NS.FlatRaidFrames
local FlatRaidFramesFrame = NS.FlatRaidFrames.frame

local function updateTextures(self)
  if not self then
    return
  end

  if self:IsForbidden() then
    return
  end

  if self:GetName() then
    local name = self:GetName()

    if name and name:match("^Compact") then
      if self:IsForbidden() then
        return
      end

      self.healthBar:SetStatusBarTexture(texture)
      self.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
      self.powerBar:SetStatusBarTexture(texture)
      self.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
      self.myHealPrediction:SetTexture(texture)
      self.otherHealPrediction:SetTexture(texture)

      if name:find("CompactPartyFrame") then
        self.horizDivider:SetVertexColor(0.3, 0.3, 0.3)
        for _, region in pairs({ CompactPartyFrameBorderFrame:GetRegions() }) do
          if region:IsObjectType("Texture") then
            region:SetVertexColor(0, 0, 0, 0.15)
          end
        end
      end

      self.vertLeftBorder:Hide()
      self.vertRightBorder:Hide()
      self.horizTopBorder:Hide()
      self.horizBottomBorder:Hide()
    end
  end
end

hooksecurefunc("CompactUnitFrame_UpdateAll", updateTextures)

local function updateRoles(frame)
  if not frame then
    return
  end

  if frame:IsForbidden() then
    return
  end

  if frame.optionTable == DefaultCompactUnitFrameOptions then
    if frame.roleIcon then
      frame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
    end
  end
end

hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", updateRoles)

local function updateNames(frame)
  if not frame then
    return
  end

  if frame:IsForbidden() then
    return
  end

  if frame:GetName() then
    local name = frame:GetName()
    if
      name
      and (
        name:match("^CompactRaidFrame%d")
        or name:match("^CompactRaidGroup%dMember%d")
        or name:match("^CompactPartyFrameMember%d")
      )
    then
      if frame:IsForbidden() then
        return
      end
      if frame.unit then
        local nameWithServer = GetUnitName(frame.unit, true)
        if nameWithServer and frame.name then
          if NS.db.hideFrameRealmNames then
            local nameWithoutServer = nameWithServer:match("[^-]+")
            frame.name:SetText(nameWithoutServer)
          end
        end
      end
    end
  end

  if frame.optionTable == DefaultCompactUnitFrameOptions then
    if frame.name then
      frame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
    end
  else
    if NS.inParty() then
      local unitIndex = 1
      local petFrame
      repeat
        petFrame = _G["CompactPartyFramePet" .. unitIndex]
        if petFrame then
          if petFrame.name then
            petFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
          end
        end
        unitIndex = unitIndex + 1
      until not petFrame
    end
    if NS.inRaid() then
      local unitIndex = 1
      local raidFrame
      repeat
        raidFrame = _G["CompactRaidFrame" .. unitIndex]
        if raidFrame then
          if raidFrame.name then
            raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
          end
        end
        unitIndex = unitIndex + 1
      until not raidFrame
    end
  end
end

hooksecurefunc("CompactUnitFrame_UpdateName", updateNames)

local function updateGroups(groupIndex)
  local groupFrame = _G["CompactRaidGroup" .. groupIndex]
  if groupFrame then
    if groupFrame.title then
      groupFrame.title:SetAlpha(NS.db.hideFrameTitles and 0 or 1)
    end
    -- loop through 1-5
    for unitIndex = 1, 5 do
      local raidFrame = _G["CompactRaidGroup" .. groupIndex .. "Member" .. unitIndex]
      if raidFrame then
        if raidFrame.unit then
          local nameWithServer = GetUnitName(raidFrame.unit, true)
          if nameWithServer and raidFrame.name then
            if NS.db.hideFrameRealmNames then
              local nameWithoutIndicator = nameWithServer:match("[^-]+")
              raidFrame.name:SetText(nameWithoutIndicator)
            end
          end
        end
        if raidFrame.name then
          raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
        end
        if raidFrame.roleIcon then
          raidFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
        end
      end
    end
  end
end

hooksecurefunc("CompactRaidGroup_GenerateForGroup", updateGroups)

function FlatRaidFrames:PLAYER_ENTERING_WORLD()
  local function set_stealth_unit_textures(foreground_texture, background_texture)
    foreground_texture:SetTexture(texture)
    background_texture:SetTexture(texture)
  end
  local function set_pre_match_unit_textures(pre_match_texture)
    pre_match_texture:SetTexture(texture)
  end
  local function set_unit_border(unit_frame)
    -- Setup the border
    if not unit_frame.backdropInfo then
      Mixin(unit_frame, BackdropTemplateMixin)
      unit_frame:SetBackdrop(backdrop)
      unit_frame:ApplyBackdrop()
      unit_frame:SetBackdropBorderColor(0, 0, 0)
    end
  end

  -- local set_arena_opponent_foreground_color = function(_texture, class)
  -- 	local class_color = class_colors[class]
  -- 	_texture:SetVertexColor(class_color[1], class_color[2], class_color[3], class_color[4])
  -- end

  -- local function set_stealth_unit_color(stealthed_unit_frame, foreground_texture)
  -- 	local unit_class_info = stealthed_unit_frame:GetUnitClassInfo()
  -- 	local class = unit_class_info.class or "PRIEST"
  -- 	set_arena_opponent_foreground_color(foreground_texture, class)
  -- end

  -- local function set_pre_match_frame_color(index, pre_match_texture)
  -- 	local spec_id = GetArenaOpponentSpec(index)
  -- 	if spec_id and spec_id > 0 then
  -- 		local class = select(6, GetSpecializationInfoByID(spec_id)) or "PRIEST"
  -- 		set_arena_opponent_foreground_color(pre_match_texture, class)
  -- 	end
  -- end

  -- color
  for i = 1, 3 do
    -- Stealth Unit
    local stealthed_unit_frame = CompactArenaFrame["StealthedUnitFrame" .. i]
    if stealthed_unit_frame then
      local foreground_texture = stealthed_unit_frame.BarTexture
      local background_texture = stealthed_unit_frame.BackgroundTexture
      -- hooksecurefunc(stealthed_unit_frame, "SetUnitFrame", function()
      -- 	set_stealth_unit_color(stealthed_unit_frame, foreground_texture)
      -- end)
      -- set_stealth_unit_color(stealthed_unit_frame, foreground_texture)
      set_stealth_unit_textures(foreground_texture, background_texture)
      set_unit_border(stealthed_unit_frame)
    end

    -- Pre Match Frame
    local pre_match_frame = CompactArenaFrame.PreMatchFramesContainer["PreMatchFrame" .. i]
    if pre_match_frame then
      local pre_match_texture = pre_match_frame.BarTexture
      -- hooksecurefunc(pre_match_frame, "Update", function()
      -- 	set_pre_match_frame_color(i, pre_match_texture)
      -- end)
      -- set_pre_match_frame_color(i, pre_match_texture)
      set_pre_match_unit_textures(pre_match_texture)
      set_unit_border(pre_match_frame)
    end
  end
end

function FlatRaidFrames:PLAYER_LOGIN()
  FlatRaidFramesFrame:UnregisterEvent("PLAYER_LOGIN")

  NS.OnDbChanged()

  FlatRaidFramesFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
FlatRaidFramesFrame:RegisterEvent("PLAYER_LOGIN")

NS.OnDbChanged = function()
  FlatRaidFramesFrame.dbChanged = true

  do
    if NS.inParty() then
      CompactPartyFrameTitle:SetAlpha(NS.db.hideFrameTitles and 0 or 1)
      -- loop through 1-5
      for unitIndex = 1, 5 do
        local memberFrame = _G["CompactPartyFrameMember" .. unitIndex]
        local petFrame = _G["CompactPartyFramePet" .. unitIndex]
        if memberFrame then
          if memberFrame.unit then
            local nameWithServer = GetUnitName(memberFrame.unit, true)
            if nameWithServer and memberFrame.name then
              if NS.db.hideFrameRealmNames then
                local nameWithoutServer = nameWithServer:match("[^-]+")
                memberFrame.name:SetText(nameWithoutServer)
              else
                memberFrame.name:SetText(nameWithServer)
              end
            end
          end
          if memberFrame.name then
            memberFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
          end
          if memberFrame.roleIcon then
            memberFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
          end
        end
        if petFrame then
          if petFrame.name then
            petFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
          end
        end
      end
    end
  end

  do
    if NS.inRaid() then
      local unitIndex = 1
      local raidFrame
      repeat
        raidFrame = _G["CompactRaidFrame" .. unitIndex]
        if raidFrame then
          if raidFrame.unit then
            local nameWithServer = GetUnitName(raidFrame.unit, true)
            if nameWithServer and raidFrame.name then
              if NS.db.hideFrameRealmNames then
                local nameWithoutIndicator = nameWithServer:match("[^-]+")
                raidFrame.name:SetText(nameWithoutIndicator)
              else
                raidFrame.name:SetText(nameWithServer)
              end
            end
          end
          if raidFrame.name then
            raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
          end
          if raidFrame.roleIcon then
            raidFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
          end
        end
        unitIndex = unitIndex + 1
      until not raidFrame
    end
  end

  do
    if NS.inRaid() then
      -- loop through 1-8
      for groupIndex = 1, 8 do
        local groupFrame = _G["CompactRaidGroup" .. groupIndex]
        if groupFrame then
          if groupFrame.title then
            groupFrame.title:SetAlpha(NS.db.hideFrameTitles and 0 or 1)
          end
          -- loop through 1-5
          for unitIndex = 1, 5 do
            local raidFrame = _G["CompactRaidGroup" .. groupIndex .. "Member" .. unitIndex]
            if raidFrame then
              if raidFrame.unit then
                local nameWithServer = GetUnitName(raidFrame.unit, true)
                if nameWithServer and raidFrame.name then
                  if NS.db.hideFrameRealmNames then
                    local nameWithoutIndicator = nameWithServer:match("[^-]+")
                    raidFrame.name:SetText(nameWithoutIndicator)
                  else
                    raidFrame.name:SetText(nameWithServer)
                  end
                end
              end
              if raidFrame.name then
                raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
              end
              if raidFrame.roleIcon then
                raidFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
              end
            end
          end
        end
      end
    end
  end

  FlatRaidFramesFrame.dbChanged = false
end

NS.Options_SlashCommands = function(_)
  AceConfigDialog:Open(AddonName)
end

NS.Options_Setup = function()
  AceConfig:RegisterOptionsTable(AddonName, NS.AceConfig)
  AceConfigDialog:AddToBlizOptions(AddonName, AddonName)

  SLASH_FRF1 = AddonName
  SLASH_FRF2 = "/frf"

  function SlashCmdList.FRF(message)
    NS.Options_SlashCommands(message)
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

    NS.Options_Setup()
  end
end
FlatRaidFramesFrame:RegisterEvent("ADDON_LOADED")
