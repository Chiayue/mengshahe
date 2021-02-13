--庇护--
initiative_shelter_lua = class({})

LinkLuaModifier("modifier_shelter_lua_magic_immune","ability/abilities_lua/initiative_shelter_lua.lua",LUA_MODIFIER_MOTION_NONE)

function initiative_shelter_lua:GetCooldown(iLevel)   
    local cooldown = self.BaseClass.GetCooldown(self, iLevel)
    cooldown = cooldown - (GameRules:GetCustomGameDifficulty() - 1)*1
    return cooldown
end
--施法开始
function initiative_shelter_lua:OnSpellStart()

	local caster = self:GetCaster()
    local friendlys = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetOrigin(),
        self,
        1000,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES ,
        1,
        false
    )

    local hClosestTarget = nil
    local flClosestDist = 0.0
    -- 选取范围最近的1个单位
    if #friendlys > 0 then
        for _,friendly in pairs(friendlys) do
            if friendly ~= nil and not friendly:HasModifier("modifier_shelter_lua_magic_immune") then
                local vToTarget = friendly:GetOrigin() - caster:GetOrigin()
                local flDistToTarget = vToTarget:Length()

                if hClosestTarget == nil or flDistToTarget < flClosestDist  then
                    hClosestTarget = friendly
                    flClosestDist = flDistToTarget
                end		
            end
        end
    end
    if hClosestTarget ~= nil  then
        hClosestTarget:AddNewModifier(caster,self, "modifier_shelter_lua_magic_immune", {duration =  self:GetSpecialValueFor("duration")})
    end
end

--修饰器
modifier_shelter_lua_magic_immune = class({})


function modifier_shelter_lua_magic_immune:IsBuff()			return true end
function modifier_shelter_lua_magic_immune:IsDebuff()				return true end
function modifier_shelter_lua_magic_immune:IsHidden() 			return false end
function modifier_shelter_lua_magic_immune:IsPurgable() 			return false end
function modifier_shelter_lua_magic_immune:IsPurgeException() 	return false end

function modifier_shelter_lua_magic_immune:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_shelter_lua_magic_immune:OnCreated(kv)
    if IsServer() then
        local caster = self:GetAbility():GetCaster()
        local index = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", 
            PATTACH_POINT_FOLLOW, 
            caster
        )
        ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(index)
    end
end

function modifier_shelter_lua_magic_immune:GetStatusEffectName() return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end
function modifier_shelter_lua_magic_immune:StatusEffectPriority() return 10 end
function modifier_shelter_lua_magic_immune:GetEffectName() return "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf" end

function modifier_shelter_lua_magic_immune:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_shelter_lua_magic_immune:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}
	return funcs
end
function modifier_shelter_lua_magic_immune:GetModifierCooldownReduction_Constant()
    return self:GetAbility():GetCooldown(1)
end

