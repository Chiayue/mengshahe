LinkLuaModifier( "modifier_archon_passive_dark", "ability/abilities_lua/archon_passive_dark.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archon_passive_dark_debuff", "ability/abilities_lua/archon_passive_dark.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if archon_passive_dark == nil then
	archon_passive_dark = class({})
end

if modifier_archon_passive_dark_debuff == nil then
	modifier_archon_passive_dark_debuff = class({})
end

function archon_passive_dark:GetIntrinsicModifierName()
 	return "modifier_archon_passive_dark"
end
--------------------------------------------------
if modifier_archon_passive_dark == nil then
	modifier_archon_passive_dark = class({})
end

function modifier_archon_passive_dark:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_archon_passive_dark:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return 0
	end
	local hTarget = params.target
	self.abil_damage = self:GetCaster():GetStrength() + self:GetCaster():GetAgility() + self:GetCaster():GetIntellect()
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local damage = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self.abil_damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
	}
	ApplyDamage( damage )

	hTarget:AddNewModifier( 
		self:GetCaster(), 
		self:GetAbility(), 
		"modifier_archon_passive_dark_debuff", 
		{ duration = duration} 
	)
end

--------------------------------------------------------------------------------

function modifier_archon_passive_dark_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_archon_passive_dark_debuff:GetEffectName()
	return "particles/units/heroes/hero_spectre/spectre_desolate_debuff_embers.vpcf"
end

function modifier_archon_passive_dark_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_archon_passive_dark_debuff:OnCreated( kv )
	local property_all = self:GetCaster():GetStrength() + self:GetCaster():GetAgility() + self:GetCaster():GetIntellect()
	self.arrmor_out = property_all * 0.05
	-- print(self:GetCaster():GetStrength() , self:GetCaster():GetAgility() , self:GetCaster():GetIntellect())
	-- print(property_all , property_all * 0.05)
	-- print(self.arrmor_out)
	-- PopupDamage(self:GetParent(), self.abil_damage)
	-- PopupHealing(self:GetParent(), self.abil_damage)

end


function modifier_archon_passive_dark_debuff:OnRefresh( kv )
	local property_all = self:GetCaster():GetStrength() + self:GetCaster():GetAgility() + self:GetCaster():GetIntellect()
	self.arrmor_out = property_all * 0.05
end

function modifier_archon_passive_dark_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_archon_passive_dark_debuff:GetModifierPhysicalArmorBonus()
	return -self.arrmor_out
end



