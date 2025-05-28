local _, Mingus = ...

Mingus.warnings = {}

-- recalculate warnings
function Mingus:EnumerateWarnings()
  Mingus.warnings = {}
  -- old guild addon
  if C_AddOns.IsAddOnLoaded("MythicMinusMedia") then
    table.insert(Mingus.warnings, {
      description = "MythicMinusMedia is still installed."
    })
  end

  -- obsolete and duplicate auras
  for name, aura in pairs(Mingus.wa) do
    if aura.obsolete and Mingus:IsAuraInstalled(aura) then
      local reason = aura.displayName .. " is still installed."
      if aura.obsoleteReason then
        reason = reason .. " " .. aura.obsoleteReason
      end
      table.insert(Mingus.warnings, {
        description = reason
      })
    end

    -- duplicate auras
    -- just check if "<name> <2 / 3 /4>" is installed
    -- if they went to 5 they are unredeemable
    for i = 2, 4 do
      if WeakAuras.GetData(name .. " " .. i) then
        table.insert(Mingus.warnings, {
          description = "You have duplicate versions of " ..
              name .. " installed (e.g. \"" .. name .. " 2\"). Remove all of them and re-import via the Update tab."
        })
      end
    end
  end

  Mingus:RefreshWarningsPane()
end
