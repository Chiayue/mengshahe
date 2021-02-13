if modifier_yu_zhan_yu_yong == nil then 
	modifier_yu_zhan_yu_yong = ({})
end

function modifier_yu_zhan_yu_yong:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_yu_zhan_yu_yong:OnCreated( table )
	if IsServer() then 
		local hero = self:GetParent()
        local weartable = {
            "models/items/beastmaster/ti9_cache_beast_master_dinosaurs_telepathy_weapon/ti9_cache_beast_master_dinosaurs_telepathy_weapon.vmdl",
        }
		WearForHero(weartable,self:GetParent())
		
		self:GetParent():RemoveModifierByName("modifier_yu_zhan_yu_yong_base")
		self.critical_cf = self:GetAbility():GetSpecialValueFor("critical_cf")
		self.critical = 0
		self.is_critical = false
	end
end

function modifier_yu_zhan_yu_yong:OnAttackStart(params)
	if IsServer() then 
		local attacker = params.attacker
		if not attacker:IsHero() then 
			return
		end
		if attacker:HasModifier("modifier_critical_strike") then
			self.is_critical = true
		end
	end
end

function modifier_yu_zhan_yu_yong:OnAttackLanded(params)
	if IsServer() then 
		local attacker = params.attacker
		if not attacker:IsHero() then 
			return
		end
		if self.is_critical then
			attacker.dynamic_properties.attack_critical = attacker.dynamic_properties.attack_critical - self.critical
			self.critical = 0
			self.is_critical = false
		else
			self.critical = self.critical + self.critical_cf
			attacker.dynamic_properties.attack_critical = self.critical
		end
	end
end

function modifier_yu_zhan_yu_yong:IsHidden()
	return true
end
