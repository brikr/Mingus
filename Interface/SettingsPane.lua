local _, Mingus = ...

function Mingus:InitializeSettingsPane()
  local minimapCheck = Mingus:CreateCheckbox(
    Mingus.settingsPane,
    "Hide minimap icon when auras are up to date",
    function(checked)
      MingusSaved.minimap.hideWhenUpToDate = checked
      Mingus:UpdateMinimapIcon()
    end,
    MingusSaved.minimap.hideWhenUpToDate
  )

  minimapCheck:SetPoint("TOPLEFT", Mingus.settingsPane, "TOPLEFT", 16, -16)
end
