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

      -- TODO: minimap icon

      Mingus:InitializeInterface()

      Mingus:MaybeShowOldAddOnWarning()
    end
  end
end)

SLASH_MINGUS1 = "/mingus"
SLASH_MINGUS2 = "/mm"

function SlashCmdList.MINGUS()
  -- TODO: show main window
end
