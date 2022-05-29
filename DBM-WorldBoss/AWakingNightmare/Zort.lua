local mod	= DBM:NewMod("Zort", "DBM-WorldBoss", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("20210501000000"):sub(12, -3))
mod:SetCreatureID(50702)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
    "SPELL_AURA_APPLIED_DOSE",
	"UNIT_TARGET",
    "SPELL_DAMAGE",
    "SPELL_PERIODIC_DAMAGE",
	"SPELL_AURA_REMOVED",
	"SPELL_INTERRUPT",
	"SPELL_CAST_FAILED",
    "UNIT_HEALTH",
	"UNIT_DIED",
	"SWING_DAMAGE"
)


local warnPhase2Soon   					= mod:NewPrePhaseAnnounce(2, 2)
local warnPhase2     					= mod:NewPhaseAnnounce(2, 2)
local warnPech							= mod:NewTargetAnnounce(307814, 2)
local warnFlame							= mod:NewTargetAnnounce(307839, 2)
local warnSveaz							= mod:NewTargetAnnounce(308516, 3)
local warnkik							= mod:NewCastAnnounce(307829, 1)
local warnPriziv						= mod:NewCastAnnounce(307852, 3)
local warnShkval						= mod:NewCastAnnounce(307821, 3)
local warnTraitor						= mod:NewCountAnnounce(307814, 2, nil, false)

local specWarnshkval					= mod:NewSpecialWarningCast(307821, nil, nil, nil, 1, 2)
local specWarnTraitor					= mod:NewSpecialWarningStack(307814, nil, 4, nil, nil, 1, 6)
local specWarnReturnInterrupt			= mod:NewSpecialWarningInterrupt(307829, "HasInterrupt", nil, 2, 1, 2)
local specWarnPechati					= mod:NewSpecialWarningCast(307814, nil, nil, nil, 5, 2) --предатель
local specWarnFlame						= mod:NewSpecialWarningMoveAway(307839, nil, nil, nil, 3, 2)
local specWarnSveaz						= mod:NewSpecialWarningYou(308516, nil, nil, nil, 3, 2)
local yellSveazi						= mod:NewYell(308516)
local yellFlame							= mod:NewYell(307839, nil, nil, nil, "YELL") --Огонь
local yellFlameFade						= mod:NewShortFadesYell(307839, nil, nil, nil, "YELL")
local yellCastsvFade					= mod:NewShortFadesYell(308520)


local timerSveazi						= mod:NewCDTimer(20, 314606, nil, nil, nil, 2)
local timerPriziv						= mod:NewCDTimer(60, 307852, nil, nil, nil, 4)
local timerkik							= mod:NewCDTimer(15, 307829, nil, nil, nil, 3)
local timerShkval						= mod:NewCDTimer(20, 307821, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnSveazTarget", 314606, true, true, {1, 2, 3})
mod:AddSetIconOption("SetIconOnFlameTarget", 307839, true, true, {5, 6})
mod:AddBoolOption("AnnounceSveaz", false)
mod:AddBoolOption("AnnounceFlame", false)

local SveazTargets = {}
local FlameTargets = {}
local SveazIcons = 3
local FlameIcons = 6
local warned_preP1 = false
local warned_preP2 = false

function mod:OnCombatStart(delay)
	mod:SetStage(1)
	timerkik:start(-delay)
	timerShkval:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

function mod:OnCombatEnd(wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 307829 then
		warnkik:Show()
		timerkik:Start()
		specWarnReturnInterrupt:Show()
	elseif spellId == 307820 or spellId == 307818 or spellId == 307817 then
		warnShkval:Show()
		timerShkval:Start()
		specWarnshkval:Show()
	elseif spellId == 308520 then
		yellCastsvFade:Countdown(spellId)
	elseif spellId == 307852 then
		warnPriziv:Show()
		timerPriziv:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 307814 then
		if args:IsPlayer() then
			specWarnPechati:Show()
			warnTraitor:Show(args.amount or 1)
			if ((args.amount or 1) >= 3) then
				specWarnTraitor:Show(args.amount)
				specWarnTraitor:Play("stackhigh")
			end
		end
	elseif spellId == 307839 then
		FlameTargets[#FlameTargets + 1] = args.destName
		self:ScheduleMethod(0.1, "SetFlameIcons")
		if args:IsPlayer() then
			specWarnFlame:Show()
			yellFlame:Yell()
			yellFlameFade:Countdown(spellId)
		end
	elseif spellId == 308516 or spellId == 308517 then
		SveazTargets[#SveazTargets + 1] = args.destName
		self:ScheduleMethod(0.1, "SetSveazIcons")
		timerSveazi:Start()
		if args:IsPlayer() then
			yellSveazi:Yell()
			specWarnSveaz:Show()
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 307839 then
		FlameIcons = 6
		if self.Options.SetIconOnFlameTarget then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 308516 or spellId == 308517 then
		if self.Options.SetIconOnSveazTarget then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_INTERRUPT(args)
	local spellId = args.spellId
	if spellId == 307829 then
	timerkik:Start()
	specWarnReturnInterrupt:Show()
	end
end
function mod:SPELL_CAST_FAILED(args)
	local spellId = args.spellId
	if spellId == 308520 then
		yellCastsvFade:Cancel()
	end
end

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	end
	function mod:SetFlameIcons()
		table.sort(FlameTargets, sort_by_group)
		for i, v in ipairs(FlameTargets) do
			if mod.Options.AnnounceFlame then
				if DBM:GetRaidRank() > 0 then
					SendChatMessage(L.Flame:format(FlameIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.Flame:format(FlameIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnFlameTarget then
				self:SetIcon(UnitName(v), FlameIcons, 15)
			end
			FlameIcons = FlameIcons - 1
		end
			warnFlame:Show(table.concat(FlameTargets, "<, >"))
			table.wipe(FlameTargets)
	end
	function mod:SetSveazIcons()
		table.sort(SveazTargets, sort_by_group)
		for i, v in ipairs(SveazTargets) do
			if mod.Options.AnnounceSveaz then
				if DBM:GetRaidRank() > 0 then
					SendChatMessage(L.Sveaz:format(SveazIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.Sveaz:format(SveazIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnSveazTarget then
				self:SetIcon(UnitName(v), SveazIcons, 10)
			end
			SveazIcons = SveazIcons - 1
		end
			warnSveaz:Show(table.concat(SveazTargets, "<, >"))
			table.wipe(SveazTargets)
			SveazIcons = 3
	end
end

--[[
function mod:UNIT_HEALTH(uId)
		if self.vb.phase == 1 and not warned_preP1 and self:GetUnitCreatureId(uId) == 50715 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.53 then
			warned_preP1 = true
			warnPhase2Soon:Show()
		end
		if self.vb.phase == 1 and not warned_preP2 and self:GetUnitCreatureId(uId) == 50702 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 then
			warned_preP2 = true
			mod:SetStage(2)
			warnPhase2:Show()
		end
end


function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if self.vb.phase == 1 and cid == 50715 then
		mod:SetStage(2)
	elseif self.vb.phase == 2 and cid == 50714 then
		mod:SetStage(3)

	end
end
]]