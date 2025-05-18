local _, Mingus = ...

function Mingus:CreateCheckbox(parent, label, OnValueChanged, initialValue)
  local checkbox = CreateFrame("Button", nil, parent)

  checkbox:SetSize(24, 24)

  checkbox.texture = checkbox:CreateTexture(nil, "BACKGROUND")
  checkbox.texture:SetAllPoints()
  checkbox.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())

  checkbox.highlight = checkbox:CreateTexture(nil, "HIGHLIGHT")
  checkbox.highlight:SetAllPoints()
  checkbox.highlight:SetColorTexture(Mingus.theme.highlight:GetRGBA())

  checkbox.mark = checkbox:CreateTexture(nil, "OVERLAY")
  checkbox.mark:SetAllPoints()
  checkbox.mark:SetAtlas("common-icon-checkmark-yellow")
  checkbox.mark:SetShown(initialValue)

  local checked = initialValue
  checkbox:SetScript("OnClick", function()
    checked = not checked
    checkbox.mark:SetShown(checked)
    OnValueChanged(checked)
  end)

  checkbox.label = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  checkbox.label:SetPoint("LEFT", checkbox, "RIGHT", 8, 0)
  checkbox.label:SetTextColor(Mingus.theme.onSurface:GetRGBA())
  checkbox.label:SetText(label)

  return checkbox
end
