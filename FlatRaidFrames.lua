local AddonName, NS = ...

local FRF = {}
NS.FRF = FRF

local FRFFrame = CreateFrame("Frame", "FRFFrame")
FRFFrame:SetScript("OnEvent", function(_, event, ...)
  if FRF[event] then
    FRF[event](FRF, ...)
  end
end)

function FRF:ADDON_LOADED(addon)
  if addon == AddonName then
    FRFFrame:UnregisterEvent("ADDON_LOADED")
    FRFFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  end
end
FRFFrame:RegisterEvent("ADDON_LOADED")

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

      local texture = [[Interface\Addons\FlatRaidFrames\texture.blp]]
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

function FRF:PLAYER_ENTERING_WORLD()
  hooksecurefunc("CompactUnitFrame_UpdateAll", updateTextures)
end
