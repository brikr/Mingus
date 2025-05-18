local _, Mingus = ...

local rowHeight = 40
local dataProvider, noWarningsText

local function WarningRowElementInitializer(row, warning)
  -- Create UI if it doesn't exist
  if not row.content then
    row.content = true

    row.container = CreateFrame("Frame", nil, row)
    row.container:SetPoint("TOPLEFT", row, "TOPLEFT", 16, -16)
    row.container:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -16, 16)

    row.text = row.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.text:SetAllPoints()
    row.text:SetJustifyH("LEFT")
    row.text:SetJustifyV("TOP")
    row.text:SetWordWrap(true)
    row.text:SetTextColor(Mingus.theme.error:GetRGBA())
  end

  -- Set data
  row.text:SetText("• " .. warning.description)
end

function Mingus:RefreshWarningsPane()
  dataProvider:Flush()
  -- add all warnings to dataprovider
  for _, warning in ipairs(Mingus.warnings) do
    dataProvider:Insert(warning)
  end

  if #Mingus.warnings == 0 then
    noWarningsText:Show()
  else
    noWarningsText:Hide()
  end
end

function Mingus:InitializeWarningsPane()
  local scrollFrame = CreateFrame("Frame", nil, Mingus.warningsPane, "WowScrollBoxList")
  scrollFrame:SetPoint("TOPLEFT", Mingus.warningsPane, "TOPLEFT")
  scrollFrame:SetPoint("BOTTOMRIGHT", Mingus.warningsPane, "BOTTOMRIGHT", -24, 0)

  local scrollBar = CreateFrame("EventFrame", nil, Mingus.warningsPane, "MinimalScrollBar")
  scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -8)
  scrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 24, 8)

  dataProvider = CreateDataProvider()
  local scrollView = CreateScrollBoxListLinearView()
  scrollView:SetDataProvider(dataProvider)

  ScrollUtil.InitScrollBoxListWithScrollBar(scrollFrame, scrollBar, scrollView)

  scrollView:SetElementExtent(rowHeight)
  scrollView:SetElementInitializer("Frame", WarningRowElementInitializer)

  noWarningsText = Mingus.warningsPane:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  noWarningsText:SetPoint("CENTER", Mingus.warningsPane, "CENTER")
  noWarningsText:SetTextColor(Mingus.theme.success:GetRGBA())
  noWarningsText:SetText("All good bud :)")

  Mingus:RefreshWarningsPane()
end
