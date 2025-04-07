local AddonName, NS = ...

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local pairs = pairs
-- local GetArenaOpponentSpec = GetArenaOpponentSpec
-- local GetSpecializationInfoByID = GetSpecializationInfoByID

local texture = [[Interface\Addons\FlatRaidFrames\texture.blp]]
local backdrop = {
  edgeFile = "Interface\\Buttons\\WHITE8X8",
  tile = false,
  tileEdge = true,
  edgeSize = 1,
  insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local FRF = {}
NS.FRF = FRF

local FRFFrame = CreateFrame("Frame", "FRFFrame")
FRFFrame:SetScript("OnEvent", function(_, event, ...)
  if FRF[event] then
    FRF[event](FRF, ...)
  end
end)

local function updateTextures(self)
  if self:IsForbidden() then
    return
  end

  if self and self:GetName() then
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

function FRF:PLAYER_ENTERING_WORLD()
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

function FRF:ADDON_LOADED(addon)
  if addon == AddonName then
    FRFFrame:UnregisterEvent("ADDON_LOADED")
    FRFFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  end
end
FRFFrame:RegisterEvent("ADDON_LOADED")
