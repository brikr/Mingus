local _, Mingus = ...

function Mingus:CreateButton(parent, text, OnClick)
  local button = CreateFrame("Button", nil, parent)

  button:SetScript("OnClick", OnClick)

  button.texture = button:CreateTexture(nil, "BACKGROUND")
  button.texture:SetAllPoints()
  button.texture:SetColorTexture(Mingus.UITheme.primary:GetRGBA())

  local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  label:SetPoint("CENTER")
  label:SetTextColor(Mingus.UITheme.onPrimary:GetRGBA())
  label:SetText(text)
  button:SetFontString(label)

  button:SetSize(label:GetUnboundedStringWidth() + 16, 24)

  button:SetScript("OnEnter", function()
    button.texture:SetColorTexture(Mingus.UITheme.primaryHover:GetRGBA())
  end)
  button:SetScript("OnLeave", function()
    button.texture:SetColorTexture(Mingus.UITheme.primary:GetRGBA())
  end)

  return button
end
