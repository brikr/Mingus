local _, Mingus = ...

function Mingus:CreateButton(parent, text, OnClick, variant)
  if not variant then variant = "primary" end

  local button = CreateFrame("Button", nil, parent)

  button.backgroundColor = Mingus.UITheme.primary

  button:SetScript("OnClick", OnClick)

  button.texture = button:CreateTexture(nil, "BACKGROUND")
  button.texture:SetAllPoints()
  button.texture:SetColorTexture(button.backgroundColor:GetRGBA())

  button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
  button.highlight:SetAllPoints()
  button.highlight:SetColorTexture(Mingus.UITheme.highlight:GetRGBA())

  local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  label:SetPoint("CENTER")
  label:SetTextColor(Mingus.UITheme.onPrimary:GetRGBA())
  label:SetText(text)
  button:SetFontString(label)

  button:SetSize(label:GetUnboundedStringWidth() + 16, 24)

  return button
end
