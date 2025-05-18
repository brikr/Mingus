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

  -- obsolete auras
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
  end

  Mingus:RefreshWarningsPane()
end
