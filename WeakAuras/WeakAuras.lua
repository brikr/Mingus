local _, Mingus = ...

local installedUIDToID = {}

function Mingus:IsAuraInstalled(aura)
  if aura.auraUpdater and C_AddOns.IsAddOnLoaded("AuraUpdater") then
    -- Assume AuraUpdater got our back
    return true
  end

  return installedUIDToID[aura.uid] ~= nil
end

function Mingus:IsAuraUpToDate(aura)
  if aura.auraUpdater and C_AddOns.IsAddOnLoaded("AuraUpdater") then
    -- Assume AuraUpdater got our back
    return true
  end

  local installedVersion = WeakAuras.GetData(installedUIDToID[aura.uid]).version
  return installedVersion >= aura.version
end

function Mingus:ImportAura(aura)
  WeakAuras.Import(
    aura.import,
    nil,
    function(success, id)
      if not success then return end

      installedUIDToID[aura.uid] = id
    end
  )
end

function Mingus:InitializeWeakAuras()
  -- merge metadata with imported data
  for name, metadata in pairs(Mingus.waMetadata) do
    if Mingus.wa[name] then
      for mdKey, mdValue in pairs(Mingus.waMetadata[name]) do
        Mingus.wa[name][mdKey] = mdValue
      end
    else
      -- No imported data, metadata only
      Mingus.wa[name] = metadata
    end
  end

  -- set displayName on all auras
  for name, aura in pairs(Mingus.wa) do
    if not aura.displayName then aura.displayName = name end
  end

  -- maintain mapping of aura UID to ID (local display name)
  if WeakAuras and WeakAurasSaved and WeakAurasSaved.displays then
    for id, auraData in pairs(WeakAurasSaved.displays) do
      installedUIDToID[auraData.uid] = id
    end

    hooksecurefunc(
      WeakAuras,
      "Add",
      function(data)
        local uid = data.uid

        if uid then
          installedUIDToID[uid] = data.id
        end
      end
    )

    hooksecurefunc(
      WeakAuras,
      "Rename",
      function(data, newID)
        local uid = data.uid

        if uid then
          installedUIDToID[uid] = newID
        end
      end
    )

    hooksecurefunc(
      WeakAuras,
      "Delete",
      function(data)
        local uid = data.uid

        if uid then
          installedUIDToID[uid] = nil
        end
      end
    )
  end
end
