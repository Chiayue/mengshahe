require("global/random_affix")

modifier_active_point_magical_lua_thinker = class({})

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua_thinker:OnCreated( kv )
	self.light_strike_array_aoe = self:GetAbility():GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_damage = self:GetAbility():GetSpecialValueFor( "light_strike_array_damage" )
	self.light_strike_array_stun_duration = self:GetAbility():GetSpecialValueFor( "light_strike_array_stun_duration" )
	self.light_strike_array_delay_time = self:GetAbility():GetSpecialValueFor( "light_strike_array_delay_time" )
	self.bonuses_scale = self:GetAbility():GetSpecialValueFor("bonuses_scale");
	self.attribute_type = self:GetAbility():GetSpecialValueFor("attribute_type");
	if IsServer() then
		self:StartIntervalThink( self.light_strike_array_delay_time )

		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self:GetCaster() )
		
		local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_active_point_magical_lua_thinker:OnIntervalThink()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.light_strike_array_aoe, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.light_strike_array_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local att_value = self:GetCaster():GetIntellect();
		
					if self.attribute_type == 0 then
						att_value = self:GetCaster():GetStrength();
					elseif self.attribute_type == 1 then
						att_value = self:GetCaster():GetAgility();
					end
					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.light_strike_array_damage + att_value * self.bonuses_scale,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}
					-- print(">>>>>>>>>>>>> damage: "..damage.damage);
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_active_point_magical_lua", { duration = self.light_strike_array_stun_duration } )
					ApplyDamage( damage )
				end
			end
		end

		-- local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, nil )
		-- ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		-- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1 ) )
		-- ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.LightStrikeArray", self:GetCaster() )

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------