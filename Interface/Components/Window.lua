local _, Mingus = ...

function Mingus:CreateWindow(name)
  local window = CreateFrame("Frame", name, UIParent)

  window.background = window:CreateTexture(nil, "OVERLAY")
  window.background:SetAllPoints()
  window.background:SetTexture("Interface/Buttons/WHITE8x8")
  window.background:SetColorTexture(Mingus.theme.surface:GetRGBA())

  window:EnableMouse(true)

  return window
end
