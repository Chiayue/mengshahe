
LinkLuaModifier( "modifier_passive_shock_lua", "ability/abilities_lua/passive_shock_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shock_stun_lua", "ability/abilities_lua/passive_shock_lua",LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------
--Abilities
if passive_shock_lua_a == nil then
    passive_shock_lua_a = class({})
end


function passive_shock_lua_a:GetIntrinsicModifierName()
    return "modifier_passive_shock_lua"
end
---------------------------------------------------------------------------------
if passive_shock_lua_s == nil then
    passive_shock_lua_s = class({})
end

function passive_shock_lua_s:GetIntrinsicModifierName()
    return "modifier_passive_shock_lua"
end



-----------------------------------------------
if modifier_passive_shock_lua == nil then
	modifier_passive_shock_lua = class({})
end
function modifier_passive_shock_lua:IsDebuff()
    return false
 end
 function modifier_passive_shock_lua:IsHidden()
    return true
end

function modifier_passive_shock_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end
function modifier_passive_shock_lua:OnAttackLanded(params)
    if not IsServer() then
        return 
    end
    local attacker = params.attacker
	local caster = self:GetCaster()
    if attacker ~= caster then
        return
    end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("chance")) and #enemies > 0 then
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster,self:GetAbility(), "modifier_shock_stun_lua", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = self:GetAbility():GetSpecialValueFor("stomp_damage")+self:GetAbility():GetSpecialValueFor("attr_scale")*caster:GetIntellect(),
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
			ApplyDamage(damageTable)
		end

		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Centaur.HoofStomp", caster)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
		for i=0,6 do
			ParticleManager:SetParticleControl(pfx, i, caster:GetAbsOrigin())
		end
		ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius")))
		GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), false)
	end
end
----------------------------
--buff眩晕修饰器

modifier_shock_stun_lua = class({})

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_shock_stun_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
