local _, Mingus = ...

function Mingus:InitializeSettingsPane()
  local nyiText = Mingus.settingsPane:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  nyiText:SetPoint("CENTER", Mingus.settingsPane, "CENTER")
  nyiText:SetTextColor(Mingus.theme.onSurface:GetRGBA())
  nyiText:SetText("Coming soon")
end
