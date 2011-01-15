-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("General Umbriss", "Grim Batol")
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(39625)
mod.toggleOptions = {
	{74670, "ICON"}, -- Blitz
	90249, -- Ground Siege
	74853, -- Frenzy
	91937, -- Wound
	"bosskill",
}

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then--@do-not-package@
L["blitz_trigger"] = " "--@localization(locale="enUS", namespace="GrimBatol/Umbriss", format="lua_additive_table", handle-unlocalized="ignore")@
end -- XXX trigger ulic + activate locale
L = mod:GetLocale()

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:Emote("Blitz", L["blitz_trigger"])
	self:RegisterEvent("UNIT_HEALTH")

	self:Log("SPELL_CAST_START", "Siege", 74634, 90249)
	self:Log("SPELL_AURA_APPIED", "Frenzy", 74853)
	self:Log("SPELL_AURA_APPIED", "Wound", 74846, 91937)
	self:Log("SPELL_AURA_REMOVED", "WoundRemoved", 74846, 91937)

	self:Death("Win", 39625)
end

function mod:VerifyEnable()
	if not UnitInVehicle("player") then return true end
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Blitz(_, _, _, _, player)
	self:TargetMessage(74670, GetSpellInfo(74670), player, "Urgent", 74670, "Alert")
	self:PrimaryIcon(74670, player)
	self:ScheduleTimer("ClearIcon", 3.5)
end

function mod:ClearIcon()
	self:PrimaryIcon(74670)
end

function mod:Siege(_, spellId, _, _, spellName)
	self:Message(90249, spellName, "Attention", spellId)
end

function mod:UNIT_HEALTH(_, unit)
	if unit ~= "boss1" then return end
	if UnitName(unit) == self.displayName then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp < 36 then
			self:Message(74853, LW_CL["soon"]:format(GetSpellInfo(74853)), "Attention", 74853)
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

function mod:Frenzy(_, spellId, _, _, spellName)
	self:Message(74853, spellName, "Long", spellId, "Info")
end

function mod:Wound(player, spellId, _, _, spellName)
	self:TargetMessage(91937, spellName, player, "Urgent", spellId)
	self:Bar(91937, player..": "..spellName, 15, spellId)
end

function mod:WoundRemoved(player, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, player..": "..spellName)
end

