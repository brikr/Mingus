local _, Mingus = ...

-- Debug: make Mingus global so I can /dump it
_G["Mingus"] = Mingus

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local addOnName = ...

    if addOnName == "Mingus" then
      if not MingusSaved then MingusSaved = {} end

      Mingus:InitializeMinimapIcon()

      Mingus:InitializeWeakAuras()
      Mingus:InitializeMainWindow()

      Mingus:EnumerateWarnings()

      Mingus:MaybeShowOldAddOnWarning()
    end
  elseif event == "PLAYER_LOGIN" then
    -- LibDBIcon updates icon visibility with this event which would typically override the hideWhenUpToDate setting, so
    -- we need to update via this event as well
    Mingus:UpdateMinimapIcon()
  end
end)

SLASH_MINGUS1 = "/mingus"
SLASH_MINGUS2 = "/mm"
SLASH_MINGUSCENTER1 = "/wheremingus"
SLASH_MINGUSIMPORT1 = "/mmi"

function SlashCmdList.MINGUS()
  Mingus.window:SetShown(not Mingus.window:IsShown())
end

function SlashCmdList.MINGUSCENTER()
  -- Adding this before anyone accidentally drags the window off their monitor and can't find it
  Mingus.window:ClearAllPoints()
  Mingus.window:SetPoint("CENTER")
  Mingus.window:SetShown(true)
end

function SlashCmdList.MINGUSIMPORT(auraId)
  if Mingus.wa[auraId] then
    Mingus:ImportAura(Mingus.wa[auraId])
  else
    print("Aura " .. auraId .. " not found")
  end
end
