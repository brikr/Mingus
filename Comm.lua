local _, Mingus = ...

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")
local AceComm = LibStub("AceComm-3.0")

--@debug@
-- Some sample version check table response for testing
local sampleCheckInfo = {
  name = "Qm",
  mingus = { version = "1.0.13" },
  wa = {
    -- AU-maintained aura
    ["LiquidWeakAuras"] = {
      version = "au"
    },
    -- Undermine is installed but out of date
    ["Liquid - Liberation of Undermine"] = {
      version = "20"
    },
    -- Liquid Anchors is required but not installed
    -- Northern Sky DB is optional but included
    ["Northern Sky - Database & Functions"] = {
      version = 10
    },
  }
}
--@end-debug@

local function ReceiveVersionCheckTable(_, msg, _, sender)
  -- Don't be doin cpu things while in combat
  if InCombatLockdown() then return end

  local compressed = LibDeflate:DecodeForWoWAddonChannel(msg)
  if not compressed then return end

  local serialized = LibDeflate:DecompressDeflate(compressed)
  if not serialized then return end

  local success, checkInfo = LibSerialize:Deserialize(serialized)
  if not success then return end

  checkInfo.name = sender
  Mingus:InsertIntoCheckPaneTable(checkInfo)
end

local function SendVersionCheckTable()
  -- Don't be doin cpu things while in combat
  if InCombatLockdown() then return end

  local checkInfo = Mingus:GetVersionCheckInfo()

  local serialized = LibSerialize:Serialize(checkInfo)
  local compressed = LibDeflate:CompressDeflate(serialized)
  local msg = LibDeflate:EncodeForWoWAddonChannel(compressed)

  AceComm:SendCommMessage("MM_VerRes", msg, IsInRaid() and "RAID" or "PARTY")
end

function Mingus:RequestVersionCheck()
  AceComm:SendCommMessage("MM_VerReq", ":)", IsInRaid() and "RAID" or "PARTY")

  --@debug@
  -- "Receive" the sample response
  Mingus:InsertIntoCheckPaneTable(sampleCheckInfo)
  --@end-debug@
end

function Mingus:InitializeComms()
  AceComm:RegisterComm("MM_VerRes", ReceiveVersionCheckTable)
  AceComm:RegisterComm("MM_VerReq", SendVersionCheckTable)
end
