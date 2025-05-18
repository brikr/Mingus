local _, Mingus = ...

local width = 640
local height = 400

local function ShowPane(pane)
  Mingus.updatePane:Hide()
  Mingus.warningsPane:Hide()
  Mingus.checkPane:Hide()
  Mingus.settingsPane:Hide()
  if pane == "update" then
    Mingus.updatePane:Show()
  elseif pane == "warnings" then
    Mingus.warningsPane:Show()
  elseif pane == "check" then
    Mingus.checkPane:Show()
  elseif pane == "settings" then
    Mingus.settingsPane:Show()
  end
end

function Mingus:InitializeMainWindow()
  Mingus.window = Mingus:CreateWindow("MingusMainWindow")
  Mingus.window:SetFrameStrata("HIGH")
  Mingus.window:SetPoint("CENTER")
  Mingus.window:SetSize(width, height)
  Mingus.window:Hide()

  local tabFrame = CreateFrame("Frame", "MingusTabFrame", Mingus.window)
  tabFrame:SetPoint("TOPLEFT", Mingus.window, "TOPLEFT")
  tabFrame:SetPoint("TOPRIGHT", Mingus.window, "TOPRIGHT")
  tabFrame:SetHeight(40)
  tabFrame.background = tabFrame:CreateTexture(nil, "ARTWORK")
  tabFrame.background:SetAllPoints()
  tabFrame.background:SetTexture("Interface/Buttons/WHITE8x8")
  tabFrame.background:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())

  local updateTab = Mingus:CreateButton(tabFrame, "Update", function() ShowPane("update") end)
  updateTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  updateTab:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 8, -8)

  local warningsTab = Mingus:CreateButton(tabFrame, "Warnings", function() ShowPane("warnings") end)
  warningsTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  warningsTab:SetPoint("TOPLEFT", updateTab, "TOPRIGHT", 8, 0)

  -- TODO
  -- local checkTab = Mingus:CreateButton(tabFrame, "Group check", function() ShowPane("check") end)
  -- checkTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  -- checkTab:SetPoint("TOPLEFT", updateTab, "TOPRIGHT", 8, 0)

  local settingsTab = Mingus:CreateButton(tabFrame, "Settings", function() ShowPane("settings") end)
  settingsTab.texture:SetColorTexture(Mingus.theme.surfaceContainer:GetRGBA())
  settingsTab:SetPoint("TOPLEFT", warningsTab, "TOPRIGHT", 8, 0)

  Mingus.updatePane = CreateFrame("Frame", "MingusUpdatePane", Mingus.window)
  Mingus.updatePane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.updatePane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")

  Mingus.warningsPane = CreateFrame("Frame", "MingusWarningsPane", Mingus.window)
  Mingus.warningsPane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.warningsPane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")

  Mingus.checkPane = CreateFrame("Frame", "MingusCheckPane", Mingus.window)
  Mingus.checkPane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.checkPane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")

  Mingus.settingsPane = CreateFrame("Frame", "MingusSettingsPane", Mingus.window)
  Mingus.settingsPane:SetPoint("TOPLEFT", tabFrame, "BOTTOMLEFT")
  Mingus.settingsPane:SetPoint("BOTTOMRIGHT", Mingus.window, "BOTTOMRIGHT")

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

  Mingus:InitializeUpdatePane()
  Mingus:InitializeWarningsPane()
  Mingus:InitializeSettingsPane()

  Mingus.updatePane:Show()
  Mingus.warningsPane:Hide()
  Mingus.checkPane:Hide()
  Mingus.settingsPane:Hide()
end
