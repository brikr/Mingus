local _, Mingus = ...

local rowHeight = 40

local function AuraRowElementInitializer(row, aura)
  -- Create UI if it doesn't exist
  if not row.title then
    row.title = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    row.title:SetPoint("LEFT", row, "LEFT", 8, 0)
    row.title:SetTextColor(Mingus.theme.onSurface:GetRGBA())
  end

  -- Set data
  row.title:SetText(aura.displayName)
end

function Mingus:InitializeUpdatePane()
  local scrollFrame = CreateFrame("Frame", nil, Mingus.updatePane, "WowScrollBoxList")
  scrollFrame:SetPoint("TOPLEFT", Mingus.updatePane, "TOPLEFT")
  scrollFrame:SetPoint("BOTTOMRIGHT", Mingus.updatePane, "BOTTOMRIGHT", -24, 0)

  local scrollBar = CreateFrame("EventFrame", nil, Mingus.updatePane, "MinimalScrollBar")
  scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -8)
  scrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 24, 8)

  local dataProvider = CreateDataProvider()
  local scrollView = CreateScrollBoxListLinearView()
  scrollView:SetDataProvider(dataProvider)

  ScrollUtil.InitScrollBoxListWithScrollBar(scrollFrame, scrollBar, scrollView)

  scrollView:SetElementExtent(rowHeight)
  scrollView:SetElementInitializer("Frame", AuraRowElementInitializer)

  dataProvider:SetSortComparator(
    function(aura1, aura2)
      -- Required auras first
      if aura1.optional and not aura2.optional then
        return false
      elseif aura2.optional and not aura1.optional then
        return true
      end

      -- Then sort by name
      return aura1.displayName < aura2.displayName
    end
  )

  for _, aura in pairs(Mingus.wa) do
    -- Only show importable and non-obsolete auras
    if aura.import and not aura.obsolete then
      dataProvider:Insert(aura)
    end
  end

  -- add all WAs to dataprovider

  -- local lastRow -- used for anchoring
  -- for _, aura in pairs(Mingus.wa) do
  --   local row = CreateAuraRow(aura)
  --   if not lastRow then
  --     -- First row anchors to top of update pane
  --     row:SetPoint("TOPLEFT", Mingus.updatePane, "TOPLEFT")
  --     row:SetPoint("TOPRIGHT", Mingus.updatePane, "TOPRIGHT")
  --   else
  --     -- Subsequent rows anchor to bottom of previous row
  --     row:SetPoint("TOPLEFT", lastRow, "BOTTOMLEFT")
  --     row:SetPoint("TOPRIGHT", lastRow, "BOTTOMRIGHT")
  --   end
  --   lastRow = row
  -- end
end
