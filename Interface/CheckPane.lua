local _, Mingus = ...

local lastUpdateTime = 0
local rowHeight = 100
local dataProvider

local function ClassColorName(name)
  if not UnitExists(name) then return name end

  return string.format("|c%s%s|r", RAID_CLASS_COLORS[UnitClassBase(name)].colorStr, name)
end

local function BuildCompareString(playerCheckInfo)
  local usesAuraUpdater = false
  local notableComparisons = {}

  for name, ourAura in pairs(Mingus.wa) do
    -- Only worried about required auras we know about for now
    if not ourAura.optional and not ourAura.obsolete then
      DevTool:AddData(ourAura, "comparing")
      local displayName = ourAura.displayName or name
      local theirAura = playerCheckInfo.wa[name]
      local theirVersion = 0
      if theirAura and theirAura.version then
        theirVersion = theirAura.version
      end

      if theirVersion == "au" then
        -- Note AU use to put in final string
        usesAuraUpdater = true
      elseif theirVersion == 0 then
        -- Special case for missing
        table.insert(notableComparisons, displayName .. " not installed")
      elseif theirVersion ~= ourAura.version then
        -- Version difference case
        DevTool:AddData(theirVersion, "theirVersion")
        DevTool:AddData(ourAura.version, "our version")
        local versionDiff = theirVersion - ourAura.version
        if versionDiff > 0 then
          versionDiff = "+" .. versionDiff
        end

        table.insert(notableComparisons, displayName .. " v" .. theirVersion .. " (" .. versionDiff .. ")")
      end
    end
  end

  local rval = ""
  if usesAuraUpdater then
    rval = "AuraUpdater user! Check AU for Liquid aura status.|n"
  end
  rval = rval .. table.concat(notableComparisons, "|n")

  if rval == "" then
    rval = "All good bud :)"
  end

  return rval
end

---@param row Frame
local function PlayerCheckRowElementInitializer(row, playerCheckInfo)
  -- Create UI if it doesn't exist
  if not row.content then
    row.content = true

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    row.name:SetTextColor(Mingus.theme.onSurface:GetRGBA())
    row.name:SetPoint("TOPLEFT", row, "TOPLEFT", 16, -16)

    row.comparison = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.comparison:SetTextColor(Mingus.theme.onSurface:GetRGBA())
    row.comparison:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -16)
    row.comparison:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -16, 0)
    row.comparison:SetJustifyH("LEFT")
    row.comparison:SetJustifyV("TOP")
    row.comparison:SetWordWrap(true)
  end

  -- Set data
  row.name:SetText(ClassColorName(playerCheckInfo.name))
  row.comparison:SetText(BuildCompareString(playerCheckInfo))
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

  if checkInfo.name == GetUnitName("player") then
    -- Our own check info isn't shown in the table, but it is used as a basis for comparing others
    selfCheckInfo = checkInfo
    -- return
  end

  dataProvider:RemoveByPredicate(function(el)
    return el.name == checkInfo.name
  end)
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
