local _, Mingus = ...

local rowHeight = 80
local dataProvider

local function GetAuraButtonText(aura)
  if not Mingus:IsAuraInstalled(aura) then
    return "Install"
  elseif not Mingus:IsAuraUpToDate(aura) then
    return "Update"
  else
    return nil -- show "up to date" text
  end
end

local function HandleAuraButtonClick(aura)
  Mingus:ImportAura(aura, function()
    Mingus:RefreshUpdatePaneEntry(aura.uid)
    Mingus:EnumerateWarnings()
    Mingus:UpdateMinimapIcon()
  end)
end

local function AuraRowElementInitializer(row, aura)
  -- Create UI if it doesn't exist
  if not row.content then
    row.content = true

    row.infoContainer = CreateFrame("Frame", nil, row)
    row.infoContainer.title = row.infoContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    row.infoContainer.title:SetPoint("TOPLEFT", row.infoContainer, "TOPLEFT", 0, 0)
    row.infoContainer.title:SetTextColor(Mingus.theme.onSurface:GetRGBA())
    row.infoContainer.description = row.infoContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.infoContainer.description:SetPoint("TOPLEFT", row.infoContainer.title, "BOTTOMLEFT", 0, -8)
    row.infoContainer.description:SetPoint("BOTTOMRIGHT", row.infoContainer, "BOTTOMRIGHT")
    row.infoContainer.description:SetJustifyH("LEFT")
    row.infoContainer.description:SetJustifyV("TOP")
    row.infoContainer.description:SetWordWrap(true)
    row.infoContainer.description:SetTextColor(Mingus.theme.onSurface:GetRGBA())

    row.installContainer = CreateFrame("Frame", nil, row)
    row.installContainer.button = Mingus:CreateButton(row.installContainer, "")
    row.installContainer.button:SetPoint("RIGHT", row.installContainer, "RIGHT")
    row.installContainer.upToDate = row.installContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.installContainer.upToDate:SetPoint("RIGHT", row.installContainer, "RIGHT")
    row.installContainer.upToDate:SetTextColor(Mingus.theme.success:GetRGBA())
    row.installContainer.upToDate:SetText("Up to date")
    row.installContainer:SetHeight(rowHeight)
    row.installContainer:SetWidth(100)

    row.infoContainer:SetPoint("LEFT", row, "LEFT", 16, 0)
    row.infoContainer:SetPoint("RIGHT", row.installContainer, "LEFT", -8, 0)
    row.installContainer:SetPoint("RIGHT", row, "RIGHT", -16, 0)
  end

  -- Set data
  row.infoContainer.title:SetText(aura.displayName)
  local requiredText = aura.optional and "(Optional) " or "(Required) "
  row.infoContainer.description:SetText(requiredText .. aura.description)
  local titleHeight = row.infoContainer.title:GetStringHeight()
  local descHeight = row.infoContainer.description:GetStringHeight()
  row.infoContainer:SetHeight(titleHeight + descHeight + 8)

  local installText = GetAuraButtonText(aura)
  if installText then
    row.installContainer.button:SetText(installText)
    row.installContainer.button:SetScript("OnClick", function() HandleAuraButtonClick(aura) end)
    row.installContainer.button:Show()
    row.installContainer.upToDate:Hide()
  else
    row.installContainer.button:Hide()
    row.installContainer.upToDate:SetText("Up to date (v" .. aura.version .. ")")
    row.installContainer.upToDate:Show()
  end
end

-- remove then re-add so it re-draws. seems hacky but i couldn't find another way
function Mingus:RefreshUpdatePaneEntry(uid)
  local aura
  dataProvider:RemoveByPredicate(function(data)
    if data.uid == uid then
      aura = data
      return true
    end
    return false
  end)
  if aura then dataProvider:Insert(aura) end
end

function Mingus:InitializeUpdatePane()
  local scrollFrame = CreateFrame("Frame", nil, Mingus.updatePane, "WowScrollBoxList")
  scrollFrame:SetPoint("TOPLEFT", Mingus.updatePane, "TOPLEFT")
  scrollFrame:SetPoint("BOTTOMRIGHT", Mingus.updatePane, "BOTTOMRIGHT", -24, 0)

  local scrollBar = CreateFrame("EventFrame", nil, Mingus.updatePane, "MinimalScrollBar")
  scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -8)
  scrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 24, 8)

  dataProvider = CreateDataProvider()
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

  -- add all WAs to dataprovider
  for _, aura in pairs(Mingus.wa) do
    -- Only show importable and non-obsolete auras
    if aura.import and not aura.obsolete then
      dataProvider:Insert(aura)
    end
  end
end
