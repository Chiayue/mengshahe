if modifier_diyuhuo == nil then 
	modifier_diyuhuo = ({})
end

function modifier_diyuhuo:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    }
    return funcs
end

function modifier_diyuhuo:OnCreated( param )
	if IsServer() then
		self.attack_time = self:GetAbility():GetSpecialValueFor("base_attacktime")
	end
end

function modifier_diyuhuo:OnDestroy()
	if IsServer() then
		if self:GetParent() then 
			-- self:GetParent():ForceKill(true)
			UTIL_Remove(self:GetParent())
		end
	end
end

function modifier_diyuhuo:IsHidden()
	return true
end

function modifier_diyuhuo:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		return self.attack_time
	end
end




