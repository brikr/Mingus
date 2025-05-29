local _, Mingus = ...

local lastUpdateTime = 0
local rowHeight = 100
local dataProvider


---@param row Frame
local function PlayerCheckRowElementInitializer(row, playerCheckInfo)
  if not row.content then
    row.content = true

    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.text:SetAllPoints()
  end
end

local function RequestVersionCheckThrottled()
  local time = GetTime()
  if time - lastUpdateTime > 5 then
    lastUpdateTime = time

    Mingus:RequestVersionCheck()
  end
end

function Mingus:InsertIntoCheckPaneTable(checkInfo)
  lastUpdateTime = GetTime()
  DevTool:AddData(checkInfo, "checkInfo " .. checkInfo.name)
  dataProvider:Insert(checkInfo)
end

function Mingus:InitializeCheckPane()
  local fetchButton = Mingus:CreateButton(Mingus.checkPane, "Fetch", RequestVersionCheckThrottled)
  fetchButton:SetPoint("TOPLEFT", Mingus.checkPane, "TOPLEFT", 8, -8)

  local scrollFrame = CreateFrame("Frame", nil, Mingus.checkPane, "WowScrollBoxList")
  scrollFrame:SetPoint("TOPLEFT", fetchButton, "BOTTOMLEFT", 0, -8)
  scrollFrame:SetPoint("BOTTOMRIGHT", Mingus.checkPane, "BOTTOMRIGHT", -24, 0)

  local scrollBar = CreateFrame("EventFrame", nil, Mingus.checkPane, "MinimalScrollBar")
  scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -8)
  scrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 24, 8)
  scrollBar:SetHideIfUnscrollable(true)

  dataProvider = CreateDataProvider()
  local scrollView = CreateScrollBoxListLinearView()
  scrollView:SetDataProvider(dataProvider)

  ScrollUtil.InitScrollBoxListWithScrollBar(scrollFrame, scrollBar, scrollView)

  scrollView:SetElementExtent(rowHeight)
  scrollView:SetElementInitializer("Frame", PlayerCheckRowElementInitializer)

  dataProvider:SetSortComparator(
    function(info1, info2)
      return info1.name > info2.name
    end
  )
end
