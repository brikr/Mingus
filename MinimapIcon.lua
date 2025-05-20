local _, Mingus = ...

local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

-- returns true if any required auras are either out of date or not installed
local function AreUpdatesRequired()
  for name, aura in pairs(Mingus.wa) do
    if not aura.optional and not aura.obsolete then
      if not Mingus:IsAuraUpToDate(aura) then
        print("updates required because", aura.displayName)
        return true
      end
    end
  end
  return false
end

local function AreWarningsPresent()
  return #Mingus.warnings > 0
end

-- sets the minimap icon state based on updates required / warnings
function Mingus:UpdateMinimapIcon()
  if AreWarningsPresent() then
    Mingus.LDB.icon = [[Interface\AddOns\Mingus\Media\Textures\minimap_warning.tga]]
    LDBIcon:Show("Mythic Minus")
  elseif AreUpdatesRequired() then
    Mingus.LDB.icon = [[Interface\AddOns\Mingus\Media\Textures\minimap_update.tga]]
    LDBIcon:Show("Mythic Minus")
  else
    Mingus.LDB.icon = [[Interface\AddOns\Mingus\Media\Textures\minimap.tga]]
    if MingusSaved.minimap.hideWhenUpToDate then
      LDBIcon:Hide("Mythic Minus")
    else
      LDBIcon:Show("Mythic Minus")
    end
  end
end

function Mingus:InitializeMinimapIcon()
  if not MingusSaved.minimap then MingusSaved.minimap = {} end

  Mingus.LDB = LDB:NewDataObject(
    "Mythic Minus",
    {
      type = "data source",
      text = "Mythic Minus",
      icon = [[Interface\AddOns\Mingus\Media\Textures\minimap.tga]],
      OnClick = function() Mingus.window:SetShown(not Mingus.window:IsShown()) end
    }
  )
  LDBIcon:Register("Mythic Minus", Mingus.LDB, MingusSaved.minimap)
end
