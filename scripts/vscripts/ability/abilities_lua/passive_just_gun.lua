passive_just_gun = class({})

function passive_just_gun:GetIntrinsicModifierName()
	return "modifier_passive_just_gun"
end

function passive_just_gun:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    if hTarget and not hTarget:IsNull() and hTarget:IsAlive() and not hTarget:IsInvulnerable() then
        local caster = self:GetCaster()
        hTarget:AddNewModifier(caster, self, "modifier_common_knockback", nil)
        ApplyDamage({
            victim = hTarget,
            attacker = caster,
            damage = (caster:GetStrength() + caster:GetIntellect()) * 3,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self
        })
        caster:PerformAttack(hTarget, false, false, true, false, true, false, true)
	end
	return false
end

-------------------------------------------------------------
LinkLuaModifier("modifier_passive_just_gun", "ability/abilities_lua/passive_just_gun.lua", LUA_MODIFIER_MOTION_NONE)

modifier_passive_just_gun = class({})

function modifier_passive_just_gun:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_passive_just_gun:OnRespawn()
    local parent = self:GetParent()
    parent:AddNewModifier(parent, self:GetAbility(), "modifier_passive_just_gun_buff", nil)
end

function modifier_passive_just_gun:OnCreated(params)
    if IsServer() then
        self:OnRespawn()
    end
end

function modifier_passive_just_gun:IsHidden()
    return true
end

-------------------------------------------------------------
LinkLuaModifier("modifier_passive_just_gun_buff", "ability/abilities_lua/passive_just_gun.lua", LUA_MODIFIER_MOTION_NONE)

modifier_passive_just_gun_buff = class({})

function modifier_passive_just_gun_buff:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(0.2)
    end
end

function modifier_passive_just_gun_buff:OnIntervalThink()
    local parent = self:GetParent()
    ProjectileManager:CreateLinearProjectile({
        EffectName = "",
        Ability = self:GetAbility(),
        Source = parent,
        vSpawnOrigin = parent:GetOrigin(),
        fStartRadius = 100,
        fEndRadius = 100,
        fDistance = 100,
        vVelocity = parent:GetForwardVector() * 500,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
    }) 
end

function modifier_passive_just_gun_buff:IsHidden()
    return true
end

function modifier_passive_just_gun_buff:IsPurgable()
    return false
end