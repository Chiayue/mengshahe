LinkLuaModifier( "modifier_fireoil_lua", "ability/abilities_lua/innateskill_fireoil_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_active_fire_lua","ability/abilities_lua/innateskill_fireoil_lua.lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------
--Abilities
if fireoil_lua == nil then
	fireoil_lua = class({})
end

function fireoil_lua:GetIntrinsicModifierName()
 	return "modifier_fireoil_lua"
end
--------------------------------------------------
if modifier_fireoil_lua == nil then
	modifier_fireoil_lua = class({})
end

function modifier_fireoil_lua:IsHidden()
    return true
end

function modifier_fireoil_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_fireoil_lua:OnAttackLanded(params)
    if not IsServer( ) then
        return
    end
    if params.attacker ~= self:GetParent() then
		return
    end
    if not self:GetAbility():IsCooldownReady() then
		return 0
	end
    local hTarget = params.target
    local kv = {}
	CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_active_fire_lua", kv, hTarget:GetOrigin(), self:GetCaster():GetTeamNumber(), false )

	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end
-----------------------------

modifier_active_fire_lua = class({})

--------------------------------------------------------------------------------

function modifier_active_fire_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_active_fire_lua:OnCreated( kv )
    if IsServer() then
        -- DeepPrintTable(self:GetAbility())
        self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
        self.space_time = self:GetAbility():GetSpecialValueFor( "space_time" )
        self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
        self.bonuses_scale = self:GetAbility():GetSpecialValueFor("bonuses_scale")
        self.Caster = self:GetCaster()
		
		-- EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self.Caster )
		
		-- self.index = ParticleManager:CreateParticleForTeam( "particles/diy_particles/fire.vpcf", PATTACH_WORLDORIGIN, self.Caster, self.Caster:GetTeamNumber() )
		-- ParticleManager:SetParticleControl( self.index, 0, self:GetParent():GetOrigin() )
		-- ParticleManager:SetParticleControl( self.index, 1, Vector( self.radius, 1, 1 ) )
		-- ParticleManager:ReleaseParticleIndex( self.index )
		self.index = ParticleManager:CreateParticle("particles/diy_particles/fire.vpcf", PATTACH_WORLDORIGIN, self.Caster)	
		ParticleManager:SetParticleControl( self.index, 0, self:GetParent():GetOrigin() )
		
		self:SetStackCount(1)
        self:StartIntervalThink( self.space_time )
	end
end

--------------------------------------------------------------------------------

function modifier_active_fire_lua:OnIntervalThink()
	if IsServer() then
		
		self:SetStackCount(self:GetStackCount() + 1)
		-- self:GetParent():CalculateStatBonus()
		
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local att_value = self.Caster:GetIntellect()+self.Caster:GetAgility()+self.Caster:GetStrength();
		
					att_value = self.Caster:GetStrength();
					local damage = {
						victim = enemy,
						attacker = self.Caster,
						damage = att_value * self.bonuses_scale,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility()
					}
					-- print(">>>>>>>>>>>>> damage: "..damage.damage);
					-- enemy:AddNewModifier( self.Caster, self:GetAbility(), "modifier_active_point_magical_lua", { duration = self.duration } )
					ApplyDamage( damage )
				end
			end
		end

		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self.Caster )
		
        -- print(" >>>>>>>>>>>> self.duration: "..self.duration)
        -- print(" >>>>>>>>>>>> self.GetStackCount: "..self:GetStackCount())
		if self.duration < self:GetStackCount() then
			self:Destroy()
		end
		-- UTIL_Remove( self:GetParent() )
	end
end

function modifier_active_fire_lua:OnDestroy()
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.index, false)
	ParticleManager:ReleaseParticleIndex(self.index)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------