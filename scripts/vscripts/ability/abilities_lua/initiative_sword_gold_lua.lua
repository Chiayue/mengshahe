--黄金之剑
require("global/random_affix")
LinkLuaModifier( "modifier_initiative_sword_gold_lua_thinker","ability/abilities_lua/initiative_sword_gold_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_initiative_sword_gold_lua","ability/abilities_lua/initiative_sword_gold_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sword_gold_slow_lua","ability/abilities_lua/initiative_sword_gold_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
initiative_sword_gold_lua_d = class({})

function initiative_sword_gold_lua_d:GetAOERadius()
	return self:GetSpecialValueFor( "sword_gold_aoe" )
end

function initiative_sword_gold_lua_d:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "sword_gold_aoe" )
	self.light_sword_gold_delay_time = self:GetSpecialValueFor( "sword_gold_delay_time" )

	local kv = {duration = self:GetSpecialValueFor( "attribute_type" )}
	CreateModifierThinker( self:GetCaster(), self, "modifier_initiative_sword_gold_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function initiative_sword_gold_lua_d:GetIntrinsicModifierName()
	return "modifier_initiative_sword_gold_lua"
end
function initiative_sword_gold_lua_d:GetIntrinsicModifierName()
	return "modifier_sword_gold_slow_lua"
end
--------------------------------------------------------------------------------
initiative_sword_gold_lua_c = class({})

function initiative_sword_gold_lua_c:GetAOERadius()
	return self:GetSpecialValueFor( "sword_gold_aoe" )
end

function initiative_sword_gold_lua_c:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "sword_gold_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "sword_gold_delay_time" )

	local kv = {duration = self:GetSpecialValueFor( "attribute_type" )}
	CreateModifierThinker( self:GetCaster(), self, "modifier_initiative_sword_gold_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function initiative_sword_gold_lua_c:GetIntrinsicModifierName()
	return "modifier_initiative_sword_gold_lua"
end
function initiative_sword_gold_lua_c:GetIntrinsicModifierName()
	return "modifier_sword_gold_slow_lua"
end
--------------------------------------------------------------------------------
initiative_sword_gold_lua_b = class({})

function initiative_sword_gold_lua_b:GetAOERadius()
	return self:GetSpecialValueFor( "sword_gold_aoe" )
end

function initiative_sword_gold_lua_b:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "sword_gold_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "sword_gold_delay_time" )

	local kv = {duration = self:GetSpecialValueFor( "attribute_type" )}
	CreateModifierThinker( self:GetCaster(), self, "modifier_initiative_sword_gold_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function initiative_sword_gold_lua_b:GetIntrinsicModifierName()
	return "modifier_initiative_sword_gold_lua"
end
function initiative_sword_gold_lua_b:GetIntrinsicModifierName()
	return "modifier_sword_gold_slow_lua"
end
--------------------------------------------------------------------------------
initiative_sword_gold_lua_a = class({})

function initiative_sword_gold_lua_a:GetAOERadius()
	return self:GetSpecialValueFor( "sword_gold_aoe" )
end

function initiative_sword_gold_lua_a:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "sword_gold_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "sword_gold_delay_time" )

	local kv = {duration = self:GetSpecialValueFor( "attribute_type" )}
	CreateModifierThinker( self:GetCaster(), self, "modifier_initiative_sword_gold_lua_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

function initiative_sword_gold_lua_a:GetIntrinsicModifierName()
	return "modifier_initiative_sword_gold_lua"
end
function initiative_sword_gold_lua_a:GetIntrinsicModifierName()
	return "modifier_sword_gold_slow_lua"
end

if modifier_initiative_sword_gold_lua == nil then
	modifier_initiative_sword_gold_lua = class({})
end


function modifier_initiative_sword_gold_lua:IsHidden()
    return true
end

function modifier_initiative_sword_gold_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_initiative_sword_gold_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_initiative_sword_gold_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_initiative_sword_gold_lua:OnCreated(params)
    if not IsServer( ) then
        return
	end
end

function modifier_initiative_sword_gold_lua:OnDestroy()
	if not IsServer( ) then
        return
    end
end
-----------------------------------------------------------------
if modifier_initiative_sword_gold_lua_thinker == nil then
	modifier_initiative_sword_gold_lua_thinker = class({})
end

--------------------------------------------------------------------------------

function modifier_initiative_sword_gold_lua_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_initiative_sword_gold_lua_thinker:OnCreated( kv )
	self.light_strike_array_aoe = self:GetAbility():GetSpecialValueFor( "sword_gold_aoe" )
	self.light_strike_array_damage = self:GetAbility():GetSpecialValueFor( "sword_gold_damage" )
	self.light_strike_array_delay_time = self:GetAbility():GetSpecialValueFor( "sword_gold_delay_time" )
	self.bonuses_scale = self:GetAbility():GetSpecialValueFor("bonuses_scale")
	self.attribute_type = self:GetAbility():GetSpecialValueFor("attribute_type")
	self.count = self:GetAbility():GetSpecialValueFor( "attribute_type" )
	if IsServer() then
		EmitSoundOn( "hero.attack.npc_dota_hero_zuus", self:GetCaster() )
		-- EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/diy_particles/gold_jian.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin()+Vector(0, 0, 350))--self:GetParent():GetOrigin()
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )   
		--设置计时器延时时间
		self:StartIntervalThink( self.light_strike_array_delay_time )
		--启动计时器
		self:OnIntervalThink()
  
	end
end

--------------------------------------------------------------------------------

function modifier_initiative_sword_gold_lua_thinker:OnIntervalThink()
	if IsServer() then
		if self.count  <= 0 then
			UTIL_Remove( self:GetParent() )
			return
		end
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.light_strike_array_aoe, false )
		--效率不高计时器里慎用
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.light_strike_array_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local att_value = self:GetAbility():GetCaster():GetStrength();
					local damage = {
						victim = enemy,
						attacker = self:GetAbility():GetCaster(),
						damage = self.light_strike_array_damage + att_value * self.bonuses_scale,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}
					ApplyDamage( damage )
					
					enemy:AddNewModifier(self:GetAbility():GetCaster(),self:GetAbility(), "modifier_sword_gold_slow_lua", {duration = 3})
				end
			end
		end
		
        -- EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.LightStrikeArray", self:GetCaster() )
        local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call_ring.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		-- particles/econ/items/skywrath_mage/skywrath_mage_weapon_empyrean/skywrath_mystic_flare_hit_sword_gold.vpcf
		self.count = self.count - 0.5
	end
end

modifier_sword_gold_slow_lua = class({})

--------------------------------------------------------------------------------

function modifier_sword_gold_slow_lua:IsDebuff() return true end
function modifier_sword_gold_slow_lua:IsPurgable() return true end
function modifier_sword_gold_slow_lua:IsPurgeException() return true end
function modifier_sword_gold_slow_lua:IsHidden() return true end


function modifier_sword_gold_slow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}
	return funcs
end

function modifier_sword_gold_slow_lua:GetModifierMoveSpeedBonus_Percentage() return -30 end
