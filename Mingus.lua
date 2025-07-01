local _, Mingus = ...

--@debug@
-- Debug: make Mingus global so I can /dump it
_G["Mingus"] = Mingus
--@end-debug@

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local addOnName = ...

    if addOnName == "Mingus" then
      if not MingusSaved then MingusSaved = {} end
      -- Minimap icon before anything else since things in WeakAuras.lua hook into it
      Mingus:InitializeMinimapIcon()

      -- Packaged WA parsing and installed WA utility
      Mingus:InitializeWeakAuras()

      -- UI
      Mingus:InitializeMainWindow()

      -- Calling the aforementioned installed WA utility
      Mingus:EnumerateWarnings()
      Mingus:UpdateMinimapIcon()

      -- Ready to listen/send
      Mingus:InitializeComms()

      -- Warn about old addon
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
