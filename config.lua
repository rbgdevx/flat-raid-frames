local _, NS = ...

local CreateFrame = CreateFrame

---@class DBTable : table
---@field hideFrameTitles boolean
---@field hideFrameNames boolean
---@field hideFrameRoles boolean

---@class FlatRaidFrames
---@field ADDON_LOADED function
---@field PLAYER_ENTERING_WORLD function
---@field PLAYER_LOGIN function
---@field SlashCommands function
---@field frame Frame
---@field db DBTable

---@type FlatRaidFrames
---@diagnostic disable-next-line: missing-fields
local FlatRaidFrames = {}
NS.FlatRaidFrames = FlatRaidFrames

local FlatRaidFramesFrame = CreateFrame("Frame", "FlatRaidFramesFrame")
FlatRaidFramesFrame:SetScript("OnEvent", function(_, event, ...)
  if FlatRaidFrames[event] then
    FlatRaidFrames[event](FlatRaidFrames, ...)
  end
end)
NS.FlatRaidFrames.frame = FlatRaidFramesFrame

NS.DefaultDatabase = {
  hideFrameTitles = false,
  hideFrameNames = false,
  hideFrameRoles = false,
}
