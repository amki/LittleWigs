-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Drahga Shadowburner", "Grim Batol")
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(40319)
mod.toggleOptions = {
	75218, -- Invocation of Flame
	90950, -- Devouring Flames
	"bosskill",
}
mod.optionHeaders = {
	[90950] = "heroic",
	[75218] = "general",
}
-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then--@do-not-package@
L["summon_trigger"] = "%s Summons an"
L["summon_message"] = "Add Spawned!"--@end-do-not-package@
--@localization(locale="enUS", namespace="GrimBatol/Drahga", format="lua_additive_table", handle-unlocalized="ignore")@
end
L = mod:GetLocale()

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	-- normal
	self:Emote("Summon", L["summon_trigger"])
	-- heroic
	self:Log("SPELL_CAST_START", "Flame", 90950)

	self:Death("Win", 40319)
end

function mod:VerifyEnable()
	if not UnitInVehicle("player") then return true end
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Summon()
	self:Message(75218, L["summon_message"], "Attention", 75218, "Alarm")
end

function mod:Flame(_, spellId, _, _, spellName)
	self:Message(90950, spellName, "Important", spellId, "Long")
end

