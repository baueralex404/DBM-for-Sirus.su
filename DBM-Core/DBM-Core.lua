-- *********************************************************
-- **               Deadly Boss Mods - Core               **
-- **            http://www.deadlybossmods.com            **
-- **        https://www.patreon.com/deadlybossmods       **
-- *********************************************************
--
-- This addon is written and copyrighted by:
--    * Paul Emmerich (Tandanu @ EU-Aegwynn) (DBM-Core)
--    * Martin Verges (Nitram @ EU-Azshara) (DBM-GUI)
--    * Adam Williams (Omegal @ US-Whisperwind) (Primary boss mod author & DBM maintainer)
--
-- The localizations are written by:
--    * enGB/enUS: Omegal				Twitter @MysticalOS
--    * deDE: Ebmor						http://www.deadlybossmods.com/forum/memberlist.php?mode=viewprofile&u=79
--    * ruRU: TOM_RUS					http://www.curseforge.com/profiles/TOM_RUS/
--    * zhTW: Whyv						ultrashining@gmail.com
--    * koKR: Elnarfim					---
--    * zhCN: Mini Dragon				projecteurs@gmail.com
--
--
-- Special thanks to:
--    * Arta
--    * Tennberg (a lot of fixes in the enGB/enUS localization)
--    * nBlueWiz (a lot of previous fixes in the koKR localization as well as boss mod work) Contact: everfinale@gmail.com
--
--
-- The code of this addon is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
-- All included textures and sounds are copyrighted by their respective owners, license information for these media files can be found in the modules that make use of them.
--
--
--  You are free:
--    * to Share - to copy, distribute, display, and perform the work
--    * to Remix - to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work). (A link to http://www.deadlybossmods.com is sufficient)
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--

-------------------------------
--  Globals/Default Options  --
-------------------------------

local function releaseDate(year, month, day, hour, minute, second)
	hour = hour or 0
	minute = minute or 0
	second = second or 0
	return second + minute * 10^2 + hour * 10^4 + day * 10^6 + month * 10^8 + year * 10^10
end

local function parseCurseDate(date)
	date = tostring(date)
	if #date == 13 then
		-- support for broken curse timestamps: leading 0 in hours is missing...
		date = date:sub(1, 8) .. "0" .. date:sub(9, #date)
	end
	local year, month, day, hour, minute, second = tonumber(date:sub(1, 4)), tonumber(date:sub(5, 6)), tonumber(date:sub(7, 8)), tonumber(date:sub(9, 10)), tonumber(date:sub(11, 12)), tonumber(date:sub(13, 14))
	if year and month and day and hour and minute and second then
		return releaseDate(year, month, day, hour, minute, second)
	end
end

local function showRealDate(curseDate)
	curseDate = tostring(curseDate)
	local year, month, day, hour, minute, second = curseDate:sub(1, 4), curseDate:sub(5, 6), curseDate:sub(7, 8), curseDate:sub(9, 10), curseDate:sub(11, 12), curseDate:sub(13, 14)
	if year and month and day and hour and minute and second then
		return year.."/"..month.."/"..day.." "..hour..":"..minute..":"..second
	end
end

DBM = {
	Revision = parseCurseDate("20200413173000"),
	DisplayVersion = "5.40", -- the string that is shown as version
	ReleaseRevision = releaseDate(2020, 4, 13) -- the date of the latest stable version that is available, optionally pass hours, minutes, and seconds for multiple releases in one day
}
DBM.HighestRelease = DBM.ReleaseRevision --Updated if newer version is detected, used by update nags to reflect critical fixes user is missing on boss pulls

-- support for github downloads, which doesn't support curse keyword expansion
-- just use the latest release revision
if not DBM.Revision then
	DBM.Revision = DBM.ReleaseRevision
end

function DBM:ShowRealDate(curseDate)
	return showRealDate(curseDate)
end

function DBM:ReleaseDate(year, month, day, hour, minute, second)
	return releaseDate(year, month, day, hour, minute, second)
end

local wowVersionString, wowBuild, _, wowTOC = GetBuildInfo()

-- dual profile setup
local _, playerClass = UnitClass("player")
DBM_UseDualProfile = true
if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "ROGUE" then
	DBM_UseDualProfile = false
end
DBM_CharSavedRevision = 2

--Hard code STANDARD_TEXT_FONT since skinning mods like to taint it (or worse, set it to nil, wtf?)
local standardFont = STANDARD_TEXT_FONT
if (LOCALE_ruRU) then
	standardFont = "Fonts\\ARIALN.TTF"
else
	standardFont = "Fonts\\FRIZQT__.TTF"
end

DBM.DefaultOptions = {
	WarningColors = {
		{r = 0.41, g = 0.80, b = 0.94}, -- Color 1 - #69CCF0 - Turqoise
		{r = 0.95, g = 0.95, b = 0.00}, -- Color 2 - #F2F200 - Yellow
		{r = 1.00, g = 0.50, b = 0.00}, -- Color 3 - #FF8000 - Orange
		{r = 1.00, g = 0.10, b = 0.10}, -- Color 4 - #FF1A1A - Red
	},
	RaidWarningSound = "Sound\\Doodad\\BellTollNightElf.wav",
	SpecialWarningSound = "Sound\\Spells\\PVPFlagTaken.wav",
	SpecialWarningSound2 = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
	SpecialWarningSound3 = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
	SpecialWarningSound4 = "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav",
	SpecialWarningSound5 = "Sound\\Creature\\Loathstare\\Loa_Naxx_Aggro02.wav",
	ModelSoundValue = "Short",
	CountdownVoice = "Corsica",
	CountdownVoice2 = "Kolt",
	CountdownVoice3 = "Smooth",
	ChosenVoicePack = "None",
	VoiceOverSpecW2 = "DefaultOnly",
	AlwaysPlayVoice = false,
	EventSoundVictory2 = "None",
	EventSoundWipe = "None",
	EventSoundEngage2 = "None",
	EventSoundMusic = "None",
	EventSoundDungeonBGM = "None",
	EventSoundMusicCombined = false,
	EventDungMusicMythicFilter = true,
	EventMusicMythicFilter = true,
	Enabled = true,
	ShowWarningsInChat = true,
	ShowSWarningsInChat = true,
	WarningIconLeft = true,
	WarningIconRight = true,
	WarningIconChat = true,
	WarningAlphabetical = true,
	WarningShortText = true,
	ShowAllVersions = true,
	ShowPizzaMessage = true,
	ShowEngageMessage = true,
	ShowDefeatMessage = true,
	ShowGuildMessages = true,
	ShowGuildMessagesPlus = false,
	AutoRespond = true,
	WhisperStats = false,
	DisableStatusWhisper = false,
	DisableGuildStatus = false,
	HideBossEmoteFrame2 = true,
	SWarningAlphabetical = true,
	SWarnNameInNote = true,
	CustomSounds = 0,
	ShowBigBrotherOnCombatStart = false,
	FilterTankSpec = true,
	FilterInterrupt2 = "TandFandBossCooldown",
	FilterInterruptNoteName = false,
	FilterDispel = true,
	FilterTrashWarnings2 = true,
	FilterVoidFormSay = true,
	--FilterSelfHud = true,
	AutologBosses = false,
	AdvancedAutologBosses = false,
	RecordOnlyBosses = false,
	LogOnlyNonTrivial = true,
	UseSoundChannel = "Master",
	LFDEnhance = true,
	WorldBossNearAlert = false,
	RLReadyCheckSound = true,
	AFKHealthWarning = false,
	AutoReplySound = true,
	HideObjectivesFrame = true,
	HideGarrisonToasts = true,
	HideGuildChallengeUpdates = true,
	HideQuestTooltips = true,
	HideTooltips = false,
	DisableSFX = false,
	EnableModels = true,
	RangeFrameFrames = "radar",
	RangeFrameUpdates = "Average",
	RangeFramePoint = "CENTER",
	RangeFrameX = 50,
	RangeFrameY = -50,
	RangeFrameSound1 = "none",
	RangeFrameSound2 = "none",
	RangeFrameLocked = false,
	RangeFrameRadarPoint = "CENTER",
	RangeFrameRadarX = 100,
	RangeFrameRadarY = -100,
	InfoFramePoint = "CENTER",
	InfoFrameX = 75,
	InfoFrameY = -75,
	InfoFrameShowSelf = false,
	InfoFrameLines = 0,
	WarningDuration2 = 1.5,
	WarningPoint = "CENTER",
	WarningX = 0,
	WarningY = 260,
	WarningFont = standardFont,
	WarningFontSize = 20,
	WarningFontStyle = "None",
	WarningFontShadow = true,
	SpecialWarningDuration2 = 1.5,
	SpecialWarningPoint = "CENTER",
	SpecialWarningX = 0,
	SpecialWarningY = 75,
	SpecialWarningFont = standardFont,
	SpecialWarningFontSize2 = 35,
	SpecialWarningFontStyle = "THICKOUTLINE",
	SpecialWarningFontShadow = false,
	SpecialWarningIcon = true,
	SpecialWarningShortText = true,
	SpecialWarningFontCol = {1.0, 0.7, 0.0},--Yellow, with a tint of orange
	SpecialWarningFlashCol1 = {1.0, 1.0, 0.0},--Yellow
	SpecialWarningFlashCol2 = {1.0, 0.5, 0.0},--Orange
	SpecialWarningFlashCol3 = {1.0, 0.0, 0.0},--Red
	SpecialWarningFlashCol4 = {1.0, 0.0, 1.0},--Purple
	SpecialWarningFlashCol5 = {0.2, 1.0, 1.0},--Tealish
	SpecialWarningFlashDura1 = 0.4,
	SpecialWarningFlashDura2 = 0.4,
	SpecialWarningFlashDura3 = 1,
	SpecialWarningFlashDura4 = 0.7,
	SpecialWarningFlashDura5 = 1,
	SpecialWarningFlashAlph1 = 0.3,
	SpecialWarningFlashAlph2 = 0.3,
	SpecialWarningFlashAlph3 = 0.4,
	SpecialWarningFlashAlph4 = 0.4,
	SpecialWarningFlashAlph5 = 0.5,
	SpecialWarningFlash1 = true,
	SpecialWarningFlash2 = true,
	SpecialWarningFlash3 = true,
	SpecialWarningFlash4 = true,
	SpecialWarningFlash5 = true,
	SpecialWarningFlashCount1 = 1,
	SpecialWarningFlashCount2 = 1,
	SpecialWarningFlashCount3 = 3,
	SpecialWarningFlashCount4 = 2,
	SpecialWarningFlashCount5 = 3,
	SWarnClassColor = true,
	ArrowPosX = 0,
	ArrowPosY = -150,
	ArrowPoint = "TOP",
	-- global boss mod settings (overrides mod-specific settings for some options)
	DontShowBossAnnounces = false,
	DontShowTargetAnnouncements = false,
	DontShowSpecialWarnings = false,
	DontShowSpecialWarningText = false,
	DontShowBossTimers = false,
	DontShowUserTimers = false,
	DontShowFarWarnings = true,
	DontSetIcons = false,
	DontRestoreIcons = false,
	DontShowRangeFrame = false,
	DontRestoreRange = false,
	DontShowInfoFrame = false,
	DontShowHudMap2 = false,
	DontPlayCountdowns = false,
	DontSendYells = false,
	BlockNoteShare = false,
	DontShowReminders = false,
	DontShowPT2 = false,
	DontShowPTCountdownText = false,
	DontPlayPTCountdown = false,
	DontShowPTText = false,
	DontShowPTNoID = false,
	PTCountThreshold2 = 5,
	LatencyThreshold = 250,
	BigBrotherAnnounceToRaid = false,
	SettingsMessageShown = false,
	ForumsMessageShown = false,
	AlwaysShowSpeedKillTimer2 = false,
	ShowRespawn = true,
	ShowQueuePop = true,
	HelpMessageVersion = 3,
	MoviesSeen = {},
	MovieFilter2 = "OnlyFight",
	LastRevision = 0,
	DebugMode = false,
	DebugLevel = 1,
	RoleSpecAlert = true,
	CheckGear = true,
	WorldBossAlert = false,
	AutoAcceptFriendInvite = false,
	AutoAcceptGuildInvite = false,
	FakeBWVersion = false,
	AITimer = true,
	ShortTimerText = true,
	ChatFrame = "DEFAULT_CHAT_FRAME",
	CoreSavedRevision = 1,

	-- these keys are not in live
	StatusEnabled = true,
	ShowFakedRaidWarnings = false,
	Memes = false,
	ShowLoadMessage = true,
	ShowKillMessage = true,
	ShowWipeMessage = true,
	ShowRecoveryMessage = true,
	HideBossEmoteFrame = false,
	SpamBlockRaidWarning = true,
	SpamBlockBossWhispers = false,
	FixCLEUOnCombatStart = false,
	BlockVersionUpdatePopup = true,
	ShowSpecialWarnings = true,
	AlwaysShowHealthFrame = false,
	HPFramePoint = "CENTER",
	HPFrameX = -50,
	HPFrameY = 50,
	HPFrameMaxEntries = 5,
	HealthFrameGrowUp = false,
	HealthFrameLocked = false,
	HealthFrameWidth = 200,
	DontSendBossAnnounces = false,
	DontSendBossWhispers = false,
}

DBM.Bars = DBT:New()
DBM.Mods = {}
DBM.ModLists = {}
DBM.Counts = {
	{text = "Corsica",					value = "Corsica",	path = "Interface\\AddOns\\DBM-Core\\Sounds\\Corsica\\", max = 10},
	{text = "Koltrane",					value = "Kolt",		path = "Interface\\AddOns\\DBM-Core\\Sounds\\Kolt\\", max = 10},
	{text = "Smooth",					value = "Smooth",	path = "Interface\\AddOns\\DBM-Core\\Sounds\\Smooth\\", max = 10},
	{text = "Smooth (Reverb)",			value = "SmoothR",	path = "Interface\\AddOns\\DBM-Core\\Sounds\\SmoothReverb\\", max = 10},
	{text = "Pewsey",					value = "Pewsey",	path = "Interface\\AddOns\\DBM-Core\\Sounds\\Pewsey\\", max = 10},
	{text = "Bear (Child)",				value = "Bear",		path = "Interface\\AddOns\\DBM-Core\\Sounds\\Bear\\", max = 10},
	{text = "Moshne",					value = "Mosh",		path = "Interface\\AddOns\\DBM-Core\\Sounds\\Mosh\\", max = 5},
	{text = "Anshlun (ptBR)",			value = "Anshlun",	path = "Interface\\AddOns\\DBM-Core\\Sounds\\Anshlun\\", max = 10},
	{text = "Neryssa (ptBR)",			value = "Neryssa",	path = "Interface\\AddOns\\DBM-Core\\Sounds\\Neryssa\\", max = 10},
}
--Sounds use SoundKit Ids (not file data ids)
DBM.Victory = {
	{text = "None",						value = "None"},
	{text = "Random",					value = "Random"},
	{text = "Blakbyrd: FF Fanfare",		value = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\bbvictory.ogg", length = 4},
	{text = "SMG: FF Fanfare",			value = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg", length = 4},
}
DBM.Defeat = {
	{text = "None",						value = "None"},
	{text = "Random",					value = "Random"},
	{text = "Kologarn: You Fail",		value = "Sound\\Creature\\Kologarn\\UR_Kologarn_Slay02.wav", length = 4},
	{text = "Hodir: Tragic",			value = "Sound\\Creature\\Hodir\\UR_Hodir_Slay01.wav", length = 4},
	{text = "Thorim: Failures",			value = "Sound\\Creature\\Thorim\\UR_Thorim_P1Wipe01.wav", length = 4},
	{text = "Valithria: Failures",		value = "Sound\\Creature\\ValithriaDreamwalker\\IC_Valithria_Berserk01.wav", length = 4},
	{text = "Yogg-Saron: Laugh",		value = "Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.wav", length = 4},
}
--Music uses file data IDs
DBM.Music = {--Contains all music media, period
	{text = "None",						value = "None"},
	{text = "Random",					value = "Random"},
	{text = "Bronze Jam",				value = "Sound\\Music\\ZoneMusic\\IcecrownRaid\\IR_BronzeJam.mp3", length = 116},
	{text = "Ulduar: Titan Orchestra",	value = "Sound\\Music\\ZoneMusic\\UlduarRaidInt\\UR_TitanOrchestraIntro.mp3", length = 102},
}
DBM.DungeonMusic = {--Filtered list of media assigned to dungeon/raid background music catagory
	{text = "None",						value = "None"},
	{text = "Random",					value = "Random"},
	{text = "Ulduar: Titan Orchestra",	value = "Sound\\Music\\ZoneMusic\\UlduarRaidInt\\UR_TitanOrchestraIntro.mp3", length = 102},
}
DBM.BattleMusic = {--Filtered list of media assigned to boss/encounter background music catagory
	{text = "None",						value = "None"},
	{text = "Random",					value = "Random"},
	{text = "Bronze Jam",				value = "Sound\\Music\\ZoneMusic\\IcecrownRaid\\IR_BronzeJam.mp3", length = 116},
}

------------------------
-- Global Identifiers --
------------------------
DBM_DISABLE_ZONE_DETECTION = newproxy(false)
DBM_OPTION_SPACER = newproxy(false)

--------------
--  Locals  --
--------------
local bossModPrototype = {}
local usedProfile = "Default"
local dbmIsEnabled = true
local lastCombatStarted = GetTime()
local loadcIds = {}
local inCombat = {}
local oocBWComms = {}
local combatInfo = {}
local bossIds = {}
local updateFunctions = {}
local raid = {}
local modSyncSpam = {}
local autoRespondSpam = {}
local chatPrefix = "<Deadly Boss Mods> "
local chatPrefixShort = "<DBM> "
local ver = ("%s (%s)"):format(DBM.DisplayVersion, tostring(DBM.Revision))
local mainFrame = CreateFrame("Frame", "DBMMainFrame")
local newerVersionPerson = {}
local newerRevisionPerson = {}
local combatInitialized = false
local healthCombatInitialized = false
local pformat
local schedulerFrame = CreateFrame("Frame", "DBMScheduler")
schedulerFrame:Hide()
local startScheduler
local schedule
local unschedule
local unscheduleAll
local scheduleCountdown
local loadOptions
local checkWipe
local checkBossHealth
local checkCustomBossHealth
local fireEvent
local playerName = UnitName("player")
local playerLevel = UnitLevel("player")
local playerRealm = GetRealmName()
local LastInstanceMapID = -1
local LastGroupSize = 0
local iconFolder = "Interface\\AddOns\\DBM-Core\\icon\\"
local LastInstanceType = nil
local watchFrameRestore = false
local bossHealth = {}
local bossHealthuIdCache = {}
local bossuIdCache = {}
local savedDifficulty, difficultyText, difficultyIndex
local lastBossEngage = {}
local lastBossDefeat = {}
local timerRequestInProgress = false
local updateNotificationDisplayed = 0
local showConstantReminder = 0
local tooltipsHidden = false
local SWFilterDisabed = 3
local currentSpecName, currentSpecGroup
local cSyncSender = {}
local cSyncReceived = 0
local canSetIcons = {}
local iconSetRevision = {}
local iconSetPerson = {}
local addsGUIDs = {}
local targetEventsRegistered = false
local statusWhisperDisabled = false
local statusGuildDisabled = false
local UpdateChestTimer
local breakTimerStart
local AddMsg
local delayedFunction
local dataBroker
local voiceSessionDisabled = false
local handleSync

local enableIcons = true -- set to false when a raid leader or a promoted player has a newer version of DBM

local bannedMods = { -- a list of "banned" (meaning they are replaced by another mod or discontinued). These mods will not be loaded by DBM (and they wont show up in the GUI)
	"DBM_API",
	"DBM-Outlands",
	"DBM-Sunwell",
	"DBM-Battlegrounds", --replaced by DBM-PvP
}


-----------------
--  Libraries  --
-----------------
local LL
if LibStub("LibLatency", true) then
	LL = LibStub("LibLatency")
end
local LD
if LibStub("LibDurability", true) then
	LD = LibStub("LibDurability")
end


--------------------------------------------------------
--  Cache frequently used global variables in locals  --
--------------------------------------------------------
local DBM = DBM
-- these global functions are accessed all the time by the event handler
-- so caching them is worth the effort
local ipairs, pairs, next = ipairs, pairs, next
local tinsert, tremove, twipe, tsort, tconcat = table.insert, table.remove, table.wipe, table.sort, table.concat
local type, select = type, select
local GetTime = GetTime
local bband = bit.band
local floor, mhuge, mmin, mmax = math.floor, math.huge, math.min, math.max
local GetNumPartyMembers, GetNumRaidMembers, GetRaidRosterInfo = GetNumPartyMembers, GetNumRaidMembers, GetRaidRosterInfo
local UnitName, GetUnitName = UnitName, GetUnitName
local IsInInstance = IsInInstance
local UnitAffectingCombat, InCombatLockdown, IsFalling, UnitPlayerOrPetInRaid, UnitPlayerOrPetInParty = UnitAffectingCombat, InCombatLockdown, IsFalling, UnitPlayerOrPetInRaid, UnitPlayerOrPetInParty
local UnitGUID, UnitHealth, UnitHealthMax, UnitBuff, UnitDebuff = UnitGUID, UnitHealth, UnitHealthMax, UnitBuff, UnitDebuff
local UnitExists, UnitIsDead, UnitIsFriend, UnitIsUnit = UnitExists, UnitIsDead, UnitIsFriend, UnitIsUnit
local GetSpellInfo, GetSpellTexture, GetSpellCooldown = GetSpellInfo, GetSpellTexture, GetSpellCooldown

local GetActiveTalentGroup = C_Talent and C_Talent.GetActiveTalentGroup or GetActiveTalentGroup

local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitIsPartyLeader, UnitIsRaidOfficer = UnitIsPartyLeader, UnitIsRaidOfficer
local PlaySoundFile, PlaySound = PlaySoundFile, PlaySound

local SendAddonMessage = SendAddonMessage

-- for Phanx' Class Colors
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

---------------------------------
--  General (local) functions  --
---------------------------------
-- checks if a given value is in an array
-- returns true if it finds the value, false otherwise
local function checkEntry(t, val)
	for i, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

local function findEntry(t, val)
	for i, v in ipairs(t) do
		if v and val and val:find(v) then
			return true
		end
	end
	return false
end

-- removes all occurrences of a value in an array
-- returns true if at least one occurrence was remove, false otherwise
local function removeEntry(t, val)
	local existed = false
	for i = #t, 1, -1 do
		if t[i] == val then
			tremove(t, i)
			existed = true
		end
	end
	return existed
end

-- automatically sends an addon message to the appropriate channel (BATTLEGROUND, RAID or PARTY)
local function sendSync(prefix, msg)
	msg = msg or ""
	local zoneType = select(2, IsInInstance())
	if zoneType == "pvp" or zoneType == "arena" then
		SendAddonMessage("D4", prefix .. "\t" .. msg, "BATTLEGROUND")
	else
		if GetRealNumRaidMembers() > 0 then
			SendAddonMessage("D4", prefix .. "\t" .. msg, "RAID")
		elseif GetRealNumPartyMembers() > 0 then
			SendAddonMessage("D4", prefix .. "\t" .. msg, "PARTY")
		else--for solo raid
			handleSync("SOLO", playerName, prefix, strsplit("\t", msg))
		end
	end
end

--
local function strFromTime(time)
	if type(time) ~= "number" then time = 0 end
	time = floor(time)
	if time < 60 then
		return DBM_CORE_TIMER_FORMAT_SECS:format(time)
	elseif time % 60 == 0 then
		return DBM_CORE_TIMER_FORMAT_MINS:format(time/60)
	else
		return DBM_CORE_TIMER_FORMAT:format(time/60, time % 60)
	end
end

do
	-- fail-safe format, replaces missing arguments with unknown
	-- note: doesn't handle cases like %%%s correctly at the moment (should become %unknown, but becomes %%s)
	-- also, the end of the format directive is not detected in all cases, but handles everything that occurs in our boss mods ;)
	--> not suitable for general-purpose use, just for our warnings and timers (where an argument like a spell-target might be nil due to missing target information from unreliable detection methods)
	local function replace(cap1, cap2)
		return cap1 == "%" and DBM_CORE_UNKNOWN
	end

	function pformat(fstr, ...)
		local ok, str = pcall(format, fstr, ...)
		return ok and str or fstr:gsub("(%%+)([^%%%s<]+)", replace):gsub("%%%%", "%%")
	end
end

-- sends a whisper to a player by his or her character name or BNet presence id
-- returns true if the message was sent, nil otherwise
local function sendWhisper(target, msg)
	if type(target) == "number" then
		if not BNIsSelf(target) then -- never send BNet whispers to ourselves
			BNSendWhisper(target, msg)
			return true
		end
	elseif type(target) == "string" then
		-- whispering to ourselves here is okay and somewhat useful for whisper-warnings
		SendChatMessage(msg, "WHISPER", nil, target)
		return true
	end
end
local BNSendWhisper = sendWhisper

local function stripServerName(cap)
	return cap:sub(2, -2)
end

--------------
--  Events  --
--------------
do
	local registeredEvents = {}
	local registeredSpellIds = {}
	local unfilteredCLEUEvents = {}
	local registeredUnitEventIds = {}
	local argsMT = {__index = {}}
	local args = setmetatable({}, argsMT)

	function argsMT.__index:IsSpellID(a1, a2, a3, a4, a5)
		local v = self.spellId
		return v == a1 or v == a2 or v == a3 or v == a4 or v == a5
	end

	function argsMT.__index:IsPlayer()
		return bband(args.destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(args.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
	end

	function argsMT.__index:IsPlayerSource()
		return bband(args.sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(args.sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
	end

	function argsMT.__index:IsNPC()
		return bband(args.destFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
	end

	function argsMT.__index:IsPet()
		return bband(args.destFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
	end

	function argsMT.__index:IsPetSource()
		return bband(args.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
	end

	function argsMT.__index:IsSrcTypePlayer()
		return bband(args.sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
	end

	function argsMT.__index:IsDestTypePlayer()
		return bband(args.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
	end

	function argsMT.__index:IsSrcTypeHostile()
		return bband(args.sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
	end

	function argsMT.__index:IsDestTypeHostile()
		return bband(args.destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
	end

	function argsMT.__index:GetSrcCreatureID()
		return DBM:GetCIDFromGUID(self.sourceGUID)
	end

	function argsMT.__index:GetDestCreatureID()
		return DBM:GetCIDFromGUID(self.destGUID)
	end

	local function handleEvent(self, event, ...)
		if not registeredEvents[event] or DBM.Options and not DBM.Options.Enabled then return end
		for i, v in ipairs(registeredEvents[event]) do
			if type(v[event]) == "function" and (not v.zones or checkEntry(v.zones, GetRealZoneText()) or checkEntry(v.zones, GetCurrentMapAreaID())) and (not v.Options or v.Options.Enabled) then
				v[event](v, ...)
			end
		end
	end

	function DBM:RegisterEvents(...)
		for i = 1, select("#", ...) do
			local event = select(i, ...)
			registeredEvents[event] = registeredEvents[event] or {}
			tinsert(registeredEvents[event], self)
			mainFrame:RegisterEvent(event)
		end
	end

	DBM:RegisterEvents("ADDON_LOADED")

	function DBM:FilterRaidBossEmote(msg, ...)
		return handleEvent(nil, "CHAT_MSG_RAID_BOSS_EMOTE_FILTERED", msg:gsub("\124c%x+(.-)\124r", "%1"), ...)
	end

	function DBM:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
		if not registeredEvents[event] then return end
		twipe(args)
		args.timestamp = timestamp
		args.event = event
		args.sourceGUID = sourceGUID
		args.sourceName = sourceName
		args.sourceFlags = sourceFlags
		args.destGUID = destGUID
		args.destName = destName
		args.destFlags = destFlags
		-- taken from Blizzard_CombatLog.lua
		if event == "SWING_DAMAGE" then
			args.amount, args.overkill, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(1, ...)
		elseif event == "SWING_MISSED" then
			args.spellName = ACTION_SWING
			args.missType = select(1, ...)
		elseif event:sub(1, 5) == "RANGE" then
			args.spellId, args.spellName, args.spellSchool = select(1, ...)
			if event == "RANGE_DAMAGE" then
				args.amount, args.overkill, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(4, ...)
			elseif event == "RANGE_MISSED" then
				args.missType = select(4, ...)
			end
		elseif event:sub(1, 5) == "SPELL" then
			args.spellId, args.spellName, args.spellSchool = select(1, ...)
			if event == "SPELL_DAMAGE" then
				args.amount, args.overkill, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(4, ...)
			elseif event == "SPELL_MISSED" then
				args.missType, args.amountMissed = select(4, ...)
			elseif event == "SPELL_HEAL" then
				args.amount, args.overheal, args.absorbed, args.critical = select(4, ...)
				args.school = args.spellSchool
			elseif event == "SPELL_ENERGIZE" then
				args.valueType = 2
				args.amount, args.powerType = select(4, ...)
			elseif event:sub(1, 14) == "SPELL_PERIODIC" then
				if event == "SPELL_PERIODIC_MISSED" then
					args.missType = select(4, ...)
				elseif event == "SPELL_PERIODIC_DAMAGE" then
					args.amount, args.overkill, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(4, ...)
				elseif event == "SPELL_PERIODIC_HEAL" then
					args.amount, args.overheal, args.absorbed, args.critical = select(4, ...)
					args.school = args.spellSchool
				elseif event == "SPELL_PERIODIC_DRAIN" then
					args.amount, args.powerType, args.extraAmount = select(4, ...)
					args.valueType = 2
				elseif event == "SPELL_PERIODIC_LEECH" then
					args.amount, args.powerType, args.extraAmount = select(4, ...)
					args.valueType = 2
				elseif event == "SPELL_PERIODIC_ENERGIZE" then
					args.amount, args.powerType = select(4, ...)
					args.valueType = 2
				end
			elseif event == "SPELL_DRAIN" then
				args.amount, args.powerType, args.extraAmount = select(4, ...)
				args.valueType = 2
			elseif event == "SPELL_LEECH" then
				args.amount, args.powerType, args.extraAmount = select(4, ...)
				args.valueType = 2
			elseif event == "SPELL_INTERRUPT" then
				args.extraSpellId, args.extraSpellName, args.extraSpellSchool = select(4, ...)
			elseif event == "SPELL_EXTRA_ATTACKS" then
				args.amount = select(4, ...)
			elseif event == "SPELL_DISPEL_FAILED" then
				args.extraSpellId, args.extraSpellName, args.extraSpellSchool = select(4, ...)
			elseif event == "SPELL_AURA_DISPELLED" then
				args.extraSpellId, args.extraSpellName, args.extraSpellSchool = select(4, ...)
				args.auraType = select(7, ...)
			elseif event == "SPELL_AURA_STOLEN" then
				args.extraSpellId, args.extraSpellName, args.extraSpellSchool = select(4, ...)
				args.auraType = select(7, ...)
			elseif event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REMOVED" then
				args.auraType = select(4, ...)
				args.sourceName = args.destName
				args.sourceGUID = args.destGUID
				args.sourceFlags = args.destFlags
			elseif event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" then
				args.auraType, args.amount = select(4, ...)
				args.sourceName = args.destName
				args.sourceGUID = args.destGUID
				args.sourceFlags = args.destFlags
			elseif event == "SPELL_CAST_FAILED" then
				args.missType = select(4, ...)
			end
		elseif event == "DAMAGE_SHIELD" then
			args.spellId, args.spellName, args.spellSchool = select(1, ...)
			args.amount, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(4, ...)
		elseif event == "DAMAGE_SHIELD_MISSED" then
			args.spellId, args.spellName, args.spellSchool = select(1, ...)
			args.missType = select(4, ...)
		elseif event == "ENCHANT_APPLIED" then
			args.spellName = select(1,...)
			args.itemId, args.itemName = select(2,...)
		elseif event == "ENCHANT_REMOVED" then
			args.spellName = select(1,...)
			args.itemId, args.itemName = select(2,...)
		elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" then
			args.sourceName = args.destName
			args.sourceGUID = args.destGUID
			args.sourceFlags = args.destFlags
		elseif event == "ENVIRONMENTAL_DAMAGE" then
			args.environmentalType = select(1,...)
			args.amount, args.overkill, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(2, ...)
			args.spellName = _G["ACTION_"..event.."_"..args.environmentalType]
			args.spellSchool = args.school
		elseif event == "DAMAGE_SPLIT" then
			args.spellId, args.spellName, args.spellSchool = select(1, ...)
			args.amount, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = select(4, ...)
		end
		return handleEvent(nil, event, args)
	end
	mainFrame:SetScript("OnEvent", handleEvent)
end

--------------
--  OnLoad  --
--------------
do
	local isLoaded = false
	local onLoadCallbacks = {}
	local disabledMods = {}

	local function runDelayedFunctions(self)
		--Check if voice pack missing
		local activeVP = self.Options.ChosenVoicePack
		if activeVP ~= "None" then
			if not self.VoiceVersions[activeVP] or (self.VoiceVersions[activeVP] and self.VoiceVersions[activeVP] == 0) then--A voice pack is selected that does not belong
				voiceSessionDisabled = true
				AddMsg(DBM, DBM_CORE_VOICE_MISSING)
			end
		else
			if not self.Options.DontShowReminders and #self.Voices > 1 then
				--At least one voice pack installed but activeVP set to "None"
				AddMsg(DBM, DBM_CORE_VOICE_DISABLED)
			end
		end
		--Check if any of countdown sounds are using missing voice pack
		local found1, found2, found3 = false, false, false
		for i = 1, #self.Counts do
			local voice = self.Counts[i].value
			if voice == self.Options.CountdownVoice then
				found1 = true
			end
			if voice == self.Options.CountdownVoice2 then
				found2 = true
			end
			if voice == self.Options.CountdownVoice3 then
				found3 = true
			end
		end
		if not found1 then
			AddMsg(DBM, DBM_CORE_VOICE_COUNT_MISSING:format(1, self.DefaultOptions.CountdownVoice))
			self.Options.CountdownVoice = self.DefaultOptions.CountdownVoice
		end
		if not found2 then
			AddMsg(DBM, DBM_CORE_VOICE_COUNT_MISSING:format(2, self.DefaultOptions.CountdownVoice2))
			self.Options.CountdownVoice2 = self.DefaultOptions.CountdownVoice2
		end
		if not found3 then
			AddMsg(DBM, DBM_CORE_VOICE_COUNT_MISSING:format(3, self.DefaultOptions.CountdownVoice3))
			self.Options.CountdownVoice3 = self.DefaultOptions.CountdownVoice3
		end
		self:BuildVoiceCountdownCache()
		--Break timer recovery
		--Try local settings
		if self.Options.tempBreak2 then
			local timer, startTime = string.split("/", self.Options.tempBreak2)
			local elapsed = time() - tonumber(startTime)
			local remaining = timer - elapsed
			if remaining > 0 then
				breakTimerStart(DBM, remaining, playerName)
			else--It must have ended while we were offline, kill variable.
				self.Options.tempBreak2 = nil
			end
		end
		if IsInGuild() then
			SendAddonMessage("D4", "GH", "GUILD")
		end
		if not savedDifficulty or not difficultyText or not difficultyIndex then--prevent error if savedDifficulty or difficultyText is nil
			savedDifficulty, difficultyText, difficultyIndex, LastGroupSize = self:GetCurrentInstanceDifficulty()
		end
	end

	-- register a callback that will be executed once the addon is fully loaded (ADDON_LOADED fired, saved vars are available)
	function DBM:RegisterOnLoadCallback(cb)
		if isLoaded then
			cb()
		else
			onLoadCallbacks[#onLoadCallbacks + 1] = cb
		end
	end

	function DBM:ADDON_LOADED(modname)
		if modname == "DBM-Core" and not isLoaded then
			isLoaded = true
			loadOptions(self)
			self.Bars:LoadOptions("DBM")
			self.Arrow:LoadPosition()
			for i, v in ipairs(onLoadCallbacks) do
				xpcall(v, geterrorhandler())
			end
			onLoadCallbacks = nil
			-- LibDBIcon setup
			if type(DBM_MinimapIcon) ~= "table" then
				DBM_MinimapIcon = {}
			end
			if LibStub("LibDBIcon-1.0", true) then
				LibStub("LibDBIcon-1.0"):Register("DBM", dataBroker, DBM_MinimapIcon)
			end

			self.AddOns = {}
			self.Voices = {{text = "None", value = "None"}} --Create voice table, with default "None" value
			self.VoiceVersions = {}
			for i = 1, GetNumAddOns() do
				local addonName, _, _, enabled = GetAddOnInfo(i)
				if GetAddOnMetadata(i, "X-DBM-Mod") and not checkEntry(bannedMods, addonName) then
					if enabled then
						table.insert(self.AddOns, {
							sort			= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Sort") or math.huge) or math.huge,
							type			= GetAddOnMetadata(i, "X-DBM-Mod-Type") or "OTHER",
							category		= GetAddOnMetadata(i, "X-DBM-Mod-Category") or "Other",
							name			= GetAddOnMetadata(i, "X-DBM-Mod-Name") or "",
							zone			= {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-LoadZone") or "")},
							zoneId			= {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-LoadZoneID") or "")},
							subTabs			= GetAddOnMetadata(i, "X-DBM-Mod-SubCategories") and {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-SubCategories"))},
							oneFormat		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Has-Single-Format") or 0) == 1,
							noHeroic		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-No-Heroic") or 0) == 1,
							noStatistics	= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-No-Statistics") or 0) == 1,
							isWorldBoss		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-World-Boss") or 0) == 1,
							modId			= addonName,
						})

						for k, v in ipairs(self.AddOns[#self.AddOns].zone) do
							self.AddOns[#self.AddOns].zone[k] = (self.AddOns[#self.AddOns].zone[k]):trim()
						end

						for j = #self.AddOns[#self.AddOns].zoneId, 1, -1 do
							local id = tonumber(self.AddOns[#self.AddOns].zoneId[j])
							if id then
								self.AddOns[#self.AddOns].zoneId[j] = id
							else
								table.remove(self.AddOns[#self.AddOns].zoneId, j)
							end
						end

						if self.AddOns[#self.AddOns].subTabs then
							for k, v in ipairs(self.AddOns[#self.AddOns].subTabs) do
								self.AddOns[#self.AddOns].subTabs[k] = (self.AddOns[#self.AddOns].subTabs[k]):trim()
							end
						end
					end
				end
				if GetAddOnMetadata(i, "X-DBM-Voice") and enabled then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local voiceValue = GetAddOnMetadata(i, "X-DBM-Voice-ShortName")
						local voiceVersion = tonumber(GetAddOnMetadata(i, "X-DBM-Voice-Version") or 0)
						if voiceVersion > 0 then--Do not insert voice version 0 into THIS table. 0 should be used by voice packs that insert only countdown
							tinsert(self.Voices, { text = GetAddOnMetadata(i, "X-DBM-Voice-Name"), value = voiceValue })
						end
						self.VoiceVersions[voiceValue] = voiceVersion
						self:Schedule(10, self.CheckVoicePackVersion, self, voiceValue)--Still at 1 since the count sounds won't break any mods or affect filter. V2 if support countsound path
						if GetAddOnMetadata(i, "X-DBM-Voice-HasCount") then--Supports adding countdown options, insert new countdown into table
							tinsert(self.Counts, { text = GetAddOnMetadata(i, "X-DBM-Voice-Name"), value = "VP:"..voiceValue, path = "Interface\\AddOns\\DBM-VP"..voiceValue.."\\count\\", max = 10})
						end
					end
				end
				if GetAddOnMetadata(i, "X-DBM-CountPack") and enabled then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						local voiceGlobal = GetAddOnMetadata(i, "X-DBM-CountPack-GlobalName")
						local insertFunction = _G[voiceGlobal]
						if loaded and insertFunction then
							insertFunction()
						else
							DBM:Debug(addonName.." failed to load at time CountPack function "..voiceGlobal.."ran", 2)
						end
					end
				end
				if GetAddOnMetadata(i, "X-DBM-VictoryPack") and enabled then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						local victoryGlobal = GetAddOnMetadata(i, "X-DBM-VictoryPack-GlobalName")
						local insertFunction = _G[victoryGlobal]
						if loaded and insertFunction then
							insertFunction()
						else
							DBM:Debug(addonName.." failed to load at time VictoryPack function "..victoryGlobal.." ran", 2)
						end
					end
				end
				if GetAddOnMetadata(i, "X-DBM-DefeatPack") and enabled then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						local defeatGlobal = GetAddOnMetadata(i, "X-DBM-DefeatPack-GlobalName")
						local insertFunction = _G[defeatGlobal]
						if loaded and insertFunction then
							insertFunction()
						else
							DBM:Debug(addonName.." failed to load at time DefeatPack function "..defeatGlobal.." ran", 2)
						end
					end
				end
				if GetAddOnMetadata(i, "X-DBM-MusicPack") and enabled then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						local musicGlobal = GetAddOnMetadata(i, "X-DBM-MusicPack-GlobalName")
						local insertFunction = _G[musicGlobal]
						if loaded and insertFunction then
							insertFunction()
						else
							DBM:Debug(addonName.." failed to load at time MusicPack function "..musicGlobal.." ran", 2)
						end
					end
				end
			end
			tsort(self.AddOns, function(v1, v2) return v1.sort < v2.sort end)
			self:RegisterEvents(
				"COMBAT_LOG_EVENT_UNFILTERED",
				"ZONE_CHANGED_NEW_AREA",
				"RAID_ROSTER_UPDATE",
				"PARTY_MEMBERS_CHANGED",
				"CHAT_MSG_ADDON",
				"PLAYER_REGEN_DISABLED",
				"PLAYER_REGEN_ENABLED",
				"UNIT_DIED",
				"UNIT_DESTROYED",
				"CHAT_MSG_WHISPER",
				"CHAT_MSG_BN_WHISPER",
				"CHAT_MSG_MONSTER_YELL",
				"CHAT_MSG_MONSTER_EMOTE",
				"CHAT_MSG_MONSTER_SAY",
				"CHAT_MSG_RAID_BOSS_EMOTE",
				"PLAYER_ENTERING_WORLD",
				"SPELL_CAST_SUCCESS",
				"LFG_PROPOSAL_SHOW",
				"LFG_PROPOSAL_FAILED",
				"LFG_PROPOSAL_SUCCEEDED",
				"LFG_UPDATE",
				"PLAYER_TALENT_UPDATE"
			)
			self:ZONE_CHANGED_NEW_AREA()
			self:RAID_ROSTER_UPDATE()
			C_Timer:After(1.5, function()
				combatInitialized = true
			end)
			self:Schedule(10, runDelayedFunctions, self)
		end
	end
end


-----------------
--  Callbacks  --
-----------------
do
	local callbacks = {}

	function fireEvent(event, ...)
		if not callbacks[event] then return end
		for i, v in ipairs(callbacks[event]) do
			local ok, err = pcall(v, event, ...)
			if not ok then DBM:AddMsg(("Error while executing callback %s for event %s: %s"):format(tostring(v), tostring(event), err)) end
		end
	end

	function DBM:FireEvent(event, ...)
		fireEvent(event, ...)
	end

	function DBM:IsCallbackRegistered(event, f)
		if not event or type(f) ~= "function" then
			error("Usage: IsCallbackRegistered(event, callbackFunc)", 2)
		end
		if not callbacks[event] then return end
		for i = 1, #callbacks[event] do
			if callbacks[event][i] == f then return true end
		end
		return false
	end

	function DBM:RegisterCallback(event, f)
		if not event or type(f) ~= "function" then
			error("Usage: DBM:RegisterCallback(event, callbackFunc)", 2)
		end
		callbacks[event] = callbacks[event] or {}
		tinsert(callbacks[event], f)
		return #callbacks[event]
	end

	function DBM:UnregisterCallback(event, f)
		if not event or not callbacks[event] then return end
		if f then
			if type(f) ~= "function" then
				error("Usage: UnregisterCallback(event, callbackFunc)", 2)
			end
			--> checking from the end to start and not stoping after found one result in case of a func being twice registered.
			for i = #callbacks[event], 1, -1 do
				if callbacks[event][i] == f then tremove (callbacks[event], i) end
			end
		else
			callbacks[event] = nil
		end
	end
end


--------------------------
--  OnUpdate/Scheduler  --
--------------------------
do
	-- stack that stores a few tables (up to 8) which will be recycled
	local popCachedTable, pushCachedTable
	local numChachedTables = 0
	do
		local tableCache = nil

		-- gets a table from the stack, it will then be recycled.
		function popCachedTable()
			local t = tableCache
			if t then
				tableCache = t.next
				numChachedTables = numChachedTables - 1
			end
			return t
		end

		-- tries to push a table on the stack
		-- only tables with <= 4 array entries are accepted as cached tables are only used for tasks with few arguments as we don't want to have big arrays wasting our precious memory space doing nothing...
		-- also, the maximum number of cached tables is limited to 8 as DBM rarely has more than eight scheduled tasks with less than 4 arguments at the same time
		-- this is just to re-use all the tables of the small tasks that are scheduled all the time (like the wipe detection)
		-- note that the cache does not use weak references anywhere for performance reasons, so a cached table will never be deleted by the garbage collector
		function pushCachedTable(t)
			if numChachedTables < 8 and #t <= 4 then
				twipe(t)
				t.next = tableCache
				tableCache = t
				numChachedTables = numChachedTables + 1
			end
		end
	end

	-- priority queue (min-heap) that stores all scheduled tasks.
	-- insert: O(log n)
	-- deleteMin: O(log n)
	-- getMin: O(1)
	-- removeAllMatching: O(n)
	local insert, removeAllMatching, getMin, deleteMin
	do
		local heap = {}
		local firstFree = 1

		-- gets the next task
		function getMin()
			return heap[1]
		end

		-- restores the heap invariant by moving an item up
		local function siftUp(n)
			local parent = floor(n / 2)
			while n > 1 and heap[parent].time > heap[n].time do -- move the element up until the heap invariant is restored, meaning the element is at the top or the element's parent is <= the element
				heap[n], heap[parent] = heap[parent], heap[n] -- swap the element with its parent
				n = parent
				parent = floor(n / 2)
			end
		end

		-- restores the heap invariant by moving an item down
		local function siftDown(n)
			local m -- position of the smaller child
			while 2 * n < firstFree do -- #children >= 1
				-- swap the element with its smaller child
				if 2 * n + 1 == firstFree then -- n does not have a right child --> it only has a left child as #children >= 1
					m = 2 * n -- left child
				elseif heap[2 * n].time < heap[2 * n + 1].time then -- #children = 2 and left child < right child
					m = 2 * n -- left child
				else -- #children = 2 and right child is smaller than the left one
					m = 2 * n + 1 -- right
				end
				if heap[n].time <= heap[m].time then -- n is <= its smallest child --> heap invariant restored
					return
				end
				heap[n], heap[m] = heap[m], heap[n]
				n = m
			end
		end

		-- inserts a new element into the heap
		function insert(ele)
			heap[firstFree] = ele
			siftUp(firstFree)
			firstFree = firstFree + 1
		end

		-- deletes the min element
		function deleteMin()
			local min = heap[1]
			firstFree = firstFree - 1
			heap[1] = heap[firstFree]
			heap[firstFree] = nil
			siftDown(1)
			return min
		end

		-- removes multiple scheduled tasks from the heap
		-- note that this function is comparatively slow by design as it has to check all tasks and allows partial matches
		function removeAllMatching(f, mod, ...)
			-- remove all elements that match the signature, this destroyes the heap and leaves a normal array
			local v, match
			local foundMatch = false
			for i = #heap, 1, -1 do -- iterate backwards over the array to allow usage of table.remove
				v = heap[i]
				if (not f or v.func == f) and (not mod or v.mod == mod) then
					match = true
					for j = 1, select("#", ...) do
						if select(j, ...) ~= v[j] then
							match = false
							break
						end
					end
					if match then
						tremove(heap, i)
						firstFree = firstFree - 1
						foundMatch = true
					end
				end
			end
			-- rebuild the heap from the array in O(n)
			if foundMatch then
				for i = floor((firstFree - 1) / 2), 1, -1 do
					siftDown(i)
				end
			end
		end
	end


	local wrappers = {}
	local function range(max, cur, ...)
		cur = cur or 1
		if cur > max then
			return ...
		end
		return cur, range(max, cur + 1, select(2, ...))
	end
	local function getWrapper(n)
		wrappers[n] = wrappers[n] or loadstring(([[
			return function(func, tbl)
				return func(]] .. ("tbl[%s], "):rep(n):sub(0, -3) .. [[)
			end
		]]):format(range(n)))()
		return wrappers[n]
	end

	local nextModSyncSpamUpdate = 0
	--mainFrame:SetScript("OnUpdate", function(self, elapsed)
	local function onUpdate(self, elapsed)
		local time = GetTime()

		-- execute scheduled tasks
		local nextTask = getMin()
		while nextTask and nextTask.func and nextTask.time <= time do
			deleteMin()
			local n = nextTask.n
			if n == #nextTask then
			nextTask.func(unpack(nextTask))
			else
				-- too many nil values (or a trailing nil)
				-- this is bad because unpack will not work properly
				-- TODO: is there a better solution?
				getWrapper(n)(nextTask.func, nextTask)
			end
			pushCachedTable(nextTask)
			nextTask = getMin()
		end

		-- execute OnUpdate handlers of all modules
		local foundModFunctions = 0
		for i, v in pairs(updateFunctions) do
			foundModFunctions = foundModFunctions + 1
			if i.Options.Enabled and (not i.zones or checkEntry(i.zones, GetRealZoneText()) or checkEntry(i.zones, GetCurrentMapAreaID())) then
				i.elapsed = (i.elapsed or 0) + elapsed
				if i.elapsed >= (i.updateInterval or 0) then
					v(i, i.elapsed)
					i.elapsed = 0
				end
			end
		end

		-- clean up sync spam timers and auto respond spam blockers
		if time > nextModSyncSpamUpdate then
			nextModSyncSpamUpdate = time + 20
			-- TODO: optimize this; using next(t, k) all the time on nearly empty hash tables is not a good idea...doesn't really matter here as modSyncSpam only very rarely contains more than 4 entries...
			-- we now do this just every 20 seconds since the earlier assumption about modSyncSpam isn't true any longer
			-- note that not removing entries at all would be just a small memory leak and not a problem (the sync functions themselves check the timestamp)
			local k, v = next(modSyncSpam, nil)
			if v and (time - v > 8) then
				modSyncSpam[k] = nil
			end
		end
		if not nextTask and foundModFunctions == 0 then--Nothing left, stop scheduler
			schedulerFrame:SetScript("OnUpdate", nil)
			schedulerFrame:Hide()
		end
	end

	function startScheduler()
		if not schedulerFrame:IsShown() then
			schedulerFrame:Show()
			schedulerFrame:SetScript("OnUpdate", onUpdate)
		end
	end

	function schedule(t, f, mod, ...)
		if type(f) ~= "function" then
			error("usage: schedule(time, func, [mod, args...])", 2)
		end
		startScheduler()
		local v
		if numChachedTables > 0 and select("#", ...) <= 4 then -- a cached table is available and all arguments fit into an array with four slots
			v = popCachedTable()
			v.time = GetTime() + t
			v.func = f
			v.mod = mod
			v.n = select("#", ...)
			for i = 1, v.n do
				v[i] = select(i, ...)
			end
			-- clear slots if necessary
			for i = v.n + 1, 4 do
				v[i] = nil
			end
		else -- create a new table
			v = {time = GetTime() + t, func = f, mod = mod, n = select("#", ...), ...}
		end
		insert(v)
	end

	function scheduleCountdown(time, numAnnounces, func, mod, self, ...)
		time = time or 5
		numAnnounces = numAnnounces or 3
		for i = 1, numAnnounces do
			schedule(time - i, func, mod, self, i, ...)
		end
	end

	function unschedule(f, mod, ...)
		if not f and not mod then
			-- you really want to kill the complete scheduler? call unscheduleAll
			error("cannot unschedule everything, pass a function and/or a mod")
		end
		return removeAllMatching(f, mod, ...)
	end

	function unscheduleAll()
		return removeAllMatching()
	end
end

function DBM:Schedule(t, f, ...)
	if type(f) ~= "function" then
		error("usage: DBM:Schedule(time, func, [args...])", 2)
	end
	return schedule(t, f, nil, ...)
end

function DBM:Unschedule(f, ...)
	return unschedule(f, nil, ...)
end

---------------
--  Profile  --
---------------
function DBM:CreateProfile(name)
	if not name or name == "" or name:find(" ") then
		self:AddMsg(DBM_CORE_PROFILE_CREATE_ERROR)
		return
	end
	if DBM_AllSavedOptions[name] then
		self:AddMsg(DBM_CORE_PROFILE_CREATE_ERROR_D:format(name))
		return
	end
	-- create profile
	usedProfile = name
	DBM_UsedProfile = usedProfile
	DBM_AllSavedOptions[usedProfile] = DBM_AllSavedOptions[usedProfile] or {}
	self:AddDefaultOptions(DBM_AllSavedOptions[usedProfile], self.DefaultOptions)
	self.Options = DBM_AllSavedOptions[usedProfile]
	-- rearrange position
	self.Bars:CreateProfile("DBM")
	self:RepositionFrames()
	self:AddMsg(DBM_CORE_PROFILE_CREATED:format(name))
end

function DBM:ApplyProfile(name)
	if not name or not DBM_AllSavedOptions[name] then
		self:AddMsg(DBM_CORE_PROFILE_APPLY_ERROR:format(name or DBM_CORE_UNKNOWN))
		return
	end
	usedProfile = name
	DBM_UsedProfile = usedProfile
	self:AddDefaultOptions(DBM_AllSavedOptions[usedProfile], self.DefaultOptions)
	self.Options = DBM_AllSavedOptions[usedProfile]
	-- rearrange position
	self.Bars:ApplyProfile("DBM")
	self:RepositionFrames()
	self:AddMsg(DBM_CORE_PROFILE_APPLIED:format(name))
end

function DBM:CopyProfile(name)
	if not name or not DBM_AllSavedOptions[name] then
		self:AddMsg(DBM_CORE_PROFILE_COPY_ERROR:format(name or DBM_CORE_UNKNOWN))
		return
	elseif name == usedProfile then
		self:AddMsg(DBM_CORE_PROFILE_COPY_ERROR_SELF)
		return
	end
	DBM_AllSavedOptions[usedProfile] = DBM_AllSavedOptions[name]
	self:AddDefaultOptions(DBM_AllSavedOptions[usedProfile], self.DefaultOptions)
	self.Options = DBM_AllSavedOptions[usedProfile]
	-- rearrange position
	self.Bars:CopyProfile(name, "DBM")
	self:RepositionFrames()
	self:AddMsg(DBM_CORE_PROFILE_COPIED:format(name))
end

function DBM:DeleteProfile(name)
	if not name or not DBM_AllSavedOptions[name] then
		self:AddMsg(DBM_CORE_PROFILE_DELETE_ERROR:format(name or DBM_CORE_UNKNOWN))
		return
	elseif name == "Default" then-- Default profile cannot be deleted.
		self:AddMsg(DBM_CORE_PROFILE_CANNOT_DELETE)
		return
	end
	--Delete
	DBM_AllSavedOptions[name] = nil
	usedProfile = "Default"--Restore to default
	DBM_UsedProfile = usedProfile
	self.Options = DBM_AllSavedOptions[usedProfile]
	if not self.Options then
		-- the default profile got lost somehow (maybe WoW crashed and the saved variables file got corrupted)
		self:CreateProfile("Default")
	end
	-- rearrange position
	self.Bars:DeleteProfile(name, "DBM")
	self:RepositionFrames()
	self:AddMsg(DBM_CORE_PROFILE_DELETED:format(name))
end

function DBM:RepositionFrames()
	-- rearrange position
	self:UpdateWarningOptions()
	self:UpdateSpecialWarningOptions()
	self.Arrow:LoadPosition()
	if DBMRangeCheck then
		DBMRangeCheck:ClearAllPoints()
		DBMRangeCheck:SetPoint(self.Options.RangeFramePoint, UIParent, self.Options.RangeFramePoint, self.Options.RangeFrameX, self.Options.RangeFrameY)
	end
	if DBMRangeCheckRadar then
		DBMRangeCheckRadar:ClearAllPoints()
		DBMRangeCheckRadar:SetPoint(self.Options.RangeFrameRadarPoint, UIParent, self.Options.RangeFrameRadarPoint, self.Options.RangeFrameRadarX, self.Options.RangeFrameRadarY)
	end
	if DBMInfoFrame then
		DBMInfoFrame:ClearAllPoints()
		DBMInfoFrame:SetPoint(self.Options.InfoFramePoint, UIParent, self.Options.InfoFramePoint, self.Options.InfoFrameX, self.Options.InfoFrameY)
	end
end

----------------------
--  Slash Commands  --
----------------------
do
	local function Pull(timer)
		if DBM:GetRaidRank(playerName) == 0 or select(2, IsInInstance()) == "pvp" or (timer > 0 and timer < 3) then
			return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
		end
		local targetName = (UnitExists("target") and UnitIsEnemy("player", "target")) and UnitName("target") or nil--Filter non enemies in case player isn't targetting bos but another player/pet
		if targetName then
			sendSync("PT", timer.."\t"..targetName)
		else
			sendSync("PT", timer)
		end
	end
	local function Break(timer)
		if GetNumRaidMembers() == 0 and DBM:GetRaidRank(playerName) == 0 or select(2, IsInInstance()) == "pvp" then--No break timers if not assistant or if it's dungeon/BG
			DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
			return
		end
		if timer > 60 then
			DBM:AddMsg(DBM_CORE_BREAK_USAGE)
			return
		end
		timer = timer * 60
		sendSync("BT", timer)
	end

	SLASH_DEADLYBOSSMODS1 = "/dbm"
	SLASH_DEADLYBOSSMODSRPULL1 = "/rpull"
	SLASH_DEADLYBOSSMODSDWAY1 = "/dway"--/way not used because DBM would load before TomTom and can't check
	SlashCmdList["DEADLYBOSSMODSDWAY"] = function(msg)
		if DBM:HasMapRestrictions() then
			DBM:AddMsg(DBM_CORE_NO_ARROW)
			return
		end
		local x, y = string.split(" ", msg:sub(1):trim())
		local xNum, yNum = tonumber(x or ""), tonumber(y or "")
		local success
		if xNum and yNum then
			DBM.Arrow:ShowRunTo(xNum, yNum, 1, nil, true)
			success = true
		else--Check if they used , instead of space.
			x, y = string.split(",", msg:sub(1):trim())
			xNum, yNum = tonumber(x or ""), tonumber(y or "")
			if xNum and yNum then
				DBM.Arrow:ShowRunTo(xNum, yNum, 1, nil, true)
				success = true
			end
		end
		if not success then
			if DBM.Arrow:IsShown() then
				DBM.Arrow:Hide()--Hide
			else--error
				DBM:AddMsg(DBM_ARROW_WAY_USAGE)
			end
		end
	end
	SLASH_DEADLYBOSSMODSPULL1 = "/pull"
	SLASH_DEADLYBOSSMODSBREAK1 = "/break"
	SlashCmdList["DEADLYBOSSMODSPULL"] = function(msg)
		Pull(tonumber(msg) or 10)
	end
	SlashCmdList["DEADLYBOSSMODSBREAK"] = function(msg)
		Break(tonumber(msg) or 10)
	end
	SlashCmdList["DEADLYBOSSMODSRPULL"] = function(msg)
		Pull(30)
	end
	SlashCmdList["DEADLYBOSSMODS"] = function(msg)
		local cmd = msg:lower()
		if cmd == "ver" or cmd == "version" then
			DBM:ShowVersions(false)
		elseif cmd == "ver2" or cmd == "version2" then
			DBM:ShowVersions(true)
		elseif cmd == "unlock" or cmd == "move" then
			DBM.Bars:ShowMovableBar()
		elseif cmd == "help2" then
			for i, v in ipairs(DBM_CORE_SLASHCMD_HELP2) do DBM:AddMsg(v) end
		elseif cmd == "help" then
			for i, v in ipairs(DBM_CORE_SLASHCMD_HELP) do DBM:AddMsg(v) end
		elseif cmd:sub(1, 13) == "timer endloop" then
			DBM:CreatePizzaTimer(time, "", nil, nil, nil, true)
		elseif cmd:sub(1, 5) == "timer" then
			local time, text = msg:match("^%w+ ([%d:]+) (.+)$")
			if not (time and text) then
				for i, v in ipairs(DBM_CORE_TIMER_USAGE) do DBM:AddMsg(v) end
				return
			end
			local min, sec = string.split(":", time)
			min = tonumber(min or "") or 0
			sec = tonumber(sec or "")
			if min and not sec then
				sec = min
				min = 0
			end
			time = min * 60 + sec
			DBM:CreatePizzaTimer(time, text)
		elseif cmd:sub(1, 6) == "ltimer" then
			local time, text = msg:match("^%w+ ([%d:]+) (.+)$")
			if not (time and text) then
				DBM:AddMsg(DBM_PIZZA_ERROR_USAGE)
				return
			end
			local min, sec = string.split(":", time)
			min = tonumber(min or "") or 0
			sec = tonumber(sec or "")
			if min and not sec then
				sec = min
				min = 0
			end
			time = min * 60 + sec
			DBM:CreatePizzaTimer(time, text, nil, nil, true)
		elseif cmd:sub(1, 15) == "broadcast timer" then--Standard Timer
			local permission = true
			if DBM:GetRaidRank(playerName) == 0 then
				DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				permission = false
			end
			local time, text = msg:match("^%w+ %w+ ([%d:]+) (.+)$")
			if not (time and text) then
				DBM:AddMsg(DBM_PIZZA_ERROR_USAGE)
				return
			end
			local min, sec = string.split(":", time)
			min = tonumber(min or "") or 0
			sec = tonumber(sec or "")
			if min and not sec then
				sec = min
				min = 0
			end
			time = min * 60 + sec
			DBM:CreatePizzaTimer(time, text, permission)
		elseif cmd:sub(1, 16) == "broadcast ltimer" then
			local permission = true
			if DBM:GetRaidRank(playerName) == 0 then
				DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
				permission = false
			end
			local time, text = msg:match("^%w+ %w+ ([%d:]+) (.+)$")
			if not (time and text) then
				DBM:AddMsg(DBM_PIZZA_ERROR_USAGE)
				return
			end
			local min, sec = string.split(":", time)
			min = tonumber(min or "") or 0
			sec = tonumber(sec or "")
			if min and not sec then
				sec = min
				min = 0
			end
			time = min * 60 + sec
			DBM:CreatePizzaTimer(time, text, permission, nil, true)
		elseif cmd:sub(0,5) == "break" then
			local timer = tonumber(cmd:sub(6)) or 5
			Break(timer)
		elseif cmd:sub(1, 4) == "pull" then
			local timer = tonumber(cmd:sub(5)) or 10
			Pull(timer)
		elseif cmd:sub(1, 5) == "rpull" then
			Pull(30)
		elseif cmd:sub(1, 3) == "lag" then
			if not LL then
				DBM:AddMsg(DBM_CORE_UPDATE_REQUIRES_RELAUNCH)
				return
			end
			LL:RequestLatency()
			DBM:AddMsg(DBM_CORE_LAG_CHECKING)
			C_Timer:After(5, function() DBM:ShowLag() end)
		elseif cmd:sub(1, 10) == "durability" then
			if not LD then
				DBM:AddMsg(DBM_CORE_UPDATE_REQUIRES_RELAUNCH)
				return
			end
			LD:RequestDurability()
			DBM:AddMsg(DBM_CORE_DUR_CHECKING)
			C_Timer:After(5, function() DBM:ShowDurability() end)
		elseif cmd:sub(1, 5) == "arrow" then
			if not DBM:IsInRaid() then
				DBM:AddMsg(DBM_ARROW_NO_RAIDGROUP)
				return false
			end
			local x, y = string.split(" ", cmd:sub(6):trim())
			local xNum, yNum = tonumber(x or ""), tonumber(y or "")
			local success
			if xNum and yNum then
				DBM.Arrow:ShowRunTo(xNum / 100, yNum / 100, 0)
				success = true
			elseif type(x) == "string" and x:trim() ~= "" then
				local subCmd = x:trim()
				if subCmd:upper() == "HIDE" then
					DBM.Arrow:Hide()
					success = true
				elseif subCmd:upper() == "MOVE" then
					DBM.Arrow:Move()
					success = true
				elseif subCmd:upper() == "TARGET" then
					DBM.Arrow:ShowRunTo("target")
					success = true
				elseif subCmd:upper() == "FOCUS" then
					DBM.Arrow:ShowRunTo("focus")
					success = true
				elseif DBM:GetRaidUnitId(DBM:Capitalize(subCmd)) then
					DBM.Arrow:ShowRunTo(DBM:Capitalize(subCmd))
					success = true
				end
			end
			if not success then
				for i, v in ipairs(DBM_ARROW_ERROR_USAGE) do
					DBM:AddMsg(v)
				end
			end
		elseif cmd:sub(1, 7) == "lockout" or cmd:sub(1, 3) == "ids" then
			if DBM:GetRaidRank(playerName) == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
			end
			if GetNumRaidMembers() == 0 then
				return DBM:AddMsg(DBM_ERROR_NO_RAID)
			end
			DBM:RequestInstanceInfo()
		elseif cmd:sub(1, 10) == "debuglevel" then
			local level = tonumber(cmd:sub(11)) or 1
			if level < 1 or level > 3 then
				DBM:AddMsg("Invalid Value. Debug Level must be between 1 and 3.")
				return
			end
			DBM.Options.DebugLevel = level
			DBM:AddMsg("Debug Level is " .. level)
		elseif cmd:sub(1, 5) == "debug" then
			DBM.Options.DebugMode = DBM.Options.DebugMode == false and true or false
			DBM:AddMsg("Debug Message is " .. (DBM.Options.DebugMode and "ON" or "OFF"))
		elseif cmd:sub(1, 7) == "request" then
			DBM:Unschedule(DBM.RequestTimers)
			DBM:RequestTimers(1)
			DBM:RequestTimers(2)
			DBM:RequestTimers(3)
		elseif cmd:sub(1, 6) == "silent" then
			DBM.Options.SilentMode = DBM.Options.SilentMode == false and true or false
			DBM:AddMsg("SilentMode is " .. (DBM.Options.SilentMode and "ON" or "OFF"))
		else
			DBM:LoadGUI()
		end
	end
end

do
	local function updateRangeFrame(r, reverse)
		if DBM.RangeCheck:IsShown() then
			DBM.RangeCheck:Hide(true)
		else
			if r and (r < 201) then
				DBM.RangeCheck:Show(r, nil, true, nil, reverse)
			else
				DBM.RangeCheck:Show(10, nil, true, nil, reverse)
			end
		end
	end
	SLASH_DBMRANGE1 = "/range"
	SLASH_DBMRANGE2 = "/distance"
	SLASH_DBMHUDAR1 = "/hudar"
	SLASH_DBMRRANGE1 = "/rrange"
	SLASH_DBMRRANGE2 = "/rdistance"
	SlashCmdList["DBMRANGE"] = function(msg)
		local r = tonumber(msg) or 10
		updateRangeFrame(r, false)
	end
	SlashCmdList["DBMHUDAR"] = function(msg)
		local r = tonumber(msg) or 10
		DBMHudMap:ToggleHudar(r)
	end
	SlashCmdList["DBMRRANGE"] = function(msg)
		local r = tonumber(msg) or 10
		updateRangeFrame(r, true)
	end
end

do
	local sortMe = {}
	local OutdatedUsers = {}

	local function sort(v1, v2)
		if v1.revision and not v2.revision then
			return true
		elseif v2.revision and not v1.revision then
			return false
		elseif v1.revision and v2.revision then
			return v1.revision > v2.revision
		else
			return (v1.bwversion or 0) > (v2.bwversion or 0)
		end
	end

	function DBM:ShowVersions(notify)
		for i, v in pairs(raid) do
			tinsert(sortMe, v)
		end
		tsort(sortMe, sort)
		twipe(OutdatedUsers)
		self:AddMsg(DBM_CORE_VERSIONCHECK_HEADER)
		for i, v in ipairs(sortMe) do
			local name = v.name
			local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(name)]
			if playerColor then
				name = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, name, 0.41 * 255, 0.8 * 255, 0.94 * 255)
			end
			if v.displayVersion then
				self:AddMsg(DBM_CORE_VERSIONCHECK_ENTRY:format(name, "DBM "..v.displayVersion, showRealDate(v.revision), v.VPVersion or ""), false)
				if notify and v.revision < self.ReleaseRevision then
					SendChatMessage(chatPrefixShort..DBM_CORE_YOUR_VERSION_OUTDATED, "WHISPER", nil, v.name)
				end
			else
				self:AddMsg(DBM_CORE_VERSIONCHECK_ENTRY_NO_DBM:format(name), false)
			end
		end
		local TotalUsers = #sortMe
		local NoDBM = 0
		local OldMod = 0
		for i = #sortMe, 1, -1 do
			if not sortMe[i].revision then
				NoDBM = NoDBM + 1
			end
			--Table sorting sorts dbm to top, bigwigs underneath. Highest version dbm always at top. so sortMe[1]
			--This check compares all dbm version to highest RELEASE version in raid.
			if sortMe[i].revision and (sortMe[i].revision < sortMe[1].version) then
				OldMod = OldMod + 1
				local name = sortMe[i].name
				local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(name)]
				if playerColor then
					name = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, name, 0.41 * 255, 0.8 * 255, 0.94 * 255)
				end
				tinsert(OutdatedUsers, name)
			end
		end
		local TotalDBM = TotalUsers - NoDBM
		self:AddMsg("---", false)
		self:AddMsg(DBM_CORE_VERSIONCHECK_FOOTER:format(TotalDBM), false)
		self:AddMsg(DBM_CORE_VERSIONCHECK_OUTDATED:format(OldMod, #OutdatedUsers > 0 and tconcat(OutdatedUsers, ", ") or NONE), false)
		twipe(OutdatedUsers)
		twipe(sortMe)
		for i = #sortMe, 1, -1 do
			sortMe[i] = nil
		end
	end
end


-- Lag checking
do
	local sortLag = {}
	local nolagResponse = {}
	local function sortit(v1, v2)
		return (v1.worldlag or 0) < (v2.worldlag or 0)
	end
	function DBM:ShowLag()
		for i, v in pairs(raid) do
			tinsert(sortLag, v)
		end
		tsort(sortLag, sortit)
		self:AddMsg(DBM_CORE_LAG_HEADER)
		for i, v in ipairs(sortLag) do
			local name = v.name
			local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(name)]
			if playerColor then
				name = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, name, 0.41 * 255, 0.8 * 255, 0.94 * 255)
			end
			if v.worldlag then
				self:AddMsg(DBM_CORE_LAG_ENTRY:format(name, v.worldlag, v.homelag), false)
			else
				tinsert(nolagResponse, v.name)
			end
		end
		if #nolagResponse > 0 then
			self:AddMsg(DBM_CORE_LAG_FOOTER:format(tconcat(nolagResponse, ", ")), false)
			for i = #nolagResponse, 1, -1 do
				nolagResponse[i] = nil
			end
		end
		for i = #sortLag, 1, -1 do
			sortLag[i] = nil
		end
	end
	if LL then
		LL:Register("DBM", function(homelag, worldlag, sender, channel)
			if sender and raid[sender] then
				raid[sender].homelag = homelag
				raid[sender].worldlag = worldlag
			end
		end)
	end

end

-- Durability checking
do
	local sortDur = {}
	local nodurResponse = {}
	local function sortit(v1, v2)
		return (v1.worldlag or 0) < (v2.worldlag or 0)
	end
	function DBM:ShowDurability()
		for i, v in pairs(raid) do
			tinsert(sortDur, v)
		end
		tsort(sortDur, sortit)
		self:AddMsg(DBM_CORE_DUR_HEADER)
		for i, v in ipairs(sortDur) do
			local name = v.name
			local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(name)]
			if playerColor then
				name = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, name, 0.41 * 255, 0.8 * 255, 0.94 * 255)
			end
			if v.durpercent then
				self:AddMsg(DBM_CORE_DUR_ENTRY:format(name, v.durpercent, v.durbroken), false)
			else
				tinsert(nodurResponse, v.name)
			end
		end
		if #nodurResponse > 0 then
			self:AddMsg(DBM_CORE_LAG_FOOTER:format(tconcat(nodurResponse, ", ")), false)
			for i = #nodurResponse, 1, -1 do
				nodurResponse[i] = nil
			end
		end
		for i = #sortDur, 1, -1 do
			sortDur[i] = nil
		end
	end
	if LD then
		LD:Register("DBM", function(percent, broken, sender, channel)
			if sender and raid[sender] then
				raid[sender].durpercent = percent
				raid[sender].durbroken = broken
			end
		end)
	end

end

-------------------
--  Pizza Timer  --
-------------------
do

	local function loopTimer(time, text, broadcast, sender)
		DBM:CreatePizzaTimer(time, text, broadcast, sender, true)
	end

	local ignore = {}
	--Standard Pizza Timer
	function DBM:CreatePizzaTimer(time, text, broadcast, sender, loop, terminate)
		if terminate or time == 0 then
			self:Unschedule(loopTimer)
			self.Bars:CancelBar(text)
			fireEvent("DBM_TimerStop", "DBMPizzaTimer")
			return
		end
		if sender and ignore[sender] then return end
		text = text:sub(1, 16)
		text = text:gsub("%%t", UnitName("target") or "<no target>")
		if time < 3 then
			self:AddMsg(DBM_PIZZA_ERROR_USAGE)
			return
		end
		self.Bars:CreateBar(time, text, "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME")
		fireEvent("DBM_TimerStart", "DBMPizzaTimer", text, time, "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME", "pizzatimer", nil, 0)
		if broadcast and self:GetRaidRank() >= 1 then
			sendSync("U", ("%s\t%s"):format(time, text))
		end
		if sender then self:ShowPizzaInfo(text, sender) end
		if loop then
			self:Unschedule(loopTimer)--Only one loop timer supported at once doing this, but much cleaner this way
			self:Schedule(time, loopTimer, time, text, broadcast, sender)
		end
	end

	function DBM:AddToPizzaIgnore(name)
		ignore[name] = true
	end
end

function DBM:ShowPizzaInfo(id, sender)
	if self.Options.ShowPizzaMessage then
		self:AddMsg(DBM_PIZZA_SYNC_INFO:format(sender, id))
	end
end



------------------
--  Hyperlinks  --
------------------
do
	local ignore, cancel
	StaticPopupDialogs["DBM_CONFIRM_IGNORE"] = {
		text = DBM_PIZZA_CONFIRM_IGNORE,
		button1 = YES,
		button2 = NO,
		OnAccept = function(self)
			DBM:AddToPizzaIgnore(ignore)
			DBM.Bars:CancelBar(cancel)
		end,
		timeout = 0,
		hideOnEscape = 1,
	}

	DEFAULT_CHAT_FRAME:HookScript("OnHyperlinkClick", function(self, link, string, button, ...)
		local linkType, arg1, arg2, arg3 = strsplit(":", link)
		if linkType == "DBM" and arg1 == "cancel" then
			DBM.Bars:CancelBar(link:match("DBM:cancel:(.+):nil$"))
		elseif linkType == "DBM" and arg1 == "ignore" then
			cancel = link:match("DBM:ignore:(.+):[^%s:]+$")
			ignore = link:match(":([^:]+)$")
			StaticPopup_Show("DBM_CONFIRM_IGNORE", ignore)
		elseif linkType == "DBM" and arg1 == "update" then
			DBM:ShowUpdateReminder(arg2, arg3) -- displayVersion, revision
		end
	end)
end

do
	local old = ItemRefTooltip.SetHyperlink -- we have to hook this function since the default ChatFrame code assumes that all links except for player and channel links are valid arguments for this function
	function ItemRefTooltip:SetHyperlink(link, ...)
		if link:match("^DBM") then return end
		return old(self, link, ...)
	end
end

-----------------
--  GUI Stuff  --
-----------------
do
	local callOnLoad = {}
	function DBM:LoadGUI()
		if not dbmIsEnabled then
			DBM:AddMsg(DBM_CORE_UPDATEREMINDER_DISABLE)
			return
		end
		if not IsAddOnLoaded("DBM-GUI") then
			local _, _, _, enabled = GetAddOnInfo("DBM-GUI")
			if not enabled then
				EnableAddOn("DBM-GUI")
			end
			local loaded, reason = LoadAddOn("DBM-GUI")
			if not loaded then
				if reason then
					self:AddMsg(DBM_CORE_LOAD_GUI_ERROR:format(tostring(_G["ADDON_"..reason or ""])))
				else
					self:AddMsg(DBM_CORE_LOAD_GUI_ERROR:format(DBM_CORE_UNKNOWN))
				end
				return false
			end
			tsort(callOnLoad, function(v1, v2) return v1[2] < v2[2] end)
			for i, v in ipairs(callOnLoad) do v[1]() end
			if not InCombatLockdown() and not UnitAffectingCombat("player") and not IsFalling() then--We loaded in combat but still need to avoid garbage collect in combat
				collectgarbage("collect")
			end
		end
		return DBM_GUI:ShowHide()
	end

	function DBM:RegisterOnGuiLoadCallback(f, sort)
		tinsert(callOnLoad, {f, sort or mhuge})
	end
end


----------------------
--  Minimap Button  --
----------------------
do
	--Old LDB Functions
	local frame = CreateFrame("Frame", "DBMLDBFrame")

	--New LDB Object
	if LibStub("LibDataBroker-1.1", true) then
		dataBroker = LibStub("LibDataBroker-1.1"):NewDataObject("DBM",
			{type = "launcher", label = "DBM", icon = "Interface\\AddOns\\DBM-Core\\textures\\dbm_airhorn"}
		)

		function dataBroker.OnClick(self, button)
			if IsShiftKeyDown() then return end
			DBM:LoadGUI()
		end

		function dataBroker.OnTooltipShow(GameTooltip)
			GameTooltip:SetText(DBM_CORE_MINIMAP_TOOLTIP_HEADER, 1, 1, 1)
			GameTooltip:AddLine(("%s (%s)"):format(DBM.DisplayVersion, showRealDate(DBM.Revision)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(DBM_CORE_MINIMAP_TOOLTIP_FOOTER, RAID_CLASS_COLORS.MAGE.r, RAID_CLASS_COLORS.MAGE.g, RAID_CLASS_COLORS.MAGE.b, 1)
			GameTooltip:AddLine(DBM_LDB_TOOLTIP_HELP1, RAID_CLASS_COLORS.MAGE.r, RAID_CLASS_COLORS.MAGE.g, RAID_CLASS_COLORS.MAGE.b)
		end
	end

	function DBM:ToggleMinimapButton()
		DBM_MinimapIcon.hide = not DBM_MinimapIcon.hide
		if DBM_MinimapIcon.hide then
			LibStub("LibDBIcon-1.0"):Hide("DBM")
		else
			LibStub("LibDBIcon-1.0"):Show("DBM")
		end
	end
end

-------------------------------------------------
--  Raid/Party Handling and Unit ID Utilities  --
-------------------------------------------------
do
	local inRaid = false

	local raidGuids = {}
	local iconSeter = {}

	--	save playerinfo into raid table on load. (for solo raid)
	DBM:RegisterOnLoadCallback(function()
		if not raid[playerName] then
			raid[playerName] = {}
			raid[playerName].name = playerName
			raid[playerName].guid = UnitGUID("player") or ""
			raid[playerName].rank = 0
			raid[playerName].class = playerClass
			raid[playerName].id = "player"
			raid[playerName].groupId = 0
			raid[playerName].revision = DBM.Revision
			raid[playerName].version = DBM.ReleaseRevision
			raid[playerName].displayVersion = DBM.DisplayVersion
			raid[playerName].enabledIcons = tostring(not DBM.Options.DontSetIcons)
			raidGuids[UnitGUID("player") or ""] = playerName
		end
	end)

	local function updateAllRoster(self)
		if GetNumRaidMembers() >= 1 then
			if not inRaid then
				inRaid = true
				sendSync("H")
				fireEvent("DBM_raidJoin", playerName)
			end
			for i = 1, GetNumRaidMembers() do
				local name, rank, subgroup, _, _, className = GetRaidRosterInfo(i)
				if name and name ~= UNKNOWN then
					local id = "raid"..i
					if (not raid[name]) and inRaid then
						fireEvent("DBM_raidJoin", name)
					end
					raid[name] = raid[name] or {}
					raid[name].name = name
					raid[name].rank = rank
					raid[name].subgroup = subgroup
					raid[name].class = className
					raid[name].id = id
					raid[name].groupId = i
					raid[name].guid = UnitGUID(id) or ""
					raid[name].updated = true
					raidGuids[UnitGUID(id) or ""] = name
				end
			end
--			enableIcons = false
			twipe(iconSeter)
			for i, v in pairs(raid) do
				if not v.updated then
					raidGuids[v.guid] = nil
					raid[i] = nil
					removeEntry(newerVersionPerson, i)
					fireEvent("DBM_raidLeave", i)
				else
					v.updated = nil
					if v.revision and v.rank > 0 and (v.enabledIcons or "") == "true" then
						iconSeter[#iconSeter + 1] = v.revision.." "..v.name
					end
				end
			end
			if #iconSeter > 0 then
				tsort(iconSeter, function(a, b) return a > b end)
				local elected = iconSeter[1]
				if playerName == elected:sub(elected:find(" ") + 1) then
					enableIcons = true
				end
			end
		elseif GetNumPartyMembers() >= 1 then
			if not inRaid then
				-- joined a new party
				inRaid = true
				sendSync("H")
				fireEvent("DBM_partyJoin", playerName)
			end
			for i = 0, GetNumPartyMembers() do
				local id
				if (i == 0) then
					id = "player"
				else
					id = "party"..i
				end
				local name, server = UnitName(id)
				local rank = UnitIsPartyLeader(id) and 2 or 0
				local _, className = UnitClass(id)
				if server and server ~= ""  then
					name = name.."-"..server
				end
				if (not raid[name]) and inRaid then
					fireEvent("DBM_partyJoin", name)
				end
				raid[name] = raid[name] or {}
				raid[name].name = name
				raid[name].guid = UnitGUID(id) or ""
				raid[name].rank = rank
				raid[name].class = className
				raid[name].id = id
				raid[name].groupId = i
				raid[name].updated = true
				raidGuids[UnitGUID(id) or ""] = name
			end
--			enableIcons = false
			twipe(iconSeter)
			for i, v in pairs(raid) do
				if not v.updated then
					raidGuids[v.guid] = nil
					raid[i] = nil
					removeEntry(newerVersionPerson, i)
					fireEvent("DBM_partyLeave", i)
				else
					v.updated = nil
					if v.revision and v.rank > 0 and (v.enabledIcons or "") == "true" then
						iconSeter[#iconSeter + 1] = v.revision.." "..v.name
					end
				end
			end
			if #iconSeter > 0 then
				tsort(iconSeter, function(a, b) return a > b end)
				local elected = iconSeter[1]
				if playerName == elected:sub(elected:find(" ") + 1) then
					enableIcons = true
				end
			end
		else
			-- left the current group/raid
			inRaid = false
			enableIcons = true
			fireEvent("DBM_raidLeave", playerName)
			twipe(raid)
			twipe(newerVersionPerson)
			-- restore playerinfo into raid table on raidleave. (for solo raid)
			raid[playerName] = {}
			raid[playerName].name = playerName
			raid[playerName].guid = UnitGUID("player") or ""
			raid[playerName].rank = 0
			raid[playerName].class = playerClass
			raid[playerName].id = "player"
			raid[playerName].groupId = 0
			raid[playerName].revision = DBM.Revision
			raid[playerName].version = DBM.ReleaseRevision
			raid[playerName].displayVersion = DBM.DisplayVersion
			raidGuids[UnitGUID("player") or ""] = playerName
		end
	end

	function DBM:RAID_ROSTER_UPDATE(force)
		self:Unschedule(updateAllRoster)
		if force then
			updateAllRoster(self)
		else
			self:Schedule(1.5, updateAllRoster, self)
		end
	end

	function DBM:PARTY_MEMBERS_CHANGED(force)
		self:Unschedule(updateAllRoster)
		if force then
			updateAllRoster(self)
		else
			self:Schedule(1.5, updateAllRoster, self)
		end
	end

	function DBM:IsInRaid()
		return inRaid
	end

	function DBM:GetRaidRank(name)
		name = name or playerName
		if name == playerName then--If name is player, try to get actual rank. Because raid[name].rank sometimes seems returning 0 even player is promoted.
			return UnitIsPartyLeader("player") and 2 or UnitIsRaidOfficer("player") and 1 or 0
		else
			return (raid[name] and raid[name].rank) or 0
		end
	end

	function DBM:GetRaidSubgroup(name)
		return (raid[name] and raid[name].subgroup) or 0
	end

	function DBM:GetRaidClass(name)
		return (raid[name] and raid[name].class) or "UNKNOWN"
	end

	function DBM:GetRaidUnitId(name)
		return raid[name] and raid[name].id
	end

	function DBM:GetEnemyUnitIdByGUID(guid)
		for i = 1, 4 do
			local unitId = "boss"..i
			local guid2 = UnitGUID(unitId)
			if guid == guid2 then
				return unitId
			end
		end

		local idType = ((GetNumRaidMembers() == 0) and "party") or "raid"
		for i = 0, mmax(GetNumRaidMembers(), GetNumPartyMembers()) do
			local unitId = ((i == 0) and "target") or idType..i.."target"
			local guid2 = UnitGUID(unitId)
			if guid == guid2 then
				return unitId
			end
		end
		return DBM_CORE_UNKNOWN
	end

	function DBM:GetPlayerGUIDByName(name)
		return raid[name] and raid[name].guid
	end

	function DBM:GetMyPlayerInfo()
		return playerName, playerLevel, playerRealm
	end

	function DBM:GetUnitFullName(uId)
		if not uId then return nil end
		return GetUnitName(uId, true)
	end

	function DBM:GetFullPlayerNameByGUID(guid)
		return raidGuids[guid]
	end

	function DBM:GetPlayerNameByGUID(guid)
		return raidGuids[guid] and raidGuids[guid]:gsub("%-.*$", "")
	end

	function DBM:GetGroupId(name)
		local raidMember = raid[name] or raid[GetUnitName(name) or ""]
		return raidMember and raidMember.groupId or 0
	end
end

do
	-- yes, we still do avoid memory allocations during fights; so we don't use a closure around a counter here
	-- this seems to be the easiest way to write an iterator that returns the unit id *string* as first argument without a memory allocation
	local function raidIterator(groupMembers, uId)
		local a, b = uId:byte(-2, -1)
		local i = (a >= 0x30 and a <= 0x39 and (a - 0x30) * 10 or 0) + b - 0x30
		if i < groupMembers then
			return "raid" .. i + 1, i + 1
		end
	end

	local function partyIterator(groupMembers, uId)
		if not uId then
			return "player", 0
		elseif uId == "player" then
			if groupMembers > 0 then
				return "party1", 1
			end
		else
			local i = uId:byte(-1) - 0x30
			if i < groupMembers then
				return "party" .. i + 1, i + 1
			end
		end
	end

	local function soloIterator(_, state)
		if not state then -- no state == first call
			return "player", 0
		end
	end

	-- returns the unit ids of all raid or party members, including the player's own id
	-- limitations: will break if there are ever raids with more than 99 players or partys with more than 10
	function DBM:GetGroupMembers()
		if GetNumRaidMembers() > 0 then
			return raidIterator, GetNumRaidMembers(), "raid0"
		elseif GetNumPartyMembers() > 0 then
			return partyIterator, GetNumPartyMembers(), nil
		else
			-- solo!
			return soloIterator, nil, nil
		end
	end
end
function DBM:GetUnitCreatureId(uId)
	local guid = UnitGUID(uId)
	return self:GetCIDFromGUID(guid)
end

function DBM:GetCIDFromGUID(guid)
	return guid and tonumber(guid:sub(9, 12), 16) or 0
end

function DBM:IsCreatureGUID(guid)
	if bband(guid:sub(1, 5), 0x00F) == 3 or bband(guid:sub(1, 5), 0x00F) == 5 then
		return true
	end
	return false
end

function DBM:GetBossUnitId(name, bossOnly)--Deprecated, only old mods use this
	local returnUnitID
	for i = 1, 4 do
		if UnitName("boss" .. i) == name then
			returnUnitID = "boss"..i
		end
	end
	if not returnUnitID and not bossOnly then
		for uId in self:GetGroupMembers() do
			if UnitName(uId .. "target") == name and not UnitIsPlayer(uId .. "target") then
				returnUnitID = uId.."target"
			end
		end
	end
	return returnUnitID
end

function DBM:GetUnitIdFromGUID(cidOrGuid, bossOnly)
	local returnUnitID
	for i = 1, 4 do
		local unitId = "boss"..i
		local bossGUID = UnitGUID(unitId)
		if type(cidOrGuid) == "number" then--CID passed
			local cid = self:GetCIDFromGUID(bossGUID)
			if cid == cidOrGuid then
				returnUnitID = unitId
			end
		else--GUID passed
			if bossGUID == cidOrGuid then
				returnUnitID = unitId
			end
		end
	end
	--Didn't find valid unitID from boss units, scan raid targets
	if not returnUnitID and not bossOnly then
		for uId in self:GetGroupMembers() do
			local unitId = uId .. "target"
			local bossGUID = UnitGUID(unitId)
			local cid = self:GetCIDFromGUID(cidOrGuid)
			if bossGUID == cidOrGuid or cid == cidOrGuid then
				returnUnitID = unitId
			end
		end
	end
	return returnUnitID
end

function DBM:CheckNearby(range, targetname)
	if not targetname and DBM.RangeCheck:GetDistanceAll(range) then
		return true--No target name means check if anyone is near self, period
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId and not UnitIsUnit("player", uId) then
			local inRange = DBM.RangeCheck:GetDistance(uId)
			if inRange and inRange < range + 0.5 then
				return true
			end
		end
	end
	return false
end

---------------
--  Options  --
---------------
function DBM:AddDefaultOptions(t1, t2)
	for i, v in pairs(t2) do
		if t1[i] == nil then
			t1[i] = v
		elseif type(v) == "table" and type(t1[i]) == "table" then
			self:AddDefaultOptions(t1[i], v)
		end
	end
end

function DBM:LoadModOptions(modId, inCombat, first)
	local oldSavedVarsName = modId:gsub("-", "").."_SavedVars"
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local savedStatsName = modId:gsub("-", "").."_SavedStats"
	local fullname = playerName.."-"..playerRealm
	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	local savedOptions = _G[savedVarsName][fullname] or {}
	local savedStats = _G[savedStatsName] or {}
	local existId = {}
	for i, id in ipairs(DBM.ModLists[modId]) do
		existId[id] = true
		-- init
		if not savedOptions[id] then savedOptions[id] = {} end
		local mod = DBM:GetModByName(id)
		-- migrate old option
		if _G[oldSavedVarsName] and _G[oldSavedVarsName][id] then
			self:Debug("LoadModOptions: Found old options, importing", 2)
			local oldTable = _G[oldSavedVarsName][id]
			_G[oldSavedVarsName][id] = nil
			savedOptions[id][profileNum] = oldTable
		end
		if not savedOptions[id][profileNum] and not first then--previous profile not found. load defaults
			self:Debug("LoadModOptions: No saved options, creating defaults for profile "..profileNum, 2)
			local defaultOptions = {}
			for option, optionValue in pairs(mod.DefaultOptions) do
				if type(optionValue) == "table" then
					optionValue = optionValue.value
				elseif type(optionValue) == "string" then
					optionValue = mod:GetRoleFlagValue(optionValue)
				end
				defaultOptions[option] = optionValue
			end
			savedOptions[id][profileNum] = defaultOptions
		else
			savedOptions[id][profileNum] = savedOptions[id][profileNum] or mod.Options
			--check new option
			for option, optionValue in pairs(mod.DefaultOptions) do
				if savedOptions[id][profileNum][option] == nil then
					if type(optionValue) == "table" then
						optionValue = optionValue.value
					elseif type(optionValue) == "string" then
						optionValue = mod:GetRoleFlagValue(optionValue)
					end
					savedOptions[id][profileNum][option] = optionValue
				end
			end
			--clean unused saved variables (do not work on combat load)
			if not inCombat then
				for option, optionValue in pairs(savedOptions[id][profileNum]) do
					if mod.DefaultOptions[option] == nil then
						savedOptions[id][profileNum][option] = nil
					elseif mod.DefaultOptions[option] and (type(mod.DefaultOptions[option]) == "table") then--recover broken dropdown option
						if savedOptions[id][profileNum][option] and (type(savedOptions[id][profileNum][option]) == "boolean") then
							savedOptions[id][profileNum][option] = mod.DefaultOptions[option].value
						end
					--Fix default options for colored bar by type that were set to 0 because no defaults existed at time they were created, but do now.
					elseif option:find("TColor") then
						if savedOptions[id][profileNum][option] and savedOptions[id][profileNum][option] == 0 and mod.DefaultOptions[option] and mod.DefaultOptions[option] ~= 0 then
							savedOptions[id][profileNum][option] = mod.DefaultOptions[option]
							self:Debug("Migrated "..option.." to option defaults")
						end
					--Fix options for custom special warning sounds not in addons folder that are not using soundkit IDs
					elseif option:find("SWSound") then
						if savedOptions[id][profileNum][option] and (type(savedOptions[id][profileNum][option]) == "string") and (savedOptions[id][profileNum][option] ~= "") and (savedOptions[id][profileNum][option] ~= "None") then
							local searchMsg = (savedOptions[id][profileNum][option]):lower()
							if not searchMsg:find("addons") then
								savedOptions[id][profileNum][option] = mod.DefaultOptions[option]
								self:Debug("Migrated "..option.." to option defaults")
							end
						end
					end
				end
			end
		end
		--apply saved option to actual option table
		mod.Options = savedOptions[id][profileNum]
		--stats init (only first load)
		if first then
			savedStats[id] = savedStats[id] or {}
			local stats = savedStats[id]
			stats.normalKills = stats.normalKills or 0
			stats.normalPulls = stats.normalPulls or 0
			stats.heroicKills = stats.heroicKills or 0
			stats.heroicPulls = stats.heroicPulls or 0
			stats.normal25Kills = stats.normal25Kills or 0
			stats.normal25Pulls = stats.normal25Pulls or 0
			stats.heroic25Kills = stats.heroic25Kills or 0
			stats.heroic25Pulls = stats.heroic25Pulls or 0
			mod.stats = stats
			--run OnInitialize function
			if mod.OnInitialize then mod:OnInitialize(mod) end
		end
	end
	--clean unused saved variables (do not work on combat load)
	if not inCombat then
		for id, table in pairs(savedOptions) do
			if not existId[id] and not id:find("talent") then
				savedOptions[id] = nil
			end
		end
		for id, table in pairs(savedStats) do
			if not existId[id] then
				savedStats[id] = nil
			end
		end
	end
	_G[savedVarsName][fullname] = savedOptions
	if profileNum > 0 then
		_G[savedVarsName][fullname]["talent"..profileNum] = currentSpecName
		self:Debug("LoadModOptions: Finished loading "..(_G[savedVarsName][fullname]["talent"..profileNum] or DBM_CORE_UNKNOWN))
	end
	_G[savedStatsName] = savedStats
	if not first and DBM_GUI and DBM_GUI.currentViewing and DBM_GUI_OptionsFrame:IsShown() then
		DBM_GUI_OptionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:SpecChanged(force)
	if not force and not DBM_UseDualProfile then return end
	--Load Options again.
	self:Debug("SpecChanged fired", 2)
	for modId, idTable in pairs(self.ModLists) do
		self:LoadModOptions(modId)
	end
end

function DBM:PLAYER_LEVEL_CHANGED()
	playerLevel = UnitLevel("player")
	if playerLevel < 15 and playerLevel > 9 then
		self:PLAYER_TALENT_UPDATE()
	end
end

function DBM:LoadAllModDefaultOption(modId)
	-- modId is string like "DBM-Highmaul"
	if not modId or not self.ModLists[modId] then return end
	-- prevent error
	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local fullname = playerName.."-"..playerRealm
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	for i, id in ipairs(self.ModLists[modId]) do
		-- prevent nil table error
		if not _G[savedVarsName][fullname][id] then _G[savedVarsName][fullname][id] = {} end
		-- actual do load default option
		local mod = self:GetModByName(id)
		local defaultOptions = {}
		for option, optionValue in pairs(mod.DefaultOptions) do
			if type(optionValue) == "table" then
				optionValue = optionValue.value
			elseif type(optionValue) == "string" then
				optionValue = mod:GetRoleFlagValue(optionValue)
			end
			defaultOptions[option] = optionValue
		end
		mod.Options = {}
		mod.Options = defaultOptions
		_G[savedVarsName][fullname][id][profileNum] = {}
		_G[savedVarsName][fullname][id][profileNum] = mod.Options
	end
	self:AddMsg(DBM_CORE_ALLMOD_DEFAULT_LOADED)
	-- update gui if showing
	if DBM_GUI and DBM_GUI.currentViewing and DBM_GUI_OptionsFrame:IsShown() then
		DBM_GUI_OptionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:LoadModDefaultOption(mod)
	-- mod must be table
	if not mod then return end
	-- prevent error
	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = (mod.modId):gsub("-", "").."_AllSavedVars"
	local fullname = playerName.."-"..playerRealm
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	if not _G[savedVarsName][fullname] then _G[savedVarsName][fullname] = {} end
	if not _G[savedVarsName][fullname][mod.id] then _G[savedVarsName][fullname][mod.id] = {} end
	-- do load default
	local defaultOptions = {}
	for option, optionValue in pairs(mod.DefaultOptions) do
		if type(optionValue) == "table" then
			optionValue = optionValue.value
		elseif type(optionValue) == "string" then
			optionValue = mod:GetRoleFlagValue(optionValue)
		end
		defaultOptions[option] = optionValue
	end
	mod.Options = {}
	mod.Options = defaultOptions
	_G[savedVarsName][fullname][mod.id][profileNum] = {}
	_G[savedVarsName][fullname][mod.id][profileNum] = mod.Options
	self:AddMsg(DBM_CORE_MOD_DEFAULT_LOADED)
	-- update gui if showing
	if DBM_GUI and DBM_GUI.currentViewing and DBM_GUI_OptionsFrame:IsShown() then
		DBM_GUI_OptionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:CopyAllModOption(modId, sourceName, sourceProfile)
	-- modId is string like "DBM-Highmaul"
	if not modId or not sourceName or not sourceProfile or not DBM.ModLists[modId] then return end
	-- prevent error
	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local targetName = playerName.."-"..playerRealm
	local targetProfile = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- do not copy setting itself
	if targetName == sourceName and targetProfile == sourceProfile then
		self:AddMsg(DBM_CORE_MPROFILE_COPY_SELF_ERROR)
		return
	end
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	-- check source is exist
	if not _G[savedVarsName][sourceName] then
		self:AddMsg(DBM_CORE_MPROFILE_COPY_S_ERROR)
		return
	end
	local targetOptions = _G[savedVarsName][targetName] or {}
	for i, id in ipairs(self.ModLists[modId]) do
		-- check source is exist
		if not _G[savedVarsName][sourceName][id] then
			self:AddMsg(DBM_CORE_MPROFILE_COPY_S_ERROR)
			return
		end
		if not _G[savedVarsName][sourceName][id][sourceProfile] then
			self:AddMsg(DBM_CORE_MPROFILE_COPY_S_ERROR)
			return
		end
		-- prevent nil table error
		if not _G[savedVarsName][targetName][id] then _G[savedVarsName][targetName][id] = {} end
		-- copy table
		_G[savedVarsName][targetName][id][targetProfile] = {}--clear before copy
		_G[savedVarsName][targetName][id][targetProfile] = _G[savedVarsName][sourceName][id][sourceProfile]
		--check new option
		local mod = self:GetModByName(id)
		for option, optionValue in pairs(mod.Options) do
			if _G[savedVarsName][targetName][id][targetProfile][option] == nil then
				_G[savedVarsName][targetName][id][targetProfile][option] = optionValue
			end
		end
		-- apply to options table
		mod.Options = {}
		mod.Options = _G[savedVarsName][targetName][id][targetProfile]
	end
	if targetProfile > 0 then
		_G[savedVarsName][targetName]["talent"..targetProfile] = currentSpecName
	end
	self:AddMsg(DBM_CORE_MPROFILE_COPY_SUCCESS:format(sourceName, sourceProfile))
	-- update gui if showing
	if DBM_GUI and DBM_GUI.currentViewing and DBM_GUI_OptionsFrame:IsShown() then
		DBM_GUI_OptionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:CopyAllModTypeOption(modId, sourceName, sourceProfile, Type)
	-- modId is string like "DBM-Highmaul"
	if not modId or not sourceName or not sourceProfile or not self.ModLists[modId] or not Type then return end
	-- prevent error
	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local targetName = playerName.."-"..playerRealm
	local targetProfile = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- do not copy setting itself
	if targetName == sourceName and targetProfile == sourceProfile then
		self:AddMsg(DBM_CORE_MPROFILE_COPYS_SELF_ERROR)
		return
	end
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	-- check source is exist
	if not _G[savedVarsName][sourceName] then
		self:AddMsg(DBM_CORE_MPROFILE_COPYS_S_ERROR)
		return
	end
	local targetOptions = _G[savedVarsName][targetName] or {}
	for i, id in ipairs(self.ModLists[modId]) do
		-- check source is exist
		if not _G[savedVarsName][sourceName][id] then
			self:AddMsg(DBM_CORE_MPROFILE_COPYS_S_ERROR)
			return
		end
		if not _G[savedVarsName][sourceName][id][sourceProfile] then
			self:AddMsg(DBM_CORE_MPROFILE_COPYS_S_ERROR)
			return
		end
		-- prevent nil table error
		if not _G[savedVarsName][targetName][id] then _G[savedVarsName][targetName][id] = {} end
		-- copy table
		for option, optionValue in pairs(_G[savedVarsName][sourceName][id][sourceProfile]) do
			if option:find(Type) then
				_G[savedVarsName][targetName][id][targetProfile][option] = optionValue
			end
		end
		-- apply to options table
		local mod = self:GetModByName(id)
		mod.Options = {}
		mod.Options = _G[savedVarsName][targetName][id][targetProfile]
	end
	if targetProfile > 0 then
		_G[savedVarsName][targetName]["talent"..targetProfile] = currentSpecName
	end
	self:AddMsg(DBM_CORE_MPROFILE_COPYS_SUCCESS:format(sourceName, sourceProfile))
	-- update gui if showing
	if DBM_GUI and DBM_GUI.currentViewing and DBM_GUI_OptionsFrame:IsShown() then
		DBM_GUI_OptionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:DeleteAllModOption(modId, name, profile)
	-- modId is string like "DBM-Highmaul"
	if not modId or not name or not profile or not self.ModLists[modId] then return end
	-- prevent error
	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local fullname = playerName.."-"..playerRealm
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- cannot delete current profile.
	if fullname == name and profileNum == profile then
		self:AddMsg(DBM_CORE_MPROFILE_DELETE_SELF_ERROR)
		return
	end
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	if not _G[savedVarsName][name] then
		self:AddMsg(DBM_CORE_MPROFILE_DELETE_S_ERROR)
		return
	end
	for i, id in ipairs(self.ModLists[modId]) do
		-- prevent nil table error
		if not _G[savedVarsName][name][id] then
			self:AddMsg(DBM_CORE_MPROFILE_DELETE_S_ERROR)
			return
		end
		-- delete
		_G[savedVarsName][name][id][profile] = nil
	end
	_G[savedVarsName][name]["talent"..profile] = nil
	self:AddMsg(DBM_CORE_MPROFILE_DELETE_SUCCESS:format(name, profile))
end

function DBM:ClearAllStats(modId)
	-- modId is string like "DBM-Highmaul"
	if not modId or not self.ModLists[modId] then return end
	-- variable init
	local savedStatsName = modId:gsub("-", "").."_SavedStats"
	-- prevent nil table error
	if not _G[savedStatsName] then _G[savedStatsName] = {} end
	for i, id in ipairs(self.ModLists[modId]) do
		local mod = self:GetModByName(id)
		-- prevent nil table error
		local defaultStats = {}
		defaultStats.normalKills = 0
		defaultStats.normalPulls = 0
		defaultStats.heroicKills = 0
		defaultStats.heroicPulls = 0
		defaultStats.normal25Kills = 0
		defaultStats.normal25Pulls = 0
		defaultStats.heroic25Kills = 0
		defaultStats.heroic25Pulls = 0
		mod.stats = {}
		mod.stats = defaultStats
		_G[savedStatsName][id] = {}
		_G[savedStatsName][id] = defaultStats
	end
	self:AddMsg(DBM_CORE_ALLMOD_STATS_RESETED)
	DBM_GUI:UpdateModList()
end

do
	function loadOptions(self)
		--init
		if not DBM_AllSavedOptions then DBM_AllSavedOptions = {} end
		usedProfile = DBM_UsedProfile or usedProfile
		if not usedProfile or (usedProfile ~= "Default" and not DBM_AllSavedOptions[usedProfile]) then
			-- DBM.Option is not loaded. so use print function
			print(DBM_CORE_PROFILE_NOT_FOUND)
			usedProfile = "Default"
		end
		DBM_UsedProfile = usedProfile
		--migrate old options
		if DBM_SavedOptions and not DBM_AllSavedOptions[usedProfile] then
			DBM_AllSavedOptions[usedProfile] = DBM_SavedOptions
		end
		self.Options = DBM_AllSavedOptions[usedProfile] or {}
		dbmIsEnabled = true
		self:AddDefaultOptions(self.Options, self.DefaultOptions)
		DBM_AllSavedOptions[usedProfile] = self.Options

		-- force enable dual profile (change default)
		if DBM_CharSavedRevision < 12976 then
			if playerClass ~= "MAGE" and playerClass ~= "WARLOCK" and playerClass ~= "ROGUE" then
				DBM_UseDualProfile = true
			end
		end
		DBM_CharSavedRevision = self.Revision
		-- load special warning options
		self:UpdateWarningOptions()
		self:UpdateSpecialWarningOptions()
		self.Options.CoreSavedRevision = self.Revision
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then return end--Don't do sound migration in a situation user is loading wrong DBM version, to avoid sound path corruption
		--Migrate user sound options to soundkit Ids if selected media doesn't exist in Interface\\AddOns
		--This will in the short term, screw with people trying to use LibSharedMedia sound files on 8.1.5 until LSM has migrated as well.
		local migrated = false
		if type(self.Options.RaidWarningSound) == "string" and self.Options.RaidWarningSound ~= "" then
			local searchMsg = self.Options.RaidWarningSound:lower()
			if not searchMsg:find("addons") or searchMsg:find("classicsupport") then
				self.Options.RaidWarningSound = self.DefaultOptions.RaidWarningSound
				migrated = true
			end
		end
		if type(self.Options.SpecialWarningSound) == "string" and self.Options.SpecialWarningSound ~= "" then
			local searchMsg = self.Options.SpecialWarningSound:lower()
			if not searchMsg:find("addons") or searchMsg:find("classicsupport") then
				self.Options.SpecialWarningSound = self.DefaultOptions.SpecialWarningSound
				migrated = true
			end
		end
		if type(self.Options.SpecialWarningSound2) == "string" and self.Options.SpecialWarningSound2 ~= "" then
			local searchMsg = self.Options.SpecialWarningSound2:lower()
			if not searchMsg:find("addons") or searchMsg:find("classicsupport") then
				self.Options.SpecialWarningSound2 = self.DefaultOptions.SpecialWarningSound2
				migrated = true
			end
		end
		if type(self.Options.SpecialWarningSound3) == "string" and self.Options.SpecialWarningSound3 ~= "" then
			local searchMsg = self.Options.SpecialWarningSound3:lower()
			if not searchMsg:find("addons") or searchMsg:find("classicsupport") then
				self.Options.SpecialWarningSound3 = self.DefaultOptions.SpecialWarningSound3
				migrated = true
			end
		end
		if type(self.Options.SpecialWarningSound4) == "string" and self.Options.SpecialWarningSound4 ~= "" then
			local searchMsg = self.Options.SpecialWarningSound4:lower()
			if not searchMsg:find("addons") or searchMsg:find("classicsupport") then
				self.Options.SpecialWarningSound4 = self.DefaultOptions.SpecialWarningSound4
				migrated = true
			end
		end
		if type(self.Options.SpecialWarningSound5) == "string" and self.Options.SpecialWarningSound5 ~= "" then
			local searchMsg = self.Options.SpecialWarningSound5:lower()
			if not searchMsg:find("addons") or searchMsg:find("classicsupport") then
				self.Options.SpecialWarningSound5 = self.DefaultOptions.SpecialWarningSound5
				migrated = true
			end
		end
		if migrated then
			self:AddMsg(DBM_CORE_SOUNDKIT_MIGRATION)
		end
	end
end

function DBM:LFG_PROPOSAL_SHOW()
	if self.Options.ShowQueuePop and not self.Options.DontShowBossTimers then
		self.Bars:CreateBar(40, DBM_LFG_INVITE, "Interface\\Icons\\Spell_Holy_BorrowedTime")
		fireEvent("DBM_TimerStart", "DBMLFGTimer", DBM_LFG_INVITE, 40, "Interface\\Icons\\Spell_Holy_BorrowedTime", "extratimer", nil, 0)
	end
end

function DBM:LFG_PROPOSAL_SUCCEEDED()
	DBM.Bars:CreateBar(900, DBM_LFG_CD, "Interface\\Icons\\Spell_Holy_SurgeOfLight")
end

function DBM:LFG_PROPOSAL_FAILED()
	self.Bars:CancelBar(DBM_LFG_INVITE)
	fireEvent("DBM_TimerStop", "DBMLFGTimer")
end

function DBM:LFG_UPDATE()
	local _, joined = GetLFGInfoServer()
	if not joined then
		self.Bars:CancelBar(DBM_LFG_INVITE)
		fireEvent("DBM_TimerStop", "DBMLFGTimer")
	end
end

function DBM:PLAYER_TALENT_UPDATE()
	local lastSpecID = currentSpecGroup
	self:SetCurrentSpecInfo()
	if currentSpecGroup ~= lastSpecID then
		self:SpecChanged()
	end
end

--------------------------------
--  Load Boss Mods on Demand  --
--------------------------------
do
	local function SecondaryLoadCheck(self)
		local zoneName = GetRealZoneText()
		local mapID = GetCurrentMapAreaID()
		local _, instanceType, difficulty, difficultyName, instanceGroupSize = GetInstanceInfo()
		local currentDifficulty, currentDifficultyText = self:GetCurrentInstanceDifficulty()
		if currentDifficulty ~= savedDifficulty then
			savedDifficulty, difficultyText = currentDifficulty, currentDifficultyText
		end
		self:Debug("Instance Check fired with mapID "..mapID.." and difficulty "..difficulty, 2)
		if LastInstanceMapID == mapID then
			self:Debug("No action taken because mapID hasn't changed since last check", 2)
			return
		end--ID hasn't changed, don't waste cpu doing anything else (example situation, porting into garrosh stage 4 is a loading screen)
		LastInstanceMapID = mapID
		LastGroupSize = instanceGroupSize
		difficultyIndex = difficulty
		if instanceType == "none" then
			LastInstanceType = "none"
			if not targetEventsRegistered then
--				self:RegisterShortTermEvents("UPDATE_MOUSEOVER_UNIT")
				targetEventsRegistered = true
			end
		else
			LastInstanceType = instanceType
			if targetEventsRegistered then
--				self:UnregisterShortTermEvents()
				targetEventsRegistered = false
			end
			if savedDifficulty == "worldboss" then
				for i = #inCombat, 1, -1 do
					self:EndCombat(inCombat[i], true)
				end
			end
		end
		-- LoadMod
		self:LoadModsOnDemand("zone", zoneName)
		self:LoadModsOnDemand("zoneId", mapID)
		if DBM:HasMapRestrictions() then
			DBM.Arrow:Hide()
--			if DBM.RangeCheck:IsRadarShown() then
				DBM.RangeCheck:Hide(true)
--			end
		end
		-- Auto Logging for entire zone if record only bosses is off
		if not DBM.Options.RecordOnlyBosses then
			if LastInstanceType == "raid" or LastInstanceType == "party" then
				self:StartLogging(0, nil)
			else
				self:StopLogging()
			end
		end
	end

	function DBM:ZONE_CHANGED_NEW_AREA()
		SetMapToCurrentZone()
		timerRequestInProgress = false
		self:Debug("ZONE_CHANGED_NEW_AREA fired")
		self:Unschedule(SecondaryLoadCheck)
		self:Schedule(3, SecondaryLoadCheck, self)
	end

	function DBM:LoadModsOnDemand(checkTable, checkValue)
		self:Debug("LoadModsOnDemand fired")
		for i, v in ipairs(self.AddOns) do
			local modTable = v[checkTable]
			local _, _, _, enabled = GetAddOnInfo(v.modId)
			if not IsAddOnLoaded(v.modId) and modTable and checkEntry(modTable, checkValue) then
				if enabled then
					self:LoadMod(v)
				else
					if not self.Options.DontShowReminders then
						self:AddMsg(DBM_CORE_LOAD_MOD_DISABLED:format(v.name))
					end
				end
			end
		end
	end
end

function DBM:LoadMod(mod, force)
	if type(mod) ~= "table" then
		self:Debug("LoadMod failed because mod table not valid")
		return false
	end
	local _, _, _, enabled = GetAddOnInfo(mod.modId)
	if not enabled then
		EnableAddOn(mod.modId)
	end

	if not currentSpecName or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	self:Debug("LoadAddOn should have fired for "..mod.name, 2)
	local loaded, reason = LoadAddOn(mod.modId)
	if not loaded then
		if reason then
			self:AddMsg(DBM_CORE_LOAD_MOD_ERROR:format(tostring(mod.name), tostring(_G["ADDON_"..reason or ""])))
		else
			self:Debug("LoadAddOn failed and did not give reason")
		end
		return false
	else
		self:Debug("LoadAddOn should have succeeded for "..mod.name, 2)
		self:AddMsg(DBM_CORE_LOAD_MOD_SUCCESS:format(tostring(mod.name)))
		self:LoadModOptions(mod.modId, InCombatLockdown(), true)
		if DBM_GUI then
			DBM_GUI:UpdateModList()
		end
		local _, instanceType = IsInInstance()
		if instanceType ~= "pvp" and #inCombat == 0 and GetNumPartyMembers() > 0 then--do timer recovery only mod load
			if not timerRequestInProgress then
				timerRequestInProgress = true
				-- Request timer to 3 person to prevent failure.
				self:Unschedule(self.RequestTimers)
				self:Schedule(7, self.RequestTimers, self, 1)
				self:Schedule(10, self.RequestTimers, self, 2)
				self:Schedule(13, self.RequestTimers, self, 3)
				C_Timer:After(15, function() timerRequestInProgress = false end)
				self:RAID_ROSTER_UPDATE(true)
			end
		end
		if not InCombatLockdown() and not UnitAffectingCombat("player") and not IsFalling() then--We loaded in combat but still need to avoid garbage collect in combat
			collectgarbage("collect")
		end
		return true
	end
end



-----------------------------
--  Handle Incoming Syncs  --
-----------------------------

do
	local function checkForActualPull()
		if DBM.Options.RecordOnlyBosses and #inCombat == 0 then
			DBM:StopLogging()
		end
	end

	local syncHandlers = {}
	local whisperSyncHandlers = {}

	-- DBM uses the following prefixes since 4.1 as pre-4.1 sync code is going to be incompatible anways, so this is the perfect opportunity to throw away the old and long names
	-- M = Mod
	-- C = Combat start
	-- GC = Guild Combat Start
	-- IS = Icon set info
	-- K = Kill
	-- H = Hi!
	-- V = Incoming version information
	-- U = User Timer
	-- PT = Pull Timer (for sound effects, the timer itself is still sent as a normal timer)
	-- RT = Request Timers
	-- CI = Combat Info
	-- TI = Timer Info
	-- IR = Instance Info Request
	-- IRE = Instance Info Requested Ended/Canceled
	-- II = Instance Info
	-- DSW = Disable Send Whisper
	-- NS = Note Share

	syncHandlers["M"] = function(sender, mod, revision, event, ...)
		mod = DBM:GetModByName(mod or "")
		if mod and event and revision then
			revision = tonumber(revision) or 0
			mod:ReceiveSync(event, sender, revision, ...)
		end
	end

	syncHandlers["NS"] = function(sender, modid, modvar, text, abilityName)
		if sender == playerName then return end
		if DBM.Options.BlockNoteShare or InCombatLockdown() or UnitAffectingCombat("player") or IsFalling() or DBM:GetRaidRank(sender) == 0 then return end
		local _, zoneType = IsInInstance()
		if zoneType == "pvp" or zoneType == "arena" then return end
		local mod = DBM:GetModByName(modid or "")
		local ability = abilityName or DBM_CORE_UNKNOWN
		if mod and modvar and text and text ~= "" then
			if DBM:AntiSpam(5, modvar) then--Don't allow calling same note more than once per 5 seconds
				DBM:AddMsg(DBM_CORE_NOTE_SHARE_SUCCESS:format(sender, abilityName))
				DBM:ShowNoteEditor(mod, modvar, ability, text, sender)
			else
				DBM:Debug(sender.." is attempting to send too many notes so notes are being throttled")
			end
		else
			DBM:AddMsg(DBM_CORE_NOTE_SHARE_FAIL:format(sender, ability))
		end
	end

	syncHandlers["C"] = function(sender, delay, mod, modRevision, startHp, dbmRevision, modHFRevision, event)
		if not dbmIsEnabled or sender == playerName then return end
		local _, instanceType = IsInInstance()
		if instanceType == "pvp" then return end
		if instanceType == "none" and (not UnitAffectingCombat("player") or #inCombat > 0) then--world boss
			local senderuId = DBM:GetRaidUnitId(sender)
			if not senderuId then return end--Should never happen, but just in case. If happens, MANY "C" syncs are sent. losing 1 no big deal.
			local senderx, sendery = GetPlayerMapPosition(senderuId)
			if senderx <= 0 and sendery <= 0 then return end--not same zone
			local range = DBM.RangeCheck:GetDistance("player", senderuId)--Same zone, so check range
			if not range or range > 120 then return end
		end
		if not cSyncSender[sender] then
			cSyncSender[sender] = true
			cSyncReceived = cSyncReceived + 1
			if cSyncReceived > 2 then -- need at least 3 sync to combat start. (for security)
				local lag = select(3, GetNetStats()) / 1000
				delay = tonumber(delay or 0) or 0
				mod = DBM:GetModByName(mod or "")
				modRevision = tonumber(modRevision or 0) or 0
				dbmRevision = tonumber(dbmRevision or 0) or 0
				modHFRevision = tonumber(modHFRevision or 0) or 0
				startHp = tonumber(startHp or -1) or -1
				if mod and delay and (not mod.zones or #mod.zones == 0 or checkEntry(mod.zones, GetRealZoneText()) or checkEntry(mod.zones, GetCurrentMapAreaID())) and (not mod.minSyncRevision or modRevision >= mod.minSyncRevision) then
					DBM:StartCombat(mod, delay + lag, "SYNC from - "..sender, true, startHp, event)
					if (mod.revision < modHFRevision) and (mod.revision > 1000) then--mod.revision because we want to compare to OUR revision not senders
						if DBM:AntiSpam(3, "HOTFIX") and not DBM.Options.DontShowReminders then
							--There is a newer RELEASE version of DBM out that has this mods fixes that we do not possess
							if DBM.HighestRelease >= modHFRevision and DBM.ReleaseRevision < modHFRevision then
--								showConstantReminder = 2
								DBM:AddMsg(DBM_CORE_UPDATEREMINDER_HOTFIX)
							else--This mods fixes are in an alpha version
								DBM:AddMsg(DBM_CORE_UPDATEREMINDER_HOTFIX_ALPHA)
							end
						end
					end
				end
			end
		end
	end

	syncHandlers["DSW"] = function(sender)
		if (DBM:GetRaidRank(sender) ~= 2 or GetNumPartyMembers() == 0) then return end--If not on group, we're probably sender, don't disable status. IF not leader, someone is trying to spoof this, block that too
--		statusWhisperDisabled = true
		DBM:Debug("Raid leader has disabled status whispers")
	end

	syncHandlers["DGP"] = function(sender)
		if (DBM:GetRaidRank(sender) ~= 2 or GetNumPartyMembers() == 0) then return end--If not on group, we're probably sender, don't disable status. IF not leader, someone is trying to spoof this, block that too
--		statusGuildDisabled = true
		DBM:Debug("Raid leader has disabled guild progress messages")
	end

	syncHandlers["IS"] = function(sender, guid, ver, optionName)
		ver = tonumber(ver) or 0
		if ver > (iconSetRevision[optionName] or 0) then--Save first synced version and person, ignore same version. refresh occurs only above version (fastest person)
			iconSetRevision[optionName] = ver
			iconSetPerson[optionName] = guid
		end
		if iconSetPerson[optionName] == UnitGUID("player") then--Check if that highest version was from ourself
			canSetIcons[optionName] = true
		else--Not from self, it means someone with a higher version than us probably sent it
			canSetIcons[optionName] = false
		end
		local name = DBM:GetFullPlayerNameByGUID(iconSetPerson[optionName]) or DBM_CORE_UNKNOWN
		DBM:Debug(name.." was elected icon setter for "..optionName, 2)
	end

	syncHandlers["K"] = function(sender, cId)
		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "none" then return end
		cId = tonumber(cId or "")
		if cId then DBM:OnMobKill(cId, true) end
	end

	local dummyMod -- dummy mod for the pull timer
	syncHandlers["PT"] = function(sender, timer, target)
		if DBM.Options.DontShowUserTimers then return end
		local LFGTankException = IsPartyLFG() and UnitGroupRolesAssigned(sender) == "TANK"
		if DBM:GetRaidRank(sender) == 0 or select(2, IsInInstance()) == "pvp" then
			return
		end
		timer = tonumber(timer or 0)
		if timer > 60 or (timer > 0 and timer < 3) then
			return
		end
		if not dummyMod then
			local threshold = DBM.Options.PTCountThreshold2
			threshold = floor(threshold)
			dummyMod = DBM:NewMod("PullTimerCountdownDummy", "DBM-PvP")
			DBM:GetModLocalization("PullTimerCountdownDummy"):SetGeneralLocalization{ name = DBM_CORE_MINIMAP_TOOLTIP_HEADER }
			dummyMod.text = dummyMod:NewAnnounce("%s", 1, "Interface\\Icons\\Ability_Warrior_OffensiveStance")
			dummyMod.geartext = dummyMod:NewSpecialWarning("  %s  ", nil, nil, nil, 3)
			dummyMod.timer = dummyMod:NewTimer(20, "%s", "Interface\\Icons\\Ability_Warrior_OffensiveStance", nil, nil, 0, nil, nil, DBM.Options.DontPlayPTCountdown and 0 or 1, threshold)
		end
		--Cancel any existing pull timers before creating new ones, we don't want double countdowns or mismatching blizz countdown text (cause you can't call another one if one is in progress)
		if not DBM.Options.DontShowPT2 then--and DBM.Bars:GetBar(DBM_CORE_TIMER_PULL)
			dummyMod.timer:Stop()
		end
		if not DBM.Options.DontShowPTCountdownText then
			TimerTracker_OnEvent(TimerTracker, "PLAYER_ENTERING_WORLD")--easiest way to nil out timers on TimerTracker frame. This frame just has no actual star/stop functions
		end
		dummyMod.text:Cancel()
		if timer == 0 then return end--"/dbm pull 0" will strictly be used to cancel the pull timer (which is why we let above part of code run but not below)
		if not DBM.Options.DontShowPT2 then
			dummyMod.timer:Start(timer, DBM_CORE_TIMER_PULL)
		end
		if not DBM.Options.DontShowPTCountdownText then
			--Start A TimerTracker timer by tricking it to start a BG timer
			TimerTracker_OnEvent(TimerTracker, "START_TIMER", 1, timer + .9, timer + .9)
			--Find the timer object DBM just created and hack our own changes into it.
			local timerObject
			for a, b in pairs(TimerTracker.timerList) do
				if b.type == 1 and not b.isFree then
					timerObject = b
					break
				end
			end
			if timerObject then
				--Set end texture to nothing to eliminate pvp logo/hourglass
				timerObject.faction:SetTexture("")
				timerObject.factionGlow:SetTexture("")
				--We don't want the PVP bar, we only want timer text
				if timer > 10 then
					--timerObject.startNumbers:Play()
				--	timerObject.barShowing = false
				--	timerObject.anchorCenter = false
					AnimationsToggle_STARTNUMBERS(timerObject)
					timerObject.bar:Hide()
				else
					AnimationsToggle_STARTNUMBERS(timerObject)
					timerObject.bar:Hide()
				end
			end
		end
		if not DBM.Options.DontShowPTText then
			if target then
				dummyMod.text:Show(DBM_CORE_ANNOUNCE_PULL_TARGET:format(target, timer, sender))
				dummyMod.text:Schedule(timer, DBM_CORE_ANNOUNCE_PULL_NOW_TARGET:format(target))
			else
				dummyMod.text:Show(DBM_CORE_ANNOUNCE_PULL:format(timer, sender))
				dummyMod.text:Schedule(timer, DBM_CORE_ANNOUNCE_PULL_NOW)
			end
		end
		if DBM.Options.RecordOnlyBosses then
			DBM:StartLogging(timer, checkForActualPull)
		end
		if DBM.Options.CheckGear then
			local weapon = GetInventoryItemLink("player", 16)
			local fishingPole = false
			if weapon then
				local _, _, _, _, _, _, type = GetItemInfo(weapon)
				if type and type == DBM_CORE_GEAR_FISHING_POLE then
					fishingPole = true
				end
			end
			if GetNumRaidMembers() > 0 and (not weapon or fishingPole) then
				dummyMod.geartext:Show(DBM_CORE_GEAR_WARNING_WEAPON)
			end
		end
	end

	do
		local dummyMod2 -- dummy mod for the break timer
		function breakTimerStart(self, timer, sender)
			if not dummyMod2 then
				local threshold = DBM.Options.PTCountThreshold2
				threshold = floor(threshold)
				dummyMod2 = DBM:NewMod("BreakTimerCountdownDummy", "DBM-PvP")
				DBM:GetModLocalization("BreakTimerCountdownDummy"):SetGeneralLocalization{ name = DBM_CORE_MINIMAP_TOOLTIP_HEADER }
				dummyMod2.text = dummyMod2:NewAnnounce("%s", 1, "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME")
				dummyMod2.timer = dummyMod2:NewTimer(20, "%s", "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME", nil, nil, 0, nil, nil, DBM.Options.DontPlayPTCountdown and 0 or 1, threshold)
			end
			--Cancel any existing break timers before creating new ones, we don't want double countdowns or mismatching blizz countdown text (cause you can't call another one if one is in progress)
			if not DBM.Options.DontShowPT2 then--and DBM.Bars:GetBar(DBM_CORE_TIMER_BREAK)
				dummyMod2.timer:Stop()
			end
			dummyMod2.text:Cancel()
			DBM.Options.tempBreak2 = nil
			if timer == 0 then return end--"/dbm break 0" will strictly be used to cancel the break timer (which is why we let above part of code run but not below)
			self.Options.tempBreak2 = timer.."/"..time()
			if not self.Options.DontShowPT2 then
				dummyMod2.timer:Start(timer, DBM_CORE_TIMER_BREAK)
			end
			if not self.Options.DontShowPTText then
				local hour, minute = GetGameTime()
				minute = minute+(timer/60)
				if minute >= 60 then
					hour = hour + 1
					minute = minute - 60
				end
				minute = floor(minute)
				if minute < 10 then
					minute = tostring(0 .. minute)
				end
				dummyMod2.text:Show(DBM_CORE_BREAK_START:format(strFromTime(timer).." ("..hour..":"..minute..")", sender))
				if timer/60 > 10 then dummyMod2.text:Schedule(timer - 10*60, DBM_CORE_BREAK_MIN:format(10)) end
				if timer/60 > 5 then dummyMod2.text:Schedule(timer - 5*60, DBM_CORE_BREAK_MIN:format(5)) end
				if timer/60 > 2 then dummyMod2.text:Schedule(timer - 2*60, DBM_CORE_BREAK_MIN:format(2)) end
				if timer/60 > 1 then dummyMod2.text:Schedule(timer - 1*60, DBM_CORE_BREAK_MIN:format(1)) end
				dummyMod2.text:Schedule(timer, DBM_CORE_ANNOUNCE_BREAK_OVER:format(hour..":"..minute))
			end
			C_Timer:After(timer, function() self.Options.tempBreak2 = nil end)
		end
	end

	syncHandlers["BT"] = function(sender, timer)
		if DBM.Options.DontShowUserTimers then return end
		timer = tonumber(timer or 0)
		if timer > 3600 then return end
		if (DBM:GetRaidRank(sender) == 0 and GetNumPartyMembers() > 0) or select(2, IsInInstance()) == "pvp" then
			return
		end
		breakTimerStart(DBM, timer, sender)
	end

	whisperSyncHandlers["BTR3"] = function(sender, timer)
		if DBM.Options.DontShowUserTimers then return end
		timer = tonumber(timer or 0)
		if timer > 3600 then return end
		DBM:Unschedule(DBM.RequestTimers)--IF we got BTR3 sync, then we know immediately RequestTimers was successful, so abort others
		if #inCombat >= 1 then return end
		if DBM.Bars:GetBar(DBM_CORE_TIMER_BREAK) then return end--Already recovered. Prevent duplicate recovery
		breakTimerStart(DBM, timer, sender)
	end

	local function SendVersion(guild)
		if guild then
			local message = ("%s\t%s\t%s"):format(tostring(DBM.Revision), tostring(DBM.ReleaseRevision), DBM.DisplayVersion)
			SendAddonMessage("D4", "GV\t" .. message, "GUILD")
			return
		end
		--(Note, faker isn't to screw with bigwigs nor is theirs to screw with dbm, but rathor raid leaders who don't let people run WTF they want to run)
		local VPVersion
		local VoicePack = DBM.Options.ChosenVoicePack
		if not voiceSessionDisabled and VoicePack ~= "None" and DBM.VoiceVersions[VoicePack] then
			VPVersion = "/ VP"..VoicePack..": v"..DBM.VoiceVersions[VoicePack]
		end
		if VPVersion then
			sendSync("V", ("%s\t%s\t%s\t%s\t%s"):format(tostring(DBM.Revision), tostring(DBM.ReleaseRevision), DBM.DisplayVersion, tostring(not DBM.Options.DontSetIcons), VPVersion))
		else
			sendSync("V", ("%s\t%s\t%s\t%s"):format(tostring(DBM.Revision), tostring(DBM.ReleaseRevision), DBM.DisplayVersion, tostring(not DBM.Options.DontSetIcons)))
		end
	end

	local function HandleVersion(revision, version, displayVersion, sender, noRaid)
		if version > DBM.Revision then -- Update reminder
			if #newerVersionPerson < 4 then
				if not checkEntry(newerVersionPerson, sender) then
					newerVersionPerson[#newerVersionPerson + 1] = sender
					DBM:Debug("Newer version detected from "..sender.." : Rev - "..revision..", Ver - "..version..", Rev Diff - "..(revision - DBM.Revision), 3)
				end
				if #newerVersionPerson == 2 and updateNotificationDisplayed < 2 then--Only requires 2 for update notification.
					if DBM.HighestRelease < version then
						DBM.HighestRelease = version
					end
					DBM.NewerVersion = displayVersion
					--Find min revision.
					updateNotificationDisplayed = 2
					AddMsg(DBM, DBM_CORE_UPDATEREMINDER_HEADER:match("([^\n]*)"))
					AddMsg(DBM, DBM_CORE_UPDATEREMINDER_HEADER:match("\n(.*)"):format(displayVersion, version))
--					showConstantReminder = 1
				elseif not noRaid and #newerVersionPerson == 3 and updateNotificationDisplayed < 3 then--The following code requires at least THREE people to send that higher revision. That should be more than adaquate
					--Disable if revision grossly out of date even if not major patch.
					if raid[newerVersionPerson[1]] and raid[newerVersionPerson[2]] and raid[newerVersionPerson[3]] then
						local revDifference = mmin(((raid[newerVersionPerson[1]].revision or 0) - DBM.Revision), ((raid[newerVersionPerson[2]].revision or 0) - DBM.Revision), ((raid[newerVersionPerson[3]].revision or 0) - DBM.Revision))
						if revDifference > 100000000 then--Approx 1 month old 20190416172622
							if updateNotificationDisplayed < 3 then
								updateNotificationDisplayed = 3
								AddMsg(DBM, DBM_CORE_UPDATEREMINDER_DISABLE)
								DBM:Disable(true)
							end
						end
					end
				end
			end
		end
	end

	-- TODO: is there a good reason that version information is broadcasted and not unicasted?
	syncHandlers["H"] = function(sender)
		DBM:Unschedule(SendVersion)--Throttle so we don't needlessly send tons of comms during initial raid invites
		DBM:Schedule(3, SendVersion)--Send version if 3 seconds have past since last "Hi" sync
	end

	syncHandlers["GH"] = function(sender)
		if DBM.ReleaseRevision >= DBM.HighestRelease then--Do not send version to guild if it's not up to date, since this is only used for update notifcation
			DBM:Unschedule(SendVersion, true)--Throttle so we don't needlessly send tons of comms during initial raid invites
			DBM:Schedule(10, SendVersion, true)--Send version if 10 seconds have past since last "Hi" sync
		end
	end

	syncHandlers["V"] = function(sender, revision, version, displayVersion, iconEnabled, VPVersion)
		revision, version = tonumber(revision), tonumber(version)
		if revision and version and displayVersion and raid[sender] then
			raid[sender].revision = revision
			raid[sender].version = version
			raid[sender].displayVersion = displayVersion
			raid[sender].VPVersion = VPVersion
			raid[sender].enabledIcons = iconEnabled or "false"
			DBM:Debug("Received version info from "..sender.." : Rev - "..revision..", Ver - "..version..", Rev Diff - "..(revision - DBM.Revision), 3)
			HandleVersion(revision, version, displayVersion, sender)
		end
		DBM:RAID_ROSTER_UPDATE()
	end

	syncHandlers["GV"] = function(sender, revision, version, displayVersion)
		revision, version = tonumber(revision), tonumber(version)
		if revision and version and displayVersion then
			DBM:Debug("Received G version info from "..sender.." : Rev - "..revision..", Ver - "..version..", Rev Diff - "..(revision - DBM.Revision), 3)
			HandleVersion(revision, version, displayVersion, sender, true)
		end
	end

	syncHandlers["U"] = function(sender, time, text)
		if select(2, IsInInstance()) == "pvp" then return end -- no pizza timers in battlegrounds
		if DBM.Options.DontShowUserTimers then return end
		if DBM:GetRaidRank(sender) == 0 then return end
		if sender == playerName then return end
		time = tonumber(time or 0)
		text = tostring(text)
		if time and text then
			DBM:CreatePizzaTimer(time, text, nil, sender)
		end
	end

	-- beware, ugly and missplaced code ahead
	-- todo: move this somewhere else
	do
		local accessList = {}
		local savedSender

		local inspopup = CreateFrame("Frame", "DBMPopupLockout", UIParent)
		inspopup:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true, tileSize = 16, edgeSize = 16,
			insets = {left = 1, right = 1, top = 1, bottom = 1}}
		)
		inspopup:SetSize(500, 120)
		inspopup:SetPoint("TOP", UIParent, "TOP", 0, -200)
		inspopup:SetFrameStrata("DIALOG")

		local inspopuptext = inspopup:CreateFontString()
		inspopuptext:SetFontObject(ChatFontNormal)
		inspopuptext:SetWidth(470)
		inspopuptext:SetWordWrap(true)
		inspopuptext:SetPoint("TOP", inspopup, "TOP", 0, -15)

		local buttonaccept = CreateFrame("Button", nil, inspopup)
		buttonaccept:SetNormalTexture("Interface\\Buttons\\UI-DialogBox-Button-Up")
		buttonaccept:SetPushedTexture("Interface\\Buttons\\UI-DialogBox-Button-Down")
		buttonaccept:SetHighlightTexture("Interface\\Buttons\\UI-DialogBox-Button-Highlight", "ADD")
		buttonaccept:SetSize(128, 35)
		buttonaccept:SetPoint("BOTTOM", inspopup, "BOTTOM", -75, 0)

		local buttonatext = buttonaccept:CreateFontString()
		buttonatext:SetFontObject(ChatFontNormal)
		buttonatext:SetPoint("CENTER", buttonaccept, "CENTER", 0, 5)
		buttonatext:SetText(YES)

		local buttondecline = CreateFrame("Button", nil, inspopup)
		buttondecline:SetNormalTexture("Interface\\Buttons\\UI-DialogBox-Button-Up")
		buttondecline:SetPushedTexture("Interface\\Buttons\\UI-DialogBox-Button-Down")
		buttondecline:SetHighlightTexture("Interface\\Buttons\\UI-DialogBox-Button-Highlight", "ADD")
		buttondecline:SetSize(128, 35)
		buttondecline:SetPoint("BOTTOM", inspopup, "BOTTOM", 75, 0)

		local buttondtext = buttondecline:CreateFontString()
		buttondtext:SetFontObject(ChatFontNormal)
		buttondtext:SetPoint("CENTER", buttondecline, "CENTER", 0, 5)
		buttondtext:SetText(NO)

		inspopup:Hide()

		local function autoDecline(sender, force)
			inspopup:Hide()
			savedSender = nil
			if force then
				SendAddonMessage("D4", "II\t" .. "denied", "WHISPER", sender)
			else
				SendAddonMessage("D4", "II\t" .. "timeout", "WHISPER", sender)
			end
		end

		local function showPopupInstanceIdPermission(sender)
			DBM:Unschedule(autoDecline)
			DBM:Schedule(59, autoDecline, sender)
			inspopup:Hide()
			if savedSender ~= sender then
				if savedSender then
					autoDecline(savedSender, 1) -- Do not allow multiple popups, so auto decline to previous sender.
				end
				savedSender = sender
			end
			inspopuptext:SetText(DBM_REQ_INSTANCE_ID_PERMISSION:format(sender, sender))
			buttonaccept:SetScript("OnClick", function(f) savedSender = nil DBM:Unschedule(autoDecline) accessList[sender] = true syncHandlers["IR"](sender) f:GetParent():Hide() end)
			buttondecline:SetScript("OnClick", function(f) autoDecline(sender, 1) end)
			DBM:PlaySound(850)
			inspopup:Show()
		end

		syncHandlers["IR"] = function(sender)
			if DBM:GetRaidRank(sender) == 0 or sender == playerName then
				return
			end
			accessList = accessList or {}
			if not accessList[sender] then
				-- ask for permission
				showPopupInstanceIdPermission(sender)
				return
			end
			-- okay, send data
			local sentData = false
			for i = 1, GetNumSavedInstances() do
				local name, id, _, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, textDiff, _, progress = GetSavedInstanceInfo(i)
				if (locked or extended) and isRaid then -- only report locked raid instances
					SendAddonMessage("D4", "II\tData\t" .. name .. "\t" .. id .. "\t" .. difficulty .. "\t" .. maxPlayers .. "\t" .. (progress or 0) .. "\t" .. textDiff, "WHISPER", sender)
					sentData = true
				end
			end
			if not sentData then
				-- send something even if there is nothing to report so the receiver is able to tell you apart from someone who just didn't respond...
				SendAddonMessage("D4", "II\tNoData", "WHISPER", sender)
			end
		end

		syncHandlers["IRE"] = function(sender)
			local popup = inspopup:IsShown()
			if popup and savedSender == sender then -- found the popup with the correct data
				savedSender = nil
				DBM:Unschedule(autoDecline)
				inspopup:Hide()
			end
		end

		syncHandlers["GCB"] = function(sender, modId, ver, difficulty, name)
			if not DBM.Options.ShowGuildMessages or not difficulty then return end
			if not ver or not (ver == "2") then return end--Ignore old versions
			if DBM:AntiSpam(10, "GCB") then
				if IsInInstance() then return end--Simple filter, if you are inside an instance, just filter it, if not in instance, good to go.
				difficulty = tonumber(difficulty)
				if not DBM.Options.ShowGuildMessagesPlus then return end
				local bossName = name or DBM_CORE_UNKNOWN
				local difficultyName = DBM_CORE_UNKNOWN
				if difficulty == 4 then
					difficultyName = PLAYER_DIFFICULTY4
				elseif difficulty == 3 then
					difficultyName = PLAYER_DIFFICULTY3
				elseif difficulty == 2 then
					difficultyName = PLAYER_DIFFICULTY2
				else
					difficultyName = PLAYER_DIFFICULTY1
				end
				DBM:AddMsg(DBM_CORE_GUILD_COMBAT_STARTED:format(difficultyName.."-"..bossName))
			end
		end

		syncHandlers["GCE"] = function(sender, modId, ver, wipe, time, difficulty, name, wipeHP)
			if not DBM.Options.ShowGuildMessages or not difficulty then return end
			if not ver or not (ver == "5") then return end--Ignore old versions
			if DBM:AntiSpam(5, "GCE") then
				if IsInInstance() then return end--Simple filter, if you are inside an instance, just filter it, if not in instance, good to go.
				difficulty = tonumber(difficulty)
				if not DBM.Options.ShowGuildMessagesPlus then return end
				modId = tonumber(modId)
				local bossName = name or DBM_CORE_UNKNOWN
				local difficultyName = DBM_CORE_UNKNOWN
				if difficulty == 4 then
					difficultyName = PLAYER_DIFFICULTY4
				elseif difficulty == 3 then
					difficultyName = PLAYER_DIFFICULTY3
				elseif difficulty == 2 then
					difficultyName = PLAYER_DIFFICULTY2
				else
					difficultyName = PLAYER_DIFFICULTY1
				end
				if wipe == "1" then
					DBM:AddMsg(DBM_CORE_GUILD_COMBAT_ENDED_AT:format(difficultyName.."-"..bossName, wipeHP, time))
				else
					DBM:AddMsg(DBM_CORE_GUILD_BOSS_DOWN:format(difficultyName.."-"..bossName, time))
				end
			end
		end

		local lastRequest = 0
		local numResponses = 0
		local expectedResponses = 0
		local allResponded = false
		local results

		local updateInstanceInfo, showResults

		whisperSyncHandlers["II"] = function(sender, result, name, id, diff, maxPlayers, progress, textDiff)
			if GetTime() - lastRequest > 62 or not results then
				return
			end
			if not result then
				return
			end
			name = name or DBM_CORE_UNKNOWN
			id = id or ""
			diff = tonumber(diff or 0) or 0
			maxPlayers = tonumber(maxPlayers or 0) or 0
			progress = tonumber(progress or 0) or 0
			textDiff = textDiff or ""

			-- count responses
			if not results.responses[sender] then
				results.responses[sender] = result
				numResponses = numResponses + 1
			end

			-- get localized difficulty text
			if textDiff ~= "" then
				results.difftext[diff] = textDiff
			end

			if result == "Data" then
				-- got data in that response and not just a "no" or "i'm away"
				local instanceId = name.." "..maxPlayers.." "..diff -- locale-dependant dungeon ID
				results.data[instanceId] = results.data[instanceId] or {
					ids = {}, -- array of all ids of all raid members
					name = name,
					diff = diff,
					maxPlayers = maxPlayers,
				}

				results.data[instanceId].ids[progress] = results.data[instanceId].ids[progress] or { progress = progress }
				tinsert(results.data[instanceId].ids[progress], sender)
			end

			if numResponses >= expectedResponses then -- unlikely, lol
				DBM:Unschedule(updateInstanceInfo)
				DBM:Unschedule(showResults)
				if not allResponded then --Only display message once in case we get for example 4 syncs the last sender
					DBM:Schedule(0.99, DBM.AddMsg, DBM, DBM_INSTANCE_INFO_ALL_RESPONSES)
					allResponded = true
				end
				C_Timer:After(1, showResults) --Delay results so we allow time for same sender to send more than 1 lockout, otherwise, if we get expectedResponses before all data is sent from 1 user, we clip some of their data.
			end
		end

		function showResults()
			local resultCount = 0
			-- TODO: you could catch some localized instances by observing IDs if there are multiple players with the same instance ID but a different name ;) (not that useful if you are trying to get a fresh instance)
			DBM:AddMsg(DBM_INSTANCE_INFO_RESULTS, false)
			DBM:AddMsg("---", false)
			for i, v in pairs(results.data) do
				resultCount = resultCount + 1
				DBM:AddMsg(DBM_INSTANCE_INFO_DETAIL_HEADER:format(v.name, (results.difftext[v.diff] or v.diff)), false)
				for id, r in pairs(v.ids) do
					if r.haveid then
						DBM:AddMsg(DBM_INSTANCE_INFO_DETAIL_INSTANCE:format(id, r.progress, tconcat(r, ", ")), false)
					else
						DBM:AddMsg(DBM_INSTANCE_INFO_DETAIL_INSTANCE2:format(r.progress, tconcat(r, ", ")), false)
					end
				end
				DBM:AddMsg("---", false)
			end
			if resultCount == 0 then
				DBM:AddMsg(DBM_INSTANCE_INFO_NOLOCKOUT, false)
			end
			local denied = {}
			local away = {}
			local noResponse = {}
			for i = 1, GetNumRaidMembers() do
				if not UnitIsUnit("raid"..i, "player") then
					tinsert(noResponse, (GetRaidRosterInfo(i)))
				end
			end
			for i, v in pairs(results.responses) do
				if v == "Data" or v == "NoData" then
				elseif v == "timeout" then
					tinsert(away, i)
				else -- could be "clicked" or "override", in both cases we don't get the data because the dialog requesting it was dismissed
					tinsert(denied, i)
				end
				removeEntry(noResponse, i)
			end
			if #denied > 0 then
				DBM:AddMsg(DBM_INSTANCE_INFO_STATS_DENIED:format(tconcat(denied, ", ")), false)
			end
			if #away > 0 then
				DBM:AddMsg(DBM_INSTANCE_INFO_STATS_AWAY:format(tconcat(away, ", ")), false)
			end
			if #noResponse > 0 then
				DBM:AddMsg(DBM_INSTANCE_INFO_STATS_NO_RESPONSE:format(tconcat(noResponse, ", ")), false)
			end
			results = nil
		end

		-- called when the chat link is clicked
		function DBM:ShowRaidIDRequestResults()
			if not results then -- check if we are currently querying raid IDs, results will be nil if we don't
				return
			end
			self:Unschedule(updateInstanceInfo)
			self:Unschedule(showResults)
			showResults() -- sets results to nil after the results are displayed, ending the current id request; future incoming data will be discarded
			sendSync("IRE")
		end

		local function getResponseStats()
			local numResponses = 0
			local sent = 0
			local denied = 0
			local away = 0
			for k, v in pairs(results.responses) do
				numResponses = numResponses + 1
				if v == "Data" or v == "NoData" then
					sent = sent + 1
				elseif v == "timeout" then
					away = away + 1
				else -- could be "clicked" or "override", in both cases we don't get the data because the dialog requesting it was dismissed
					denied = denied + 1
				end
			end
			return numResponses, sent, denied, away
		end

		local function getNumDBMUsers() -- without ourselves
			local r = 0
			for i, v in pairs(raid) do
				if v.revision and v.name ~= playerName and UnitIsConnected(v.id) then
					r = r + 1
				end
			end
			return r
		end

		function updateInstanceInfo(timeRemaining, dontAddShowResultNowButton)
			local numResponses, sent, denied, away = getResponseStats()
			local dbmUsers = getNumDBMUsers()
			DBM:AddMsg(DBM_INSTANCE_INFO_STATUS_UPDATE:format(numResponses, dbmUsers, sent, denied, timeRemaining), false)
			if not dontAddShowResultNowButton then
				if dbmUsers - numResponses <= 7 then -- waiting for 7 or less players, show their names and the early result option
					-- copied from above, todo: implement a smarter way of keeping track of stuff like this
					local noResponse = {}
					for i = 1, GetNumRaidMembers() do
						if not UnitIsUnit("raid"..i, "player") and raid[GetRaidRosterInfo(i)] and raid[GetRaidRosterInfo(i)].revision then -- only show players who actually can respond (== DBM users)
							tinsert(noResponse, (GetRaidRosterInfo(i)))
						end
					end
					for i, v in pairs(results.responses) do
						removeEntry(noResponse, i)
					end

					--[[
					-- this looked like the easiest way (for some reason?) to create the player string when writing this code -.-
					local function dup(...) if select("#", ...) == 0 then return else return ..., ..., dup(select(2, ...)) end end
					DBM:AddMsg(DBM_INSTANCE_INFO_SHOW_RESULTS:format(("|Hplayer:%s|h[%s]|h| "):rep(#noResponse):format(dup(unpack(noResponse)))), false)
					]]
					-- code that one can actually read
					for i, v in ipairs(noResponse) do
						noResponse[i] = ("|Hplayer:%s|h[%s]|h|"):format(v, v)
					end
					DBM:AddMsg(DBM_INSTANCE_INFO_SHOW_RESULTS:format(tconcat(noResponse, ", ")), false)
				end
			end
		end

		function DBM:RequestInstanceInfo()
			self:AddMsg(DBM_INSTANCE_INFO_REQUESTED)
			lastRequest = GetTime()
			allResponded = false
			results = {
				responses = { -- who responded to our request?
				},
				data = { -- the actual data
				},
				difftext = {
				}
			}
			numResponses = 0
			expectedResponses = getNumDBMUsers()
			sendSync("IR")
			self:Unschedule(updateInstanceInfo)
			self:Unschedule(showResults)
			self:Schedule(17, updateInstanceInfo, 45, true)
			self:Schedule(32, updateInstanceInfo, 30)
			self:Schedule(48, updateInstanceInfo, 15)
--			C_Timer:After(62, showResults)
		end
	end

	whisperSyncHandlers["RT"] = function(sender)
		if UnitInBattleground("player") then
			DBM:SendPVPTimers(sender)
		else
			DBM:SendTimers(sender)
		end
	end

	whisperSyncHandlers["CI"] = function(sender, mod, time)
		mod = DBM:GetModByName(mod or "")
		time = tonumber(time or 0)
		if mod and time then
			DBM:ReceiveCombatInfo(sender, mod, time)
		end
	end

	whisperSyncHandlers["TI"] = function(sender, mod, timeLeft, totalTime, id, ...)
		mod = DBM:GetModByName(mod or "")
		timeLeft = tonumber(timeLeft or 0)
		totalTime = tonumber(totalTime or 0)
		if mod and timeLeft and timeLeft > 0 and totalTime and totalTime > 0 and id then
			DBM:ReceiveTimerInfo(sender, mod, timeLeft, totalTime, id, ...)
		end
	end

	whisperSyncHandlers["VI"] = function(sender, mod, name, value)
		mod = DBM:GetModByName(mod or "")
		value = tonumber(value) or value
		if mod and name and value then
			DBM:ReceiveVariableInfo(sender, mod, name, value)
		end
	end

	handleSync = function(channel, sender, prefix, ...)
		if not prefix then
			return
		end
		local handler
		if channel == "WHISPER" and sender ~= playerName and DBM:GetRaidUnitId(sender) then -- separate between broadcast and unicast, broadcast must not be sent as unicast or vice-versa
			handler = whisperSyncHandlers[prefix]
		else
			handler = syncHandlers[prefix]
		end
		if handler then
			return handler(sender, ...)
		end
	end

	function DBM:CHAT_MSG_ADDON(prefix, msg, channel, sender)
		if prefix == "D4" and msg and (channel == "PARTY" or channel == "RAID" or channel == "BATTLEGROUND" or channel == "WHISPER" or channel == "GUILD") then
			handleSync(channel, sender, strsplit("\t", msg))
		elseif prefix == "Transcriptor" and msg then
			for i = 1, #inCombat do
				local mod = inCombat[i]
				if mod and mod.OnTranscriptorSync then
					mod:OnTranscriptorSync(msg, sender)
				end
			end
			if msg:find("spell:") and (DBM.Options.DebugLevel > 2 or (Transcriptor and Transcriptor:IsLogging())) then
				local spellId = string.match(msg, "spell:(%d+)") or DBM_CORE_UNKNOWN
				local spellName = string.match(msg, "h%[(.-)%]|h") or DBM_CORE_UNKNOWN
				local message = "RAID_BOSS_WHISPER on "..sender.." with spell of "..spellName.." ("..spellId..")"
				self:Debug(message)
			end
		end
	end
end


-----------------------
--  Update Reminder  --
-----------------------
do
	local frame, fontstring, fontstringFooter, editBox, urlText

	local function createFrame()
		frame = CreateFrame("Frame", "DBMUpdateReminder", UIParent)
		frame:SetFrameStrata("FULLSCREEN_DIALOG") -- yes, this isn't a fullscreen dialog, but I want it to be in front of other DIALOG frames (like DBM GUI which might open this frame...)
		frame:SetWidth(430)
		frame:SetHeight(140)
		frame:SetPoint("TOP", 0, -230)
		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
			insets = {left = 11, right = 12, top = 12, bottom = 11},
		})
		fontstring = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		fontstring:SetWidth(410)
		fontstring:SetHeight(0)
		fontstring:SetPoint("TOP", 0, -16)
		editBox = CreateFrame("EditBox", nil, frame)
		do
			local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
			local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
			local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
			editBoxLeft:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left")
			editBoxLeft:SetHeight(32)
			editBoxLeft:SetWidth(32)
			editBoxLeft:SetPoint("LEFT", -14, 0)
			editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
			editBoxRight:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
			editBoxRight:SetHeight(32)
			editBoxRight:SetWidth(32)
			editBoxRight:SetPoint("RIGHT", 6, 0)
			editBoxRight:SetTexCoord(0.875, 1, 0, 1)
			editBoxMiddle:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
			editBoxMiddle:SetHeight(32)
			editBoxMiddle:SetWidth(1)
			editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
			editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
			editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
		end
		editBox:SetHeight(32)
		editBox:SetWidth(250)
		editBox:SetPoint("TOP", fontstring, "BOTTOM", 0, -4)
		editBox:SetFontObject("GameFontHighlight")
		editBox:SetTextInsets(0, 0, 0, 1)
		editBox:SetFocus()
		editBox:SetText(urlText)
		editBox:HighlightText()
		editBox:SetScript("OnTextChanged", function(self)
			editBox:SetText(urlText)
			editBox:HighlightText()
		end)
		fontstringFooter = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		fontstringFooter:SetWidth(410)
		fontstringFooter:SetHeight(0)
		fontstringFooter:SetPoint("TOP", editBox, "BOTTOM", 0, 0)
		local button = CreateFrame("Button", nil, frame)
		button:SetHeight(24)
		button:SetWidth(75)
		button:SetPoint("BOTTOM", 0, 13)
		button:SetNormalFontObject("GameFontNormal")
		button:SetHighlightFontObject("GameFontHighlight")
		button:SetNormalTexture(button:CreateTexture(nil, nil, "UIPanelButtonUpTexture"))
		button:SetPushedTexture(button:CreateTexture(nil, nil, "UIPanelButtonDownTexture"))
		button:SetHighlightTexture(button:CreateTexture(nil, nil, "UIPanelButtonHighlightTexture"))
		button:SetText(OKAY)
		button:SetScript("OnClick", function(self)
			frame:Hide()
		end)

	end

	function DBM:ShowUpdateReminder(newVersion, newRevision, text, url)
		urlText = url or DBM_CORE_UPDATEREMINDER_URL or "http://www.deadlybossmods.com"
		if not frame then
			createFrame()
		else
			editBox:SetText(urlText)
			editBox:HighlightText()
		end
		frame:Show()
		if newVersion then
			fontstring:SetText(DBM_CORE_UPDATEREMINDER_HEADER:format(newVersion, newRevision))
			fontstringFooter:SetText(DBM_CORE_UPDATEREMINDER_FOOTER)
		elseif text then
			fontstring:SetText(text)
			fontstringFooter:SetText(DBM_CORE_UPDATEREMINDER_FOOTER_GENERIC)
		end
	end
end

--------------------
--  Notes Editor  -- TODO
--------------------
do
	local frame, fontstring, fontstringFooter, editBox, button3

	local function createFrame()
		frame = CreateFrame("Frame", "DBMNotesEditor", UIParent)
		frame:SetFrameStrata("FULLSCREEN_DIALOG") -- yes, this isn't a fullscreen dialog, but I want it to be in front of other DIALOG frames (like DBM GUI which might open this frame...)
		frame:SetWidth(430)
		frame:SetHeight(140)
		frame:SetPoint("TOP", 0, -230)
		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",--131071
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,--131072
			insets = {left = 11, right = 12, top = 12, bottom = 11},
		})
		fontstring = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		fontstring:SetWidth(410)
		fontstring:SetHeight(0)
		fontstring:SetPoint("TOP", 0, -16)
		editBox = CreateFrame("EditBox", nil, frame)
		do
			local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
			local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
			local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
			editBoxLeft:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left")
			editBoxLeft:SetHeight(32)
			editBoxLeft:SetWidth(32)
			editBoxLeft:SetPoint("LEFT", -14, 0)
			editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
			editBoxRight:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
			editBoxRight:SetHeight(32)
			editBoxRight:SetWidth(32)
			editBoxRight:SetPoint("RIGHT", 6, 0)
			editBoxRight:SetTexCoord(0.875, 1, 0, 1)
			editBoxMiddle:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
			editBoxMiddle:SetHeight(32)
			editBoxMiddle:SetWidth(1)
			editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
			editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
			editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
		end
		editBox:SetHeight(32)
		editBox:SetWidth(250)
		editBox:SetPoint("TOP", fontstring, "BOTTOM", 0, -4)
		editBox:SetFontObject("GameFontHighlight")
		editBox:SetTextInsets(0, 0, 0, 1)
		editBox:SetFocus()
		editBox:SetText("")
		fontstringFooter = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		fontstringFooter:SetWidth(410)
		fontstringFooter:SetHeight(0)
		fontstringFooter:SetPoint("TOP", editBox, "BOTTOM", 0, 0)
		local button = CreateFrame("Button", nil, frame)
		button:SetHeight(24)
		button:SetWidth(75)
		button:SetPoint("BOTTOM", 80, 13)
		button:SetNormalFontObject("GameFontNormal")
		button:SetHighlightFontObject("GameFontHighlight")
		button:SetNormalTexture(button:CreateTexture(nil, nil, "UIPanelButtonUpTexture"))
		button:SetPushedTexture(button:CreateTexture(nil, nil, "UIPanelButtonDownTexture"))
		button:SetHighlightTexture(button:CreateTexture(nil, nil, "UIPanelButtonHighlightTexture"))
		button:SetText(OKAY)
		button:SetScript("OnClick", function(self)
			local mod = DBM.Noteframe.mod
			local modvar = DBM.Noteframe.modvar
			mod.Options[modvar .. "SWNote"] = editBox:GetText() or ""
			DBM.Noteframe.mod = nil
			DBM.Noteframe.modvar = nil
			DBM.Noteframe.abilityName = nil
			frame:Hide()
		end)
		local button2 = CreateFrame("Button", nil, frame)
		button2:SetHeight(24)
		button2:SetWidth(75)
		button2:SetPoint("BOTTOM", 0, 13)
		button2:SetNormalFontObject("GameFontNormal")
		button2:SetHighlightFontObject("GameFontHighlight")
		button2:SetNormalTexture(button2:CreateTexture(nil, nil, "UIPanelButtonUpTexture"))
		button2:SetPushedTexture(button2:CreateTexture(nil, nil, "UIPanelButtonDownTexture"))
		button2:SetHighlightTexture(button2:CreateTexture(nil, nil, "UIPanelButtonHighlightTexture"))
		button2:SetText(CANCEL)
		button2:SetScript("OnClick", function(self)
			DBM.Noteframe.mod = nil
			DBM.Noteframe.modvar = nil
			DBM.Noteframe.abilityName = nil
			frame:Hide()
		end)
		button3 = CreateFrame("Button", nil, frame)
		button3:SetHeight(24)
		button3:SetWidth(75)
		button3:SetPoint("BOTTOM", -80, 13)
		button3:SetNormalFontObject("GameFontNormal")
		button3:SetHighlightFontObject("GameFontHighlight")
		button3:SetNormalTexture(button3:CreateTexture(nil, nil, "UIPanelButtonUpTexture"))
		button3:SetPushedTexture(button3:CreateTexture(nil, nil, "UIPanelButtonDownTexture"))
		button3:SetHighlightTexture(button3:CreateTexture(nil, nil, "UIPanelButtonHighlightTexture"))
		button3:SetText(SHARE_QUEST_ABBREV)
		button3:SetScript("OnClick", function(self)
			local modid = DBM.Noteframe.mod.id
			local modvar = DBM.Noteframe.modvar
			local abilityName = DBM.Noteframe.abilityName
			local syncText = editBox:GetText() or ""
			local zoneType = select(2, IsInInstance())

			if syncText == "" then
				DBM:AddMsg(DBM_CORE_NOTESHAREERRORBLANK)
			elseif zoneType == "pvp" then--For BGs, LFR and LFG (we also check IsInInstance() so if you're in queue but fighting something outside like a world boss, it'll sync in "RAID" instead)
				DBM:AddMsg(DBM_CORE_NOTESHAREERRORGROUPFINDER)
			else
				local msg = modid.."\t"..modvar.."\t"..syncText.."\t"..abilityName
				if GetNumRaidMembers() > 0 then
					if DBM:GetRaidRank(playerName) == 0 then
						DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					else
						SendAddonMessage("D4", "NS\t" .. msg, "RAID")
						DBM:AddMsg(DBM_CORE_NOTESHARED)
					end
				elseif GetNumPartyMembers() > 0 then
					if DBM:GetRaidRank(playerName) == 0 then
						DBM:AddMsg(DBM_ERROR_NO_PERMISSION)
					else
						SendAddonMessage("D4", "NS\t" .. msg, "PARTY")
						DBM:AddMsg(DBM_CORE_NOTESHARED)
					end
				else--Solo
					DBM:AddMsg(DBM_CORE_NOTESHAREERRORSOLO)
				end
			end
		end)
	end

	function DBM:ShowNoteEditor(mod, modvar, abilityName, syncText, sender)
		if not frame then
			createFrame()
			self.Noteframe = frame
		else
			if frame:IsShown() and syncText then
				self:AddMsg(DBM_CORE_NOTESHAREERRORALREADYOPEN)
				return
			end
		end
		frame:Show()
		fontstringFooter:SetText(DBM_CORE_NOTEFOOTER)
		self.Noteframe.mod = mod
		self.Noteframe.modvar = modvar
		self.Noteframe.abilityName = abilityName
		if syncText then
			button3:Hide()--Don't show share button in shared notes
			fontstring:SetText(DBM_CORE_NOTESHAREDHEADER:format(sender, abilityName))
			editBox:SetText(syncText)
		else
			button3:Show()
			fontstring:SetText(DBM_CORE_NOTEHEADER:format(abilityName))
			if type(mod.Options[modvar .. "SWNote"]) == "string" then
				editBox:SetText(mod.Options[modvar .. "SWNote"])
			else
				editBox:SetText("")
			end
		end
	end
end

----------------------
--  Pull Detection  --
----------------------
do
	local targetList = {}
	local function buildTargetList()
		local uId = ((GetNumRaidMembers() == 0) and "party") or "raid"
		for i = 0, mmax(GetNumRaidMembers(), GetNumPartyMembers()) do
			local id = (i == 0 and "target") or uId..i.."target"
			local guid = UnitGUID(id)
			if guid and DBM:IsCreatureGUID(guid) then
				local cId = DBM:GetCIDFromGUID(guid)
				targetList[cId] = id
			end
		end
	end

	local function clearTargetList()
		twipe(targetList)
	end

	local function scanForCombat(mod, mob)
		if not checkEntry(inCombat, mod) then
			buildTargetList()
			if targetList[mob] and UnitAffectingCombat(targetList[mob]) then
				DBM:StartCombat(mod, 3)
			end
			clearTargetList()
		end
	end

	local function checkForPull(mob, combatInfo)
		local uId = targetList[mob]
		if uId and UnitAffectingCombat(uId) then
			DBM:StartCombat(combatInfo.mod, 0)
			return true
		elseif uId then
			DBM:Schedule(3, scanForCombat, combatInfo.mod, mob)
		end
	end

	function DBM:PLAYER_REGEN_DISABLED()
		if not combatInitialized then return end
		if dbmIsEnabled and combatInfo[GetRealZoneText()] or combatInfo[GetCurrentMapAreaID()] then
			buildTargetList()
			if combatInfo[GetRealZoneText()] then
				for i, v in ipairs(combatInfo[GetRealZoneText()]) do
					if v.type == "combat" then
						if v.multiMobPullDetection then
							for _, mob in ipairs(v.multiMobPullDetection) do
								if checkForPull(mob, v) then
									break
								end
							end
						else
							checkForPull(v.mob, v)
						end
					end
				end
			end
			-- copy & paste, lol
			if combatInfo[GetCurrentMapAreaID()] then
				for i, v in ipairs(combatInfo[GetCurrentMapAreaID()]) do
					if v.type == "combat" then
						if v.multiMobPullDetection then
							for _, mob in ipairs(v.multiMobPullDetection) do
								if checkForPull(mob, v) then
									break
								end
							end
						else
							checkForPull(v.mob, v)
						end
					end
				end
			end
			clearTargetList()
		end
	end

	function DBM:PLAYER_REGEN_ENABLED()
		if delayedFunction then--Will throw error if not a function, purposely not doing and type(delayedFunction) == "function" for now to make sure code works though  cause it always should be function
			delayedFunction()
			delayedFunction = nil
		end
	end
end

do
	-- called for all mob chat events
	local function onMonsterMessage(self, type, msg)
		-- pull detection
		if dbmIsEnabled and combatInfo[GetRealZoneText()] then
			for i, v in ipairs(combatInfo[GetRealZoneText()]) do
				if v.type == type and checkEntry(v.msgs, msg) then
					self:StartCombat(v.mod, 0)
				end
			end
		end
		-- copy & paste, lol
		if dbmIsEnabled and combatInfo[GetCurrentMapAreaID()] then
			for i, v in ipairs(combatInfo[GetCurrentMapAreaID()]) do
				if v.type == type and checkEntry(v.msgs, msg) then
					self:StartCombat(v.mod, 0)
				end
			end
		end
		-- kill detection (wipe detection would also be nice to have)
		-- todo: add sync
		for i = #inCombat, 1, -1 do
			local v = inCombat[i]
			if not v.combatInfo then return end
			if v.combatInfo.killType == type and v.combatInfo.killMsgs[msg] then
				self:EndCombat(v)
			end
		end
	end

	function DBM:CHAT_MSG_MONSTER_YELL(msg)
		return onMonsterMessage(self, "yell", msg)
	end

	function DBM:CHAT_MSG_MONSTER_EMOTE(msg, name)
		return onMonsterMessage(self, "emote", msg)
	end

	function DBM:CHAT_MSG_RAID_BOSS_EMOTE(msg, ...)
		onMonsterMessage(self, "emote", msg)
		return self:FilterRaidBossEmote(msg, ...)
	end

	function DBM:CHAT_MSG_MONSTER_SAY(msg)
		return onMonsterMessage(self, "say", msg)
	end
end


---------------------------
--  Kill/Wipe Detection  --
---------------------------
function checkWipe(self, confirm)
	if #inCombat > 0 then
		if not savedDifficulty or not difficultyText or not difficultyIndex then--prevent error if savedDifficulty or difficultyText is nil
			savedDifficulty, difficultyText, difficultyIndex, LastGroupSize = self:GetCurrentInstanceDifficulty()
		end
		local wipe = true
		local uId = ((GetNumRaidMembers() == 0) and "party") or "raid"
		for i = 0, mmax(GetNumRaidMembers(), GetNumPartyMembers()) do
			local id = (i == 0 and "player") or uId..i
			if UnitAffectingCombat(id) and not UnitIsDeadOrGhost(id) then
				wipe = false
				break
			end
		end
		if not wipe then
			self:Schedule(3, checkWipe, self)
		elseif confirm then
			for i = #inCombat, 1, -1 do
				local reason = (wipe and "No combat unit found in your party.")
				self:Debug("You wiped. Reason : "..reason)
				self:EndCombat(inCombat[i], true)
			end
		else
			local maxDelayTime = 5
			for i, v in ipairs(inCombat) do
				maxDelayTime = v.combatInfo and v.combatInfo.wipeTimer and v.combatInfo.wipeTimer > maxDelayTime and v.combatInfo.wipeTimer or maxDelayTime
			end
			self:Schedule(maxDelayTime, checkWipe, self, true)
		end
	end
end

function DBM:FireCustomEvent(event, ...)
	fireEvent(event, ...)
end

function checkBossHealth(self)
	if #inCombat > 0 then
		for i, v in ipairs(inCombat) do
			if not v.multiMobPullDetection or v.mainBoss then
				self:GetBossHP(v.mainBoss or v.combatInfo.mob or -1)
			else
				for _, mob in ipairs(v.multiMobPullDetection) do
					self:GetBossHP(mob)
				end
			end
		end
		self:Schedule(1, checkBossHealth, self)
	end
end

function checkCustomBossHealth(self, mod)
	mod:CustomHealthUpdate()
	self:Schedule(1, checkCustomBossHealth, self, mod)
end

function DBM:InGuildParty()
	local guildName = GetGuildInfo("player")
	local numRaid = GetNumPartyMembers()

	if guildName and numRaid > 0 then
		local guldMatch = 0
		for i = 1, numRaid do
			local guild = GetGuildInfo("raid"..i) or ""
			if guild == guildName then
				guldMatch = guldMatch + 1
			end
		end
		if guldMatch >= numRaid * 0.75 then
			return true
		end
	end
end

do
	local statVarTable = {
		--Current
		["event5"] = "normal",
		["event20"] = "lfr25",
		["event40"] = "lfr25",
		["normal5"] = "normal",
		["heroic5"] = "heroic",
		["normal"] = "normal",
		["heroic"] = "heroic",
		["worldboss"] = "normal",
		--Legacy
		["normal10"] = "normal",
		["normal20"] = "normal",
		["normal25"] = "normal25",
		["normal40"] = "normal",
		["heroic10"] = "heroic",
		["heroic25"] = "heroic25",
	}

	function DBM:StartCombat(mod, delay, event, synced, syncedStartHp, syncedEvent)
		cSyncSender = {}
		cSyncReceived = 0
		if not checkEntry(inCombat, mod) then
			-- - HACK: гарантирует, что мы не обнаружим ложное притяжение, если событие сработает снова, когда босс умрет ...
			if mod.lastKillTime and GetTime() - mod.lastKillTime < 10 then return end
			if not mod.combatInfo then return end
			if mod.combatInfo.noCombatInVehicle and UnitInVehicle("player") then -- HACK
				return
			end
			if event then
				self:Debug("StartCombat called by : "..event..". LastInstanceMapID is "..LastInstanceMapID)
			else
				self:Debug("StartCombat called by individual mod or unknown reason. LastInstanceMapID is "..LastInstanceMapID)
			end
			--check completed. starting combat
			tinsert(inCombat, mod)
			if mod.inCombatOnlyEvents and not mod.inCombatOnlyEventsRegistered then
				mod.inCombatOnlyEventsRegistered = 1
				mod:RegisterEvents(unpack(mod.inCombatOnlyEvents))
			end
			--Fix for "attempt to perform arithmetic on field 'stats' (a nil value)"
			if not mod.stats and not mod.noStatistics then
				self:AddMsg(DBM_CORE_BAD_LOAD)--Warn user that they should reload ui soon as they leave combat to get their mod to load correctly as soon as possible
				mod.ignoreBestkill = true--Force this to true so we don't check any more occurances of "stats"
			elseif event == "TIMER_RECOVERY" then --add a lag time to delay when TIMER_RECOVERY
				delay = delay + select(3, GetNetStats()) / 1000
			else
				mod.ignoreBestkill = false
			end
			savedDifficulty, difficultyText, difficultyIndex, LastGroupSize = self:GetCurrentInstanceDifficulty()
			local name = mod.combatInfo.name
			local modId = mod.id
			mod.inCombat = true
			mod.blockSyncs = nil
			mod.combatInfo.pull = GetTime() - (delay or 0)
			if (self.Options.AlwaysShowHealthFrame or mod.Options.HealthFrame) and mod.Options.Enabled then
				self.BossHealth:Show(mod.localization.general.name)
				if mod.bossHealthInfo then
					for i = 1, #mod.bossHealthInfo, 2 do
						self.BossHealth:AddBoss(mod.bossHealthInfo[i], mod.bossHealthInfo[i + 1])
					end
				else
					self.BossHealth:AddBoss(mod.combatInfo.mob, mod.localization.general.name)
				end
			end
			if mod.minCombatTime then
				self:Schedule(mmax((mod.minCombatTime - delay), 3), checkWipe, self)
			else
				self:Schedule(3, checkWipe, self)
			end
			--get boss hp at pull
			if syncedStartHp and syncedStartHp < 1 then
				syncedStartHp = syncedStartHp * 100
			end
			local startHp = syncedStartHp or mod:GetBossHP(mod.mainBoss or mod.combatInfo.mob or -1) or 100
			if self.Options.HideTooltips then
				--Better or cleaner way?
				tooltipsHidden = true
				GameTooltip.Temphide = function() GameTooltip:Hide() end; GameTooltip:SetScript("OnShow", GameTooltip.Temphide)
			end
			if self.Options.DisableSFX and GetCVar("Sound_EnableSFX") == "1" then
				self.Options.sfxDisabled = true
				SetCVar("Sound_EnableSFX", 0)
			end
			--boss health info scheduler
			if mod.CustomHealthUpdate then
				self:Schedule(1, checkCustomBossHealth, self, mod)
			else
				self:Schedule(1, checkBossHealth, self)
			end
			if self.Options.RecordOnlyBosses then
				self:StartLogging(0, nil)
			end
			fireEvent("DBM_Pull", mod, delay, synced, startHp)
			--serperate timer recovery and normal start.
			if event ~= "TIMER_RECOVERY" then
				--add pull count
				if mod.stats and not mod.noStatistics then
					if not mod.stats[statVarTable[savedDifficulty].."Pulls"] then mod.stats[statVarTable[savedDifficulty].."Pulls"] = 0 end
					mod.stats[statVarTable[savedDifficulty].."Pulls"] = mod.stats[statVarTable[savedDifficulty].."Pulls"] + 1
				end
				--show speed timer
				if self.Options.AlwaysShowSpeedKillTimer2 and mod.stats and not mod.ignoreBestkill and not mod.noStatistics then
					local bestTime = mod.stats[statVarTable[savedDifficulty].."BestTime"]
					if bestTime and bestTime > 0 then
						local speedTimer = mod:NewTimer(bestTime, DBM_SPEED_KILL_TIMER_TEXT, "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME", nil, false)
						speedTimer:Start()
					end
				end
				--update boss left
				if mod.numBoss then
					mod.vb.bossLeft = mod.numBoss
				end
				--elect icon person
				if mod.findFastestComputer and not self.Options.DontSetIcons then
					if self:GetRaidRank() > 0 then
						for i = 1, #mod.findFastestComputer do
							local option = mod.findFastestComputer[i]
							if mod.Options[option] then
								sendSync("IS", UnitGUID("player").."\t"..tostring(DBM.Revision).."\t"..option)
							end
						end
					elseif GetNumPartyMembers() == 0 then
						for i = 1, #mod.findFastestComputer do
							local option = mod.findFastestComputer[i]
							if mod.Options[option] then
								canSetIcons[option] = true
							end
						end
					end
				end
				--call OnCombatStart
				if mod.OnCombatStart then
					local startEvent = syncedEvent or event
					mod:OnCombatStart(delay or 0, startEvent == "PLAYER_REGEN_DISABLED_AND_MESSAGE" or startEvent == "SPELL_CAST_SUCCESS" or startEvent == "MONSTER_MESSAGE", startEvent == "ENCOUNTER_START")
				end
				--send "C" sync
				event = event or ""
				if not synced then
					sendSync("C", (delay or 0).."\t"..modId.."\t"..(mod.revision or 0).."\t"..startHp.."\t"..tostring(DBM.Revision).."\t"..(mod.hotfixNoticeRev or 0).."\t"..event)
				end
				if UnitIsPartyLeader("player") then
					if self.Options.DisableGuildStatus then
						sendSync("DGP")
					end
					if self.Options.DisableStatusWhisper then
						sendSync("DSW")
					end
				end
				--show bigbrother check
				if self.Options.ShowBigBrotherOnCombatStart and BigBrother and type(BigBrother.ConsumableCheck) == "function" then
					if self.Options.BigBrotherAnnounceToRaid then
						BigBrother:ConsumableCheck("RAID")
					else
						BigBrother:ConsumableCheck("SELF")
					end
				end
				--show enage message
				if self.Options.ShowEngageMessage and not mod.noStatistics then
					self:AddMsg(DBM_CORE_COMBAT_STARTED:format(difficultyText..name))
					if self:InGuildParty() and not statusGuildDisabled and not self.Options.DisableGuildStatus then
						SendAddonMessage("D4", "GCB\t"..modId.."\t2\t"..difficultyIndex.."\t"..name, "GUILD")
					end
				end
				--stop pull count
				local dummyMod = self:GetModByName("PullTimerCountdownDummy")
				if dummyMod then--stop pull timer
					dummyMod.text:Cancel()
					dummyMod.timer:Stop()
					TimerTracker_OnEvent(TimerTracker, "PLAYER_ENTERING_WORLD")
				end
				if self.Options.EventSoundEngage2 and self.Options.EventSoundEngage2 ~= "" and self.Options.EventSoundEngage2 ~= "None" then
					self:PlaySoundFile(self.Options.EventSoundEngage2)
				end
				fireEvent("DBM_MusicStart", "BossEncounter")
				if self.Options.EventSoundMusic and self.Options.EventSoundMusic ~= "None" and self.Options.EventSoundMusic ~= "" and not (self.Options.EventMusicMythicFilter and (savedDifficulty == "mythic" or savedDifficulty == "challenge")) then
					if not self.Options.tempMusicSetting then
						self.Options.tempMusicSetting = tonumber(GetCVar("Sound_EnableMusic")) or 1
						if self.Options.tempMusicSetting == 0 then
							SetCVar("Sound_EnableMusic", 1)
						else
							self.Options.tempMusicSetting = nil--Don't actually need it
						end
					end
					local path = "MISSING"
					if self.Options.EventSoundMusic == "Random" then
						local usedTable = self.Options.EventSoundMusicCombined and DBM.Music or DBM.BattleMusic
						local rnd = random(3, #usedTable)
						path = usedTable[rnd].value
					else
						path = self.Options.EventSoundMusic
					end
					PlayMusic(path)
					self.Options.musicPlaying = true
					DBM:Debug("Starting combat music with file: "..path)
				end
			else
				self:AddMsg(DBM_CORE_COMBAT_STATE_RECOVERED:format(difficultyText..name, strFromTime(delay)))
				if mod.OnTimerRecovery then
					mod:OnTimerRecovery()
				end
			end
		end
	end

	function DBM:EndCombat(mod, wipe, srmIncluded)
		if removeEntry(inCombat, mod) then
			if mod.updateInterval then
				mod:UnregisterOnUpdateHandler()
			end
			mod:Stop()
			if enableIcons and not self.Options.DontSetIcons and not self.Options.DontRestoreIcons then
				-- restore saved previous icon
				for uId, icon in pairs(mod.iconRestore) do
					SetRaidTarget(uId, icon)
				end
				twipe(mod.iconRestore)
			end
			mod.inCombat = false
			mod.blockSyncs = true
			if mod.combatInfo.killMobs then
				for i, v in pairs(mod.combatInfo.killMobs) do
					mod.combatInfo.killMobs[i] = true
				end
			end
			if not savedDifficulty or not difficultyText or not difficultyIndex then--prevent error if savedDifficulty or difficultyText is nil
				savedDifficulty, difficultyText, difficultyIndex, LastGroupSize = DBM:GetCurrentInstanceDifficulty()
			end
			local name = mod.combatInfo.name
			local modId = mod.id
			if wipe and mod.stats and not mod.noStatistics then
				mod.lastWipeTime = GetTime()
				--Fix for "attempt to perform arithmetic on field 'pull' (a nil value)" (which was actually caused by stats being nil, so we never did getTime on pull, fixing one SHOULD fix the other)
				local thisTime = GetTime() - mod.combatInfo.pull
				local hp = mod.highesthealth and mod:GetHighestBossHealth() or mod:GetLowestBossHealth()
				local wipeHP = mod.CustomHealthUpdate and mod:CustomHealthUpdate() or hp and ("%d%%"):format(hp) or DBM_CORE_UNKNOWN
				if mod.vb.phase then
					wipeHP = wipeHP.." ("..DBM_PHASE:format(mod.vb.phase)..")"
				end
				if mod.numBoss and mod.vb.bossLeft and mod.numBoss > 1 then
					local bossesKilled = mod.numBoss - mod.vb.bossLeft
					wipeHP = wipeHP.." ("..BOSSES_KILLED:format(bossesKilled, mod.numBoss)..")"
				end
				local totalPulls = mod.stats[statVarTable[savedDifficulty].."Pulls"]
				local totalKills = mod.stats[statVarTable[savedDifficulty].."Kills"]
				if thisTime < 30 then -- Normally, one attempt will last at least 30 sec.
					totalPulls = totalPulls - 1
					mod.stats[statVarTable[savedDifficulty].."Pulls"] = totalPulls
					if self.Options.ShowDefeatMessage then
						self:AddMsg(DBM_CORE_COMBAT_ENDED_AT:format(difficultyText..name, wipeHP, strFromTime(thisTime)))
					end
				else
					if self.Options.ShowDefeatMessage then
						self:AddMsg(DBM_CORE_COMBAT_ENDED_AT_LONG:format(difficultyText..name, wipeHP, strFromTime(thisTime), totalPulls - totalKills))
						if self:InGuildParty() and not statusGuildDisabled and not self.Options.DisableGuildStatus then--Maybe add mythic plus/CM?
							SendAddonMessage("D4", "GCE\t"..modId.."\t5\t1\t"..strFromTime(thisTime).."\t"..difficultyIndex.."\t"..name.."\t"..wipeHP, "GUILD")
						end
					end
					if self.Options.EventSoundWipe and self.Options.EventSoundWipe ~= "None" and self.Options.EventSoundWipe ~= "" then
						if self.Options.EventSoundWipe == "Random" then
							local rnd = random(3, #DBM.Defeat)
							self:PlaySoundFile(DBM.Defeat[rnd].value)--Since this one hard reads table, shouldn't need to validate path
						else
							self:PlaySoundFile(self.Options.EventSoundWipe, nil, true)
						end
					end
				end
				local msg
				for k, v in pairs(autoRespondSpam) do
					if self.Options.WhisperStats then
						msg = msg or chatPrefixShort..DBM_CORE_WHISPER_COMBAT_END_WIPE_STATS_AT:format(playerName, difficultyText..(name or ""), wipeHP, totalPulls - totalKills)
					else
						msg = msg or chatPrefixShort..DBM_CORE_WHISPER_COMBAT_END_WIPE_AT:format(playerName, difficultyText..(name or ""), wipeHP)
					end
					sendWhisper(k, msg)
				end
				fireEvent("DBM_Wipe", mod)
			elseif not wipe and mod.stats and not mod.noStatistics then
				mod.lastKillTime = GetTime()
				local thisTime = GetTime() - (mod.combatInfo.pull or 0)
				local lastTime = mod.stats[statVarTable[savedDifficulty].."LastTime"]
				local bestTime = mod.stats[statVarTable[savedDifficulty].."BestTime"]
				if not mod.stats[statVarTable[savedDifficulty].."Kills"] or mod.stats[statVarTable[savedDifficulty].."Kills"] < 0 then mod.stats[statVarTable[savedDifficulty].."Kills"] = 0 end
				--Fix logical error i've seen where for some reason we have more kills then pulls for boss as seen by - stats for wipe messages.
				mod.stats[statVarTable[savedDifficulty].."Kills"] = mod.stats[statVarTable[savedDifficulty].."Kills"] + 1
				if mod.stats[statVarTable[savedDifficulty].."Kills"] > mod.stats[statVarTable[savedDifficulty].."Pulls"] then mod.stats[statVarTable[savedDifficulty].."Kills"] = mod.stats[statVarTable[savedDifficulty].."Pulls"] end
				if not mod.ignoreBestkill and mod.combatInfo.pull then
					mod.stats[statVarTable[savedDifficulty].."LastTime"] = thisTime
					--Just to prevent pre mature end combat calls from broken mods from saving bad time stats.
					if bestTime and bestTime > 0 and bestTime < 1.5 then
						mod.stats[statVarTable[savedDifficulty].."BestTime"] = thisTime
					else
						mod.stats[statVarTable[savedDifficulty].."BestTime"] = mmin(bestTime or mhuge, thisTime)
					end
				end
				local totalKills = mod.stats[statVarTable[savedDifficulty].."Kills"]
				if self.Options.ShowDefeatMessage then
					local msg = ""
					local thisTimeString = thisTime and strFromTime(thisTime)
					if not mod.combatInfo.pull then--was a bad pull so we ignored thisTime, should never happen
						msg = DBM_CORE_BOSS_DOWN:format(difficultyText..name, DBM_CORE_UNKNOWN)
					elseif mod.ignoreBestkill then--Should never happen in a scenario so no need for scenario check.
						msg = DBM_CORE_BOSS_DOWN_I:format(difficultyText..name, totalKills)
					elseif not lastTime then
						msg = DBM_CORE_BOSS_DOWN:format(difficultyText..name, thisTimeString)
					elseif thisTime < (bestTime or mhuge) then
						msg = DBM_CORE_BOSS_DOWN_NR:format(difficultyText..name, thisTimeString, strFromTime(bestTime), totalKills)
					else
						msg = DBM_CORE_BOSS_DOWN_L:format(difficultyText..name, thisTimeString, strFromTime(lastTime), strFromTime(bestTime), totalKills)
					end
					if thisTimeString and self:InGuildParty() and not statusGuildDisabled and not self.Options.DisableGuildStatus then
						SendAddonMessage("D4", "GCE\t"..modId.."\t5\t0\t"..thisTimeString.."\t"..difficultyIndex.."\t"..name, "GUILD")
					end
					self:Schedule(1, self.AddMsg, self, msg)
				end
				local msg
				for k, v in pairs(autoRespondSpam) do
					if self.Options.WhisperStats then
						msg = msg or chatPrefixShort..DBM_CORE_WHISPER_COMBAT_END_KILL_STATS:format(playerName, difficultyText..(name or ""), totalKills)
					else
						msg = msg or chatPrefixShort..DBM_CORE_WHISPER_COMBAT_END_KILL:format(playerName, difficultyText..(name or ""))
					end
					sendWhisper(k, msg)
				end
				fireEvent("DBM_Kill", mod)
				if self.Options.EventSoundVictory2 and self.Options.EventSoundVictory2 ~= "None" and self.Options.EventSoundVictory2 ~= "" then
					if self.Options.EventSoundVictory2 == "Random" then
						local rnd = random(3, #DBM.Victory)
						self:PlaySoundFile(DBM.Victory[rnd].value)
					else
						self:PlaySoundFile(self.Options.EventSoundVictory2)
					end
				end
			end
			if mod.OnCombatEnd then mod:OnCombatEnd(wipe) end
			if mod.OnLeavingCombat then delayedFunction = mod.OnLeavingCombat end
			self.BossHealth:Hide()
			if #inCombat == 0 then--prevent error if you pulled multiple boss. (Earth, Wind and Fire)
				statusWhisperDisabled = false
				statusGuildDisabled = false
				if self.Options.RecordOnlyBosses then
					self:Schedule(10, self.StopLogging, self)--small delay to catch kill/died combatlog events
				end
				self:Unschedule(checkBossHealth)
				self:Unschedule(checkCustomBossHealth)
				self.Arrow:Hide(true)
				if tooltipsHidden then
					--Better or cleaner way?
					tooltipsHidden = false
					GameTooltip:SetScript("OnShow", GameTooltip.Show)
				end
				if self.Options.sfxDisabled then
					self.Options.sfxDisabled = nil
					SetCVar("Sound_EnableSFX", 1)
				end
				--cache table
				twipe(autoRespondSpam)
				twipe(bossHealth)
				twipe(bossHealthuIdCache)
				twipe(bossuIdCache)
				--sync table
				twipe(canSetIcons)
				twipe(iconSetRevision)
				twipe(iconSetPerson)
				twipe(addsGUIDs)

				twipe(canSetIcons)
				twipe(iconSetRevision)
				twipe(iconSetPerson)
				twipe(addsGUIDs)
				self:CreatePizzaTimer(time, "", nil, nil, nil, true)--Auto Terminate infinite loop timers on combat end
			end
		end
	end
end

function DBM:OnMobKill(cId, synced)
	for i = #inCombat, 1, -1 do
		local v = inCombat[i]
		if not v.combatInfo then
			return
		end
		if v.combatInfo.killMobs and v.combatInfo.killMobs[cId] then
			if not synced then
				sendSync("K", cId)
			end
			v.combatInfo.killMobs[cId] = false
			local allMobsDown = true
			for j, k in pairs(v.combatInfo.killMobs) do
				if k then
					allMobsDown = false
					break
				end
			end
			if allMobsDown then
				self:EndCombat(v)
			end
		elseif cId == v.combatInfo.mob and not v.combatInfo.killMobs and not v.combatInfo.multiMobPullDetection then
			if not synced then
				sendSync("K", cId)
			end
			self:EndCombat(v)
		end
	end
end

do
	local autoLog = false
	local autoTLog = false

	function DBM:StartLogging(timer, checkFunc)
		self:Unschedule(DBM.StopLogging)
		local _, instanceType = IsInInstance()
		if self.Options.LogOnlyNonTrivial and ((instanceType ~= "raid") or IsPartyLFG()) then return end
		if self.Options.AutologBosses then--Start logging here to catch pre pots.
			if not LoggingCombat() then
				autoLog = true
				self:AddMsg("|cffffff00"..COMBATLOGENABLED.."|r")
				LoggingCombat(true)
				if checkFunc then
					self:Unschedule(checkFunc)
					self:Schedule(timer+10, checkFunc)--But if pull was canceled and we don't have a boss engaged within 10 seconds of pull timer ending, abort log
				end
			end
		end
		if self.Options.AdvancedAutologBosses and Transcriptor then
			if not Transcriptor:IsLogging() then
				autoTLog = true
				self:AddMsg("|cffffff00"..DBM_CORE_TRANSCRIPTOR_LOG_START.."|r")
				Transcriptor:StartLog(1)
			end
			if checkFunc then
				self:Unschedule(checkFunc)
				self:Schedule(timer+10, checkFunc)--But if pull was canceled and we don't have a boss engaged within 10 seconds of pull timer ending, abort log
			end
		end
	end

	function DBM:StopLogging()
		if self.Options.AutologBosses and LoggingCombat() and autoLog then
			autoLog = false
			self:AddMsg("|cffffff00"..COMBATLOGDISABLED.."|r")
			LoggingCombat(false)
		end
		if self.Options.AdvancedAutologBosses and Transcriptor and autoTLog then
			if Transcriptor:IsLogging() then
				autoTLog = false
				self:AddMsg("|cffffff00"..DBM_CORE_TRANSCRIPTOR_LOG_END.."|r")
				Transcriptor:StopLog(1)
			end
		end
	end
end

function DBM:SetCurrentSpecInfo()
	currentSpecGroup = GetActiveTalentGroup() or 1

	local maxPoints, specName = 0

	for i = 1, MAX_TALENT_TABS do
		local name, _, pointsSpent = GetTalentTabInfo(i, nil, nil, currentSpecGroup)
		if maxPoints <= pointsSpent then
			maxPoints = pointsSpent
			specName = name
		end
	end

	currentSpecName = specName
end

function DBM:GetCurrentInstanceDifficulty()
	local _, instanceType, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
	if difficulty == 1 and maxPlayers == 25 then difficulty = 2 end

	if difficulty == 1 then
		return instanceType == "raid" and "normal10" or "normal5", difficultyName.." - ", difficulty, maxPlayers
	elseif difficulty == 2 then
		return instanceType == "raid" and "normal25" or "heroic5", difficultyName.." - ", difficulty, maxPlayers
	elseif difficulty == 3 then
		return "heroic10", difficultyName.." - ", difficulty, maxPlayers
	elseif difficulty == 4 then
		return "heroic25", difficultyName.." - ", difficulty, maxPlayers
	else
		return "normal", "", difficulty, maxPlayers, 0
	end
end

function DBM:GetGroupSize()
	return LastGroupSize
end

function DBM:HasMapRestrictions()
	local mapName = GetMapInfo()
	local level = GetCurrentMapDungeonLevel()
	if level == 0 then level = 1 end
	local playerX, playerY = GetPlayerMapPosition("player")
	if (playerX == 0 or playerY == 0) or (self.MapSizes[mapName] and not self.MapSizes[mapName][level]) then
		return true
	end
	return false
end

do
	local LSMMediaCacheBuilt = false
	local sharedMediaFileCache = {}
	local function buildLSMFileCache()
		local keytable = {}
		for k in next, LibStub("LibSharedMedia-3.0", true):HashTable("sound") do
			tinsert(keytable, k)
			for i=1,#keytable do
				local key = keytable[i]
				local path = LibStub("LibSharedMedia-3.0", true):HashTable("sound")[key]
				sharedMediaFileCache[path] = true
			end
		end
		LSMMediaCacheBuilt = true
	end
	local function playSoundFile(self, path, ignoreSFX, validate)
		if validate then
			--Validate LibSharedMedia
			if not LSMMediaCacheBuilt then buildLSMFileCache() end
			if not sharedMediaFileCache[path] and not path:find("DBM") then
				--This uses debug print because it has potential to cause mid fight spam
				DBM:Debug("PlaySoundFile failed do to missing media at "..path..". To fix this, re-add missing sound or change setting using this sound to a different sound.")
				return
			end
			--Validate Event packs
			if not DBMVPSoundEventsPack and path:find("DBM-SoundEventsPack") then
				--This uses actual user print because these events only occure at start or end of instance or fight.
				DBM:AddMsg("PlaySoundFile failed do to missing media at "..path..". To fix this, re-add/enable DBM-SoundEventsPack or change setting using this sound to a different sound.")
				return
			end
			if not DBMVPSMGPack and path:find("DBM-SMGEventsPack") then
				--This uses actual user print because these events only occure at start or end of instance or fight.
				DBM:AddMsg("PlaySoundFile failed do to missing media at "..path..". To fix this, re-add/enable DBM-SMGEventsPack or change setting using this sound to a different sound.")
				return
			end
		end
		local soundSetting = self.Options.UseSoundChannel
		DBM:Debug("PlaySoundFile playing with media "..path, 3)
		if soundSetting == "Dialog" then
			PlaySoundFile(path, "Dialog")
		elseif ignoreSFX or soundSetting == "Master" then
			PlaySoundFile(path, "Master")
		else
			PlaySoundFile(path)
		end
		fireEvent("DBM_PlaySound", path)
	end
	local function playSound(self, path, ignoreSFX, validate)
		local soundSetting = self.Options.UseSoundChannel
		DBM:Debug("PlaySound playing with media "..path, 3)
		if soundSetting == "Dialog" then
			PlaySound(path, "Dialog", false)
		elseif ignoreSFX or soundSetting == "Master" then
			PlaySound(path, "Master", false)
		else
			PlaySound(path)--using SFX channel, leave forceNoDuplicates on.
		end
		fireEvent("DBM_PlaySound", path)
	end

	function DBM:PlaySoundFile(path, ignoreSFX, validate)
		if self.Options.SilentMode or path == "" or path == "None" then return end
		playSoundFile(self, path, ignoreSFX, validate)
	end

	function DBM:PlaySound(path, ignoreSFX)
		if self.Options.SilentMode then return end
		playSound(self, path, ignoreSFX)
	end
end

--Handle new spell name requesting with wrapper, to make api changes easier to handle
function DBM:GetSpellInfo(spellId)
	local name, rank, icon, cost, isFunnel, powerType, castingTime, minRange, maxRange = GetSpellInfo(spellId)
	if not name then--Bad request all together
		DBM:Debug("|cffff0000Invalid call to GetSpellInfo for spellID: |r"..spellId)
		return nil
	else--Good request, return now
		return name, rank, icon, cost, isFunnel, powerType, castingTime, minRange, maxRange
	end
end

function DBM:UnitDebuff(uId, spellInput, spellInput2, spellInput3, spellInput4)
	if not uId then return end
	for i = 1, 60 do
		local spellName, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(uId, i)
		if not spellName then return end
		if spellInput == spellName or spellInput == spellId or spellInput2 == spellName or spellInput2 == spellId or spellInput3 == spellName or spellInput3 == spellId or spellInput4 == spellName or spellInput4 == spellId then
			return spellName, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId
		end
	end
end

function DBM:UnitBuff(uId, spellInput, spellInput2, spellInput3, spellInput4)
	if not uId then return end
	for i = 1, 60 do
		local spellName, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff(uId, i)
		if not spellName then return end
		if spellInput == spellName or spellInput == spellId or spellInput2 == spellName or spellInput2 == spellId or spellInput3 == spellName or spellInput3 == spellId or spellInput4 == spellName or spellInput4 == spellId then
			return spellName, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId
		end
	end
end

function DBM:UNIT_DIED(args)
	local GUID = args.destGUID
	if self:IsCreatureGUID(GUID) then
		self:OnMobKill(self:GetCIDFromGUID(GUID))
	end
end
DBM.UNIT_DESTROYED = DBM.UNIT_DIED

----------------------
--  Timer recovery  --
----------------------
do
	local requestedFrom = {}
	local requestTime = 0
	local clientUsed = {}
	local sortMe = {}

	local function sort(v1, v2)
		if v1.revision and not v2.revision then
			return true
		elseif v2.revision and not v1.revision then
			return false
		elseif v1.revision and v2.revision then
			return v1.revision > v2.revision
		end
	end

	function DBM:RequestTimers(requestNum)
		twipe(sortMe)
		for i, v in pairs(raid) do
			tinsert(sortMe, v)
		end
		tsort(sortMe, sort)
		self:Debug("RequestTimers Running", 2)
		local selectedClient
		local listNum = 0
		for i, v in ipairs(sortMe) do
			-- If selectedClient player's realm is not same with your's, timer recovery by selectedClient not works at all.
			-- SendAddonMessage target channel is "WHISPER" and target player is other realm, no msg sends at all. At same realm, message sending works fine. (Maybe bliz bug or SendAddonMessage function restriction?)
			if v.name ~= playerName and UnitIsConnected(v.id) and (not UnitIsGhost(v.id)) and (GetTime() - (clientUsed[v.name] or 0)) > 10 then
				listNum = listNum + 1
				if listNum == requestNum then
					selectedClient = v
					clientUsed[v.name] = GetTime()
					break
				end
			end
		end
		if not selectedClient then return end
		self:Debug("Requesting timer recovery to "..selectedClient.name)
		requestedFrom[selectedClient.name] = true
		requestTime = GetTime()
		SendAddonMessage("D4", "RT", "WHISPER", selectedClient.name)
	end

	function DBM:ReceiveCombatInfo(sender, mod, time)
		if dbmIsEnabled and requestedFrom[sender] and (GetTime() - requestTime) < 5 and #inCombat == 0 then
			self:StartCombat(mod, time, "TIMER_RECOVERY")
			--Recovery successful, someone sent info, abort other recovery requests
			self:Unschedule(self.RequestTimers)
			twipe(requestedFrom)
		end
	end

	function DBM:ReceiveTimerInfo(sender, mod, timeLeft, totalTime, id, ...)
		if requestedFrom[sender] and (GetTime() - requestTime) < 5 then
			local lag = select(3, GetNetStats()) / 1000
			for i, v in ipairs(mod.timers) do
				if v.id == id then
					v:Start(totalTime, ...)
					v:Update(totalTime - timeLeft + lag, totalTime, ...)
				end
			end
		end
	end

	function DBM:ReceiveVariableInfo(sender, mod, name, value)
		if requestedFrom[sender] and (GetTime() - requestTime) < 5 then
			if value == "true" then
				mod.vb[name] = true
			elseif value == "false" then
				mod.vb[name] = false
			else
				mod.vb[name] = value
			end
		end
	end
end

do
	local spamProtection = {}
	function DBM:SendTimers(target)
		self:Debug("SendTimers requested by "..target, 2)
		local spamForTarget = spamProtection[target] or 0
		-- just try to clean up the table, that should keep the hash table at max. 4 entries or something :)
		for k, v in pairs(spamProtection) do
			if GetTime() - v >= 1 then
				spamProtection[k] = nil
			end
		end
		if GetTime() - spamForTarget < 1 then -- just to prevent players from flooding this on purpose
			return
		end
		spamProtection[target] = GetTime()
		if #inCombat < 1 then
			--Break timer is up, so send that
			--But only if we are not in combat with a boss
			local breakBar = self.Bars:GetBar("%s\t"..DBM_CORE_TIMER_BREAK) or self.Bars:GetBar(DBM_CORE_TIMER_BREAK)
			if breakBar then
				SendAddonMessage("D4", "BTR3\t"..breakBar.timer, "WHISPER", target)
			end
			return
		end
		local mod
		for i, v in ipairs(inCombat) do
			mod = not v.isCustomMod and v
		end
		mod = mod or inCombat[1]
		self:SendCombatInfo(mod, target)
		self:SendVariableInfo(mod, target)
		self:SendTimerInfo(mod, target)
	end
	function DBM:SendPVPTimers(target)
		self:Debug("SendPVPTimers requested by "..target, 2)
		local spamForTarget = spamProtection[target] or 0
		-- just try to clean up the table, that should keep the hash table at max. 4 entries or something :)
		for k, v in pairs(spamProtection) do
			if GetTime() - v >= 1 then
				spamProtection[k] = nil
			end
		end
		if GetTime() - spamForTarget < 1 then -- just to prevent players from flooding this on purpose
			return
		end
		spamProtection[target] = GetTime()
		local mod = nil -- TODO:
		if mod then
			self:SendTimerInfo(mod, target)
		end
	end
end

function DBM:SendCombatInfo(mod, target)
	return SendAddonMessage("D4", ("CI\t%s\t%s"):format(mod.id, GetTime() - mod.combatInfo.pull), "WHISPER", target)
end

function DBM:SendTimerInfo(mod, target)
	for i, v in ipairs(mod.timers) do
		--Pass on any timer that has no type, or has one that isn't an ai timer
		if not v.type or v.type and v.type ~= "ai" then
			for _, uId in ipairs(v.startedTimers) do
				local elapsed, totalTime, timeLeft
				if select("#", string.split("\t", uId)) > 1 then
					elapsed, totalTime = v:GetTime(select(2, string.split("\t", uId)))
				else
					elapsed, totalTime = v:GetTime()
				end
				timeLeft = totalTime - elapsed
				if timeLeft > 0 and totalTime > 0 then
					SendAddonMessage("D4", ("TI\t%s\t%s\t%s\t%s"):format(mod.id, timeLeft, totalTime, uId), "WHISPER", target)
				end
			end
		end
	end
end

function DBM:SendVariableInfo(mod, target)
	for vname, v in pairs(mod.vb) do
		local v2 = tostring(v)
		if v2 then
			SendAddonMessage("D4", ("VI\t%s\t%s\t%s"):format(mod.id, vname, v2), "WHISPER", target)
		end
	end
end

do
	function DBM:PLAYER_ENTERING_WORLD()
		if not self.Options.DontShowReminders then
			C_Timer:After(25, function() if self.Options.SilentMode then self:AddMsg(DBM_SILENT_REMINDER) end end)
			C_Timer:After(30, function() if not self.Options.SettingsMessageShown then self.Options.SettingsMessageShown = true self:AddMsg(DBM_HOW_TO_USE_MOD) end end)
		end
		--Check if any previous changed cvars were not restored and restore them
		if self.Options.sfxDisabled then
			self.Options.sfxDisabled = nil
			SetCVar("Sound_EnableSFX", 1)
			DBM:Debug("Restoring Sound_EnableSFX CVAR")
		end
		if #inCombat == 0 then
			DBM:Schedule(0, self.RequestTimers, self, 1)
		end
		self:LFG_UPDATE()
	end
end

------------------------------------
--  Auto-respond/Status whispers  --
------------------------------------
do
	local function getNumAlivePlayers()
		local alive = 0
		if GetNumRaidMembers() > 0 then
			for i = 1, GetNumRaidMembers() do
				alive = alive + ((UnitIsDeadOrGhost("raid"..i) and 0) or 1)
			end
		else
			alive = (UnitIsDeadOrGhost("player") and 0) or 1
			for i = 1, GetNumPartyMembers() do
				alive = alive + ((UnitIsDeadOrGhost("party"..i) and 0) or 1)
			end
		end
		return alive
	end

	local function isOnSameServer(presenceId)
		local toonID, client = select(5, BNGetFriendInfoByID(presenceId))
		if client ~= "WoW" then
			return false
		end
		return GetRealmName() == select(4, BNGetToonInfo(toonID))
	end

	-- sender is a presenceId for real id messages, a character name otherwise
	local function onWhisper(msg, sender, isRealIdMessage)
		if statusWhisperDisabled then return end--RL has disabled status whispers for entire raid.
		if msg == "status" and #inCombat > 0 and DBM.Options.AutoRespond then
			if not difficultyText then -- prevent error when timer recovery function worked and etc (StartCombat not called)
				savedDifficulty, difficultyText, difficultyIndex, LastGroupSize = DBM:GetCurrentInstanceDifficulty()
			end
			local mod
			for i, v in ipairs(inCombat) do
				mod = not v.isCustomMod and v
			end
			mod = mod or inCombat[1]
			local hp = mod.highesthealth and mod:GetHighestBossHealth() or mod:GetLowestBossHealth()
			local hpText = mod.CustomHealthUpdate and mod:CustomHealthUpdate() or hp and ("%d%%"):format(hp) or DBM_CORE_UNKNOWN
			if mod.vb.phase then
				hpText = hpText.." ("..DBM_PHASE:format(mod.vb.phase)..")"
			end
			if mod.numBoss and mod.vb.bossLeft and mod.numBoss > 1 then
				local bossesKilled = mod.numBoss - mod.vb.bossLeft
				hpText = hpText.." ("..BOSSES_KILLED:format(bossesKilled, mod.numBoss)..")"
			end
			sendWhisper(sender, chatPrefix..DBM_CORE_STATUS_WHISPER:format(difficultyText..(mod.combatInfo.name or ""), hpText, getNumAlivePlayers(), mmax(GetNumRaidMembers(), GetNumPartyMembers() + 1)))
		elseif #inCombat > 0 and DBM.Options.AutoRespond then
			if not difficultyText then -- prevent error when timer recovery function worked and etc (StartCombat not called)
				savedDifficulty, difficultyText, difficultyIndex, LastGroupSize = DBM:GetCurrentInstanceDifficulty()
			end
			local mod
			for i, v in ipairs(inCombat) do
				mod = not v.isCustomMod and v
			end
			mod = mod or inCombat[1]
			local hp = mod.highesthealth and mod:GetHighestBossHealth() or mod:GetLowestBossHealth()
			local hpText = mod.CustomHealthUpdate and mod:CustomHealthUpdate() or hp and ("%d%%"):format(hp) or DBM_CORE_UNKNOWN
			if mod.vb.phase then
				hpText = hpText.." ("..DBM_PHASE:format(mod.vb.phase)..")"
			end
			if mod.numBoss and mod.vb.bossLeft and mod.numBoss > 1 then
				local bossesKilled = mod.numBoss - mod.vb.bossLeft
				hpText = hpText.." ("..BOSSES_KILLED:format(bossesKilled, mod.numBoss)..")"
			end
			if not autoRespondSpam[sender] then
				sendWhisper(sender, chatPrefix..DBM_CORE_AUTO_RESPOND_WHISPER:format(playerName, difficultyText..(mod.combatInfo.name or ""), hpText, getNumAlivePlayers(), mmax(GetNumRaidMembers(), GetNumPartyMembers() + 1)))
				DBM:AddMsg(DBM_CORE_AUTO_RESPONDED)
			end
			autoRespondSpam[sender] = true
		end
	end

	function DBM:CHAT_MSG_WHISPER(msg, name)
		return onWhisper(msg, name, false)
	end

	function DBM:CHAT_MSG_BN_WHISPER(msg, ...)
		local presenceId = select(12, ...) -- srsly?
		return onWhisper(msg, presenceId, true)
	end
end


-------------------
--  Chat Filter  --
-------------------
do
	local function filterOutgoing(self, event, ...)
		local msg = ...
		if not msg and self then -- compatibility mode!
			-- we also check if self exists to prevent a possible freeze if the function is called without arguments at all
			-- as this would be even worse than the issue with missing whisper messages ;)
			return filterOutgoing(nil, nil, self, event)
		end
		return msg:sub(1, chatPrefix:len()) == chatPrefix or msg:sub(1, chatPrefixShort:len()) == chatPrefixShort, ...
	end

	local function filterIncoming(self, event, ...)
		local msg = ...
		if not msg and self then -- compatibility mode!
			return filterIncoming(nil, nil, self, event)
		end
		if DBM.Options.SpamBlockBossWhispers then
			return #inCombat > 0 and (msg == "status" or msg:sub(1, chatPrefix:len()) == chatPrefix or msg:sub(1, chatPrefixShort:len()) == chatPrefixShort), ...
		else
			return msg == "status" and #inCombat > 0, ...
		end
	end

	local function filterRaidWarning(self, event, ...)
		local msg = ...
		if not msg and self then -- compatibility mode!
			return filterRaidWarning(nil, nil, self, event)
		end
		return DBM.Options.SpamBlockRaidWarning and type(msg) == "string" and (not not msg:match("^%s*%*%*%*")), ...
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterOutgoing)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterOutgoing)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterIncoming)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterIncoming)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", filterRaidWarning)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterRaidWarning)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterRaidWarning)
end


do
	local old = RaidWarningFrame:GetScript("OnEvent")
	RaidWarningFrame:SetScript("OnEvent", function(self, event, msg, ...)
		if DBM.Options.SpamBlockRaidWarning and msg:find("%*%*%* .* %*%*%*") then
			return
		end
		return old(self, event, msg, ...)
	end)
end

do
	local old = RaidBossEmoteFrame:GetScript("OnEvent")
	RaidBossEmoteFrame:SetScript("OnEvent", function(...)
		if DBM.Options.HideBossEmoteFrame and #inCombat > 0 then
			return
		end
		return old(...)
	end)
end

--------------------------
--  Enable/Disable DBM  --
--------------------------
do
	local forceDisabled = false
	function DBM:Disable(forceDisable)
		unscheduleAll()
		dbmIsEnabled = false
		forceDisabled = forceDisable
	end

	function DBM:Enable()
		if not forceDisabled then
			dbmIsEnabled = true
		end
	end

	function DBM:IsEnabled()
		return dbmIsEnabled
	end
end

-----------------------
--  Misc. Functions  --
-----------------------
function DBM:AddMsg(text, prefix)
	local tag = prefix or (self.localization and self.localization.general.name) or "DBM"
	local frame = _G[tostring(DBM.Options.ChatFrame)]
	frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
	if prefix ~= false then
		frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(tag), tostring(text)), 0.41, 0.8, 0.94)
	else
		frame:AddMessage(text, 0.41, 0.8, 0.94)
	end
end
AddMsg = DBM.AddMsg

function DBM:Debug(text, level)
	if not self.Options or not self.Options.DebugMode then return end
	if (level or 1) <= DBM.Options.DebugLevel then
		local frame = _G[tostring(DBM.Options.ChatFrame)]
		frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
		frame:AddMessage("|cffff7d0aDBM Debug:|r "..text, 1, 1, 1)
		fireEvent("DBM_Debug", text, level)
	end
end

do
	local testMod
	local testWarning1, testWarning2, testWarning3
	local testTimer1, testTimer2, testTimer3, testTimer4, testTimer5, testTimer6, testTimer7, testTimer8
	local testSpecialWarning1, testSpecialWarning2, testSpecialWarning3
	function DBM:DemoMode()
		if not testMod then
			testMod = self:NewMod("TestMod", "DBM-PvP")
			self:GetModLocalization("TestMod"):SetGeneralLocalization{ name = "Test Mod" }
			testWarning1 = testMod:NewAnnounce("%s", 1, "Interface\\Icons\\Spell_Nature_WispSplode")
			testWarning2 = testMod:NewAnnounce("%s", 2, "Interface\\Icons\\Spell_Shadow_Shadesofdarkness")
			testWarning3 = testMod:NewAnnounce("%s", 3, "Interface\\Icons\\Spell_Fire_SelfDestruct")
			testTimer1 = testMod:NewTimer(20, "%s", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil)
			testTimer2 = testMod:NewTimer(20, "%s ", "Interface\\Icons\\INV_Misc_Head_Orc_01", nil, nil, 1)
			testTimer3 = testMod:NewTimer(20, "%s  ", "Interface\\Icons\\Spell_Shadow_Shadesofdarkness", nil, nil, 3, DBM_CORE_MAGIC_ICON, nil, 1, 4)--inlineIcon, keep, countdown, countdownMax
			testTimer4 = testMod:NewTimer(20, "%s   ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 4, DBM_CORE_INTERRUPT_ICON)
			testTimer5 = testMod:NewTimer(20, "%s    ", "Interface\\Icons\\Spell_Fire_SelfDestruct", nil, nil, 2, DBM_CORE_HEALER_ICON, nil, 3, 4)--inlineIcon, keep, countdown, countdownMax
			testTimer6 = testMod:NewTimer(20, "%s     ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 5, DBM_CORE_TANK_ICON, nil, 2, 4)--inlineIcon, keep, countdown, countdownMax
			testTimer7 = testMod:NewTimer(20, "%s      ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 6)
			testTimer8 = testMod:NewTimer(20, "%s       ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 7)
			testSpecialWarning1 = testMod:NewSpecialWarning("%s", nil, nil, nil, 1, 2)
			testSpecialWarning2 = testMod:NewSpecialWarning(" %s ", nil, nil, nil, 2, 2)
			testSpecialWarning3 = testMod:NewSpecialWarning("  %s  ", nil, nil, nil, 3, 2) -- hack: non auto-generated special warnings need distinct names (we could go ahead and give them proper names with proper localization entries, but this is much easier)
		end
		testTimer1:Start(10, "Test Bar")
		testTimer2:Start(30, "Adds")
		testTimer3:Start(43, "Evil Debuff")
		testTimer4:Start(20, "Important Interrupt")
		testTimer5:Start(60, "Boom!")
		testTimer6:Start(35, "Handle your Role")
		testTimer7:Start(50, "Next Stage")
		testTimer8:Start(55, "Custom User Bar")
		testWarning1:Cancel()
		testWarning2:Cancel()
		testWarning3:Cancel()
		testSpecialWarning1:Cancel()
		testSpecialWarning1:CancelVoice()
		testSpecialWarning2:Cancel()
		testSpecialWarning2:CancelVoice()
		testSpecialWarning3:Cancel()
		testSpecialWarning3:CancelVoice()
		testWarning1:Show("Test-mode started...")
		testWarning1:Schedule(62, "Test-mode finished!")
		testWarning3:Schedule(50, "Boom in 10 sec!")
		testWarning3:Schedule(20, "Pew Pew Laser Owl!")
		testWarning2:Schedule(38, "Evil Spell in 5 sec!")
		testWarning2:Schedule(43, "Evil Spell!")
		testWarning1:Schedule(10, "Test bar expired!")
		testSpecialWarning1:Schedule(20, "Pew Pew Laser Owl")
		testSpecialWarning1:ScheduleVoice(20, "runaway")
		testSpecialWarning2:Schedule(43, "Fear!")
		testSpecialWarning2:ScheduleVoice(43, "fearsoon")
		testSpecialWarning3:Schedule(60, "Boom!")
		testSpecialWarning3:ScheduleVoice(60, "defensive")
	end
end

DBM.Bars:SetAnnounceHook(function(bar)
	local prefix
	if bar.color and bar.color.r == 1 and bar.color.g == 0 and bar.color.b == 0 then
		prefix = DBM_CORE_HORDE or FACTION_HORDE
	elseif bar.color and bar.color.r == 0 and bar.color.g == 0 and bar.color.b == 1 then
		prefix = DBM_CORE_ALLIANCE or FACTION_ALLIANCE
	end
	if prefix then
		return ("%s: %s  %d:%02d"):format(prefix, _G[bar.frame:GetName().."BarName"]:GetText(), floor(bar.timer / 60), bar.timer % 60)
	end
end)

function DBM:Capitalize(str)
	local firstByte = str:byte(1, 1)
	local numBytes = 1
	if firstByte >= 0xF0 then -- firstByte & 0b11110000
		numBytes = 4
	elseif firstByte >= 0xE0 then -- firstByte & 0b11100000
		numBytes = 3
	elseif firstByte >= 0xC0 then  -- firstByte & 0b11000000
		numBytes = 2
	end
	return str:sub(1, numBytes):upper()..str:sub(numBytes + 1):lower()
end

-- An anti spam function to throttle spammy events (e.g. SPELL_AURA_APPLIED on all group members)
-- @param time the time to wait between two events (optional, default 2.5 seconds)
-- @param id the id to distinguish different events (optional, only necessary if your mod keeps track of two different spam events at the same time)
function DBM:AntiSpam(time, id)
	if GetTime() - (id and (self["lastAntiSpam" .. tostring(id)] or 0) or self.lastAntiSpam or 0) > (time or 2.5) then
		if id then
			self["lastAntiSpam" .. tostring(id)] = GetTime()
		else
			self.lastAntiSpam = GetTime()
		end
		return true
	else
		return false
	end
end

function DBM:GetTOC()
	return wowTOC, wowVersionString, wowBuild
end

function DBM:InCombat()
	if #inCombat > 0 then
		return true
	end
	return false
end

do
	local iconStrings = {[1] = RAID_TARGET_1, [2] = RAID_TARGET_2, [3] = RAID_TARGET_3, [4] = RAID_TARGET_4, [5] = RAID_TARGET_5, [6] = RAID_TARGET_6, [7] = RAID_TARGET_7, [8] = RAID_TARGET_8,}
	function DBM:IconNumToString(number)
		return iconStrings[number] or number
	end
	function DBM:IconNumToTexture(number)
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..number..".blp:12:12|t" or number
	end
end

-----------------
--  Map Sizes  --
-----------------
DBM.MapSizes = {}

function DBM:RegisterMapSize(zone, ...)
	if not DBM.MapSizes[zone] then
		DBM.MapSizes[zone] = {}
	end
	for i = 1, select("#", ...), 3 do
		local level, width, height = select(i, ...)
		DBM.MapSizes[zone][level] = {width, height}
	end
end

function DBM:GetMapSizes()
--	if not currentSizes then -- TODO
		DBM:UpdateMapSizes()
--	end
--	return currentSizes
end

----------------------------
--  Boss Mod Constructor  --
----------------------------
do
	local modsById = setmetatable({}, {__mode = "v"})
	local mt = {__index = bossModPrototype}

	function DBM:NewMod(name, modId, modSubTab, instanceId)
		name = tostring(name) -- the name should never be a number of something as it confuses sync handlers that just receive some string and try to get the mod from it
		if name == "DBM-ProfilesDummy" then return end
		if modsById[name] then error("DBM:NewMod(): Mod names are used as IDs and must therefore be unique.", 2) end
		local obj = setmetatable(
			{
				Options = {
					Enabled = true,
				},
				DefaultOptions = {
					Enabled = true,
				},
				subTab = modSubTab,
				optionCategories = {
				},
				categorySort = {"announce", "announceother", "announcepersonal", "announcerole", "timer", "sound", "yell", "icon", "misc"},
				id = name,
				announces = {},
				specwarns = {},
				timers = {},
				vb = {},
				iconRestore = {},
				modId = modId,
				instanceId = instanceId,
				revision = 0,
				SyncThreshold = 8,
				localization = self:GetModLocalization(name)
			},
			mt
		)
		for i, v in ipairs(self.AddOns) do
			if v.modId == modId then
				obj.addon = v
				break
			end
		end
		obj.localization.general.name = obj.localization.general.name or name
		tinsert(self.Mods, obj)
		if modId then
			self.ModLists[modId] = self.ModLists[modId] or {}
			tinsert(self.ModLists[modId], name)
		end
		modsById[name] = obj
		obj:AddBoolOption("HealthFrame", false, "misc")
		obj:SetZone()
		return obj
	end

	function DBM:GetModByName(name)
		return modsById[tostring(name)]
	end
end

-----------------------
--  General Methods  --
-----------------------
bossModPrototype.RegisterEvents = DBM.RegisterEvents
bossModPrototype.AddMsg = DBM.AddMsg

function bossModPrototype:SetZone(...)
	if select("#", ...) == 0 then
		self.zones = {}
		if self.addon.zone and #self.addon.zone > 0 and self.addon.zoneId and #self.addon.zoneId > 0 then
			for i, v in ipairs(self.addon.zone) do
				self.zones[#self.zones + 1] = v
			end
			for i, v in ipairs(self.addon.zoneId) do
				self.zones[#self.zones + 1] = v
			end
		else
			self.zones = self.addon.zone and #self.addon.zone > 0 and self.addon.zone or self.addon.zoneId and #self.addon.zoneId > 0 and self.addon.zoneId or {}
		end
	elseif select(1, ...) ~= DBM_DISABLE_ZONE_DETECTION then
		self.zones = {...}
	else -- disable zone detection
		self.zones = nil
	end
end

function bossModPrototype:SetCreatureID(...)
	self.creatureId = ...
	if select("#", ...) > 1 then
		self.multiMobPullDetection = {...}
		if self.combatInfo then
			self.combatInfo.multiMobPullDetection = self.multiMobPullDetection
		end
	end
end

function bossModPrototype:Toggle()
	if self.Options.Enabled then
		self:DisableMod()
	else
		self:EnableMod()
	end
end

function bossModPrototype:EnableMod()
	self.Options.Enabled = true
end

function bossModPrototype:DisableMod()
	self:Stop()
	self.Options.Enabled = false
end

function bossModPrototype:Stop()
	for i, v in ipairs(self.timers) do
		v:Stop()
	end
	self:Unschedule()
end

function bossModPrototype:SetUsedIcons(...)
	self.usedIcons = {}
	for i = 1, select("#", ...) do
		self.usedIcons[select(i, ...)] = true
	end
end

function bossModPrototype:RegisterOnUpdateHandler(func, interval)
	startScheduler()
	if type(func) ~= "function" then return end
	self.elapsed = 0
	self.updateInterval = interval or 0
	updateFunctions[self] = func
end

function bossModPrototype:UnregisterOnUpdateHandler()
	self.elapsed = nil
	self.updateInterval = nil
	twipe(updateFunctions)
end

--------------
--  Events  --
--------------
function bossModPrototype:RegisterEventsInCombat(...)
	if self.inCombatOnlyEvents then
		geterrorhandler()("combat events already set")
	end
	self.inCombatOnlyEvents = {...}
	for k, v in pairs(self.inCombatOnlyEvents) do
		if v:sub(0, 5) == "UNIT_" and v:sub(v:len() - 10) ~= "_UNFILTERED" and not v:find(" ") and v ~= "UNIT_DIED" and v ~= "UNIT_DESTROYED" then
			-- legacy event, oh noes
			self.inCombatOnlyEvents[k] = v .. " boss1 boss2 boss3 boss4 target focus"
		end
	end
end

function bossModPrototype:SendWhisper(msg, target)
	return not DBM.Options.DontSendBossWhispers and sendWhisper(target, chatPrefixShort..msg)
end

function bossModPrototype:GetBossTarget(cid)
	cid = cid or self.creatureId
	for i = 1, GetNumRaidMembers() do
		if self:GetUnitCreatureId("raid"..i.."target") == cid then
			return UnitName("raid"..i.."targettarget"), "raid"..i.."targettarget"
		elseif self:GetUnitCreatureId("focus") == cid then	-- we check our own focus frame, maybe the boss is there ;)
			return UnitName("focustarget"), "focustarget"
		end
	end
end

function bossModPrototype:GetThreatTarget(cid)
	cid = cid or self.creatureId
	for i = 1, GetNumRaidMembers() do
		if self:GetUnitCreatureId("raid"..i.."target") == cid then
			for x = 1, GetNumRaidMembers() do
				if UnitDetailedThreatSituation("raid"..x, "raid"..i.."target") == 1 then
					return "raid"..x
				end
			end
		end
	end
end

-----------------------
--  Utility Methods  --
-----------------------

function bossModPrototype:IsDifficulty(...)
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	for i = 1, select("#", ...) do
		if diff == select(i, ...) then
			return true
		end
	end
	return false
end

-- hard coded party-mod support, yay :)
-- returns heroic for old instances that do not have a heroic mode (Naxx, Ulduar...)
-- function bossModPrototype:GetDifficulty()
-- 	local _, instanceType, difficulty, _, _, playerDifficulty, isDynamicInstance = GetInstanceInfo()
-- 	if instanceType == "raid" and isDynamicInstance then -- "new" instance (ICC)
-- 		if difficulty == 1 then -- 10 men
-- 			return playerDifficulty == 0 and "normal10" or playerDifficulty == 1 and "heroic10" or "unknown"
-- 		elseif difficulty == 2 then -- 25 men
-- 			return playerDifficulty == 0 and "normal25" or playerDifficulty == 1 and "heroic25" or "unknown"
-- 		end
-- 	else -- support for "old" instances
-- 		if GetInstanceDifficulty() == 1 then
-- 			return (self.modId == "DBM-Party-WotLK" or self.modId == "DBM-Party-BC") and "normal5" or
-- 			self.hasHeroic and "normal10" or "heroic10"
-- 		elseif GetInstanceDifficulty() == 2 then
-- 			return (self.modId == "DBM-Party-WotLK" or self.modId == "DBM-Party-BC") and "heroic5" or
-- 			self.hasHeroic and "normal25" or "heroic25"
-- 		elseif GetInstanceDifficulty() == 3 then
-- 			return "heroic10"
-- 		elseif GetInstanceDifficulty() == 4 then
-- 			return "heroic25"
-- 		end
-- 	end
-- end

function bossModPrototype:GetDifficulty()
	local _, instanceType = GetInstanceInfo()
	local diff = GetInstanceDifficulty()
	if instanceType == "party" then
		if diff == 1 then
			return "normal5"
		elseif diff == 2 then
			return "heroic5"
		end
	elseif instanceType == "raid" then
		if diff == 1 then
			return "normal10"
		elseif diff == 2 then
			return "normal25"
		elseif diff == 3 then
			return "heroic10"
		elseif diff == 4 then
			return "heroic25"
		end
	end
end

function bossModPrototype:IsDifficulty(...)
	local diff = self:GetDifficulty()
	for i = 1, select("#", ...) do
		if diff == select(i, ...) then
			return true
		end
	end
	return false
end

function bossModPrototype:SetUsedIcons(...)
	self.usedIcons = {}
	for i = 1, select("#", ...) do
		self.usedIcons[select(i, ...)] = true
	end
end

function bossModPrototype:LatencyCheck(custom)
	return select(3, GetNetStats()) < (custom or DBM.Options.LatencyThreshold)
end

bossModPrototype.IconNumToString = DBM.IconNumToString
bossModPrototype.IconNumToTexture = DBM.IconNumToTexture
bossModPrototype.AntiSpam = DBM.AntiSpam
bossModPrototype.HasMapRestrictions = DBM.HasMapRestrictions
bossModPrototype.GetUnitCreatureId = DBM.GetUnitCreatureId
bossModPrototype.GetCIDFromGUID = DBM.GetCIDFromGUID
bossModPrototype.IsCreatureGUID = DBM.IsCreatureGUID
bossModPrototype.GetUnitIdFromGUID = DBM.GetUnitIdFromGUID
bossModPrototype.CheckNearby = DBM.CheckNearby

local function getTalentpointsSpent(spellID)
	local spellName = GetSpellInfo(spellID)
	for tabIndex=1, GetNumTalentTabs() do
		for talentID=1, GetNumTalents(tabIndex) do
			local name, _, _, _, spent = GetTalentInfo(tabIndex, talentID)
			if(name == spellName) then
				return spent
			end
		end
	end
	return 0
end

local specFlags ={
	["Tank"] = "IsTank",
	["Healer"] = "IsHealer",
	["Melee"] = "IsMelee",
	["Ranged"] = "IsRanged",
	["Physical"] = "IsPhysical",
	["RemoveEnrage"] = "CanRemoveEnrage",
	["MagicDispeller"] = "IsMagicDispeller",
}

function bossModPrototype:GetRoleFlagValue(flag)
	if not flag then return false end
	local flags = {strsplit("|", flag)}
	for i = 1, #flags do
		local flagText = flags[i]
		local flagFunc = specFlags[flagText] and self[specFlags[flagText]]
		if flagFunc then
			if flagText:match("^-") then
				flagText = flagText:gsub("-", "")
				if not flagFunc() then
					return true
				end
			else
				if flagFunc() then
					return true
				end
			end
		end
	end
	return false
end

function bossModPrototype:IsMelee()
	return select(2, UnitClass("player")) == "ROGUE"
		or select(2, UnitClass("player")) == "WARRIOR"
		or select(2, UnitClass("player")) == "DEATHKNIGHT"
		or (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) < 51)
		or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(2)) >= 50)
		or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(2)) >= 51)
end

function bossModPrototype:IsRanged()
	return select(2, UnitClass("player")) == "MAGE"
		or select(2, UnitClass("player")) == "HUNTER"
		or select(2, UnitClass("player")) == "WARLOCK"
		or select(2, UnitClass("player")) == "PRIEST"
		or (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) >= 51)
		or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(2)) < 51)
		or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(2)) < 51)
end

function bossModPrototype:IsPhysical()
	return self:IsMelee() or select(2, UnitClass("player")) == "HUNTER"
end

function bossModPrototype:CanRemoveEnrage()
	return select(2, UnitClass("player")) == "HUNTER" or select(2, UnitClass("player")) == "ROGUE"
end

function bossModPrototype:IsMagicDispeller()
	return select(2, UnitClass("player")) == "MAGE"
		or select(2, UnitClass("player")) == "SHAMAN"
		or select(2, UnitClass("player")) == "PRIEST"
end

local function IsDeathKnightTank()
	-- idea taken from addon 'ElitistJerks'
	local tankTalents = (getTalentpointsSpent(16271) >= 5 and 1 or 0) +		-- Anticipation
		(getTalentpointsSpent(49042) >= 5 and 1 or 0) +						-- Toughness
		(getTalentpointsSpent(55225) >= 5 and 1 or 0)						-- Blade Barrier
	return tankTalents >= 2
end

local function IsDruidTank()
	-- idea taken from addon 'ElitistJerks'
	local tankTalents = (getTalentpointsSpent(57881) >= 2 and 1 or 0) +		-- Natural Reaction
		(getTalentpointsSpent(16929) >= 3 and 1 or 0) +						-- Thick Hide
		(getTalentpointsSpent(61336) >= 1 and 1 or 0) +						-- Survival Instincts
		(getTalentpointsSpent(57877) >= 3 and 1 or 0)						-- Protector of the Pack
	return tankTalents >= 3
end

function bossModPrototype:IsTank()
	return (select(2, UnitClass("player")) == "WARRIOR" and select(3, GetTalentTabInfo(3)) >= 13)
		or (select(2, UnitClass("player")) == "DEATHKNIGHT" and IsDeathKnightTank())
		or (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(2)) >= 51)
		or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(2)) >= 51 and IsDruidTank())
end

function bossModPrototype:IsHealer()
	return (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) >= 51)
		or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(3)) >= 51)
		or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(3)) >= 51)
		or (select(2, UnitClass("player")) == "PRIEST" and select(3, GetTalentTabInfo(3)) < 51)
end

function bossModPrototype:IsWeaponDependent(uId)
	return select(2, UnitClass(uId)) == "ROGUE"
		or (select(2, UnitClass(uId)) == "WARRIOR" and not (select(3, GetTalentTabInfo(3)) >= 20))
		or select(2, UnitClass(uId)) == "DEATHKNIGHT"
		or (select(2, UnitClass(uId)) == "PALADIN" and not (select(3, GetTalentTabInfo(1)) >= 51))
		or (select(2, UnitClass(uId)) == "SHAMAN" and (select(3, GetTalentTabInfo(2)) >= 50))
end

-------------------------
--  Boss Health Frame  --
-------------------------
function bossModPrototype:SetBossHealthInfo(...)
	self.bossHealthInfo = {...}
end

-----------------------
--  Utility Methods  --
-----------------------

function bossModPrototype:IsDifficulty(...)
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	for i = 1, select("#", ...) do
		if diff == select(i, ...) then
			return true
		end
	end
	return false
end

function bossModPrototype:IsLFR()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	if diff == "lfr" or diff == "lfr25" then
		return true
	end
	return false
end

--Dungeons: normal, heroic. (Raids excluded)
function bossModPrototype:IsEasyDungeon()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	if diff == "heroic5" or diff == "normal5" then
		return true
	end
	return false
end

----------------------------
--  Boss Health Function  --
----------------------------
function DBM:GetBossHP(cIdOrGUID)
	local uId = bossHealthuIdCache[cIdOrGUID] or "target"
	local guid = UnitGUID(uId)
	--Target or Cached (if already called with this cid or GUID before)
	if (self:GetCIDFromGUID(guid) == cIdOrGUID or guid == cIdOrGUID) and UnitHealthMax(uId) ~= 0 then
		if bossHealth[cIdOrGUID] and (UnitHealth(uId) == 0 and not UnitIsDead(uId)) then return bossHealth[cIdOrGUID], uId, UnitName(uId) end--Return last non 0 value if value is 0, since it's last valid value we had.
		local hp = UnitHealth(uId) / UnitHealthMax(uId) * 100
		bossHealth[cIdOrGUID] = hp
		return hp, uId, UnitName(uId)
	--Focus
	elseif (self:GetCIDFromGUID(UnitGUID("focus")) == cIdOrGUID or UnitGUID("focus") == cIdOrGUID) and UnitHealthMax("focus") ~= 0 then
		if bossHealth[cIdOrGUID] and (UnitHealth("focus") == 0  and not UnitIsDead("focus")) then return bossHealth[cIdOrGUID], "focus", UnitName("focus") end--Return last non 0 value if value is 0, since it's last valid value we had.
		local hp = UnitHealth("focus") / UnitHealthMax("focus") * 100
		bossHealth[cIdOrGUID] = hp
		return hp, "focus", UnitName("focus")
	else
		--Boss UnitIds
		for i = 1, 4 do
			local unitID = "boss"..i
			local bossguid = UnitGUID(unitID)
			if (self:GetCIDFromGUID(bossguid) == cIdOrGUID or bossguid == cIdOrGUID) and UnitHealthMax(unitID) ~= 0 then
				if bossHealth[cIdOrGUID] and (UnitHealth(unitID) == 0 and not UnitIsDead(unitID)) then return bossHealth[cIdOrGUID], unitID, UnitName(unitID) end--Return last non 0 value if value is 0, since it's last valid value we had.
				local hp = UnitHealth(unitID) / UnitHealthMax(unitID) * 100
				bossHealth[cIdOrGUID] = hp
				bossHealthuIdCache[cIdOrGUID] = unitID
				return hp, unitID, UnitName(unitID)
			end
		end
		--Scan raid/party target frames
		local idType = (GetNumRaidMembers() == 0 and "party") or "raid"
		for i = 0, mmax(GetNumRaidMembers(), GetNumPartyMembers()) do
			local unitId = ((i == 0) and "target") or idType..i.."target"
			local bossguid = UnitGUID(unitId)
			if (self:GetCIDFromGUID(bossguid) == cIdOrGUID or bossguid == cIdOrGUID) and UnitHealthMax(unitId) ~= 0 then
				if bossHealth[cIdOrGUID] and (UnitHealth(unitId) == 0 and not UnitIsDead(unitId)) then return bossHealth[cIdOrGUID], unitId, UnitName(unitId) end--Return last non 0 value if value is 0, since it's last valid value we had.
				local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
				bossHealth[cIdOrGUID] = hp
				bossHealthuIdCache[cIdOrGUID] = unitId
				return hp, unitId, UnitName(unitId)
			end
		end
	end
	return nil
end

function DBM:GetBossHPByUnitID(uId)
	if UnitHealthMax(uId) ~= 0 then
		local hp = UnitHealth(uId) / UnitHealthMax(uId) * 100
		bossHealth[uId] = hp
		return hp, uId, UnitName(uId)
	end
	return nil
end

function bossModPrototype:SetMainBossID(cid)
	self.mainBoss = cid
end

function bossModPrototype:SetBossHPInfoToHighest(numBoss)
	if numBoss ~= false then
		self.numBoss = numBoss or (self.multiMobPullDetection and #self.multiMobPullDetection)
	end
	self.highesthealth = true
end

function bossModPrototype:GetHighestBossHealth()
	local hp
	if not self.multiMobPullDetection or self.mainBoss then
		hp = bossHealth[self.mainBoss or self.combatInfo.mob or -1]
		if hp and (hp > 100 or hp <= 0) then
			hp = nil
		end
	else
		for _, mob in ipairs(self.multiMobPullDetection) do
			if (bossHealth[mob] or 0) > (hp or 0) and (bossHealth[mob] or 0) < 100 then-- ignore full health.
				hp = bossHealth[mob]
			end
		end
	end
	return hp
end

function bossModPrototype:GetLowestBossHealth()
	local hp
	if not self.multiMobPullDetection or self.mainBoss then
		hp = bossHealth[self.mainBoss or self.combatInfo.mob or -1]
		if hp and (hp > 100 or hp <= 0) then
			hp = nil
		end
	else
		for _, mob in ipairs(self.multiMobPullDetection) do
			if (bossHealth[mob] or 100) < (hp or 100) and (bossHealth[mob] or 100) > 0 then-- ignore zero health.
				hp = bossHealth[mob]
			end
		end
	end
	return hp
end

bossModPrototype.GetBossHP = DBM.GetBossHP

-----------------------
--  Announce Object  --
-----------------------
do
	local frame = CreateFrame("Frame", "DBMWarning", UIParent)
	local font1u = CreateFrame("Frame", "DBMWarning1Updater", UIParent)
	local font2u = CreateFrame("Frame", "DBMWarning2Updater", UIParent)
	local font3u = CreateFrame("Frame", "DBMWarning3Updater", UIParent)
	local font1 = frame:CreateFontString("DBMWarning1", "OVERLAY", "GameFontNormal")
	font1:SetWidth(1024)
	font1:SetHeight(0)
	font1:SetPoint("TOP", 0, 0)
	local font2 = frame:CreateFontString("DBMWarning2", "OVERLAY", "GameFontNormal")
	font2:SetWidth(1024)
	font2:SetHeight(0)
	font2:SetPoint("TOP", font1, "BOTTOM", 0, 0)
	local font3 = frame:CreateFontString("DBMWarning3", "OVERLAY", "GameFontNormal")
	font3:SetWidth(1024)
	font3:SetHeight(0)
	font3:SetPoint("TOP", font2, "BOTTOM", 0, 0)
	frame:SetMovable(1)
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 300)
	font1u:Hide()
	font2u:Hide()
	font3u:Hide()

	local font1elapsed, font2elapsed, font3elapsed

	local function fontHide1()
		local duration = DBM.Options.WarningDuration2
		if font1elapsed > duration * 1.3 then
			font1u:Hide()
			font1:Hide()
			if frame.font1ticker then
				frame.font1ticker:Cancel()
				frame.font1ticker = nil
			end
		elseif font1elapsed > duration then
			font1elapsed = font1elapsed + 0.05
			local alpha = 1 - (font1elapsed - duration) / (duration * 0.3)
			font1:SetAlpha(alpha > 0 and alpha or 0)
		else
			font1elapsed = font1elapsed + 0.05
			font1:SetAlpha(1)
		end
	end

	local function fontHide2()
		local duration = DBM.Options.WarningDuration2
		if font2elapsed > duration * 1.3 then
			font2u:Hide()
			font2:Hide()
			if frame.font2ticker then
				frame.font2ticker:Cancel()
				frame.font2ticker = nil
			end
		elseif font2elapsed > duration then
			font2elapsed = font2elapsed + 0.05
			local alpha = 1 - (font2elapsed - duration) / (duration * 0.3)
			font2:SetAlpha(alpha > 0 and alpha or 0)
		else
			font2elapsed = font2elapsed + 0.05
			font2:SetAlpha(1)
		end
	end

	local function fontHide3()
		local duration = DBM.Options.WarningDuration2
		if font3elapsed > duration * 1.3 then
			font3u:Hide()
			font3:Hide()
			if frame.font3ticker then
				frame.font3ticker:Cancel()
				frame.font3ticker = nil
			end
		elseif font3elapsed > duration then
			font3elapsed = font3elapsed + 0.05
			local alpha = 1 - (font3elapsed - duration) / (duration * 0.3)
			font3:SetAlpha(alpha > 0 and alpha or 0)
		else
			font3elapsed = font3elapsed + 0.05
			font3:SetAlpha(1)
		end
	end

	font1u:SetScript("OnUpdate", function(self)
		local diff = GetTime() - font1.lastUpdate
		local origSize = DBM.Options.WarningFontSize
		if diff > 0.4 then
			font1:SetTextHeight(origSize)
			self:Hide()
		elseif diff > 0.2 then
			font1:SetTextHeight(origSize * (1.5 - (diff-0.2) * 2.5))
		else
			font1:SetTextHeight(origSize * (1 + diff * 2.5))
		end
	end)

	font2u:SetScript("OnUpdate", function(self)
		local diff = GetTime() - font2.lastUpdate
		local origSize = DBM.Options.WarningFontSize
		if diff > 0.4 then
			font2:SetTextHeight(origSize)
			self:Hide()
		elseif diff > 0.2 then
			font2:SetTextHeight(origSize * (1.5 - (diff-0.2) * 2.5))
		else
			font2:SetTextHeight(origSize * (1 + diff * 2.5))
		end
	end)

	font3u:SetScript("OnUpdate", function(self)
		local diff = GetTime() - font3.lastUpdate
		local origSize = DBM.Options.WarningFontSize
		if diff > 0.4 then
			font3:SetTextHeight(origSize)
			self:Hide()
		elseif diff > 0.2 then
			font3:SetTextHeight(origSize * (1.5 - (diff-0.2) * 2.5))
		else
			font3:SetTextHeight(origSize * (1 + diff * 2.5))
		end
	end)

	function DBM:UpdateWarningOptions()
		frame:ClearAllPoints()
		frame:SetPoint(self.Options.WarningPoint, UIParent, self.Options.WarningPoint, self.Options.WarningX, self.Options.WarningY)
		font1:SetFont(self.Options.WarningFont, self.Options.WarningFontSize, self.Options.WarningFontStyle == "None" and nil or self.Options.WarningFontStyle)
		font2:SetFont(self.Options.WarningFont, self.Options.WarningFontSize, self.Options.WarningFontStyle == "None" and nil or self.Options.WarningFontStyle)
		font3:SetFont(self.Options.WarningFont, self.Options.WarningFontSize, self.Options.WarningFontStyle == "None" and nil or self.Options.WarningFontStyle)
		if self.Options.WarningFontShadow then
			font1:SetShadowOffset(1, -1)
			font2:SetShadowOffset(1, -1)
			font3:SetShadowOffset(1, -1)
		else
			font1:SetShadowOffset(0, 0)
			font2:SetShadowOffset(0, 0)
			font3:SetShadowOffset(0, 0)
		end
	end

	function DBM:AddWarning(text, force)
		local added = false
		if not frame.font1ticker then
			font1elapsed = 0
			font1.lastUpdate = GetTime()
			font1:SetText(text)
			font1:Show()
			font1u:Show()
			added = true
			frame.font1ticker = frame.font1ticker or C_Timer:NewTicker(0.05, fontHide1)
		elseif not frame.font2ticker then
			font2elapsed = 0
			font2.lastUpdate = GetTime()
			font2:SetText(text)
			font2:Show()
			font2u:Show()
			added = true
			frame.font2ticker = frame.font2ticker or C_Timer:NewTicker(0.05, fontHide2)
		elseif not frame.font3ticker or force then
			font3elapsed = 0
			font3.lastUpdate = GetTime()
			font3:SetText(text)
			font3:Show()
			font3u:Show()
			fontHide3()
			added = true
			frame.font3ticker = frame.font3ticker or C_Timer:NewTicker(0.05, fontHide3)
		end
		if not added then
			local prevText1 = font2:GetText()
			local prevText2 = font3:GetText()
			font1:SetText(prevText1)
			font1elapsed = font2elapsed
			font2:SetText(prevText2)
			font2elapsed = font3elapsed
			self:AddWarning(text, true)
		end
	end

	do
		local anchorFrame
		local function moveEnd(self)
			anchorFrame:Hide()
			if anchorFrame.ticker then
				anchorFrame.ticker:Cancel()
				anchorFrame.ticker = nil
			end
			font1elapsed = self.Options.WarningDuration2
			font2elapsed = self.Options.WarningDuration2
			font3elapsed = self.Options.WarningDuration2
			frame:SetFrameStrata("HIGH")
			self:Unschedule(moveEnd)
			self.Bars:CancelBar(DBM_CORE_MOVE_WARNING_BAR)
		end

		function DBM:MoveWarning()
			if not anchorFrame then
				anchorFrame = CreateFrame("Frame", nil, frame)
				anchorFrame:SetWidth(32)
				anchorFrame:SetHeight(32)
				anchorFrame:EnableMouse(true)
				anchorFrame:SetPoint("TOP", frame, "TOP", 0, 32)
				anchorFrame:RegisterForDrag("LeftButton")
				anchorFrame:SetClampedToScreen()
				anchorFrame:Hide()
				local texture = anchorFrame:CreateTexture()
				texture:SetTexture("Interface\\Addons\\DBM-GUI\\textures\\dot.blp")
				texture:SetPoint("CENTER", anchorFrame, "CENTER", 0, 0)
				texture:SetWidth(32)
				texture:SetHeight(32)
				anchorFrame:SetScript("OnDragStart", function()
					frame:StartMoving()
					self:Unschedule(moveEnd)
					self.Bars:CancelBar(DBM_CORE_MOVE_WARNING_BAR)
				end)
				anchorFrame:SetScript("OnDragStop", function()
					frame:StopMovingOrSizing()
					local point, _, _, xOfs, yOfs = frame:GetPoint(1)
					self.Options.WarningPoint = point
					self.Options.WarningX = xOfs
					self.Options.WarningY = yOfs
					self:Schedule(15, moveEnd, self)
					self.Bars:CreateBar(15, DBM_CORE_MOVE_WARNING_BAR)
				end)
			end
			if anchorFrame:IsShown() then
				moveEnd(self)
			else
				anchorFrame:Show()
				anchorFrame.ticker = anchorFrame.ticker or C_Timer:NewTicker(5, function() self:AddWarning(DBM_CORE_MOVE_WARNING_MESSAGE) end)
				self:AddWarning(DBM_CORE_MOVE_WARNING_MESSAGE)
				self:Schedule(15, moveEnd, self)
				self.Bars:CreateBar(15, DBM_CORE_MOVE_WARNING_BAR)
				frame:Show()
				frame:SetFrameStrata("TOOLTIP")
				frame:SetAlpha(1)
			end
		end
	end

	local textureCode = " |T%s:12:12|t "
	local textureExp = " |T(%S+......%S+):12:12|t "--Fix texture file including blank not strips(example: Interface\\Icons\\Spell_Frost_Ring of Frost). But this have limitations. Since I'm poor at regular expressions, this is not good fix. Do you have another good regular expression, tandanu?
	local announcePrototype = {}
	local mt = {__index = announcePrototype}

	-- TODO: is there a good reason that this is a weak table?
	local cachedColorFunctions = setmetatable({}, {__mode = "kv"})

	local function setText(announceType, spellId, castTime, preWarnTime)
		local spellName = (spellId or 0) >= 6 and DBM:GetSpellInfo(spellId) or DBM_CORE_UNKNOWN
		local text
		if announceType == "cast" then
			local spellHaste = select(7, DBM:GetSpellInfo(53142)) / 10000 -- 53142 = Dalaran Portal, should have 10000 ms cast time
			local timer = (select(7, DBM:GetSpellInfo(spellId)) or 1000) / spellHaste
			text = DBM_CORE_AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName, castTime or (timer / 1000))
		elseif announceType == "prewarn" then
			if type(preWarnTime) == "string" then
				text = DBM_CORE_AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName, preWarnTime)
			else
				text = DBM_CORE_AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName, DBM_CORE_SEC_FMT:format(tostring(preWarnTime or 5)))
			end
		elseif announceType == "stage" or announceType == "prestage" then
			text = DBM_CORE_AUTO_ANNOUNCE_TEXTS[announceType]:format(tostring(spellId))
		elseif announceType == "stagechange" then
			text = DBM_CORE_AUTO_ANNOUNCE_TEXTS.spell
		else
			text = DBM_CORE_AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName)
		end
		return text, spellName
	end

	-- TODO: this function is an abomination, it needs to be rewritten. Also: check if these work-arounds are still necessary
	function announcePrototype:Show(...) -- todo: reduce amount of unneeded strings
		if not self.option or self.mod.Options[self.option] then
			if DBM.Options.DontShowBossAnnounces then return end	-- don't show the announces if the spam filter option is set
			if DBM.Options.DontShowTargetAnnouncements and (self.announceType == "target" or self.announceType == "targetcount") and not self.noFilter then return end--don't show announces that are generic target announces
			local argTable = {...}
			local colorCode = ("|cff%.2x%.2x%.2x"):format(self.color.r * 255, self.color.g * 255, self.color.b * 255)
			if #self.combinedtext > 0 then
				--Throttle spam.
				if DBM.Options.WarningAlphabetical then
					tsort(self.combinedtext)
				end
				local combinedText = tconcat(self.combinedtext, "<, >")
				if self.combinedcount == 1 then
					combinedText = combinedText.." "..DBM_CORE_GENERIC_WARNING_OTHERS
				elseif self.combinedcount > 1 then
					combinedText = combinedText.." "..DBM_CORE_GENERIC_WARNING_OTHERS2:format(self.combinedcount)
				end
				--Process
				for i = 1, #argTable do
					if type(argTable[i]) == "string" then
						argTable[i] = combinedText
					end
				end
			end
			local message = pformat(self.text, unpack(argTable))
			local text = ("%s%s%s|r%s"):format(
				(DBM.Options.WarningIconLeft and self.icon and textureCode:format(self.icon)) or "",
				colorCode,
				message,
				(DBM.Options.WarningIconRight and self.icon and textureCode:format(self.icon)) or ""
			)
			self.combinedcount = 0
			self.combinedtext = {}
			if not cachedColorFunctions[self.color] then
				local color = self.color -- upvalue for the function to colorize names, accessing self in the colorize closure is not safe as the color of the announce object might change (it would also prevent the announce from being garbage-collected but announce objects are never destroyed)
				cachedColorFunctions[color] = function(cap)
					cap = cap:sub(2, -2)
					local noStrip = cap:match("noStrip ")
					if not noStrip then
						local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(cap)] or color
						if playerColor then
							cap = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, cap, color.r * 255, color.g * 255, color.b * 255)
						end
					else
						cap = cap:sub(9)
					end
					return cap
				end
			end
			text = text:gsub(">.-<", cachedColorFunctions[self.color])
			DBM:AddWarning(text)
			if DBM.Options.ShowWarningsInChat then
				if not DBM.Options.WarningIconChat then
					text = text:gsub(textureExp, "") -- textures @ chat frame can (and will) distort the font if using certain combinations of UI scale, resolution and font size TODO: is this still true as of cataclysm?
				end
				self.mod:AddMsg(text, nil)
			end
			if self.sound > 0 then
				if self.sound > 1 and DBM.Options.ChosenVoicePack ~= "None" and not voiceSessionDisabled and self.sound <= SWFilterDisabed then return end
				if not self.option or self.mod.Options[self.option.."SWSound"] ~= "None" then
--					DBM:PlaySoundFile(DBM.Options.RaidWarningSound, nil, true)--Validate true
					DBM:PlaySoundFile(DBM.Options.RaidWarningSound)
				end
			end
			--Message: Full message text
			--Icon: Texture path/id for icon
			--Type: Announce type
			----Types: you, target, targetsource, spell, ends, endtarget, fades, adds, count, stack, cast, soon, sooncount, prewarn, bait, stage, stagechange, prestage, moveto
			------Personal/Role (Applies to you, or your job): you, stack, bait, moveto, fades
			------General Target Messages (informative, doesn't usually apply to you): target, targetsource
			------Fight Changes (Stages, adds, boss buff/debuff, etc): stage, stagechange, prestage, adds, ends, endtarget
			------General (can really apply to anything): spell, count, soon, sooncount, prewarn
			--SpellId: Raw spell or encounter journal Id if available.
			--Mod ID: Encounter ID as string, or a generic string for mods that don't have encounter ID (such as trash, dummy/test mods)
			--boolean: Whether or not this warning is a special warning (higher priority).
			fireEvent("DBM_Announce", message, self.icon, self.type, self.spellId, self.mod.id, false)
		else
			self.combinedcount = 0
			self.combinedtext = {}
		end
	end

	function announcePrototype:CombinedShow(delay, ...)
		if self.option and not self.mod.Options[self.option] then return end
		if DBM.Options.DontShowBossAnnounces then return end	-- don't show the announces if the spam filter option is set
		if DBM.Options.DontShowTargetAnnouncements and (self.announceType == "target" or self.announceType == "targetcount") and not self.noFilter then return end--don't show announces that are generic target announces
		local argTable = {...}
		for i = 1, #argTable do
			if type(argTable[i]) == "string" then
				if #self.combinedtext < 8 then--Throttle spam. We may not need more than 9 targets..
					if not checkEntry(self.combinedtext, argTable[i]) then
						self.combinedtext[#self.combinedtext + 1] = argTable[i]
					end
				else
					self.combinedcount = self.combinedcount + 1
				end
			end
		end
		unschedule(self.Show, self.mod, self)
		schedule(delay or 0.5, self.Show, self.mod, self, ...)
	end

	function announcePrototype:Schedule(t, ...)
		return schedule(t, self.Show, self.mod, self, ...)
	end

	function announcePrototype:Countdown(time, numAnnounces, ...)
		scheduleCountdown(time, numAnnounces, self.Show, self.mod, self, ...)
	end

	function announcePrototype:Cancel(...)
		return unschedule(self.Show, self.mod, self, ...)
	end

	function announcePrototype:Play(name, customPath)
		local voice = DBM.Options.ChosenVoicePack
		if voiceSessionDisabled or voice == "None" then return end
		local always = DBM.Options.AlwaysPlayVoice
		if DBM.Options.DontShowTargetAnnouncements and (self.announceType == "target" or self.announceType == "targetcount") and not self.noFilter and not always then return end--don't show announces that are generic target announces
		if (not DBM.Options.DontShowBossAnnounces and (not self.option or self.mod.Options[self.option]) or always) and self.sound <= SWFilterDisabed then
			--Filter tank specific voice alerts for non tanks if tank filter enabled
			--But still allow AlwaysPlayVoice to play as well.
			if (name == "changemt" or name == "tauntboss") and DBM.Options.FilterTankSpec and not self.mod:IsTank() and not always then return end
			local path = customPath or "Interface\\AddOns\\DBM-VP"..voice.."\\"..name..".ogg"
			DBM:PlaySoundFile(path)
		end
	end

	function announcePrototype:ScheduleVoice(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack == "None" then return end
		unschedule(self.Play, self.mod, self)--Allow ScheduleVoice to be used in same way as CombinedShow
		return schedule(t, self.Play, self.mod, self, ...)
	end

	--Object Permits scheduling voice multiple times for same object
	function announcePrototype:ScheduleVoiceOverLap(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack == "None" then return end
		return schedule(t, self.Play, self.mod, self, ...)
	end

	function announcePrototype:CancelVoice(...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack == "None" then return end
		return unschedule(self.Play, self.mod, self, ...)
	end

	-- old constructor (no auto-localize)
	function bossModPrototype:NewAnnounce(text, color, icon, optionDefault, optionName, soundOption)
		if not text then
			error("NewAnnounce: you must provide announce text", 2)
			return
		end
		if type(optionName) == "number" then
			DBM:Debug("Non auto localized optionNames cannot be numbers, fix this for "..text)
			optionName = nil
		end
		if soundOption and type(soundOption) == "boolean" then
			soundOption = 0--No Sound
		end
		local obj = setmetatable(
			{
				text = self.localization.warnings[text],
				combinedtext = {},
				combinedcount = 0,
				color = DBM.Options.WarningColors[color or 1] or DBM.Options.WarningColors[1],
				sound = soundOption or 1,
				mod = self,
				icon = (type(icon) == "number" and ( icon <=8 and (iconFolder .. icon) or select(3, GetSpellInfo(icon)))) or icon or "Interface\\Icons\\Spell_Nature_WispSplode",
			},
			mt
		)
		if optionName then
			obj.option = optionName
			self:AddBoolOption(obj.option, optionDefault, "announce")
		elseif not (optionName == false) then
			obj.option = text
			self:AddBoolOption(obj.option, optionDefault, "announce")
		end
		tinsert(self.announces, obj)
		return obj
	end

	-- new constructor (partially auto-localized warnings and options, yay!)
	local function newAnnounce(self, announceType, spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, noFilter)
		if not spellId then
			error("newAnnounce: you must provide spellId", 2)
			return
		end
		local optionVersion, alternateSpellId
		if type(optionName) == "number" then
			if optionName > 1000 then--Being used as spell name shortening
				if DBM.Options.WarningShortText then
					alternateSpellId = optionName
				end
			else--Being used as option version
				optionVersion = optionName
			end
			optionName = nil
		end
		if soundOption and type(soundOption) == "boolean" then
			soundOption = 0--No Sound
		end
		if type(spellId) == "string" and spellId:match("OptionVersion") then
			print("newAnnounce for "..color.." is using OptionVersion hack. this is depricated")
			return
		end
		local text, spellName = setText(announceType, alternateSpellId or spellId, castTime, preWarnTime)
		icon = icon or spellId
		local obj = setmetatable( -- todo: fix duplicate code
			{
				text = text,
				combinedtext = {},
				combinedcount = 0,
				announceType = announceType,
				color = DBM.Options.WarningColors[color or 1] or DBM.Options.WarningColors[1],
				mod = self,
				icon = (type(icon) == "number" and (icon <=8 and (iconFolder .. icon) or select(3, GetSpellInfo(icon)))) or icon or "Interface\\Icons\\Spell_Nature_WispSplode",
				sound = soundOption or 1,
				type = announceType,
				spellId = spellId,
				spellName = spellName,
				noFilter = noFilter,
				castTime = castTime,
				preWarnTime = preWarnTime,
			},
			mt
		)
		local catType = "announce"--Default to General announce
		--Change if Personal or Other
		if announceType == "target" or announceType == "targetcount" or announceType == "stack" then
			catType = "announceother"
		end
		if optionName then
			obj.option = optionName
			self:AddBoolOption(obj.option, optionDefault, catType)
		elseif not (optionName == false) then
			obj.option = catType..spellId..announceType..(optionVersion or "")
			self:AddBoolOption(obj.option, optionDefault, catType)
			self.localization.options[obj.option] = DBM_CORE_AUTO_ANNOUNCE_OPTIONS[announceType]:format(spellId)
		end
		tinsert(self.announces, obj)
		return obj
	end

	function bossModPrototype:NewYouAnnounce(spellId, color, ...)
		return newAnnounce(self, "you", spellId, color or 1, ...)
	end

	function bossModPrototype:NewTargetNoFilterAnnounce(spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, noFilter)
		return newAnnounce(self, "target", spellId, color or 3, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, true)
	end

	function bossModPrototype:NewTargetAnnounce(spellId, color, ...)
		return newAnnounce(self, "target", spellId, color or 3, ...)
	end

	function bossModPrototype:NewTargetSourceAnnounce(spellId, color, ...)
		return newAnnounce(self, "targetsource", spellId, color or 3, ...)
	end

	function bossModPrototype:NewTargetCountAnnounce(spellId, color, ...)
		return newAnnounce(self, "targetcount", spellId, color or 3, ...)
	end

	function bossModPrototype:NewSpellAnnounce(spellId, color, ...)
		return newAnnounce(self, "spell", spellId, color or 2, ...)
	end

	function bossModPrototype:NewEndAnnounce(spellId, color, ...)
		return newAnnounce(self, "ends", spellId, color or 2, ...)
	end

	function bossModPrototype:NewEndTargetAnnounce(spellId, color, ...)
		return newAnnounce(self, "endtarget", spellId, color or 2, ...)
	end

	function bossModPrototype:NewFadesAnnounce(spellId, color, ...)
		return newAnnounce(self, "fades", spellId, color or 2, ...)
	end

	function bossModPrototype:NewAddsLeftAnnounce(spellId, color, ...)
		return newAnnounce(self, "adds", spellId, color or 3, ...)
	end

	function bossModPrototype:NewCountAnnounce(spellId, color, ...)
		return newAnnounce(self, "count", spellId, color or 2, ...)
	end

	function bossModPrototype:NewStackAnnounce(spellId, color, ...)
		return newAnnounce(self, "stack", spellId, color or 2, ...)
	end

	function bossModPrototype:NewCastAnnounce(spellId, color, castTime, icon, optionDefault, optionName, noArg, soundOption)
		return newAnnounce(self, "cast", spellId, color or 3, icon, optionDefault, optionName, castTime, nil, soundOption)
	end

	function bossModPrototype:NewSoonAnnounce(spellId, color, ...)
		return newAnnounce(self, "soon", spellId, color or 2, ...)
	end

	function bossModPrototype:NewSoonCountAnnounce(spellId, color, ...)
		return newAnnounce(self, "sooncount", spellId, color or 2, ...)
	end

	--This object disables sounds, it's almost always used in combation with a countdown timer. Even if not a countdown, its a text only spam not a sound spam
	function bossModPrototype:NewCountdownAnnounce(spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, noFilter)
		return newAnnounce(self, "countdown", spellId, color or 4, icon, optionDefault, optionName, castTime, preWarnTime, 0, noFilter)
	end

	function bossModPrototype:NewPreWarnAnnounce(spellId, time, color, icon, optionDefault, optionName, noArg, soundOption)
		return newAnnounce(self, "prewarn", spellId, color or 2, icon, optionDefault, optionName, nil, time, soundOption)
	end

	function bossModPrototype:NewBaitAnnounce(spellId, color, ...)
		return newAnnounce(self, "bait", spellId, color or 3, ...)
	end

	function bossModPrototype:NewPhaseAnnounce(stage, color, icon, ...)
		return newAnnounce(self, "stage", stage, color or 2, icon or "136116", ...)
	end

	function bossModPrototype:NewPhaseChangeAnnounce(color, icon, ...)
		return newAnnounce(self, "stagechange", 0, color or 2, icon or "136116", ...)
	end

	function bossModPrototype:NewPrePhaseAnnounce(stage, color, icon, ...)
		return newAnnounce(self, "prestage", stage, color or 2, icon or "136116", ...)
	end

	function bossModPrototype:NewMoveToAnnounce(spellId, color, ...)
		return newAnnounce(self, "moveto", spellId, color or 3, ...)
	end
end

--------------------
--  Yell Object  --
--------------------
do
	local voidForm = GetSpellInfo(194249)
	local yellPrototype = {}
	local mt = { __index = yellPrototype }
	local function newYell(self, yellType, spellId, yellText, optionDefault, optionName, chatType)
		if not spellId and not yellText then
			error("NewYell: you must provide either spellId or yellText", 2)
			return
		end
		if type(spellId) == "string" and spellId:match("OptionVersion") then
			print("newYell for: "..yellText.." is using OptionVersion hack. This is depricated")
			return
		end
		local optionVersion
		if type(optionName) == "number" then
			optionVersion = optionName
			optionName = nil
		end
		local displayText
		if not yellText then
			displayText = DBM_CORE_AUTO_YELL_ANNOUNCE_TEXT[yellType]:format(DBM:GetSpellInfo(spellId) or DBM_CORE_UNKNOWN)
		end
		--Passed spellid as yellText.
		--Auto localize spelltext using yellText instead
		if yellText and type(yellText) == "number" then
			displayText = DBM_CORE_AUTO_YELL_ANNOUNCE_TEXT[yellType]:format(DBM:GetSpellInfo(yellText) or DBM_CORE_UNKNOWN)
		end
		local obj = setmetatable(
			{
				text = displayText or yellText,
				mod = self,
				chatType = chatType,
				yellType = yellType
			},
			mt
		)
		if optionName then
			obj.option = optionName
			self:AddBoolOption(obj.option, optionDefault, "yell")
		elseif not (optionName == false) then
			obj.option = "Yell"..(spellId or yellText)..(yellType ~= "yell" and yellType or "")..(optionVersion or "")
			self:AddBoolOption(obj.option, optionDefault, "yell")
			self.localization.options[obj.option] = DBM_CORE_AUTO_YELL_OPTION_TEXT[yellType]:format(spellId)
		end
		return obj
	end

	function yellPrototype:Yell(...)
		if not IsInInstance() then--as of 8.2.5, forbidden in outdoor world
			DBM:Debug("WARNING: A mod is still trying to call chat SAY/YELL messages outdoors, FIXME")
			return
		end
		if DBM.Options.DontSendYells or self.yellType and self.yellType == "position" and DBM:UnitBuff("player", voidForm) and DBM.Options.FilterVoidFormSay then return end
		if not self.option or self.mod.Options[self.option] then
			if self.yellType == "combo" then
				SendChatMessage(pformat(self.text, ...), self.chatType or "YELL")
			else
				SendChatMessage(pformat(self.text, ...), self.chatType or "SAY")
			end
		end
	end
	yellPrototype.Show = yellPrototype.Yell

	--Force override to use say message, even when object defines "YELL"
	function yellPrototype:Say(...)
		if not IsInInstance() then--as of 8.2.5, forbidden in outdoor world
			DBM:Debug("WARNING: A mod is still trying to call chat SAY/YELL messages outdoors, FIXME")
			return
		end
		if DBM.Options.DontSendYells or self.yellType and self.yellType == "position" and DBM:UnitBuff("player", voidForm) and DBM.Options.FilterVoidFormSay then return end
		if not self.option or self.mod.Options[self.option] then
			SendChatMessage(pformat(self.text, ...), "SAY")
		end
	end

	function yellPrototype:Schedule(t, ...)
		return schedule(t, self.Yell, self.mod, self, ...)
	end

	function yellPrototype:Countdown(time, numAnnounces, ...)
		if time > 60 then--It's a spellID not a time
			local _, _, _, _, _, _, expireTime = DBM:UnitDebuff("player", time)
			if expireTime then
				local remaining = expireTime-GetTime()
				scheduleCountdown(remaining, numAnnounces, self.Yell, self.mod, self, ...)
			end
		else
			scheduleCountdown(time, numAnnounces, self.Yell, self.mod, self, ...)
		end
	end

	function yellPrototype:Cancel(...)
		return unschedule(self.Yell, self.mod, self, ...)
	end

	function bossModPrototype:NewYell(...)
		return newYell(self, "yell", ...)
	end

	function bossModPrototype:NewShortYell(...)
		return newYell(self, "shortyell", ...)
	end

	function bossModPrototype:NewCountYell(...)
		return newYell(self, "count", ...)
	end

	function bossModPrototype:NewFadesYell(...)
		return newYell(self, "fade", ...)
	end

	function bossModPrototype:NewShortFadesYell(...)
		return newYell(self, "shortfade", ...)
	end

	function bossModPrototype:NewIconFadesYell(...)
		return newYell(self, "iconfade", ...)
	end

	function bossModPrototype:NewPosYell(...)
		return newYell(self, "position", ...)
	end

	function bossModPrototype:NewComboYell(...)
		return newYell(self, "combo", ...)
	end
end

------------------------------
--  Special Warning Object  --
------------------------------
do
	local frame = CreateFrame("Frame", "DBMSpecialWarning", UIParent)
	local font1 = frame:CreateFontString("DBMSpecialWarning1", "OVERLAY", "ZoneTextFont")
	font1:SetWidth(1024)
	font1:SetHeight(0)
	font1:SetPoint("TOP", 0, 0)
	local font2 = frame:CreateFontString("DBMSpecialWarning2", "OVERLAY", "ZoneTextFont")
	font2:SetWidth(1024)
	font2:SetHeight(0)
	font2:SetPoint("TOP", font1, "BOTTOM", 0, 0)
	frame:SetMovable(1)
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	local font1elapsed, font2elapsed, moving

	local function fontHide1()
		local duration = DBM.Options.SpecialWarningDuration2
		if font1elapsed > duration * 1.3 then
			font1:Hide()
			if frame.font1ticker then
				frame.font1ticker:Cancel()
				frame.font1ticker = nil
			end
		elseif font1elapsed > duration then
			font1elapsed = font1elapsed + 0.05
			local alpha = 1 - (font1elapsed - duration) / (duration * 0.3)
			font1:SetAlpha(alpha > 0 and alpha or 0)
		else
			font1elapsed = font1elapsed + 0.05
			font1:SetAlpha(1)
		end
	end

	local function fontHide2()
		local duration = DBM.Options.SpecialWarningDuration2
		if font2elapsed > duration * 1.3 then
			font2:Hide()
			if frame.font2ticker then
				frame.font2ticker:Cancel()
				frame.font2ticker = nil
			end
		elseif font2elapsed > duration then
			font2elapsed = font2elapsed + 0.05
			local alpha = 1 - (font2elapsed - duration) / (duration * 0.3)
			font2:SetAlpha(alpha > 0 and alpha or 0)
		else
			font2elapsed = font2elapsed + 0.05
			font2:SetAlpha(1)
		end
	end

	function DBM:UpdateSpecialWarningOptions()
		frame:ClearAllPoints()
		frame:SetPoint(self.Options.SpecialWarningPoint, UIParent, self.Options.SpecialWarningPoint, self.Options.SpecialWarningX, self.Options.SpecialWarningY)
		font1:SetFont(self.Options.SpecialWarningFont, self.Options.SpecialWarningFontSize2, self.Options.SpecialWarningFontStyle == "None" and nil or self.Options.SpecialWarningFontStyle)
		font2:SetFont(self.Options.SpecialWarningFont, self.Options.SpecialWarningFontSize2, self.Options.SpecialWarningFontStyle == "None" and nil or self.Options.SpecialWarningFontStyle)
		font1:SetTextColor(unpack(self.Options.SpecialWarningFontCol))
		font2:SetTextColor(unpack(self.Options.SpecialWarningFontCol))
		if self.Options.SpecialWarningFontShadow then
			font1:SetShadowOffset(1, -1)
			font2:SetShadowOffset(1, -1)
		else
			font1:SetShadowOffset(0, 0)
			font2:SetShadowOffset(0, 0)
		end
	end

	function DBM:AddSpecialWarning(text, force)
		local added = false
		if not frame.font1ticker then
			font1elapsed = 0
			font1.lastUpdate = GetTime()
			font1:SetText(text)
			font1:Show()
			added = true
			frame.font1ticker = frame.font1ticker or C_Timer:NewTicker(0.05, fontHide1)
		elseif not frame.font2ticker or force then
			font2elapsed = 0
			font2.lastUpdate = GetTime()
			font2:SetText(text)
			font2:Show()
			added = true
			frame.font2ticker = frame.font2ticker or C_Timer:NewTicker(0.05, fontHide2)
		end
		if not added then
			local prevText1 = font2:GetText()
			font1:SetText(prevText1)
			font1elapsed = font2elapsed
			self:AddSpecialWarning(text, true)
		end
	end

	do
		local anchorFrame
		local function moveEnd(self)
			moving = false
			anchorFrame:Hide()
			font1elapsed = self.Options.SpecialWarningDuration2
			font2elapsed = self.Options.SpecialWarningDuration2
			frame:SetFrameStrata("HIGH")
			self:Unschedule(moveEnd)
			self.Bars:CancelBar(DBM_CORE_MOVE_SPECIAL_WARNING_BAR)
		end

		function DBM:MoveSpecialWarning()
			if not anchorFrame then
				anchorFrame = CreateFrame("Frame", nil, frame)
				anchorFrame:SetWidth(32)
				anchorFrame:SetHeight(32)
				anchorFrame:EnableMouse(true)
				anchorFrame:SetPoint("TOP", frame, "TOP", 0, 32)
				anchorFrame:RegisterForDrag("LeftButton")
				anchorFrame:SetClampedToScreen()
				anchorFrame:Hide()
				local texture = anchorFrame:CreateTexture()
				texture:SetTexture("Interface\\Addons\\DBM-GUI\\textures\\dot.blp")
				texture:SetPoint("CENTER", anchorFrame, "CENTER", 0, 0)
				texture:SetWidth(32)
				texture:SetHeight(32)
				anchorFrame:SetScript("OnDragStart", function()
					frame:StartMoving()
					self:Unschedule(moveEnd)
					self.Bars:CancelBar(DBM_CORE_MOVE_SPECIAL_WARNING_BAR)
				end)
				anchorFrame:SetScript("OnDragStop", function()
					frame:StopMovingOrSizing()
					local point, _, _, xOfs, yOfs = frame:GetPoint(1)
					self.Options.SpecialWarningPoint = point
					self.Options.SpecialWarningX = xOfs
					self.Options.SpecialWarningY = yOfs
					self:Schedule(15, moveEnd, self)
					self.Bars:CreateBar(15, DBM_CORE_MOVE_SPECIAL_WARNING_BAR)
				end)
			end
			if anchorFrame:IsShown() then
				moveEnd(self)
			else
				moving = true
				anchorFrame:Show()
				DBM:AddSpecialWarning(DBM_CORE_MOVE_SPECIAL_WARNING_TEXT)
				DBM:AddSpecialWarning(DBM_CORE_MOVE_SPECIAL_WARNING_TEXT)
				self:Schedule(15, moveEnd, self)
				self.Bars:CreateBar(15, DBM_CORE_MOVE_SPECIAL_WARNING_BAR)
				frame:Show()
				frame:SetFrameStrata("TOOLTIP")
				frame:SetAlpha(1)
			end
		end
	end

	local specialWarningPrototype = {}
	local mt = {__index = specialWarningPrototype}

	local function classColoringFunction(cap)
		cap = cap:sub(2, -2)
		local noStrip = cap:match("noStrip ")
		if not noStrip then
			if DBM.Options.SWarnClassColor then
				local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(cap)]
				if playerColor then
					cap = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, cap, DBM.Options.SpecialWarningFontCol[1] * 255, DBM.Options.SpecialWarningFontCol[2] * 255, DBM.Options.SpecialWarningFontCol[3] * 255)
				end
			end
		else
			cap = cap:sub(9)
		end
		return cap
	end

	local textureCode = " |T%s:12:12|t "

	local function setText(announceType, spellId, stacks)
		local spellName = (spellId or 0) >= 2 and DBM:GetSpellInfo(spellId) or DBM_CORE_UNKNOWN
		local text
		if announceType == "prewarn" then
			if type(stacks) == "string" then
				text = DBM_CORE_AUTO_SPEC_WARN_TEXTS[announceType]:format(spellName, stacks)
			else
				text = DBM_CORE_AUTO_SPEC_WARN_TEXTS[announceType]:format(spellName, DBM_CORE_SEC_FMT:format(tostring(stacks or 5)))
			end
		else
			text = DBM_CORE_AUTO_SPEC_WARN_TEXTS[announceType]:format(spellName)
		end
		return text, spellName
	end

	function specialWarningPrototype:Show(...)
		if not DBM.Options.DontShowSpecialWarnings and not DBM.Options.DontShowSpecialWarningText and (not self.option or self.mod.Options[self.option]) and not moving and frame then
			if self.mod:IsEasyDungeon() and self.mod.isTrashMod and DBM.Options.FilterTrashWarnings2 then return end
			if self.announceType == "taunt" and DBM.Options.FilterTankSpec and not self.mod:IsTank() then return end--Don't tell non tanks to taunt, ever.
			local argTable = {...}
			-- add a default parameter for move away warnings
			if self.announceType == "gtfo" then
				if DBM:UnitBuff("player", 27827) then return end--Don't tell a priest in spirit of redemption form to GTFO, they can't, and they don't take damage from it anyhow
				if #argTable == 0 then
					argTable[1] = DBM_CORE_BAD
				end
			end
			if #self.combinedtext > 0 then
				--Throttle spam.
				if DBM.Options.SWarningAlphabetical then
					tsort(self.combinedtext)
				end
				local combinedText = tconcat(self.combinedtext, "<, >")
				if self.combinedcount == 1 then
					combinedText = combinedText.." "..DBM_CORE_GENERIC_WARNING_OTHERS
				elseif self.combinedcount > 1 then
					combinedText = combinedText.." "..DBM_CORE_GENERIC_WARNING_OTHERS2:format(self.combinedcount)
				end
				--Process
				for i = 1, #argTable do
					if type(argTable[i]) == "string" then
						argTable[i] = combinedText
					end
				end
			end
			local message = pformat(self.text, unpack(argTable))
			local text = ("%s%s%s"):format(
				(DBM.Options.SpecialWarningIcon and self.icon and textureCode:format(self.icon)) or "",
				message,
				(DBM.Options.SpecialWarningIcon and self.icon and textureCode:format(self.icon)) or ""
			)
			local noteHasName = false
			if self.option then
				local noteText = self.mod.Options[self.option .. "SWNote"]
				if noteText and type(noteText) == "string" and noteText ~= "" then--Filter false bool and empty strings
					local count1 = self.announceType == "count" or self.announceType == "switchcount" or self.announceType == "targetcount"
					local count2 = self.announceType == "interruptcount"
					if count1 or count2 then--Counts support different note for EACH count
						local noteCount
						local notesTable = {string.split("/", noteText)}
						if count1 then
							noteCount = argTable[1]--Count should be first arg in table
						elseif count2 then
							noteCount = argTable[2]--Count should be second arg in table
						end
						if type(noteCount) == "string" then
							--Probably a hypehnated double count like inferno slice or marked for death
							local mainCount = string.split("-", noteCount)
							noteCount = tonumber(mainCount)
						end
						noteText = notesTable[noteCount]
						if noteText and type(noteText) == "string" and noteText ~= "" then--Refilter after string split to make sure a note for this count exists
							local hasPlayerName = noteText:find(playerName)
							if DBM.Options.SWarnNameInNote and hasPlayerName then
								noteHasName = 5
							end
							--Terminate special warning, it's an interrupt count warning without player name and filter enabled
							if count2 and DBM.Options.FilterInterruptNoteName and not hasPlayerName then return end
							noteText = " ("..noteText..")"
							text = text..noteText
						end
					else--Non count warnings will have one note, period
						if DBM.Options.SWarnNameInNote and noteText:find(playerName) then
							noteHasName = 5
						end
						if self.announceType and self.announceType:find("switch") then
							noteText = noteText:gsub(">.-<", classColoringFunction)--Class color note text before combining with warning text.
						end
						noteText = " ("..noteText..")"
						text = text..noteText
					end
				end
			end
			--No stripping on switch warnings, ever. They will NEVER have player name, but often have adds with "-" in name
			if self.announceType and not self.announceType:find("switch") then
				text = text:gsub(">.-<", classColoringFunction)
			end
			DBM:AddSpecialWarning(text)
			self.combinedcount = 0
			self.combinedtext = {}
			if DBM.Options.ShowSWarningsInChat then
				local colorCode = ("|cff%.2x%.2x%.2x"):format(DBM.Options.SpecialWarningFontCol[1] * 255, DBM.Options.SpecialWarningFontCol[2] * 255, DBM.Options.SpecialWarningFontCol[3] * 255)
				self.mod:AddMsg(colorCode.."["..DBM_CORE_MOVE_SPECIAL_WARNING_TEXT.."] "..text.."|r", nil)
			end
			if not UnitIsDeadOrGhost("player") then
				if noteHasName then
					if DBM.Options.SpecialWarningFlash5 then--Not included in above if statement on purpose. we don't want to trigger else rule if noteHasName is true but SpecialWarningFlash5 is false
						local repeatCount = DBM.Options.SpecialWarningFlashCount5 or 1
						DBM.Flash:Show(DBM.Options.SpecialWarningFlashCol5[1],DBM.Options.SpecialWarningFlashCol5[2], DBM.Options.SpecialWarningFlashCol5[3], DBM.Options.SpecialWarningFlashDura5, DBM.Options.SpecialWarningFlashAlph5, repeatCount-1)
					end
				else
					local number = self.flash
					if DBM.Options["SpecialWarningFlash"..number] then
						local repeatCount = DBM.Options["SpecialWarningFlashCount"..number] or 1
						local flashcolor = DBM.Options["SpecialWarningFlashCol"..number]
						DBM.Flash:Show(flashcolor[1], flashcolor[2], flashcolor[3], DBM.Options["SpecialWarningFlashDura"..number], DBM.Options["SpecialWarningFlashAlph"..number], repeatCount-1)
					end
				end
			end
			--Text: Full message text
			--Icon: Texture path/id for icon
			--Type: Announce type
			----Types: spell, ends, fades, soon, bait, dispel, interrupt, interruptcount, you, youcount, youpos, soakpos, target, targetcount, defensive, taunt, close, move, keepmove, stopmove,
			----gtfo, dodge, dodgecount, dodgeloc, moveaway, moveawaycount, moveto, soak, jump, run, cast, lookaway, reflect, count, sooncount, stack, switch, switchcount, adds, addscustom, targetchange, prewarn
			------General Target Messages (but since it's a special warning, it applies to you in some way): target, targetcount
			------Fight Changes (Stages, adds, boss buff/debuff, etc): adds, addscustom, targetchange, switch, switchcount, ends
			------General (can really apply to anything): spell, count, soon, sooncount, prewarn
			------Personal/Role (Applies to you, or your job): Everything Else
			--SpellId: Raw spell or encounter journal Id if available.
			--Mod ID: Encounter ID as string, or a generic string for mods that don't have encounter ID (such as trash, dummy/test mods)
			--boolean: Whether or not this warning is a special warning (higher priority).
			fireEvent("DBM_Announce", text, self.icon, self.type, self.spellId, self.mod.id, true)
			if self.sound then
				local soundId = self.option and self.mod.Options[self.option .. "SWSound"] or self.flash
				if noteHasName and type(soundId) == "number" then soundId = noteHasName end--Change number to 5 if it's not a custom sound, else, do nothing with it
				if self.hasVoice and DBM.Options.ChosenVoicePack ~= "None" and not voiceSessionDisabled and self.hasVoice <= SWFilterDisabed and (type(soundId) == "number" and soundId < 5 and DBM.Options.VoiceOverSpecW2 == "DefaultOnly" or DBM.Options.VoiceOverSpecW2 == "All") then return end
				if not self.option or self.mod.Options[self.option.."SWSound"] ~= "None" then
					DBM:PlaySpecialWarningSound(soundId or 1)
				end
			end
		else
			self.combinedcount = 0
			self.combinedtext = {}
		end
	end

	function specialWarningPrototype:CombinedShow(delay, ...)
		if DBM.Options.DontShowSpecialWarnings or DBM.Options.DontShowSpecialWarningText then return end
		if self.option and not self.mod.Options[self.option] then return end
		if self.mod:IsEasyDungeon() and self.mod.isTrashMod and DBM.Options.FilterTrashWarnings2 then return end
		local argTable = {...}
		for i = 1, #argTable do
			if type(argTable[i]) == "string" then
				if #self.combinedtext < 8 then--Throttle spam. We may not need more than 9 targets..
					if not checkEntry(self.combinedtext, argTable[i]) then
						self.combinedtext[#self.combinedtext + 1] = argTable[i]
					end
				else
					self.combinedcount = self.combinedcount + 1
				end
			end
		end
		unschedule(self.Show, self.mod, self)
		schedule(delay or 0.5, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:DelayedShow(delay, ...)
		unschedule(self.Show, self.mod, self, ...)
		schedule(delay or 0.5, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Schedule(t, ...)
		return schedule(t, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Countdown(time, numAnnounces, ...)
		scheduleCountdown(time, numAnnounces, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Cancel(t, ...)
		return unschedule(self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Play(name, customPath)
		local always = DBM.Options.AlwaysPlayVoice
		local voice = DBM.Options.ChosenVoicePack
		if voiceSessionDisabled or voice == "None" then return end
		if self.mod:IsEasyDungeon() and self.mod.isTrashMod and DBM.Options.FilterTrashWarnings2 then return end
		if (not DBM.Options.DontShowSpecialWarnings and (not self.option or self.mod.Options[self.option]) or always) and self.hasVoice <= SWFilterDisabed then
			--Filter tank specific voice alerts for non tanks if tank filter enabled
			--But still allow AlwaysPlayVoice to play as well.
			if (name == "changemt" or name == "tauntboss") and DBM.Options.FilterTankSpec and not self.mod:IsTank() and not always then return end
			local path = customPath or "Interface\\AddOns\\DBM-VP"..voice.."\\"..name..".ogg"
			DBM:PlaySoundFile(path)
		end
	end

	function specialWarningPrototype:ScheduleVoice(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack == "None" then return end
		unschedule(self.Play, self.mod, self)--Allow ScheduleVoice to be used in same way as CombinedShow
		return schedule(t, self.Play, self.mod, self, ...)
	end

	--Object Permits scheduling voice multiple times for same object
	function specialWarningPrototype:ScheduleVoiceOverLap(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack == "None" then return end
		return schedule(t, self.Play, self.mod, self, ...)
	end

	function specialWarningPrototype:CancelVoice(...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack == "None" then return end
		return unschedule(self.Play, self.mod, self, ...)
	end

	function bossModPrototype:NewSpecialWarning(text, optionDefault, optionName, optionVersion, runSound, hasVoice, difficulty)
		if not text then
			error("NewSpecialWarning: you must provide special warning text", 2)
			return
		end
		if type(text) == "string" and text:match("OptionVersion") then
			print("NewSpecialWarning: you must provide remove optionversion hack for "..optionDefault)
			return
		end
		if runSound == true then
			runSound = 2
		elseif not runSound then
			runSound = 1
		end
		if hasVoice == true then--if not a number, set it to 2, old mods that don't use new numbered system
			hasVoice = 2
		end
		local obj = setmetatable(
			{
				text = self.localization.warnings[text],
				combinedtext = {},
				combinedcount = 0,
				mod = self,
				sound = runSound > 0,
				flash = runSound,--Set flash color to hard coded runsound (even if user sets custom sounds)
				hasVoice = hasVoice,
				difficulty = difficulty,
			},
			mt
		)
		local optionId = optionName or optionName ~= false and text
		if optionId then
			obj.voiceOptionId = hasVoice and "Voice"..optionId or nil
			obj.option = optionId..(optionVersion or "")
			self:AddSpecialWarningOption(optionId, optionDefault, runSound, "announce")
		end
		tinsert(self.specwarns, obj)
		return obj
	end

	local function newSpecialWarning(self, announceType, spellId, stacks, optionDefault, optionName, optionVersion, runSound, hasVoice, difficulty)
		if not spellId then
			error("newSpecialWarning: you must provide spellId", 2)
			return
		end
		if runSound == true then
			runSound = 2
		elseif not runSound then
			runSound = 1
		end
		if hasVoice == true then--if not a number, set it to 2, old mods that don't use new numbered system
			hasVoice = 2
		end
		local alternateSpellId
		if type(optionName) == "number" then
			if DBM.Options.SpecialWarningShortText then
				alternateSpellId = optionName
			end
			optionName = nil
		end
		local text, spellName = setText(announceType, alternateSpellId or spellId, stacks)
		local obj = setmetatable( -- todo: fix duplicate code
			{
				text = text,
				combinedtext = {},
				combinedcount = 0,
				announceType = announceType,
				mod = self,
				sound = runSound>0,
				flash = runSound,--Set flash color to hard coded runsound (even if user sets custom sounds)
				hasVoice = hasVoice,
				difficulty = difficulty,
				type = announceType,
				spellId = spellId,
				spellName = spellName,
				stacks = stacks,
				icon = select(3, GetSpellInfo(spellId))
			},
			mt
		)
		if optionName then
			obj.option = optionName
		elseif not (optionName == false) then
			local difficultyIcon = ""
			if difficulty then
				--1 LFR, 2 Normal, 3 Heroic, 4 Mythic
				--Likely 1 and 2 will never be used, but being prototyped just in case
				if difficulty == 3 then
					difficultyIcon = "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:18:18:0:0:255:66:102:118:7:27|t"
				elseif difficulty == 4 then
					difficultyIcon = "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:18:18:0:0:255:66:133:153:40:58|t"
				end
			end
			obj.option = "SpecWarn"..spellId..announceType..(optionVersion or "")
			if announceType == "stack" then
				self.localization.options[obj.option] = difficultyIcon..DBM_CORE_AUTO_SPEC_WARN_OPTIONS[announceType]:format(stacks or 3, spellId)
			elseif announceType == "prewarn" then
				self.localization.options[obj.option] = difficultyIcon..DBM_CORE_AUTO_SPEC_WARN_OPTIONS[announceType]:format(tostring(stacks or 5), spellId)
			else
				self.localization.options[obj.option] = difficultyIcon..DBM_CORE_AUTO_SPEC_WARN_OPTIONS[announceType]:format(spellId)
			end
		end
		if obj.option then
			local catType = "announce"--Default to General announce
			--Directly affects another target (boss or player) that you need to know about
			if announceType == "target" or announceType == "targetcount" or announceType == "close" or announceType == "reflect" then
				catType = "announceother"
			--Directly affects you
			elseif announceType == "you" or announceType == "youcount" or announceType == "youpos" or announceType == "move" or announceType == "dodge" or announceType == "dodgecount" or announceType == "moveaway" or announceType == "moveawaycount" or announceType == "keepmove" or announceType == "stopmove" or announceType == "run" or announceType == "stack" or announceType == "moveto" or announceType == "soak" or announceType == "soakpos" then
				catType = "announcepersonal"
			--Things you have to do to fulfil your role
			elseif announceType == "taunt" or announceType == "dispel" or announceType == "interrupt" or announceType == "interruptcount" or announceType == "switch" or announceType == "switchcount" then
				catType = "announcerole"
			end
			self:AddSpecialWarningOption(obj.option, optionDefault, runSound, catType)
		end
		obj.voiceOptionId = hasVoice and "Voice"..spellId or nil
		tinsert(self.specwarns, obj)
		return obj
	end

	function bossModPrototype:NewSpecialWarningSpell(text, optionDefault, ...)
		return newSpecialWarning(self, "spell", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningEnd(text, optionDefault, ...)
		return newSpecialWarning(self, "ends", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningFades(text, optionDefault, ...)
		return newSpecialWarning(self, "fades", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoon(text, optionDefault, ...)
		return newSpecialWarning(self, "soon", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningBait(text, optionDefault, ...)
		return newSpecialWarning(self, "bait", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDispel(text, optionDefault, ...)
		return newSpecialWarning(self, "dispel", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningInterrupt(text, optionDefault, ...)
		return newSpecialWarning(self, "interrupt", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningInterruptCount(text, optionDefault, ...)
		return newSpecialWarning(self, "interruptcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningYou(text, optionDefault, ...)
		return newSpecialWarning(self, "you", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningYouCount(text, optionDefault, ...)
		return newSpecialWarning(self, "youcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningYouPos(text, optionDefault, ...)
		return newSpecialWarning(self, "youpos", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoakPos(text, optionDefault, ...)
		return newSpecialWarning(self, "soakpos", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTarget(text, optionDefault, ...)
		return newSpecialWarning(self, "target", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTargetCount(text, optionDefault, ...)
		return newSpecialWarning(self, "targetcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDefensive(text, optionDefault, ...)
		return newSpecialWarning(self, "defensive", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTaunt(text, optionDefault, ...)
		return newSpecialWarning(self, "taunt", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningClose(text, optionDefault, ...)
		return newSpecialWarning(self, "close", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMove(text, optionDefault, ...)
		return newSpecialWarning(self, "move", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningKeepMove(text, optionDefault, ...)
		return newSpecialWarning(self, "keepmove", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningStopMove(text, optionDefault, ...)
		return newSpecialWarning(self, "stopmove", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningGTFO(text, optionDefault, ...)
		return newSpecialWarning(self, "gtfo", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDodge(text, optionDefault, ...)
		return newSpecialWarning(self, "dodge", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDodgeCount(text, optionDefault, ...)
		return newSpecialWarning(self, "dodgecount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDodgeLoc(text, optionDefault, ...)
		return newSpecialWarning(self, "dodgeloc", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMoveAway(text, optionDefault, ...)
		return newSpecialWarning(self, "moveaway", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMoveAwayCount(text, optionDefault, ...)
		return newSpecialWarning(self, "moveawaycount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMoveTo(text, optionDefault, ...)
		return newSpecialWarning(self, "moveto", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoak(text, optionDefault, ...)
		return newSpecialWarning(self, "soak", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningJump(text, optionDefault, ...)
		return newSpecialWarning(self, "jump", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningRun(text, optionDefault, optionName, optionVersion, runSound, ...)
		return newSpecialWarning(self, "run", text, nil, optionDefault, optionName, optionVersion, runSound or 4, ...)
	end

	function bossModPrototype:NewSpecialWarningCast(text, optionDefault, ...)
		return newSpecialWarning(self, "cast", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningLookAway(text, optionDefault, ...)
		return newSpecialWarning(self, "lookaway", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningReflect(text, optionDefault, ...)
		return newSpecialWarning(self, "reflect", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningCount(text, optionDefault, ...)
		return newSpecialWarning(self, "count", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoonCount(text, optionDefault, ...)
		return newSpecialWarning(self, "sooncount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningStack(text, optionDefault, stacks, ...)
		return newSpecialWarning(self, "stack", text, stacks, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSwitch(text, optionDefault, ...)
		return newSpecialWarning(self, "switch", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSwitchCount(text, optionDefault, ...)
		return newSpecialWarning(self, "switchcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningAdds(text, optionDefault, ...)
		return newSpecialWarning(self, "adds", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningAddsCustom(text, optionDefault, ...)
		return newSpecialWarning(self, "addscustom", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTargetChange(text, optionDefault, ...)
		return newSpecialWarning(self, "targetchange", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningPreWarn(text, optionDefault, time, ...)
		return newSpecialWarning(self, "prewarn", text, time, optionDefault, ...)
	end

	function DBM:PlayCountSound(number, forceVoice, forcePath)
		if number > 10 then return end
		local voice
		if forceVoice then--For options example
			voice = forceVoice
		else
			voice = self.Options.CountdownVoice
		end
		local path
		local maxCount = 5
		if forcePath then
			path = forcePath
		else
			for i = 1, #self.Counts do
				if self.Counts[i].value == voice then
					path = self.Counts[i].path
					maxCount = self.Counts[i].max
					break
				end
			end
		end
		if not path or (number > maxCount) then return end
		self:PlaySoundFile(path..number..".ogg")
	end

	function DBM:RegisterCountSound(t, v, p, m)
		--Prevent duplicate insert
		for i = 1, #self.Counts do
			if self.Counts[i].value == v then return end
		end
		--Insert into counts table.
		if t and v and p and m then
			tinsert(self.Counts, { text = t, value = v, path = p, max = m })
		end
	end

	function DBM:CheckVoicePackVersion(value)
		local activeVP = self.Options.ChosenVoicePack
		--Check if voice pack out of date
		if activeVP ~= "None" and activeVP == value then
			if self.VoiceVersions[value] < 8 then--Version will be bumped when new voice packs released that contain new voices.
				if not self.Options.DontShowReminders then
					self:AddMsg(DBM_CORE_VOICE_PACK_OUTDATED)
				end
				SWFilterDisabed = self.VoiceVersions[value]--Set disable to version on current voice pack
			else
				SWFilterDisabed = 8
			end
		end
	end

	function DBM:PlaySpecialWarningSound(soundId)
		local sound = type(soundId) == "number" and self.Options["SpecialWarningSound" .. (soundId == 1 and "" or soundId)] or soundId or self.Options.SpecialWarningSound
--		self:PlaySoundFile(sound, nil, true)
		self:PlaySoundFile(sound)
	end

	local function testWarningEnd()
		frame:SetFrameStrata("HIGH")
	end

	function DBM:ShowTestSpecialWarning(text, number, noSound)
		if moving then
			return
		end
		self:AddSpecialWarning(DBM_CORE_MOVE_SPECIAL_WARNING_TEXT)
		frame:SetFrameStrata("TOOLTIP")
		self:Unschedule(testWarningEnd)
		self:Schedule(self.Options.SpecialWarningDuration2 * 1.3, testWarningEnd)
		if number and not noSound then
			self:PlaySpecialWarningSound(number)
		end
		if number and DBM.Options["SpecialWarningFlash"..number] then
			local flashColor = self.Options["SpecialWarningFlashCol"..number]
			local repeatCount = self.Options["SpecialWarningFlashCount"..number] or 1
			self.Flash:Show(flashColor[1], flashColor[2], flashColor[3], self.Options["SpecialWarningFlashDura"..number], self.Options["SpecialWarningFlashAlph"..number], repeatCount-1)
		end
	end
end

--------------------
--  Timer Object  --
--------------------
do
	local timerPrototype = {}
	local mt = {__index = timerPrototype}
	local countvoice1, countvoice2, countvoice3 = nil, nil, nil
	local countvoice1max, countvoice2max, countvoice3max = 5, 5, 5
	local countpath1, countpath2, countpath3 = nil, nil, nil

	--Merged countdown object for timers with build-in countdown
	function DBM:BuildVoiceCountdownCache()
		countvoice1 = self.Options.CountdownVoice
		countvoice2 = self.Options.CountdownVoice2
		countvoice3 = self.Options.CountdownVoice3
		for i = 1, #self.Counts do
			local curVoice = self.Counts[i]
			if curVoice.value == countvoice1 then
				countpath1 = curVoice.path
				countvoice1max = curVoice.max
			end
			if curVoice.value == countvoice2 then
				countpath2 = curVoice.path
				countvoice2max = curVoice.max
			end
			if curVoice.value == countvoice3 then
				countpath3 = curVoice.path
				countvoice3max = curVoice.max
			end
		end
	end

	local function playCountSound(timerId, path)
		DBM:PlaySoundFile(path)
	end

	local function playCountdown(timerId, timer, voice, count)
		if DBM.Options.DontPlayCountdowns then return end
		timer = timer or 10
		count = count or 5
		voice = voice or 1
		if timer <= count then count = floor(timer) end
		if not countpath1 or not countpath2 or not countpath3 then
			DBM:Debug("Voice cache not built at time of playCountdown. On fly caching.", 3)
			DBM:BuildVoiceCountdownCache()
		end
		local maxCount, path
		if type(voice) == "string" then
			maxCount = 5--Safe to assume if it's not one of the built ins, it's likely heroes/OW, which has a max of 5
			path = voice
		elseif voice == 2 then
			maxCount = countvoice2max or 10
			path = countpath2 or "Interface\\AddOns\\DBM-Core\\Sounds\\Kolt\\"
		elseif voice == 3 then
			maxCount = countvoice3max or 5
			path = countpath3 or "Interface\\AddOns\\DBM-Core\\Sounds\\Smooth\\"
		else
			maxCount = countvoice1max or 10
			path = countpath1 or "Interface\\AddOns\\DBM-Core\\Sounds\\Corsica\\"
		end
		if not path then--Should not happen but apparently it does somehow
			DBM:Debug("Voice path failed in countdownProtoType:Start.")
			return
		end
		if count == 0 then--If a count of 0 is passed,then it's a "Countout" timer, not "Countdown"
			for i = 1, timer do
				if i < maxCount then
					DBM:Schedule(i, playCountSound, timerId, path..i..".ogg")
				end
			end
		else
			for i = count, 1, -1 do
				if i <= maxCount then
					DBM:Schedule(timer-i, playCountSound, timerId, path..i..".ogg")
				end
			end
		end
	end

	function timerPrototype:Start(timer, ...)
		if DBM.Options.DontShowBossTimers then return end
		if timer and type(timer) ~= "number" then
			return self:Start(nil, timer, ...) -- first argument is optional!
		end
		if not self.option or self.mod.Options[self.option] then
			if self.type and (self.type == "cdcount" or self.type == "nextcount") and not self.allowdouble then--remove previous timer.
				for i = #self.startedTimers, 1, -1 do
					if DBM.Options.DebugMode and DBM.Options.DebugLevel > 1 then
						local bar = DBM.Bars:GetBar(self.startedTimers[i])
						if bar then
							local remaining = ("%.1f"):format(bar.timer)
							local ttext = _G[bar.frame:GetName().."BarName"]:GetText() or ""
							ttext = ttext.."("..self.id..")"
							if bar.timer > 0.2 then
								DBM:Debug("Timer "..ttext.. " refreshed before expired. Remaining time is : "..remaining, 2)
							end
						end
					end
					DBM.Bars:CancelBar(self.startedTimers[i])
					fireEvent("DBM_TimerStop", self.startedTimers[i])
					self.startedTimers[i] = nil
				end
			end
			timer = timer and ((timer > 0 and timer) or self.timer + timer) or self.timer
			--AI timer api:
			--Starting ai timer with (1) indicates it's a first timer after pull
			--Starting timer with (2) or (3) indicates it's a stage 2 or stage 3 first timer
			--Starting AI timer with anything above 3 indicarets it's a regular timer and to use shortest time in between two regular casts
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			if self.type == "ai" then--A learning timer
				if not DBM.Options.AITimer then return end
				if timer > 4 then--Normal behavior.
					local newPhase = false
					for i = 1, 4 do
						--Check for any phase timers that are strings, if a string it means last cast of this ability was first case of a given stage
						if self["phase"..i.."CastTimer"] and type(self["phase"..i.."CastTimer"]) == "string" then--This is first cast of spell, we need to generate self.firstPullTimer
							self["phase"..i.."CastTimer"] = tonumber(self["phase"..i.."CastTimer"])
							self["phase"..i.."CastTimer"] = GetTime() - self["phase"..i.."CastTimer"]--We have generated a self.phase1CastTimer! Next pull, DBM should know timer for first cast next pull. FANCY!
							DBM:Debug("AI timer learned a first timer for current phase of "..self["phase"..i.."CastTimer"], 2)
							newPhase = true
						end
					end
					if self.lastCast and not newPhase then--We have a GetTime() on last cast and it's not affected by a phase change
						local timeLastCast = GetTime() - self.lastCast--Get time between current cast and last cast
						if timeLastCast > 4 then--Prevent infinite loop cpu hang. Plus anything shorter than 5 seconds doesn't need a timer
							if not self.lowestSeenCast or (self.lowestSeenCast and self.lowestSeenCast > timeLastCast) then--Always use lowest seen cast for a timer
								self.lowestSeenCast = timeLastCast
								DBM:Debug("AI timer learned a new lowest timer of "..self.lowestSeenCast, 2)
							end
						end
					end
					self.lastCast = GetTime()
					if self.lowestSeenCast then--Always use lowest seen cast for timer
						timer = self.lowestSeenCast
					else
						return--Don't start the bogus timer shoved into timer field in the mod
					end
				else--AI timer passed with 4 or less is indicating phase change, with timer as phase number
					if self["phase"..timer.."CastTimer"] and type(self["phase"..timer.."CastTimer"]) == "number" then
						--Check if timer is shorter than previous learned first timer by scanning remaining time on existing bar
						local bar = DBM.Bars:GetBar(id)
						if bar then
							local remaining = ("%.1f"):format(bar.timer)
							if bar.timer > 0.2 then
								self["phase"..timer.."CastTimer"] = self["phase"..timer.."CastTimer"] - remaining
								DBM:Debug("AI timer learned a lower first timer for current phase of "..self["phase"..timer.."CastTimer"], 2)
							end
						end
						timer = self["phase"..timer.."CastTimer"]
					else--No first pull timer generated yet, set it to GetTime, as a string
						self["phase"..timer.."CastTimer"] = tostring(GetTime())
						return--Don't start the x second timer
					end
				end
			end
			if DBM.Options.DebugMode and DBM.Options.DebugLevel > 1 then
				if not self.type or (self.type ~= "target" and self.type ~= "active" and self.type ~= "fades" and self.type ~= "ai") then
					local bar = DBM.Bars:GetBar(id)
					if bar then
						local remaining = ("%.1f"):format(bar.timer)
						local ttext = _G[bar.frame:GetName().."BarName"]:GetText() or ""
						ttext = ttext.."("..self.id..")"
						if bar.timer > 0.2 then
							DBM:Debug("Timer "..ttext.. " refreshed before expired. Remaining time is : "..remaining, 2)
						end
					end
				end
			end
			local colorId = 0
			if self.option then
				colorId = self.mod.Options[self.option .. "TColor"]
			elseif self.colorType and type(self.colorType) == "string" then--No option for specific timer, but another bool option given that tells us where to look for TColor
				colorId = self.mod.Options[self.colorType .. "TColor"] or 0
			end
			local countVoice, countVoiceMax = 0, self.countdownMax or 4
			if self.option then
				countVoice = self.mod.Options[self.option .. "CVoice"]
				if not self.fade and (type(countVoice) == "string" or countVoice > 0) then--Started without faded and has count voice assigned
					playCountdown(id, timer, countVoice, countVoiceMax)--timerId, timer, voice, count
				end
			end
			local bar = DBM.Bars:CreateBar(timer, id, self.icon, nil, nil, nil, nil, colorId, nil, self.keep, self.fade, countVoice, countVoiceMax)
			if not bar then
				return false, "error" -- creating the timer failed somehow, maybe hit the hard-coded timer limit of 15
			end
			local msg = ""
			if self.type and not self.text then
				msg = pformat(self.mod:GetLocalizedTimerText(self.type, self.spellId, self.name), ...)
			else
				if type(self.text) == "number" then--spellId passed in timer text, it's a timer with short text
					msg = pformat(self.mod:GetLocalizedTimerText(self.type, self.text, self.name), ...)
				else
					msg = pformat(self.text, ...)
				end
			end
			msg = msg:gsub(">.-<", stripServerName)
			bar:SetText(msg, self.inlineIcon)
			--ID: Internal DBM timer ID
			--msg: Timer Text (Do not use msg has an event trigger, it varies language to language or based on user timer options. Use this to DISPLAY only (such as timer replacement UI). use spellId field 99% of time
			--timer: Raw timer value (number).
			--Icon: Texture Path for Icon
			--type: Timer type (Cooldowns: cd, cdcount, nextcount, nextsource, cdspecial, nextspecial, stage, ai. Durations: target, active, fades, roleplay. Casting: cast)
			--spellId: Raw spellid if available (most timers will have spellId or EJ ID unless it's a specific timer not tied to ability such as pull or combat start or rez timers. EJ id will be in format ej%d
			--colorID: Type classification (1-Add, 2-Aoe, 3-targeted ability, 4-Interrupt, 5-Role, 6-Stage, 7-User(custom))
			--Mod ID: Encounter ID as string, or a generic string for mods that don't have encounter ID (such as trash, dummy/test mods)
			--Keep: true or nil, whether or not to keep bar on screen when it expires (if true, timer should be retained until an actual TimerStop occurs or a new TimerStart with same barId happens (in which case you replace bar with new one)
			--fade: true or nil, whether or not to fade a bar (set alpha to usersetting/2)
			fireEvent("DBM_TimerStart", id, msg, timer, self.icon, self.type, self.spellId, colorId, self.mod.id, self.keep, self.fade)
			tinsert(self.startedTimers, id)
			if not self.keep then--Don't ever remove startedTimers on a schedule, if it's a keep timer
				self.mod:Unschedule(removeEntry, self.startedTimers, id)
				self.mod:Schedule(timer, removeEntry, self.startedTimers, id)
			end
			return bar
		else
			return false, "disabled"
		end
	end
	timerPrototype.Show = timerPrototype.Start

	--A way to set the fade to yes or no, overriding hardcoded value in NewTimer object with temporary one
	--If this method is used, it WILL persist until reload or changing it back
	function timerPrototype:SetFade(fadeOn, ...)
		--Done this way so SetFade can be used with :Start without needless performance cost (ie, ApplyStyle won't run unless it needs to)
		if fadeOn and not self.fade then
			self.fade = true--set timer object metatable, which will make sure next bar started uses fade
			--Find and Update an existing bar that's already started
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBM.Bars:GetBar(id)
			if bar and not bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, true)--Timer ID, spellId, modId, true/nil (new callback only needed if we update an existing timers fade, self.fade is passed in timer start object for new timers)
				bar.fade = true--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
				if bar.countdown then--Cancel countdown, because we just enabled a bar fade
					DBM:Unschedule(playCountSound, id)
					DBM:Debug("Disabling a countdown on bar ID: "..id.." after a SetFade enable call")
				end
			end
		elseif not fadeOn and self.fade then
			self.fade = nil--set timer object metatable, which will make sure next bar started does NOT use fade
			--Find and Update an existing bar that's already started
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBM.Bars:GetBar(id)
			if bar and bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, nil)--Timer ID, spellId, modId, true/nil (new callback only needed if we update an existing timers fade, self.fade is passed in timer start object for new timers)
				bar.fade = nil--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
				if bar.countdown then--Unfading bar, start countdown
					DBM:Unschedule(playCountSound, id)
					playCountdown(id, bar.timer, bar.countdown, bar.countdownMax)--timerId, timer, voice, count
					DBM:Debug("Re-enabling a countdown on bar ID: "..id.." after a SetFade disable call")
				end
			end
		end
	end

	--This version does NOT set timer object meta, only started bar meta
	--Use this if you only want to alter an already STARTED temporarily
	--As such it also only needs fadeOn. fadeoff isn't needed since this temp alter never affects newly started bars
	function timerPrototype:SetSTFade(fadeOn, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		if bar then
			if fadeOn and not bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, true)--Timer ID, spellId, modId, true/nil (new callback only needed if we update an existing timers fade, self.fade is passed in timer start object for new timers)
				bar.fade = true--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
				if bar.countdown then--Cancel countdown, because we just enabled a bar fade
					DBM:Unschedule(playCountSound, id)
					DBM:Debug("Disabling a countdown on bar ID: "..id.." after a SetSTFade enable call")
				end
			elseif not fadeOn and bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, nil)
				bar.fade = false
				bar:ApplyStyle()
				if bar.countdown then--Unfading bar, start countdown
					DBM:Unschedule(playCountSound, id)
					playCountdown(id, bar.timer, bar.countdown, bar.countdownMax)--timerId, timer, voice, count
					DBM:Debug("Re-enabling a countdown on bar ID: "..id.." after a SetSTFade disable call")
				end
			end
		end
	end

	function timerPrototype:DelayedStart(delay, ...)
		unschedule(self.Start, self.mod, self, ...)
		schedule(delay or 0.5, self.Start, self.mod, self, ...)
	end
	timerPrototype.DelayedShow = timerPrototype.DelayedStart

	function timerPrototype:Schedule(t, ...)
		return schedule(t, self.Start, self.mod, self, ...)
	end

	function timerPrototype:Unschedule(...)
		return unschedule(self.Start, self.mod, self, ...)
	end

	--TODO, figure out why this function doesn't properly stop count timers when calling stop without count on count timers
	function timerPrototype:Stop(...)
		if select("#", ...) == 0 then
			for i = #self.startedTimers, 1, -1 do
				fireEvent("DBM_TimerStop", self.startedTimers[i])
				DBM.Bars:CancelBar(self.startedTimers[i])
				DBM:Unschedule(playCountSound, self.startedTimers[i])--Unschedule countdown by timerId
				self.startedTimers[i] = nil
			end
		else
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			for i = #self.startedTimers, 1, -1 do
				if self.startedTimers[i] == id then
					fireEvent("DBM_TimerStop", id)
					DBM.Bars:CancelBar(id)
					DBM:Unschedule(playCountSound, id)--Unschedule countdown by timerId
					tremove(self.startedTimers, i)
				end
			end
		end
		if self.type == "ai" then--A learning timer
			if not DBM.Options.AITimer then return end
			self.lastCast = nil
			for i = 1, 4 do
				--Check for any phase timers that are strings and never got a chance to become AI timers, then wipe them
				if self["phase"..i.."CastTimer"] and type(self["phase"..i.."CastTimer"]) == "string" then
					self["phase"..i.."CastTimer"] = nil
					DBM:Debug("Wiping incomplete new timer of stage "..i, 2)
				end
			end
		end
	end

	function timerPrototype:Cancel(...)
		self:Stop(...)
		self:Unschedule(...)
	end

	function timerPrototype:GetTime(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		return bar and (bar.totalTime - bar.timer) or 0, (bar and bar.totalTime) or 0
	end

	function timerPrototype:GetRemaining(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		return bar and bar.timer or 0
	end

	function timerPrototype:IsStarted(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		return bar and true
	end

	function timerPrototype:SetTimer(timer)
		self.timer = timer
	end

	function timerPrototype:Update(elapsed, totalTime, ...)
		if DBM.Options.DontShowBossTimers then return end
		if self:GetTime(...) == 0 then
			self:Start(totalTime, ...)
		end
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		fireEvent("DBM_TimerUpdate", id, elapsed, totalTime)
		if bar and bar.countdown and bar.countdown > 0 then
			DBM:Unschedule(playCountSound, id)
			if not bar.fade then--Don't start countdown voice if it's faded bar
				playCountdown(id, totalTime-elapsed, bar.countdown, bar.countdownMax)--timerId, timer, voice, count
				DBM:Debug("Updating a countdown after a timer Update call for timer ID:"..id)
			end
		end
		return DBM.Bars:UpdateBar(id, elapsed, totalTime)
	end

	function timerPrototype:AddTime(extendAmount, ...)
		if DBM.Options.DontShowBossTimers then return end
		if self:GetTime(...) == 0 then
			return self:Start(extendAmount, ...)
		else
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBM.Bars:GetBar(id)
			if bar then
				local elapsed, total = (bar.totalTime - bar.timer), bar.totalTime
				if elapsed and total then
					if bar.countdown then
						DBM:Unschedule(playCountSound, id)
						if not bar.fade then--Don't start countdown voice if it's faded bar
							local newRemaining = (total+extendAmount) - elapsed
							playCountdown(id, newRemaining, bar.countdown, bar.countdownMax)--timerId, timer, voice, count
							DBM:Debug("Updating a countdown after a timer AddTime call for timer ID:"..id)
						end
					end
					fireEvent("DBM_TimerUpdate", id, elapsed, total+extendAmount)
					return DBM.Bars:UpdateBar(id, elapsed, total+extendAmount)
				end
			end
		end
	end

	function timerPrototype:RemoveTime(reduceAmount, ...)
		if DBM.Options.DontShowBossTimers then return end
		if self:GetTime(...) == 0 then
			return--Do nothing
		else
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBM.Bars:GetBar(id)
			if bar then
				local elapsed, total = (bar.totalTime - bar.timer), bar.totalTime
				if elapsed and total then
					local newRemaining = (total-reduceAmount) - elapsed
					if newRemaining > 0 then
						if bar.countdown and newRemaining > 2 then
							DBM:Unschedule(playCountSound, id)
							if not bar.fade then--Don't start countdown voice if it's faded bar
								playCountdown(id, newRemaining, bar.countdown, bar.countdownMax)--timerId, timer, voice, count
								DBM:Debug("Updating a countdown after a timer RemoveTime call for timer ID:"..id)
							end
						end
						fireEvent("DBM_TimerUpdate", id, elapsed, total-reduceAmount)
						return DBM.Bars:UpdateBar(id, elapsed, total-reduceAmount)
					else--New remaining less than 0
						if bar.countdown then
							DBM:Unschedule(playCountSound, id)
						end
						fireEvent("DBM_TimerStop", id)
						return DBM.Bars:CancelBar(id)
					end
				end
			end
		end
	end

	function timerPrototype:UpdateIcon(icon, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		if bar then
			return bar:SetIcon((type(icon) == "number" and ( icon <=8 and (iconFolder .. icon) or select(3, GetSpellInfo(icon)))) or icon or "Interface\\Icons\\Spell_Nature_WispSplode")
		end
	end

	function timerPrototype:UpdateInline(newInline, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		if bar then
			local ttext = _G[bar.frame:GetName().."BarName"]:GetText() or ""
			return bar:SetText(ttext, newInline or self.inlineIcon)
		end
	end

	function timerPrototype:UpdateName(name, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		if bar then
			return bar:SetText(name, self.inlineIcon)
		end
	end

	function timerPrototype:SetColor(c, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		if bar then
			return bar:SetColor(c)
		end
	end

	function timerPrototype:DisableEnlarge(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBM.Bars:GetBar(id)
		if bar then
			bar.small = true
		end
	end

	function timerPrototype:AddOption(optionDefault, optionName, colorType, countdown)
		if optionName ~= false then
			self.option = optionName or self.id
			self.mod:AddBoolOption(self.option, optionDefault, "timer", nil, colorType, countdown)
		end
	end

	--If a new countdown default is added to a NewTimer object, change optionName of timer to reset a new default
	function bossModPrototype:NewTimer(timer, name, texture, optionDefault, optionName, colorType, inlineIcon, keep, countdown, countdownMax, r, g, b)
		if r and type(r) == "string" then
			DBM:Debug("|cffff0000r probably has inline icon in it and needs to be fixed for |r"..name..r)
			r = nil--Fix it for users
		end
		if inlineIcon and type(inlineIcon) == "number" then
			DBM:Debug("|cffff0000spellID texture path or colorType is in inlineIcon field and needs to be fixed for |r"..name..inlineIcon)
			inlineIcon = nil--Fix it for users
		end
		local icon = type(texture) == "number" and ( texture <=8 and (iconFolder .. texture) or select(3, GetSpellInfo(texture))) or texture or "Interface\\Icons\\Spell_Nature_WispSplode"
		local obj = setmetatable(
			{
				text = self.localization.timers[name],
				timer = timer,
				id = name,
				icon = icon,
				colorType = colorType,
				inlineIcon = inlineIcon,
				keep = keep,
				countdown = countdown,
				countdownMax = countdownMax,
				r = r,
				g = g,
				b = b,
				startedTimers = {},
				mod = self,
			},
			mt
		)
		obj:AddOption(optionDefault, optionName, colorType, countdown)
		tinsert(self.timers, obj)
		return obj
	end

	-- new constructor for the new auto-localized timer types
	-- note that the function might look unclear because it needs to handle different timer types, especially achievement timers need special treatment
	-- If a new countdown is added to an existing timer that didn't have one before, use optionName (number) to force timer to reset defaults by assigning it a new variable
	local function newTimer(self, timerType, timer, spellId, timerText, optionDefault, optionName, colorType, texture, inlineIcon, keep, countdown, countdownMax, r, g, b)
		if type(timer) == "string" and timer:match("OptionVersion") then
			DBM:Debug("|cffff0000OptionVersion hack depricated, remove it from: |r"..spellId)
			return
		end
		if type(colorType) == "number" and colorType > 7 then
			DBM:Debug("|cffff0000texture is in the colorType arg for: |r"..spellId)
		end
		--Use option optionName for optionVersion as well, no reason to split.
		--This ensures that remaining arg positions match for auto generated and regular NewTimer
		local optionVersion
		if type(optionName) == "number" then
			optionVersion = optionName
			optionName = nil
		end
		local allowdouble
		if type(timer) == "string" and timer:match("d%d+") then
			allowdouble = true
			timer = tonumber(string.sub(timer, 2))
		end
		local spellName, icon
		local unparsedId = spellId
		if timerType == "achievement" then
			spellName = select(2, GetAchievementInfo(spellId))
			icon = type(texture) == "number" and select(10, GetAchievementInfo(texture)) or texture or spellId and select(10, GetAchievementInfo(spellId))
		elseif timerType == "cdspecial" or timerType == "nextspecial" or timerType == "stage" then
			icon = type(texture) == "number" and select(3, GetSpellInfo(texture)) or texture or (type(spellId) == "number" and select(3, GetSpellInfo(texture))) or "Interface\\Icons\\Spell_Nature_WispSplode"
			if timerType == "stage" then
				colorType = 6
			end
		elseif timerType == "roleplay" then
			icon = type(texture) == "number" and select(3, GetSpellInfo(texture)) or texture or (type(spellId) == "number" and select(3, GetSpellInfo(texture))) or "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME"
			colorType = 6
		elseif timerType == "adds" or timerType == "addscustom" then
			icon = type(texture) == "number" and select(3, GetSpellInfo(texture)) or texture or (type(spellId) == "number" and select(3, GetSpellInfo(texture))) or "Interface\\Icons\\Spell_Nature_WispSplode"
			colorType = 1
		else
			spellName = DBM:GetSpellInfo(spellId or 0)
			if spellName then
				icon = type(texture) == "number" and ( texture <=8 and (iconFolder .. texture) or select(3, GetSpellInfo(texture))) or texture or spellId and select(3, GetSpellInfo(spellId))
			else
				icon = nil
			end
		end
		spellName = spellName or tostring(spellId)
		local timerTextValue
		--If timertext is a number, accept it as a secondary auto translate spellid
		if DBM.Options.ShortTimerText and timerText and type(timerText) == "number" then
			timerTextValue = timerText
			spellName = DBM:GetSpellInfo(timerText or 0)--Override Cached spell Name
		else
			timerTextValue = self.localization.timers[timerText] or timerText--Check timers table first, otherwise accept it as literal timer text
		end
		local id = "Timer"..(spellId or 0)..timerType..(optionVersion or "")
		local obj = setmetatable(
			{
				text = timerTextValue,
				type = timerType,
				spellId = spellId,
				name = spellName,
				timer = timer,
				id = id,
				icon = icon,
				colorType = colorType,
				inlineIcon = inlineIcon,
				keep = keep,
				countdown = countdown,
				countdownMax = countdownMax,
				r = r,
				g = g,
				b = b,
				allowdouble = allowdouble,
				startedTimers = {},
				mod = self,
			},
			mt
		)
		obj:AddOption(optionDefault, optionName, colorType, countdown)
		tinsert(self.timers, obj)
		-- todo: move the string creation to the GUI with SetFormattedString...
		if timerType == "achievement" then
			self.localization.options[id] = DBM_CORE_AUTO_TIMER_OPTIONS[timerType]:format(GetAchievementLink(spellId):gsub("%[(.+)%]", "%1"))
		elseif timerType == "cdspecial" or timerType == "nextspecial" or timerType == "stage" or timerType == "roleplay" then--Timers without spellid, generic
			self.localization.options[id] = DBM_CORE_AUTO_TIMER_OPTIONS[timerType]--Using more than 1 stage timer or more than 1 special timer will break this, fortunately you should NEVER use more than 1 of either in a mod
		else
			self.localization.options[id] = DBM_CORE_AUTO_TIMER_OPTIONS[timerType]:format(unparsedId)
		end
		return obj
	end

	function bossModPrototype:NewTargetTimer(...)
		return newTimer(self, "target", ...)
	end

	--Buff/Debuff/event on boss
	function bossModPrototype:NewBuffActiveTimer(...)
		return newTimer(self, "active", ...)
	end

	----Buff/Debuff on players
	function bossModPrototype:NewBuffFadesTimer(...)
		return newTimer(self, "fades", ...)
	end

	function bossModPrototype:NewCastTimer(timer, ...)
		if tonumber(timer) and timer > 1000 then -- hehe :) best hack in DBM. This makes the first argument optional, so we can omit it to use the cast time from the spell id ;)
			local spellId = timer
			timer = select(7, DBM:GetSpellInfo(spellId)) or 1000 -- GetSpellInfo takes YOUR spell haste into account...WTF?
			local spellHaste = select(7, DBM:GetSpellInfo(53142)) / 10000 -- 53142 = Dalaran Portal, should have 10000 ms cast time
			timer = timer / spellHaste -- calculate the real cast time of the spell...
			return self:NewCastTimer(timer / 1000, spellId, ...)
		end
		return newTimer(self, "cast", timer, ...)
	end

	function bossModPrototype:NewCastCountTimer(timer, ...)
		if tonumber(timer) and timer > 1000 then -- hehe :) best hack in DBM. This makes the first argument optional, so we can omit it to use the cast time from the spell id ;)
			local spellId = timer
			timer = select(7, DBM:GetSpellInfo(spellId)) or 1000 -- GetSpellInfo takes YOUR spell haste into account...WTF?
			local spellHaste = select(7, DBM:GetSpellInfo(53142)) / 10000 -- 53142 = Dalaran Portal, should have 10000 ms cast time
			timer = timer / spellHaste -- calculate the real cast time of the spell...
			return self:NewCastTimer(timer / 1000, spellId, ...)
		end
		return newTimer(self, "castcount", timer, ...)
	end

	function bossModPrototype:NewCastSourceTimer(timer, ...)
		if tonumber(timer) and timer > 1000 then -- hehe :) best hack in DBM. This makes the first argument optional, so we can omit it to use the cast time from the spell id ;)
			local spellId = timer
			timer = select(7, DBM:GetSpellInfo(spellId)) or 1000 -- GetSpellInfo takes YOUR spell haste into account...WTF?
			local spellHaste = select(7, DBM:GetSpellInfo(53142)) / 10000 -- 53142 = Dalaran Portal, should have 10000 ms cast time
			timer = timer / spellHaste -- calculate the real cast time of the spell...
			return self:NewCastSourceTimer(timer / 1000, spellId, ...)
		end
		return newTimer(self, "castsource", timer, ...)
	end

	function bossModPrototype:NewCDTimer(...)
		return newTimer(self, "cd", ...)
	end

	function bossModPrototype:NewCDCountTimer(...)
		return newTimer(self, "cdcount", ...)
	end

	function bossModPrototype:NewCDSourceTimer(...)
		return newTimer(self, "cdsource", ...)
	end

	function bossModPrototype:NewNextTimer(...)
		return newTimer(self, "next", ...)
	end

	function bossModPrototype:NewNextCountTimer(...)
		return newTimer(self, "nextcount", ...)
	end

	function bossModPrototype:NewNextSourceTimer(...)
		return newTimer(self, "nextsource", ...)
	end

	function bossModPrototype:NewAchievementTimer(...)
		return newTimer(self, "achievement", ...)
	end

	function bossModPrototype:NewCDSpecialTimer(...)
		return newTimer(self, "cdspecial", ...)
	end

	function bossModPrototype:NewNextSpecialTimer(...)
		return newTimer(self, "nextspecial", ...)
	end

	function bossModPrototype:NewPhaseTimer(...)
		return newTimer(self, "stage", ...)
	end

	function bossModPrototype:NewRPTimer(...)
		return newTimer(self, "roleplay", ...)
	end

	function bossModPrototype:NewAddsTimer(...)
		return newTimer(self, "adds", ...)
	end

	function bossModPrototype:NewAddsCustomTimer(...)
		return newTimer(self, "addscustom", ...)
	end

	function bossModPrototype:NewAITimer(...)
		return newTimer(self, "ai", ...)
	end

	function bossModPrototype:GetLocalizedTimerText(timerType, spellId, Name)
		local spellName
		if Name then
			spellName = Name--Pull from name stored in object
		elseif spellId then
			DBM:Debug("|cffff0000GetLocalizedTimerText fallback, this should not happen and is a bug. this fallback should be deleted if this message is never seen after async code is live|r")
			if timerType == "achievement" then
				spellName = select(2, GetAchievementInfo(spellId))
			else
				spellName = DBM:GetSpellInfo(spellId)
			end
		end
		if DBM_CORE_AUTO_TIMER_TEXTS[timerType.."short"] and DBM.Bars:GetOption("StripCDText") then
			return pformat(DBM_CORE_AUTO_TIMER_TEXTS[timerType.."short"], spellName)
		else
			return pformat(DBM_CORE_AUTO_TIMER_TEXTS[timerType], spellName)
		end
	end
end

------------------------------
--  Berserk/Combat Objects  --
------------------------------
do
	local enragePrototype = {}
	local mt = {__index = enragePrototype}

	function enragePrototype:Start(timer)
		timer = timer or self.timer or 600
		timer = timer <= 0 and self.timer - timer or timer
		self.bar:SetTimer(timer)
		self.bar:Start()
		if self.warning1 then
			if timer > 660 then self.warning1:Schedule(timer - 600, 10, DBM_CORE_MIN) end
			if timer > 300 then self.warning1:Schedule(timer - 300, 5, DBM_CORE_MIN) end
			if timer > 180 then self.warning2:Schedule(timer - 180, 3, DBM_CORE_MIN) end
		end
		if self.warning2 then
			if timer > 60 then self.warning2:Schedule(timer - 60, 1, DBM_CORE_MIN) end
			if timer > 30 then self.warning2:Schedule(timer - 30, 30, DBM_CORE_SEC) end
			if timer > 10 then self.warning2:Schedule(timer - 10, 10, DBM_CORE_SEC) end
		end
	end

	function enragePrototype:Schedule(t)
		return self.owner:Schedule(t, self.Start, self)
	end

	function enragePrototype:Cancel()
		self.owner:Unschedule(self.Start, self)
		if self.warning1 then
			self.warning1:Cancel()
		end
		if self.warning2 then
			self.warning2:Cancel()
		end
		self.bar:Stop()
	end
	enragePrototype.Stop = enragePrototype.Cancel

	function bossModPrototype:NewBerserkTimer(timer, text, barText, barIcon)
		timer = timer or 600
		local warning1 = self:NewAnnounce(text or DBM_CORE_GENERIC_WARNING_BERSERK, 1, nil, "warning_berserk", false)
		local warning2 = self:NewAnnounce(text or DBM_CORE_GENERIC_WARNING_BERSERK, 4, nil, "warning_berserk", false)
		local bar = self:NewTimer(timer, barText or DBM_CORE_GENERIC_TIMER_BERSERK, barIcon or 28131, nil, "timer_berserk")
		local obj = setmetatable(
			{
				warning1 = warning1,
				warning2 = warning2,
				bar = bar,
				timer = timer,
				owner = self
			},
			mt
		)
		return obj
	end

	function bossModPrototype:NewCombatTimer(timer, text, barText, barIcon)
		timer = timer or 10
		--NewTimer(timer, name, texture, optionDefault, optionName, colorType, inlineIcon, keep, countdown, countdownMax, r, g, b)
		local bar = self:NewTimer(timer, barText or DBM_CORE_GENERIC_TIMER_COMBAT, barIcon or "Interface\\Icons\\Ability_Warrior_OffensiveStance", nil, "timer_combat", nil, nil, nil, 1, 5)
		local obj = setmetatable(
			{
				bar = bar,
				timer = timer,
				owner = self
			},
			mt
		)
		return obj
	end
end

---------------
--  Options  --
---------------
function bossModPrototype:AddBoolOption(name, default, cat, func, extraOption, extraOptionTwo)
	cat = cat or "misc"
	self.DefaultOptions[name] = (default == nil) or default
	if cat == "timer" then
		self.DefaultOptions[name.."TColor"] = extraOption or 0
		self.DefaultOptions[name.."CVoice"] = extraOptionTwo or 0
	end
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	if cat == "timer" then
		self.Options[name.."TColor"] = extraOption or 0
		self.Options[name.."CVoice"] = extraOptionTwo or 0
	end
	self:SetOptionCategory(name, cat)
	if func then
		self.optionFuncs = self.optionFuncs or {}
		self.optionFuncs[name] = func
	end
end

function bossModPrototype:AddSpecialWarningOption(name, default, defaultSound, cat)
	cat = cat or "misc"
	self.DefaultOptions[name] = (default == nil) or default
	self.DefaultOptions[name.."SWSound"] = defaultSound or 1
	self.DefaultOptions[name.."SWNote"] = true
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self.Options[name.."SWSound"] = defaultSound or 1
	self.Options[name.."SWNote"] = true
	self:SetOptionCategory(name, cat)
end

function bossModPrototype:AddSetIconOption(name, spellId, default, isHostile, iconsUsed)
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self:SetOptionCategory(name, "icon")
	if isHostile then
		if not self.findFastestComputer then
			self.findFastestComputer = {}
		end
		self.findFastestComputer[#self.findFastestComputer + 1] = name
		self.localization.options[name] = DBM_CORE_AUTO_ICONS_OPTION_TEXT2:format(spellId)
	else
		self.localization.options[name] = DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(spellId)
	end
	--A table defining used icons by number, insert icon textures to end of option
	if iconsUsed then
		self.localization.options[name] = self.localization.options[name].." ("
		for i=1, #iconsUsed do
			--Texture ID 137009 if direct calling RaidTargetingIcons stops working one day
			if 		iconsUsed[i] == 1 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:0:16:0:16|t"
			elseif	iconsUsed[i] == 2 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:16:32:0:16|t"
			elseif	iconsUsed[i] == 3 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:32:48:0:16|t"
			elseif	iconsUsed[i] == 4 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:48:64:0:16|t"
			elseif	iconsUsed[i] == 5 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:0:16:16:32|t"
			elseif	iconsUsed[i] == 6 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:16:32:16:32|t"
			elseif	iconsUsed[i] == 7 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:32:48:16:32|t"
			elseif	iconsUsed[i] == 8 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:48:64:16:32|t"
			end
		end
		self.localization.options[name] = self.localization.options[name]..")"
	end
end

function bossModPrototype:AddArrowOption(name, spellId, default, isRunTo)
	if isRunTo == true then isRunTo = 2 end--Support legacy
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self:SetOptionCategory(name, "misc")
	if isRunTo == 2 then
		self.localization.options[name] = DBM_CORE_AUTO_ARROW_OPTION_TEXT:format(spellId)
	elseif isRunTo == 3 then
		self.localization.options[name] = DBM_CORE_AUTO_ARROW_OPTION_TEXT3:format(spellId)
	else
		self.localization.options[name] = DBM_CORE_AUTO_ARROW_OPTION_TEXT2:format(spellId)
	end
end

function bossModPrototype:AddRangeFrameOption(range, spellId, default)
	self.DefaultOptions["RangeFrame"] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["RangeFrame"] = (default == nil) or default
	self:SetOptionCategory("RangeFrame", "misc")
	if spellId then
		self.localization.options["RangeFrame"] = DBM_CORE_AUTO_RANGE_OPTION_TEXT:format(range, spellId)
	else
		self.localization.options["RangeFrame"] = DBM_CORE_AUTO_RANGE_OPTION_TEXT_SHORT:format(range)
	end
end

function bossModPrototype:AddHudMapOption(name, spellId, default)
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self:SetOptionCategory(name, "misc")
	if spellId then
		self.localization.options[name] = DBM_CORE_AUTO_HUD_OPTION_TEXT:format(spellId)
	else
		self.localization.options[name] = DBM_CORE_AUTO_HUD_OPTION_TEXT_MULTI
	end
end

function bossModPrototype:AddInfoFrameOption(spellId, default, optionVersion)
	local oVersion = ""
	if optionVersion then
		optionVersion = tostring(optionVersion)
	end
	self.DefaultOptions["InfoFrame"..oVersion] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["InfoFrame"..oVersion] = (default == nil) or default
	self:SetOptionCategory("InfoFrame"..oVersion, "misc")
	if spellId then
		self.localization.options["InfoFrame"..oVersion] = DBM_CORE_AUTO_INFO_FRAME_OPTION_TEXT:format(spellId)
	else
		self.localization.options["InfoFrame"..oVersion] = DBM_CORE_AUTO_INFO_FRAME_OPTION_TEXT2
	end
end

function bossModPrototype:AddReadyCheckOption(questId, default, maxLevel)
	self.readyCheckQuestId = questId
	self.readyCheckMaxLevel = maxLevel or 999
	self.DefaultOptions["ReadyCheck"] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["ReadyCheck"] = (default == nil) or default
	self.localization.options["ReadyCheck"] = DBM_CORE_AUTO_READY_CHECK_OPTION_TEXT
	self:SetOptionCategory("ReadyCheck", "misc")
end

function bossModPrototype:AddSliderOption(name, minValue, maxValue, valueStep, default, cat, func)
	cat = cat or "misc"
	self.DefaultOptions[name] = {type = "slider", value = default or 0}
	self.Options[name] = default or 0
	self:SetOptionCategory(name, cat)
	self.sliders = self.sliders or {}
	self.sliders[name] = {
		minValue = minValue,
		maxValue = maxValue,
		valueStep = valueStep,
	}
	if func then
		self.optionFuncs = self.optionFuncs or {}
		self.optionFuncs[name] = func
	end
end

function bossModPrototype:AddEditboxOption(name, default, cat, width, height, func)
	cat = cat or "misc"
	self.DefaultOptions[name] = {type = "editbox", value = default or ""}
	self.Options[name] = default or ""
	self:SetOptionCategory(name, cat)
	self.editboxes = self.editboxes or {}
	self.editboxes[name] = {
		width = width,
		height = height
	}
	if func then
		self.optionFuncs = self.optionFuncs or {}
		self.optionFuncs[name] = func
	end
end

function bossModPrototype:AddButton(name, onClick, cat, width, height, fontObject)
	cat = cat or "misc"
	self:SetOptionCategory(name, cat)
	self.buttons = self.buttons or {}
	self.buttons[name] = {
		onClick = onClick,
		width = width,
		height = height,
		fontObject = fontObject
	}
end

-- FIXME: this function does not reset any settings to default if you remove an option in a later revision and a user has selected this option in an earlier revision were it still was available
-- this will be fixed as soon as it is necessary due to removed options ;-)
function bossModPrototype:AddDropdownOption(name, options, default, cat, func)
	cat = cat or "misc"
	self.DefaultOptions[name] = {type = "dropdown", value = default}
	self.Options[name] = default
	self:SetOptionCategory(name, cat)
	self.dropdowns = self.dropdowns or {}
	self.dropdowns[name] = options
	if func then
		self.optionFuncs = self.optionFuncs or {}
		self.optionFuncs[name] = func
	end
end

function bossModPrototype:AddOptionSpacer(cat)
	cat = cat or "misc"
	if self.optionCategories[cat] then
		tinsert(self.optionCategories[cat], DBM_OPTION_SPACER)
	end
end

function bossModPrototype:AddOptionLine(text, cat)
	cat = cat or "misc"
	if not self.optionCategories[cat] then
		self.optionCategories[cat] = {}
	end
	if self.optionCategories[cat] then
		tinsert(self.optionCategories[cat], {line = true, text = text})
	end
end

function bossModPrototype:AddAnnounceSpacer()
	return self:AddOptionSpacer("announce")
end

function bossModPrototype:AddTimerSpacer()
	return self:AddOptionSpacer("timer")
end

function bossModPrototype:AddAnnounceLine(text)
	return self:AddOptionLine(text, "announce")
end

function bossModPrototype:AddTimerLine(text)
	return self:AddOptionLine(text, "timer")
end

function bossModPrototype:AddMiscLine(text)
	return self:AddOptionLine(text, "misc")
end

function bossModPrototype:RemoveOption(name)
	self.Options[name] = nil
	for i, options in pairs(self.optionCategories) do
		removeEntry(options, name)
		if #options == 0 then
			self.optionCategories[i] = nil
		end
	end
	if self.optionFuncs then
		self.optionFuncs[name] = nil
	end
end

function bossModPrototype:SetOptionCategory(name, cat)
	for _, options in pairs(self.optionCategories) do
		removeEntry(options, name)
	end
	if not self.optionCategories[cat] then
		self.optionCategories[cat] = {}
	end
	tinsert(self.optionCategories[cat], name)
end

--------------
--  Combat  --
--------------
function bossModPrototype:RegisterCombat(cType, ...)
	if cType then
		cType = cType:lower()
	end
	local info = {
		type = cType,
		mob = self.creatureId,
		name = self.localization.general.name or self.id,
		msgs = (cType ~= "combat") and {...},
		mod = self
	}
	if self.multiMobPullDetection then
		info.multiMobPullDetection = self.multiMobPullDetection
	end
	local addedKillMobs = false
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		if type(v) == "number" then
			info.killMobs = info.killMobs or {}
			info.killMobs[select(i, ...)] = true
			addedKillMobs = true
		end
	end
	if not addedKillMobs and self.multiMobPullDetection then
		for i, v in ipairs(self.multiMobPullDetection) do
			info.killMobs = info.killMobs or {}
			info.killMobs[v] = true
		end
	end
	self.combatInfo = info
	if not self.zones then return end
	for i, v in ipairs(self.zones) do
		combatInfo[v] = combatInfo[v] or {}
		tinsert(combatInfo[v], info)
	end
end

-- needs to be called _AFTER_ RegisterCombat
function bossModPrototype:RegisterKill(msgType, ...)
	if not self.combatInfo then
		error("mod.combatInfo not yet initialized, use mod:RegisterCombat before using this method", 2)
	end
	self.combatInfo.killType = msgType
	self.combatInfo.killMsgs = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		self.combatInfo.killMsgs[v] = true
	end
end


function bossModPrototype:SetDetectCombatInVehicle(flag)
	if not self.combatInfo then
		error("mod.combatInfo not yet initialized, use mod:RegisterCombat before using this method", 2)
	end
	self.combatInfo.noCombatInVehicle = not flag
end

function bossModPrototype:IsInCombat()
	return self.inCombat
end

function bossModPrototype:IsAlive()
	return not UnitIsDeadOrGhost("player")
end

function bossModPrototype:SetMinCombatTime(t)
	self.minCombatTime = t
end

-- needs to be called after RegisterCombat
function bossModPrototype:SetWipeTime(t)
	if not self.combatInfo then
		error("mod.combatInfo not yet initialized, use mod:RegisterCombat before using this method", 2)
	end
	self.combatInfo.wipeTimer = t
end

function bossModPrototype:IsWipe()
	local wipe = true
	local uId = ((GetNumRaidMembers() == 0) and "party") or "raid"
	for i = 0, mmax(GetNumRaidMembers(), GetNumPartyMembers()) do
		local id = (i == 0 and "player") or uId..i
		if UnitAffectingCombat(id) and not UnitIsDeadOrGhost(id) then
			wipe = false
			break
		end
	end
	return wipe
end

-----------------------
--  Synchronization  --
-----------------------
function bossModPrototype:SendSync(event, ...)
	event = event or ""
	local arg = select("#", ...) > 0 and strjoin("\t", tostringall(...)) or ""
	local str = ("%s\t%s\t%s\t%s"):format(self.id, self.revision or 0, event, arg)
	local spamId = self.id .. event .. arg -- *not* the same as the sync string, as it doesn't use the revision information
	local time = GetTime()
	--Mod syncs are more strict and enforce latency threshold always.
	--Do not put latency check in main sendSync local function (line 313) though as we still want to get version information, etc from these users.
	if not modSyncSpam[spamId] or (time - modSyncSpam[spamId]) > 8 then
		self:ReceiveSync(event, nil, self.revision or 0, tostringall(...))
		sendSync("M", str)
	end
end

function bossModPrototype:ReceiveSync(event, sender, revision, ...)
	local spamId = self.id .. event .. strjoin("\t", ...)
	local time = GetTime()
	if (not modSyncSpam[spamId] or (time - modSyncSpam[spamId]) > self.SyncThreshold) and self.OnSync and (not (self.blockSyncs and sender)) and (not sender or (not self.minSyncRevision or revision >= self.minSyncRevision)) then
		modSyncSpam[spamId] = time
		-- we have to use the sender as last argument for compatibility reasons (stupid old API...)
		-- avoid table allocations for frequently used number of arguments
		if select("#", ...) <= 1 then
			-- syncs with no arguments have an empty argument (also for compatibility reasons)
			self:OnSync(event, ... or "", sender)
		elseif select("#", ...) == 2 then
			self:OnSync(event, ..., select(2, ...), sender)
		else
			local tmp = { ... }
			tmp[#tmp + 1] = sender
			self:OnSync(event, unpack(tmp))
		end
	end
end

function bossModPrototype:SetRevision(revision)
	revision = parseCurseDate(revision or "")
	if not revision then
		revision = DBM.Revision
	end
	self.revision = revision
end

--Either treat it as a valid number, or a curse string that needs to be made into a valid number
function bossModPrototype:SetMinSyncRevision(revision)
	self.minSyncRevision = (type(revision or "") == "number") and revision or parseCurseDate(revision)
end

function bossModPrototype:SetHotfixNoticeRev(revision)
	self.hotfixNoticeRev = (type(revision or "") == "number") and revision or parseCurseDate(revision)
end

-----------------
--  Scheduler  --
-----------------
function bossModPrototype:Schedule(t, f, ...)
	return schedule(t, f, self, ...)
end

function bossModPrototype:Unschedule(f, ...)
	return unschedule(f, self, ...)
end

function bossModPrototype:ScheduleMethod(t, method, ...)
	if not self[method] then
		error(("Method %s does not exist"):format(tostring(method)), 2)
	end
	return self:Schedule(t, self[method], self, ...)
end
bossModPrototype.ScheduleEvent = bossModPrototype.ScheduleMethod

function bossModPrototype:UnscheduleMethod(method, ...)
	if not self[method] then
		error(("Method %s does not exist"):format(tostring(method)), 2)
	end
	return self:Unschedule(self[method], self, ...)
end
bossModPrototype.UnscheduleEvent = bossModPrototype.UnscheduleMethod

-------------
--  Icons  --
-------------

do
	local scanExpires = {}
	local addsIcon = {}
	local addsIconSet = {}

	function bossModPrototype:SetIcon(target, icon, timer)
		if not target then return end--Fix a rare bug where target becomes nil at last second (end combat fires and clears targets)
		if DBM.Options.DontSetIcons or not enableIcons or DBM:GetRaidRank(playerName) == 0 then
			return
		end
		self:UnscheduleMethod("SetIcon", target)
		if type(icon) ~= "number" or type(target) ~= "string" then--icon/target probably backwards.
			DBM:Debug("|cffff0000SetIcon is being used impropperly. Check icon/target order|r")
			return--Fail silently instead of spamming icon lua errors if we screw up
		end
		icon = icon and icon >= 0 and icon <= 8 and icon or 8
		local uId = DBM:GetRaidUnitId(target)
		if uId or UnitExists(target) then--target accepts uid, unitname both.
			uId = uId or target
			--save previous icon into a table.
			local oldIcon = self:GetIcon(uId) or 0
			if not self.iconRestore[uId] then
				self.iconRestore[uId] = oldIcon
			end
			--set icon
			if oldIcon ~= icon then--Don't set icon if it's already set to what we're setting it to
				SetRaidTarget(uId, self.iconRestore[uId] and icon == 0 and self.iconRestore[uId] or icon)
			end
			--schedule restoring old icon if timer enabled.
			if timer then
				self:ScheduleMethod(timer, "SetIcon", target, 0)
			end
		end
	end

	do
		local iconSortTable = {}
		local iconSet = {}

		local function sort_by_group(v1, v2)
			return DBM:GetRaidSubgroup(DBM:GetUnitFullName(v1)) < DBM:GetRaidSubgroup(DBM:GetUnitFullName(v2))
		end

		local function clearSortTable(scanID)
			iconSortTable[scanID] = nil
			iconSet[scanID] = nil
		end

		function bossModPrototype:SetIconByAlphaTable(returnFunc, scanID)
			tsort(iconSortTable[scanID])--Sorted alphabetically
			for i = 1, #iconSortTable[scanID] do
				local target = iconSortTable[scanID][i]
				if i > 8 then
					DBM:Debug("|cffff0000Too many players to set icons, reconsider where using icons|r", 2)
					return
				end
				if not self.iconRestore[target] then
					local oldIcon = self:GetIcon(target) or 0
					self.iconRestore[target] = oldIcon
				end
				SetRaidTarget(target, i)--Icons match number in table in alpha sort
				if returnFunc then
					self[returnFunc](self, target, i)--Send icon and target to returnFunc. (Generally used by announce icon targets to raid chat feature)
				end
			end
			DBM:Schedule(1.5, clearSortTable, scanID)--Table wipe delay so if icons go out too early do to low fps or bad latency, when they get new target on table, resort and reapplying should auto correct teh icon within .2-.4 seconds at most.
		end

		function bossModPrototype:SetAlphaIcon(delay, target, maxIcon, returnFunc, scanID)
			if not target then return end
			if DBM.Options.DontSetIcons or not enableIcons or DBM:GetRaidRank(playerName) == 0 then
				return
			end
			scanID = scanID or 1
			local uId = DBM:GetRaidUnitId(target)
			if uId or UnitExists(target) then--target accepts uid, unitname both.
				uId = uId or target
				if not iconSortTable[scanID] then iconSortTable[scanID] = {} end
				if not iconSet[scanID] then iconSet[scanID] = 0 end
				local foundDuplicate = false
				for i = #iconSortTable[scanID], 1, -1 do
					if iconSortTable[scanID][i] == uId then
						foundDuplicate = true
						break
					end
				end
				if not foundDuplicate then
					iconSet[scanID] = iconSet[scanID] + 1
					tinsert(iconSortTable[scanID], uId)
				end
				self:UnscheduleMethod("SetIconByAlphaTable")
				if maxIcon and iconSet[scanID] == maxIcon then
					self:SetIconByAlphaTable(returnFunc, scanID)
				elseif self:LatencyCheck() then--lag can fail the icons so we check it before allowing.
					self:ScheduleMethod(delay or 0.5, "SetIconByAlphaTable", returnFunc, scanID)
				end
			end
		end

		function bossModPrototype:SetIconBySortedTable(startIcon, reverseIcon, returnFunc, scanID)
			tsort(iconSortTable[scanID], sort_by_group)
			local icon, CustomIcons
			if startIcon and type(startIcon) == "table" then--Specific gapped icons
				CustomIcons = true
				icon = 1
			else
				icon = startIcon or 1
			end
			for i, v in ipairs(iconSortTable[scanID]) do
				if not self.iconRestore[v] then
					local oldIcon = self:GetIcon(v) or 0
					self.iconRestore[v] = oldIcon
				end
				if CustomIcons then
					SetRaidTarget(v, startIcon[icon])--do not use SetIcon function again. It already checked in SetSortedIcon function.
					icon = icon + 1
					if returnFunc then
						self[returnFunc](self, v, startIcon[icon])--Send icon and target to returnFunc. (Generally used by announce icon targets to raid chat feature)
					end
				else
					SetRaidTarget(v, icon)--do not use SetIcon function again. It already checked in SetSortedIcon function.
					if reverseIcon then
						icon = icon - 1
					else
						icon = icon + 1
					end
					if returnFunc then
						self[returnFunc](self, v, icon)--Send icon and target to returnFunc. (Generally used by announce icon targets to raid chat feature)
					end
				end
			end
			DBM:Schedule(1.5, clearSortTable, scanID)--Table wipe delay so if icons go out too early do to low fps or bad latency, when they get new target on table, resort and reapplying should auto correct teh icon within .2-.4 seconds at most.
		end

		function bossModPrototype:SetSortedIcon(delay, target, startIcon, maxIcon, reverseIcon, returnFunc, scanID)
			if not target then return end
			if DBM.Options.DontSetIcons or not enableIcons or DBM:GetRaidRank(playerName) == 0 then
				return
			end
			scanID = scanID or 1
			if not startIcon then startIcon = 1 end
			local uId = DBM:GetRaidUnitId(target)
			if uId or UnitExists(target) then--target accepts uid, unitname both.
				uId = uId or target
				if not iconSortTable[scanID] then iconSortTable[scanID] = {} end
				if not iconSet[scanID] then iconSet[scanID] = 0 end
				local foundDuplicate = false
				for i = #iconSortTable[scanID], 1, -1 do
					if iconSortTable[scanID][i] == uId then
						foundDuplicate = true
						break
					end
				end
				if not foundDuplicate then
					iconSet[scanID] = iconSet[scanID] + 1
					tinsert(iconSortTable[scanID], uId)
				end
				self:UnscheduleMethod("SetIconBySortedTable")
				if maxIcon and iconSet[scanID] == maxIcon then
					self:SetIconBySortedTable(startIcon, reverseIcon, returnFunc, scanID)
				elseif self:LatencyCheck() then--lag can fail the icons so we check it before allowing.
					self:ScheduleMethod(delay or 0.5, "SetIconBySortedTable", startIcon, reverseIcon, returnFunc, scanID)
				end
			end
		end
	end

	function bossModPrototype:GetIcon(uId)
		return UnitExists(uId) and GetRaidTargetIndex(uId)
	end

	function bossModPrototype:RemoveIcon(target)
		return self:SetIcon(target, 0)
	end

	function bossModPrototype:ClearIcons()
		if GetNumRaidMembers() > 0 then
			for i = 1, GetNumRaidMembers() do
				if UnitExists("raid"..i) and GetRaidTargetIndex("raid"..i) then
					SetRaidTarget("raid"..i, 0)
				end
			end
		else
			for i = 1, GetNumPartyMembers() do
				if UnitExists("party"..i) and GetRaidTargetIndex("party"..i) then
					SetRaidTarget("party"..i, 0)
				end
			end
		end
	end

	function bossModPrototype:CanSetIcon(optionName)
		if canSetIcons[optionName] then
			return true
		end
		return false
	end

	local mobUids = {"mouseover", "target", "boss1", "boss2", "boss3", "boss4"}
	function bossModPrototype:ScanForMobs(creatureID, iconSetMethod, mobIcon, maxIcon, scanInterval, scanningTime, optionName, isFriendly, secondCreatureID, skipMarked)
		if not optionName then optionName = self.findFastestComputer[1] end
		if canSetIcons[optionName] then
			--Declare variables.
			DBM:Debug("canSetIcons true", 2)
			local timeNow = GetTime()
			if not creatureID then--This function must not be used to boss, so remove self.creatureId. Accepts cid, guid and cid table
				error("DBM:ScanForMobs calld without creatureID")
				return
			end
			iconSetMethod = iconSetMethod or 0--Set IconSetMethod -- 0: Descending / 1:Ascending / 2: Force Set / 9:Force Stop
			scanningTime = scanningTime or 8
			maxIcon = maxIcon or 8 --We only have 8 icons.
			isFriendly = isFriendly or false
			secondCreatureID = secondCreatureID or 0
			scanInterval = scanInterval or 0.2
			--With different scanID, this function can support multi scanning same time. Required for Nazgrim.
			local scanID = 0
			if type(creatureID) == "number" then
				scanID = creatureID --guid and table no not supports multi scanning. only cid supports multi scanning
			end
			if iconSetMethod == 9 then--Force stop scanning
				--clear variables
				scanExpires[scanID] = nil
				addsIcon[scanID] = nil
				addsIconSet[scanID] = nil
				return
			end
			if not addsIcon[scanID] then addsIcon[scanID] = mobIcon or 8 end
			if not addsIconSet[scanID] then addsIconSet[scanID] = 0 end
			if not scanExpires[scanID] then scanExpires[scanID] = timeNow + scanningTime end
			--DO SCAN NOW
			for _, unitid2 in ipairs(mobUids) do
				local guid2 = UnitGUID(unitid2)
				local cid2 = self:GetCIDFromGUID(guid2)
				local isEnemy = UnitIsEnemy("player", unitid2) or true--If api returns nil, assume it's an enemy
				local isFiltered = false
				if (not isFriendly and not isEnemy) or (skipMarked and not GetRaidTargetIndex(unitid2)) then
					isFiltered = true
					DBM:Debug("A unit skipped because it's a filtered mob", 3)
				end
				if not isFiltered then
					if guid2 and type(creatureID) == "table" and creatureID[cid2] and not addsGUIDs[guid2] then
						DBM:Debug("Match found, SHOULD be setting icon", 2)
						if type(creatureID[cid2]) == "number" then
							SetRaidTarget(unitid2, creatureID[cid2])
						else
							SetRaidTarget(unitid2, addsIcon[scanID])
							if iconSetMethod == 1 then
								addsIcon[scanID] = addsIcon[scanID] + 1
							else
								addsIcon[scanID] = addsIcon[scanID] - 1
							end
						end
						addsGUIDs[guid2] = true
						addsIconSet[scanID] = addsIconSet[scanID] + 1
						if addsIconSet[scanID] >= maxIcon then--stop scan immediately to save cpu
							--clear variables
							scanExpires[scanID] = nil
							addsIcon[scanID] = nil
							addsIconSet[scanID] = nil
							return
						end
					elseif guid2 and (guid2 == creatureID or cid2 == creatureID or cid2 == secondCreatureID) and not addsGUIDs[guid2] then
						DBM:Debug("Match found, SHOULD be setting icon", 2)
						if iconSetMethod == 2 then
							SetRaidTarget(unitid2, mobIcon)
						else
							SetRaidTarget(unitid2, addsIcon[scanID])
							if iconSetMethod == 1 then
								addsIcon[scanID] = addsIcon[scanID] + 1
							else
								addsIcon[scanID] = addsIcon[scanID] - 1
							end
						end
						addsGUIDs[guid2] = true
						addsIconSet[scanID] = addsIconSet[scanID] + 1
						if addsIconSet[scanID] >= maxIcon then--stop scan immediately to save cpu
							--clear variables
							scanExpires[scanID] = nil
							addsIcon[scanID] = nil
							addsIconSet[scanID] = nil
							return
						end
					end
				end
			end
			for uId in DBM:GetGroupMembers() do
				local unitid = uId.."target"
				local guid = UnitGUID(unitid)
				local cid = self:GetCIDFromGUID(guid)
				local isEnemy = UnitIsEnemy("player", unitid) or true--If api returns nil, assume it's an enemy
				local isFiltered = false
				if (not isFriendly and not isEnemy) or (skipMarked and not GetRaidTargetIndex(unitid)) then
					isFiltered = true
					DBM:Debug("ScanForMobs aborting because filtered mob", 2)
				end
				if not isFiltered then
					if guid and type(creatureID) == "table" and creatureID[cid] and not addsGUIDs[guid] then
						DBM:Debug("Match found, SHOULD be setting icon", 2)
						if type(creatureID[cid]) == "number" then
							SetRaidTarget(unitid, creatureID[cid])
						else
							SetRaidTarget(unitid, addsIcon[scanID])
							if iconSetMethod == 1 then
								addsIcon[scanID] = addsIcon[scanID] + 1
							else
								addsIcon[scanID] = addsIcon[scanID] - 1
							end
						end
						addsGUIDs[guid] = true
						addsIconSet[scanID] = addsIconSet[scanID] + 1
						if addsIconSet[scanID] >= maxIcon then--stop scan immediately to save cpu
							--clear variables
							scanExpires[scanID] = nil
							addsIcon[scanID] = nil
							addsIconSet[scanID] = nil
							return
						end
					elseif guid and (guid == creatureID or cid == creatureID or cid == secondCreatureID) and not addsGUIDs[guid] then
						DBM:Debug("Match found, SHOULD be setting icon", 2)
						if iconSetMethod == 2 then
							SetRaidTarget(unitid, mobIcon)
						else
							SetRaidTarget(unitid, addsIcon[scanID])
							if iconSetMethod == 1 then
								addsIcon[scanID] = addsIcon[scanID] + 1
							else
								addsIcon[scanID] = addsIcon[scanID] - 1
							end
						end
						addsGUIDs[guid] = true
						addsIconSet[scanID] = addsIconSet[scanID] + 1
						if addsIconSet[scanID] >= maxIcon then--stop scan immediately to save cpu
							--clear variables
							scanExpires[scanID] = nil
							addsIcon[scanID] = nil
							addsIconSet[scanID] = nil
							return
						end
					end
				end
			end
			if timeNow < scanExpires[scanID] then--scan for limited times.
				self:ScheduleMethod(scanInterval, "ScanForMobs", creatureID, iconSetMethod, mobIcon, maxIcon, scanInterval, scanningTime, optionName, isFriendly, secondCreatureID)
			else
				DBM:Debug("Stopping ScanForMobs for: "..(optionName or "nil"), 2)
				--clear variables
				scanExpires[scanID] = nil
				addsIcon[scanID] = nil
				addsIconSet[scanID] = nil
				--Do not wipe adds GUID table here, it's wiped by :Stop() which is called by EndCombat
			end
		else
			DBM:Debug("Not elected to set icons for "..(optionName or "nil"), 2)
		end
	end
end

-----------------------
--  Model Functions  --
-----------------------
function bossModPrototype:SetModelScale(scale)
	self.modelScale = scale
end

function bossModPrototype:SetModelOffset(x, y, z)
	self.modelOffsetX = x
	self.modelOffsetY = y
	self.modelOffsetZ = z
end

function bossModPrototype:SetModelRotation(r)
	self.modelRotation = r
end

function bossModPrototype:SetModelMoveSpeed(v)
	self.modelMoveSpeed = v
end

function bossModPrototype:SetModelID(id)
	self.modelId = id
end

function bossModPrototype:SetModelSound(long, short)--PlaySoundFile prototype for model viewer, long is long sound, short is a short clip, configurable in UI, both sound paths defined in boss mods.
	self.modelSoundLong = long
	self.modelSoundShort = short
end

function bossModPrototype:EnableModel()
	self.modelEnabled = true
end

function bossModPrototype:DisableModel()
	self.modelEnabled = nil
end

--------------------
--  Localization  --
--------------------
function bossModPrototype:GetLocalizedStrings()
	self.localization.miscStrings.name = self.localization.general.name
	return self.localization.miscStrings
end

-- Not really good, needs a few updates
do
	local modLocalizations = {}
	local modLocalizationPrototype = {}
	local mt = {__index = modLocalizationPrototype}
	local returnKey = {__index = function(t, k) return k end}
	local defaultCatLocalization = {
		__index = setmetatable({
			timer				= DBM_CORE_OPTION_CATEGORY_TIMERS,
			announce			= DBM_CORE_OPTION_CATEGORY_WARNINGS,
			announceother		= DBM_CORE_OPTION_CATEGORY_WARNINGS_OTHER,
			announcepersonal	= DBM_CORE_OPTION_CATEGORY_WARNINGS_YOU,
			announcerole		= DBM_CORE_OPTION_CATEGORY_WARNINGS_ROLE,
			sound				= DBM_CORE_OPTION_CATEGORY_SOUNDS,
			yell				= DBM_CORE_OPTION_CATEGORY_YELLS,
			icon				= DBM_CORE_OPTION_CATEGORY_ICONS,
			misc				= MISCELLANEOUS
		}, returnKey)
	}
	local defaultTimerLocalization = {
		__index = setmetatable({
			timer_berserk = DBM_CORE_GENERIC_TIMER_BERSERK,
			timer_combat = DBM_CORE_GENERIC_TIMER_COMBAT
		}, returnKey)
	}
	local defaultAnnounceLocalization = {
		__index = setmetatable({
			warning_berserk = DBM_CORE_GENERIC_WARNING_BERSERK
		}, returnKey)
	}
	local defaultOptionLocalization = {
		__index = setmetatable({
			timer_berserk = DBM_CORE_OPTION_TIMER_BERSERK,
			timer_combat = DBM_CORE_OPTION_TIMER_COMBAT,
		}, returnKey)
	}
	local defaultMiscLocalization = {
		__index = {}
	}

	function modLocalizationPrototype:SetGeneralLocalization(t)
		for i, v in pairs(t) do
			self.general[i] = v
		end
	end

	function modLocalizationPrototype:SetWarningLocalization(t)
		for i, v in pairs(t) do
			self.warnings[i] = v
		end
	end

	function modLocalizationPrototype:SetTimerLocalization(t)
		for i, v in pairs(t) do
			self.timers[i] = v
		end
	end

	function modLocalizationPrototype:SetOptionLocalization(t)
		for i, v in pairs(t) do
			self.options[i] = v
		end
	end

	function modLocalizationPrototype:SetOptionCatLocalization(t)
		for i, v in pairs(t) do
			self.cats[i] = v
		end
	end

	function modLocalizationPrototype:SetMiscLocalization(t)
		for i, v in pairs(t) do
			self.miscStrings[i] = v
		end
	end

	function DBM:CreateModLocalization(name)
		name = tostring(name)
		local obj = {
			general = setmetatable({}, returnKey),
			warnings = setmetatable({}, defaultAnnounceLocalization),
			options = setmetatable({}, defaultOptionLocalization),
			timers = setmetatable({}, defaultTimerLocalization),
			miscStrings = setmetatable({}, defaultMiscLocalization),
			cats = setmetatable({}, defaultCatLocalization),
		}
		setmetatable(obj, mt)
		modLocalizations[name] = obj
		return obj
	end

	function DBM:GetModLocalization(name)
		name = tostring(name)
		return modLocalizations[name] or self:CreateModLocalization(name)
	end
end
