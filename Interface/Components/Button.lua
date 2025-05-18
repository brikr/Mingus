local _, Mingus = ...

function Mingus:CreateButton(parent, text, OnClick)
  local button = CreateFrame("Button", nil, parent)

  button:SetScript("OnClick", OnClick)

  button.texture = button:CreateTexture(nil, "BACKGROUND")
  button.texture:SetAllPoints()
  button.texture:SetColorTexture(Mingus.theme.primary:GetRGBA())

  button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
  button.highlight:SetAllPoints()
  button.highlight:SetColorTexture(Mingus.theme.highlight:GetRGBA())

  local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  label:SetPoint("CENTER")
  label:SetTextColor(Mingus.theme.onPrimary:GetRGBA())
  label:SetText(text)
  button:SetFontString(label)

  button:SetSize(label:GetUnboundedStringWidth() + 16, 24)

  function button:SetText(text)
    label:SetText(text)
    button:SetSize(label:GetUnboundedStringWidth() + 16, 24)
  end

  return button
end
