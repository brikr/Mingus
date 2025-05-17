local _, Mingus = ...

-- Metadata about WAs we import:
-- auraUpdater: if true, this addon will assume it's up to date if AuraUpdater is installed
-- obsolete: if true, a warning should show if the WA is installed
-- displayName: alternate name when showing the WA in tables etc.
-- optional: if true, the WA will not show as out of date if it's not installed. it will still show as out of date if
--           it's installed and not up to date

-- Metadata is merged with the imported data. there might be WAs that only have metadata and don't have import strings
-- (e.g. obsolete ones)

local waMetadata = {
  -- Liquid
  ["LiquidWeakAuras"] = {
    auraUpdater = true,
  },
  ["Liquid - Liberation of Undermine"] = {
    auraUpdater = true,
  },
  ["Liquid Anchors (don't rename these)"] = {
    auraUpdater = true,
    displayName = "Liquid Anchors",
  },
  -- Northern Sky we want to keep
  ["Northern Sky - Database & Functions"] = {
    optional = true,
  },
  ["Northern Sky Externals"] = {
    optional = true,
  },
  ["External Alert / Spell Requests (Power Infusion Innervate etc.)"] = {
    displayName = "Northern Sky Externals Alert",
    optional = true,
  },
  -- Other utilities
  ["Kaze MRT Timers (Retail+Classic)"] = {
    displayName = "Kaze MRT Timers",
    optional = true,
  },
  ["Interrupt Anchor - All Bosses"] = {
    displayName = "Interrupt Anchor",
  },
  -- Obsolete
  ["Mythic- Core"] = {
    obsolete = true,
  },
  ["Liberation of Undermine"] = {
    displayName = "Reloe Liberation of Undermine",
    obsolete = true,
  },
  ["Northern Sky Liberation of Undermine"] = {
    obsolete = true,
  },
}

for name, metadata in pairs(waMetadata) do
  if Mingus.wa[name] then
    for mdKey, mdValue in pairs(waMetadata[name]) do
      Mingus.wa[name][mdKey] = mdValue
    end
  else
    -- No imported data, metadata only
    Mingus.wa[name] = metadata
  end
end
