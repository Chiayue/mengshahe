
require("info/game_playerinfo")

LinkLuaModifier("modifier_aure_sacrificial_lua","ability/abilities_lua/aure_sacrificial_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_aure_sacrificial_monster_lua","ability/abilities_lua/aure_sacrificial_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_aure_fire_lua","ability/abilities_lua/aure_sacrificial_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

aure_sacrificial_lua = class({})

function aure_sacrificial_lua:GetIntrinsicModifierName()
	return "modifier_aure_sacrificial_lua"
end

aure_sacrificial_monster_lua = class({})

function aure_sacrificial_monster_lua:GetIntrinsicModifierName()
	return "modifier_aure_sacrificial_monster_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_aure_sacrificial_lua = class({})

--------------------------------------------------------------------------------

function modifier_aure_sacrificial_lua:DeclareFunctions()
    local funcs = {
		
    }
    return funcs
end

function modifier_aure_sacrificial_lua:IsHidden()
    return true
end

function modifier_aure_sacrificial_lua:IsAura()
    return true
end

function modifier_aure_sacrificial_lua:IsAuraActiveOnDeath()
    return true
end

function modifier_aure_sacrificial_lua:GetAuraRadius()
    return 800
end

function modifier_aure_sacrificial_lua:GetModifierAura()
    return "modifier_aure_fire_lua"
end

function modifier_aure_sacrificial_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aure_sacrificial_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_aure_sacrificial_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_aure_sacrificial_lua:OnCreated( kv )
    if not IsServer() then
        return
    end
end

modifier_aure_sacrificial_monster_lua = class({})

--------------------------------------------------------------------------------

function modifier_aure_sacrificial_monster_lua:DeclareFunctions()
    local funcs = {
		
    }
    return funcs
end

function modifier_aure_sacrificial_monster_lua:IsHidden()
    return true
end

function modifier_aure_sacrificial_monster_lua:IsAura()
    return true
end

function modifier_aure_sacrificial_monster_lua:GetAuraRadius()
    return 800
end

function modifier_aure_sacrificial_monster_lua:GetModifierAura()
    return "modifier_aure_fire_lua"
end

function modifier_aure_sacrificial_monster_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aure_sacrificial_monster_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_aure_sacrificial_monster_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_aure_sacrificial_monster_lua:OnCreated( kv )
    if not IsServer() then
        return
    end
end

modifier_aure_fire_lua = class({})
--------------------------------------------------------------------------------

function modifier_aure_fire_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_aure_fire_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(2)
	local EffectName_1 = "particles/killstreak/killstreak_fire_flames_lv2_hud.vpcf" -- 身体燃烧特效
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
    self:AddParticle(nFXIndex_1, false, false, -1, false, false)
end

function modifier_aure_fire_lua:OnIntervalThink()
    local caster = self:GetParent();
    if caster:GetUnitName() ~= "boss_finally" then
        local damageNum = 1000
        -- if ContainUnitTypeFlag(caster,DOTA_UNIT_TYPE_FLAG_CREEP) then
        --     damageNum = caster:GetMaxHealth()*0.02
        -- else
        --     damageNum = caster:GetMaxHealth()*0.01
        -- end
        ApplyDamage({
            victim = caster,
            attacker = self:GetAbility():GetCaster(),
            damage = damageNum,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        })
    end
end
