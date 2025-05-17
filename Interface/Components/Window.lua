local _, Mingus = ...

function Mingus:CreateWindow()
  local window = CreateFrame("Frame", nil, UIParent)

  window.background = window:CreateTexture(nil, "OVERLAY")
  window.background:SetAllPoints()
  window.background:SetTexture("Interface/Buttons/WHITE8x8")
  window.background:SetColorTexture(Mingus.theme.surface:GetRGBA())

  window:EnableMouse(true)

  return window
end
