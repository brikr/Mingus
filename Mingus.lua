local _, Mingus = ...

local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

-- Debug: make Mingus global so I can /dump it
_G["Mingus"] = Mingus

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local addOnName = ...

    if addOnName == "Mingus" then
      if not MingusSaved then MingusSaved = {} end
      if not MingusSaved.minimap then MingusSaved.minimap = {} end

      Mingus.LDB = LDB:NewDataObject(
        "Mythic Minus",
        {
          type = "data source",
          text = "Mythic Minus",
          icon = [[Interface\AddOns\Mingus\Media\Textures\minimap.tga]],
          OnClick = function() Mingus.window:SetShown(not Mingus.window:IsShown()) end
        }
      )
      LDBIcon:Register("Mythic Minus", Mingus.LDB, MingusSaved.minimap)

      Mingus:InitializeMainWindow()

      Mingus:MaybeShowOldAddOnWarning()
    end
  end
end)

SLASH_MINGUS1 = "/mingus"
SLASH_MINGUS2 = "/mm"

function SlashCmdList.MINGUS()
  Mingus.window:SetShown(not Mingus.window:IsShown())
end
