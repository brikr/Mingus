local _, Mingus = ...

-- Metadata about WAs we import:
-- auraUpdater: if true, this addon will assume it's up to date if AuraUpdater is installed
-- obsolete: if true, a warning should show if the WA is installed
-- displayName: alternate name when showing the WA in tables etc.
-- optional: if true, the WA will not show as out of date if it's not installed. it will still show as out of date if
--           it's installed and not up to date

-- Metadata is merged with the imported data. there might be WAs that only have metadata and don't have import strings
-- (e.g. obsolete ones)

Mingus.waMetadata = {
  -- Liquid
  ["LiquidWeakAuras"] = {
    description = "Libraries and shared functions used by Liquid stuff",
    auraUpdater = true,
  },
  ["Liquid - Nerub-ar Palace"] = {
    description = "Liquid's Nerub-ar Palace pack. This is only needed if you're doing Nerub-ar Palace sales.",
    optional = true,
  },
  ["Liquid - Liberation of Undermine"] = {
    description =
    "Liquid's Undermine pack. Contains both assignments and mechanic auras. The mechanic auras are set to Load: Never by default.",
    optional = true,
    auraUpdater = true,
  },
  ["Liquid - Manaforge Omega"] = {
    description = "Liquid's Manaforge Omega pack. Contains both assignments and mechanic auras. The mechanic auras are set to Load: Never by default.",
    auraUpdater = true,
  },
  ["Liquid - Raid Anchors"] = {
    displayName = "Liquid Anchors",
    description =
    "Anchors for Liquid raid auras. Use these to change where you want Liquid auras to show on your screen.",
    auraUpdater = true,
    atrocity = true,
  },
  -- Northern Sky we want to keep
  ["Northern Sky - Database & Functions"] = {
    description =
    "Libraries and shared functions used by Northern Sky stuff. This is only needed if you use the External alert/request auras.",
    optional = true,
  },
  ["Northern Sky Externals"] = {
    description = "Lets you request an external via a macro. This is only needed if the fight we're on relies on it.",
    optional = true,
  },
  ["External Alert / Spell Requests (Power Infusion Innervate etc.)"] = {
    displayName = "Northern Sky Externals Alert",
    description =
    "Lets you receive external requests from macro pushers. This is only needed if the fight we're on relies on it and you are a healer or paladin.",
    optional = true,
  },
  -- Other utilities
  ["Kaze MRT Timers (Retail+Classic)"] = {
    displayName = "Kaze MRT Timers",
    description =
    "Shows text/icon popups during combat based on MRT note assignments. If you use TimelineReminders or the functionality built into MRT, you don't need this.",
    optional = true,
  },
  ["Interrupt Anchor - All Bosses"] = {
    displayName = "Interrupt Anchor",
    description = "Supports interrupt assignments via MRT note.",
    atrocity = true,
  },
  -- Obsolete
  ["M- Undermine"] = {
    description = "Guild-specific Undermine pack. Only contains convenience auras in Undermine.",
    obsolete = true,
    obsoleteReason = "We no longer require or maintain any of the auras in this pack.",
  },
  ["Mythic- Core"] = {
    uid = "brII87rOnHy",
    obsolete = true,
    obsoleteReason = "We no longer require or maintain any of the auras in this pack."
  },
  -- Don't want to mark this obsolete because it's technically fine to use it and just not use the mechanical auras in
  -- Liquid pack. Will mark obsolete next patch.
  -- ["Liberation of Undermine"] = {
  --   displayName = "Reloe Liberation of Undermine",
  --   obsolete = true,
  --   obsoleteReason = "Consider switching to Liquid auras for mechanical auras."
  -- },
  ["Northern Sky Liberation of Undermine"] = {
    uid = "iXVEQvJZNKR",
    obsolete = true,
    obsoleteReason = "We are using Liquid auras for assignments now."
  },
}
