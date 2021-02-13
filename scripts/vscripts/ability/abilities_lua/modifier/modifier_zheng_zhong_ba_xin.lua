if modifier_zheng_zhong_ba_xin == nil then
	modifier_zheng_zhong_ba_xin = ({})
end

function modifier_zheng_zhong_ba_xin:OnCreated( params )
	if not IsServer() then 
		return
	end
	local unit = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility(  )
	local damage = {
		victim = unit,
		attacker = caster,
		damage = caster:GetAgility(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = ability
	}
	ApplyDamage( damage )
end

function modifier_zheng_zhong_ba_xin:OnRefresh( params )
	if not IsServer() then 
		return
	end
	self:IncrementStackCount();
	local unit = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility(  )
	local amount = self:GetStackCount()
	local damage = {
		victim = unit,
		attacker = caster,
		damage = caster:GetAgility() * (1 +amount),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = ability
	}
	ApplyDamage( damage )
end