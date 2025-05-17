local _, Mingus = ...

local width = 640
local height = 400

local function ShowPane(pane)
  Mingus.updatePane:Hide()
  Mingus.checkPane:Hide()
  Mingus.settingsPane:Hide()
  if pane == "update" then
    Mingus.updatePane:Show()
  elseif pane == "check" then
    Mingus.checkPane:Show()
  elseif pane == "settings" then
    Mingus.settingsPane:Show()
  end
end

function Mingus:InitializeMainWindow()
  Mingus.window = Mingus:CreateWindow()
  Mingus.window:SetFrameStrata("HIGH")
  Mingus.window:SetPoint("CENTER")
  Mingus.window:SetSize(width, height)
  Mingus.window:Hide()

  local tabFrame = CreateFrame("Frame", nil, Mingus.window)
  tabFrame:SetPoint("TOPLEFT", Mingus.window, "TOPLEFT")
  tabFrame:SetPoint("TOPRIGHT", Mingus.window, "TOPRIGHT")
  tabFrame:SetHeight(40)
  tabFrame.background = tabFrame:CreateTexture(nil, "ARTWORK")
  tabFrame.background:SetAllPoints()
  tabFrame.background:SetTexture("Interface/Buttons/WHITE8x8")
  tabFrame.background:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())

  local updateTab = Mingus:CreateButton(Mingus.window, "Update", function() ShowPane("update") end)
  updateTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  updateTab:SetPoint("TOPLEFT", Mingus.window, "TOPLEFT", 8, -8)

  local checkTab = Mingus:CreateButton(Mingus.window, "Group check", function() ShowPane("check") end)
  checkTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  checkTab:SetPoint("TOPLEFT", updateTab, "TOPRIGHT", 8, 0)

  local settingsTab = Mingus:CreateButton(Mingus.window, "Settings", function() ShowPane("settings") end)
  settingsTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  settingsTab:SetPoint("TOPLEFT", checkTab, "TOPRIGHT", 8, 0)

  Mingus.updatePane = CreateFrame("Frame", nil, Mingus.window)
  Mingus.updatePane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.updatePane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")
  Mingus.updatePane:Show()

  Mingus.checkPane = CreateFrame("Frame", nil, Mingus.window)
  Mingus.checkPane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.checkPane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")
  Mingus.checkPane:Hide()

  Mingus.settingsPane = CreateFrame("Frame", nil, Mingus.window)
  Mingus.settingsPane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.settingsPane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")
  Mingus.settingsPane:Hide()

  Mingus.window:SetScript(
    "OnKeyDown",
    function(_, key)
      if InCombatLockdown() then return end

      if key == "ESCAPE" then
        Mingus.window:SetPropagateKeyboardInput(false)
        Mingus.window:Hide()
      else
        Mingus.window:SetPropagateKeyboardInput(true)
      end
    end
  )
end
