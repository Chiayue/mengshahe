initiative_water_whirlpool_lua = class({})
initiative_water_whirlpool_lua_s = initiative_water_whirlpool_lua
initiative_water_whirlpool_lua_a = initiative_water_whirlpool_lua
initiative_water_whirlpool_lua_b = initiative_water_whirlpool_lua
initiative_water_whirlpool_lua_c = initiative_water_whirlpool_lua
initiative_water_whirlpool_lua_d = initiative_water_whirlpool_lua

LinkLuaModifier( "modifier_initiative_water_whirlpool_lua_thinker","ability/abilities_lua/initiative_water_whirlpool_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_water_whirlpool_slow_lua","ability/abilities_lua/initiative_water_whirlpool_lua", LUA_MODIFIER_MOTION_NONE )
function initiative_water_whirlpool_lua:OnSpellStart()
    local kv = {duration =  2}
    CreateModifierThinker( self:GetCaster(), self, "modifier_initiative_water_whirlpool_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )

end

function initiative_water_whirlpool_lua:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )

end
---------------------------------------------------------------------------------
if modifier_initiative_water_whirlpool_lua_thinker == nil then
	modifier_initiative_water_whirlpool_lua_thinker = class({})
end
function modifier_initiative_water_whirlpool_lua_thinker:IsHidden()
	return true
end
function modifier_initiative_water_whirlpool_lua_thinker:OnCreated( kv )

	if IsServer() then
		self.count = 2
		-- EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_water.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )   
		--设置计时器时间
		self:StartIntervalThink(0.1)
  
	end
end


function modifier_initiative_water_whirlpool_lua_thinker:OnIntervalThink()
	self.count = self.count - 0.1
	if self.count  <= 0.1 then
		UTIL_Remove( self:GetParent() )
	end
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 150, false )
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetAbility(),150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 1, 0, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) and (not enemy:HasModifier("modifier_water_whirlpool_slow_lua") )then
				local damage = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self:GetAbility():GetSpecialValueFor("baseDamage") + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("scale"),
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility()
				}
				enemy:AddNewModifier(self:GetCaster(),self:GetAbility(), "modifier_water_whirlpool_slow_lua", {duration = self:GetAbility():GetSpecialValueFor("duration")})
				ApplyDamage( damage ) 
			end
		end
	end
end

modifier_water_whirlpool_slow_lua = class({})

--------------------------------------------------------------------------------

function modifier_water_whirlpool_slow_lua:IsDebuff() return true end
function modifier_water_whirlpool_slow_lua:IsPurgable() return true end
function modifier_water_whirlpool_slow_lua:IsPurgeException() return true end

function modifier_water_whirlpool_slow_lua:GetEffectName()
	return "particles/ui/ui_slark_goalburst_water.vpcf"
end


function modifier_water_whirlpool_slow_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_water_whirlpool_slow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_water_whirlpool_slow_lua:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("speed_slow") end




