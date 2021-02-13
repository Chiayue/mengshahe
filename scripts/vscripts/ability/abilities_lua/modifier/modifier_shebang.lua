if modifier_shebang == nil then 
	modifier_shebang = ({})
end

function modifier_shebang:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_shebang:OnCreated( param )
	self.damage_amount = self:GetAbility():GetSpecialValueFor("damage_amount")
	self.base_attacktime = self:GetAbility():GetSpecialValueFor("base_attacktime")
end

function modifier_shebang:OnDestroy()
	if IsServer() then
		-- if self:GetParent() then 
		-- 	UTIL_Remove(self:GetParent())
		-- end
	end
end

function modifier_shebang:IsHidden()
	return true
end

function modifier_shebang:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		return self.base_attacktime
	end
end

function modifier_shebang:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_shebang:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_shebang:OnAttackLanded(params)
	local attacker = params.attacker
	if attacker:GetTeam() == DOTA_TEAM_GOODGUYS then
		return
	end
	if self:GetParent() ~= params.target then 
		return
	end
	self:IncrementStackCount()
	local count = self:GetStackCount()
	if count >= self.damage_amount then
		UTIL_Remove(self:GetParent())
	end
end

