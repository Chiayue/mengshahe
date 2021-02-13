zibao_lua = class({})

--------------------------------------------------------------------------------

function zibao_lua:OnSpellStart()
    if IsServer() then
        local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local att_value = enemy:GetHealth()*(self:GetSpecialValueFor("damagepercent")/100);
                    local percent = 1
					if ContainUnitTypeFlag(enemy, DOTA_UNIT_TYPE_FLAG_BOSS) or ContainUnitTypeFlag(enemy, DOTA_UNIT_TYPE_FLAG_OPERATION) then
                        percent = 0.5
                    end
					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = att_value * percent,
						damage_type = self:GetAbilityDamageType(),
						ability = self
					}
					-- print(">>>>>>>>>>>>> damage: "..damage.damage);
					-- enemy:AddNewModifier( self.Caster, self:GetAbility(), "modifier_active_point_magical_lua", { duration = self.duration } )
					ApplyDamage( damage )
				end
			end
        end
        local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 600, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        self:GetCaster():EmitSound("skill.bom1")
        self:GetCaster():Kill(nil, self:GetCaster())
    end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------