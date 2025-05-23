local addOnName, Mingus = ...

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

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

  local data = WeakAuras.GetData(installedUIDToID[aura.uid])
  if not data then return false end
  local installedVersion = data.version
  return installedVersion >= aura.version
end

-- Populate the check info used by group checker
function Mingus:GetVersionCheckInfo()
  local checkInfo = {
    mingus = {
      version = C_AddOns.GetAddOnMetadata(addOnName, "version"),
    },
    wa = {},
  }

  for name, aura in pairs(Mingus.wa) do
    if not aura.obsolete then
      if aura.auraUpdater and C_AddOns.IsAddOnLoaded("AuraUpdater") then
        checkInfo.wa[name] = {
          version = "au"
        }
      else
        local waData = WeakAuras.GetData(installedUIDToID[aura.uid])
        local version = 0
        if waData then
          version = waData.version
        end

        checkInfo.wa[name] = {
          version = version
        }
      end
    end
  end

  return checkInfo
end

-- If the installed version of this aura has any Load: Never or sound actions, copy them to the one being imported
-- Makes imports a bit smoother with fewer checkboxes needing changed by the updater
-- If an aura has "forceenable" in its description, it keeps it loaded (e.g. LiquidWeakAuras)
local function FixupAuraSettings(newAuraData, installedAuraData)
  if not installedAuraData then return end

  -- "Load" options
  if installedAuraData.load and not (installedAuraData.regionType == "group" or installedAuraData.regionType == "dynamicgroup") then
    newAuraData.load.use_never = installedAuraData.load.use_never

    if newAuraData.desc and type(newAuraData.desc) == "string" and newAuraData.desc:match("forceenable") then
      newAuraData.load.use_never = nil
    end
  end

  -- "Action" options
  if installedAuraData.actions then
    local start = installedAuraData.actions.start
    local finish = installedAuraData.actions.finish

    -- "On show" sounds
    if start then
      if not newAuraData.actions.start then newAuraData.actions.start = {} end

      newAuraData.actions.start.sound = start.sound
      newAuraData.actions.start.sound_channel = start.sound_channel
      newAuraData.actions.start.sound_repeat = start.sound_repeat
      newAuraData.actions.start.do_sound = start.do_sound
      newAuraData.actions.start.do_loop = start.do_loop
    end

    -- "On hide" sounds
    if finish then
      if not newAuraData.actions.finish then newAuraData.actions.finish = {} end

      newAuraData.actions.finish.sound = finish.sound
      newAuraData.actions.finish.sound_channel = finish.sound_channel
      newAuraData.actions.finish.do_sound = finish.do_sound
      newAuraData.actions.finish.do_sound_fade = finish.do_sound_fade
      newAuraData.actions.finish.stop_sound = finish.stop_sound
      newAuraData.actions.finish.stop_sound_fade = finish.stop_sound_fade
    end
  end
end

-- Converts a WA import string to table data
-- Cutting some corners and assuming that it's a modern import string rather than doing all the corner-casey stuff that
-- WeakAuras addon would do. This will break if WeakAuras bumps their encoding version
local function ParseImportString(import)
  local encoded = import:match("!WA:2!(.+)")
  if not encoded then return nil end

  local compressed = LibDeflate:DecodeForPrint(encoded)
  if not compressed then return nil end

  local serialized = LibDeflate:DecompressDeflate(compressed)
  if not serialized then return nil end

  local success, data = LibSerialize:Deserialize(serialized)
  if not success then return nil end

  return data
end

function Mingus:ImportAura(aura, callbackFunc)
  local installedAuraData = WeakAuras.GetData(installedUIDToID[aura.uid])
  local newAura = ParseImportString(aura.import)

  FixupAuraSettings(newAura.d, installedAuraData)

  -- Fix settings for children, too
  -- Note: WeakAuras children are not recursive; every subchild is under the c field of the parent. The actual tree is
  -- tracked via the parent field on auras
  if newAura.c then
    for _, newAuraChildData in pairs(newAura.c) do
      local installedAuraChildData = WeakAuras.GetData(installedUIDToID[newAuraChildData.uid])
      FixupAuraSettings(newAuraChildData, installedAuraChildData)
    end
  end

  WeakAuras.Import(
    newAura,
    nil,
    function(success, id)
      if not success then return end

      installedUIDToID[aura.uid] = id
      callbackFunc(id)
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
          Mingus:RefreshUpdatePaneEntry(uid)
        end
        Mingus:EnumerateWarnings()
        Mingus:UpdateMinimapIcon()
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
          Mingus:RefreshUpdatePaneEntry(uid)
        end
        Mingus:EnumerateWarnings()
        Mingus:UpdateMinimapIcon()
      end
    )
  end
end
