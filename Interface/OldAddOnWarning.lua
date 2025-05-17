local _, Mingus = ...

local width = 300
local height = 140
local window, disableButton

local function DisableOldAddOn()
  C_AddOns.DisableAddOn("MythicMinusMedia")
  C_UI.Reload()
end

-- Shows a warning about the old guild addon if it's installed
function Mingus:MaybeShowOldAddOnWarning()
  if C_AddOns.IsAddOnLoaded("MythicMinusMedia") then
    window = Mingus:CreateWindow()

    window:SetWidth(width)
    window:SetHeight(height)
    window:SetFrameStrata("DIALOG")
    window:SetIgnoreParentAlpha(true)
    window:SetPoint("CENTER", UIParent, "CENTER", 0, height / 2)

    disableButton = Mingus:CreateButton(window, "Disable and reload", DisableOldAddOn)
    disableButton:SetPoint("BOTTOM", window, "BOTTOM", 0, 8)

    text = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetPoint("TOP", window, "TOP", 0, -8)
    text:SetWordWrap(true)
    text:SetWidth(width - 16)
    text:SetText(
      "The old guild addon, MythicMinusMedia, is still active and will fuck your shit up if you have both.|n|nUninstall or disable it.")
    text:SetTextColor(Mingus.UITheme.onSurface:GetRGBA())

    window:Show()
  end
end
