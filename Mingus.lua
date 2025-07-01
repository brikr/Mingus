local _, Mingus = ...

-- Debug: make Mingus global so I can /dump it
_G["Mingus"] = Mingus

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local addOnName = ...

    if addOnName == "Mingus" then
      if not MingusSaved then MingusSaved = {} end

      Mingus:InitializeMinimapIcon()

      Mingus:InitializeWeakAuras()
      Mingus:InitializeMainWindow()

      Mingus:EnumerateWarnings()
      Mingus:UpdateMinimapIcon()

      Mingus:MaybeShowOldAddOnWarning()
    end
  end
end)

SLASH_MINGUS1 = "/mingus"
SLASH_MINGUS2 = "/mm"
SLASH_MINGUSCENTER1 = "/wheremingus"

function SlashCmdList.MINGUS()
  Mingus.window:SetShown(not Mingus.window:IsShown())
end

function SlashCmdList.MINGUSCENTER()
  -- Adding this before anyone accidentally drags the window off their monitor and can't find it
  Mingus.window:ClearAllPoints()
  Mingus.window:SetPoint("CENTER")
  Mingus.window:SetShown(true)
end
