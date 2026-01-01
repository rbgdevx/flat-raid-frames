local AddonName, NS = ...

local _G = _G
local next = next
local LibStub = LibStub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local GetUnitName = GetUnitName
-- local DefaultCompactUnitFrameOptions = DefaultCompactUnitFrameOptions
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

local function ensureRegionOnTop(frame, region)
  if not frame or not region then
    return
  end
  if region.SetParent and region:GetParent() ~= frame then
    region:SetParent(frame)
  end
  if region.SetDrawLayer then
    region:SetDrawLayer("OVERLAY", 7)
  end
end

local function updateAll(self)
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
      self.powerBar:SetStatusBarTexture(texture)
      self.myHealPrediction:SetTexture(texture)
      self.otherHealPrediction:SetTexture(texture)

      if name:find("CompactPartyFrame") then
        if self.horizDivider then
          self.horizDivider:SetVertexColor(0.3, 0.3, 0.3)
        end
        for _, region in pairs({ CompactPartyFrameBorderFrame:GetRegions() }) do
          if region:IsObjectType("Texture") then
            region:SetVertexColor(0, 0, 0, 0.15)
          end
        end
      end

      if self.vertLeftBorder then
        self.vertLeftBorder:Hide()
      end
      if self.vertRightBorder then
        self.vertRightBorder:Hide()
      end
      if self.horizTopBorder then
        self.horizTopBorder:Hide()
      end
      if self.horizBottomBorder then
        self.horizBottomBorder:Hide()
      end
    end
  end
end

hooksecurefunc("CompactUnitFrame_UpdateAll", updateAll)

local function updateRoleIcons(frame)
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
        or name:match("^CompactPartyFramePet%d")
        or name:match("^CompactArenaFrameMember%d")
        or name:match("^StealthedUnitFrame%d")
      )
    then
      if frame:IsForbidden() then
        return
      end

      if frame.roleIcon then
        if name:match("^CompactArenaFrameMember%d") then
          frame.roleIcon:SetAlpha(NS.db.hideEnemyArenaFrameRoles and 0 or 1)
        else
          frame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
        end
        ensureRegionOnTop(frame, frame.roleIcon)
      end

      if name:match("^PreMatchFrame%d") or name:match("^StealthedUnitFrame%d") then
        if frame.RoleIconTexture then
          if name:match("^PreMatchFrame%d") then
            frame.RoleIconTexture:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameRoles and 0 or 1)
          else
            frame.RoleIconTexture:SetAlpha(NS.db.hideEnemyArenaFrameRoles and 0 or 1)
          end
          ensureRegionOnTop(frame, frame.RoleIconTexture)
        end
      end
    end
  end

  -- if frame.optionTable == DefaultCompactUnitFrameOptions then
  -- 	if frame.roleIcon then
  -- 		frame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
  -- 		ensureRegionOnTop(frame, frame.roleIcon)
  -- 	end
  -- end
end

hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", updateRoleIcons)

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
        or name:match("^CompactPartyFramePet%d")
        or name:match("^CompactArenaFrameMember%d")
        or name:match("^PreMatchFrame%d")
        or name:match("^StealthedUnitFrame%d")
      )
    then
      if frame:IsForbidden() then
        return
      end

      if frame.unit and frame.name then
        if name:match("^CompactArenaFrameMember%d") then
          frame.name:SetAlpha(NS.db.hideEnemyArenaFrameNames and 0 or 1)
        else
          frame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
        end

        local nameWithServer = GetUnitName(frame.unit, true)
        if nameWithServer then
          if NS.db.hideFrameRealmNames then
            local nameWithoutServer = GetUnitName(frame.unit, false)
            frame.name:SetText(nameWithoutServer)
          end
        end

        if name:match("^PreMatchFrame%d") or name:match("^StealthedUnitFrame%d") then
          if name:match("^StealthedUnitFrame%d") then
            if frame.NameText then
              frame.NameText:SetAlpha(NS.db.hideEnemyArenaFrameNames and 0 or 1)
            end
          else
            if frame.ClassNameText then
              frame.ClassNameText:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameClasses and 0 or 1)
            end
            if frame.SpecNameText then
              frame.SpecNameText:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameSpecs and 0 or 1)
            end
          end
        end
      end
    end
  end

  -- if frame.optionTable == DefaultCompactUnitFrameOptions then
  -- 	if frame.name then
  -- 		frame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
  -- 	end
  -- end
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
        if raidFrame.unit and raidFrame.name then
          raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)

          local nameWithServer = GetUnitName(raidFrame.unit, true)
          if nameWithServer then
            if NS.db.hideFrameRealmNames then
              local nameWithoutIndicator = GetUnitName(raidFrame.unit, false)
              raidFrame.name:SetText(nameWithoutIndicator)
            end
          end
        end
        if raidFrame.roleIcon then
          raidFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
          ensureRegionOnTop(raidFrame, raidFrame.roleIcon)
        end
      end
    end
  end
end

hooksecurefunc("CompactRaidGroup_GenerateForGroup", updateGroups)

NS.OnDbChanged = function()
  FlatRaidFramesFrame.dbChanged = true

  if IsInInstance() then
    CompactPartyFrameTitle:SetAlpha(NS.db.hideFrameTitles and 0 or 1)
    CompactArenaFrameTitle:SetAlpha(NS.db.hideFrameTitles and 0 or 1)

    do
      -- loop through 1-3
      for unitIndex = 1, 3 do
        local memberFrame = _G["CompactArenaFrameMember" .. unitIndex]
        if memberFrame then
          if memberFrame.unit and memberFrame.name then
            memberFrame.name:SetAlpha(NS.db.hideEnemyArenaFrameNames and 0 or 1)

            local nameWithServer = GetUnitName(memberFrame.unit, true)
            if nameWithServer then
              if NS.db.hideFrameRealmNames then
                local nameWithoutServer = GetUnitName(memberFrame.unit, false)
                memberFrame.name:SetText(nameWithoutServer)
              else
                memberFrame.name:SetText(nameWithServer)
              end
            end
          end
          if memberFrame.roleIcon then
            memberFrame.roleIcon:SetAlpha(NS.db.hideEnemyArenaFrameRoles and 0 or 1)
            ensureRegionOnTop(memberFrame, memberFrame.roleIcon)
          end
        end
        local preMatchFrame = CompactArenaFrame.PreMatchFramesContainer["PreMatchFrame" .. unitIndex]
        if preMatchFrame then
          if preMatchFrame.ClassNameText then
            preMatchFrame.ClassNameText:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameClasses and 0 or 1)
          end
          if preMatchFrame.SpecNameText then
            preMatchFrame.SpecNameText:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameSpecs and 0 or 1)
          end
          if preMatchFrame.RoleIconTexture then
            preMatchFrame.RoleIconTexture:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameRoles and 0 or 1)
            ensureRegionOnTop(preMatchFrame, preMatchFrame.RoleIconTexture)
          end
          if preMatchFrame.SpecPortraitTexture then
            preMatchFrame.SpecPortraitTexture:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameSpecIcons and 0 or 1)
          end
          if preMatchFrame.SpecPortraitBorderTexture then
            preMatchFrame.SpecPortraitBorderTexture:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameSpecIcons and 0 or 1)
          end
        end
        local stealthedUnitFrame = CompactArenaFrame["StealthedUnitFrame" .. unitIndex]
        if stealthedUnitFrame then
          if stealthedUnitFrame.NameText then
            stealthedUnitFrame.NameText:SetAlpha(NS.db.hideEnemyArenaFrameNames and 0 or 1)
          end
          if stealthedUnitFrame.RoleIconTexture then
            stealthedUnitFrame.RoleIconTexture:SetAlpha(NS.db.hideEnemyArenaFrameRoles and 0 or 1)
            ensureRegionOnTop(stealthedUnitFrame, stealthedUnitFrame.RoleIconTexture)
          end
        end
      end
    end

    do
      -- loop through 1-5
      for unitIndex = 1, 5 do
        local memberFrame = _G["CompactPartyFrameMember" .. unitIndex]
        local petFrame = _G["CompactPartyFramePet" .. unitIndex]
        if memberFrame then
          if memberFrame.unit and memberFrame.name then
            memberFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)

            local nameWithServer = GetUnitName(memberFrame.unit, true)
            if nameWithServer then
              if NS.db.hideFrameRealmNames then
                local nameWithoutServer = GetUnitName(memberFrame.unit, false)
                memberFrame.name:SetText(nameWithoutServer)
              else
                memberFrame.name:SetText(nameWithServer)
              end
            end
          end
          if memberFrame.roleIcon then
            memberFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
            ensureRegionOnTop(memberFrame, memberFrame.roleIcon)
          end
        end
        if petFrame then
          if petFrame.name then
            petFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)
          end
        end
      end
    end

    do
      local unitIndex = 1
      local raidFrame
      repeat
        raidFrame = _G["CompactRaidFrame" .. unitIndex]
        if raidFrame then
          if raidFrame.unit and raidFrame.name then
            raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)

            local nameWithServer = GetUnitName(raidFrame.unit, true)
            if nameWithServer then
              if NS.db.hideFrameRealmNames then
                local nameWithoutIndicator = GetUnitName(raidFrame.unit, false)
                raidFrame.name:SetText(nameWithoutIndicator)
              else
                raidFrame.name:SetText(nameWithServer)
              end
            end
          end
          if raidFrame.roleIcon then
            raidFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
            ensureRegionOnTop(raidFrame, raidFrame.roleIcon)
          end
        end
        unitIndex = unitIndex + 1
      until not raidFrame
    end

    do
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
              if raidFrame.unit and raidFrame.name then
                raidFrame.name:SetAlpha(NS.db.hideFrameNames and 0 or 1)

                local nameWithServer = GetUnitName(raidFrame.unit, true)
                if nameWithServer then
                  if NS.db.hideFrameRealmNames then
                    local nameWithoutIndicator = GetUnitName(raidFrame.unit, false)
                    raidFrame.name:SetText(nameWithoutIndicator)
                  else
                    raidFrame.name:SetText(nameWithServer)
                  end
                end
              end
              if raidFrame.roleIcon then
                raidFrame.roleIcon:SetAlpha(NS.db.hideFrameRoles and 0 or 1)
                ensureRegionOnTop(raidFrame, raidFrame.roleIcon)
              end
            end
          end
        end
      end
    end
  end

  FlatRaidFramesFrame.dbChanged = false
end

function FlatRaidFrames:PLAYER_ENTERING_WORLD()
  if IsInInstance() then
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

        if pre_match_frame.SpecPortraitTexture then
          pre_match_frame.SpecPortraitTexture:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameSpecIcons and 0 or 1)
        end
        if pre_match_frame.SpecPortraitBorderTexture then
          pre_match_frame.SpecPortraitBorderTexture:SetAlpha(NS.db.hidePreMatchEnemyArenaFrameSpecIcons and 0 or 1)
        end
      end
    end

    CompactPartyFrameTitle:SetAlpha(NS.db.hideFrameTitles and 0 or 1)
    CompactArenaFrameTitle:SetAlpha(NS.db.hideFrameTitles and 0 or 1)
  end
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

function FlatRaidFrames:PLAYER_LOGIN()
  FlatRaidFramesFrame:UnregisterEvent("PLAYER_LOGIN")
  FlatRaidFramesFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
FlatRaidFramesFrame:RegisterEvent("PLAYER_LOGIN")

function FlatRaidFrames:ADDON_LOADED(addon)
  if addon == AddonName then
    FlatRaidFramesFrame:UnregisterEvent("ADDON_LOADED")

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
