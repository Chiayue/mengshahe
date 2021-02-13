modifier_active_single_magical_lua = class ({})

--------------------------------------------------------------------------------

function modifier_active_single_magical_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_single_magical_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_single_magical_lua:IsPurgable()
	return false
end

function modifier_active_single_magical_lua:OnCreated( kv )
	self.bonuses_scale = self:GetAbility():GetSpecialValueFor("bonuses_scale");
	self.attribute_type = self:GetAbility():GetSpecialValueFor("attribute_type");
end
--------------------------------------------------------------------------------

function modifier_active_single_magical_lua:OnDestroy()
	if IsServer() then
		local nDamageType = DAMAGE_TYPE_MAGICAL
		if self:GetCaster():HasScepter() then
			nDamageType = DAMAGE_TYPE_PURE
		end
		local att_value = self:GetCaster():GetIntellect();
		
		if self.attribute_type == 0 then
			att_value = self:GetCaster():GetStrength();
		elseif self.attribute_type == 1 then
			att_value = self:GetCaster():GetAgility();
		end
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor( "damage" ) + att_value*self.bonuses_scale,
			damage_type = nDamageType,
			ability = self:GetAbility()
		}
		-- print(">>>>>>>>>>> damage: "..damage.damage);
		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
