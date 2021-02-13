if modifier_chougou == nil then 
	modifier_chougou = ({})
end

function modifier_chougou:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_chougou:IsAura() return true end
function modifier_chougou:GetAuraDuration() return 0.1 end
function modifier_chougou:GetModifierAura() return "modifier_chougou_damage" end
function modifier_chougou:GetAuraRadius() return 500 end
function modifier_chougou:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chougou:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chougou:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
-- function modifier_chougou:GetAuraEntityReject(unit)
-- 	if unit ~= self:GetCaster() then
-- 		return true
-- 	end
-- 	return false
-- end
local property_record = {}

function modifier_chougou:OnCreated(params)
	if IsServer() then 
		local caster = self:GetParent()
		local ability = self:GetAbility()
		self.model_scale = caster:GetModelScale()
		self.damage_add = ability:GetSpecialValueFor( "damage_add" )
		self.damage_jian = -ability:GetSpecialValueFor( "damage_jian" )
		property_record.damage_add = self.damage_add
		property_record.damage_jian = self.damage_jian
		caster:SetModelScale(3)
	end
	
end

function modifier_chougou:OnDestroy(  )
	if IsServer() then 
		local caster = self:GetParent()
		caster:SetModelScale(self.model_scale)
		if not self:GetAbility():GetSpecialValueFor("do_sublime") then
			caster:SetBaseAgility(caster:GetBaseAgility() * 0.9)
			caster:SetBaseStrength(caster:GetBaseStrength(  ) * 0.9)
			caster:SetBaseIntellect(caster:GetBaseIntellect(  ) * 0.9)
		end
	end
end

function modifier_chougou:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		return self.damage_jian
	else
		return property_record.damage_jian
	end
	
	
end
function modifier_chougou:GetModifierDamageOutgoing_Percentage()
	if IsServer() then
		return self.damage_add
	else
		return property_record.damage_add
	end
	
end


if modifier_chougou_damage == nil then 
	modifier_chougou_damage = ({})
end

function modifier_chougou_damage:OnCreated( param)
	self:StartIntervalThink(1)
end

function modifier_chougou_damage:OnIntervalThink()
	if IsServer() then 
		local caster = self:GetCaster();
		local damage_amount = (caster:GetStrength(  )+ caster:GetAgility(  )+caster:GetIntellect()) * 2
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage_amount,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(  )
		}
		ApplyDamage( damage )
	end
end