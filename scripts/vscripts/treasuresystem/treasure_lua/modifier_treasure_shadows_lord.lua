---------------------------------------------------------------------------
-- 宝物：影流之主
---------------------------------------------------------------------------

if modifier_treasure_shadows_lord == nil then 
    modifier_treasure_shadows_lord = class({})
end
function modifier_treasure_shadows_lord:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_shadows_lord"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_shadows_lord:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_treasure_shadows_lord:OnAttackLanded(event)
    if event.attacker == self:GetParent() and event.attacker:IsRealHero() then
        if RollPercentage(10) then
            local attacker = event.attacker
            local target = event.target
            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_POINT_FOLLOW, target)
            ParticleManager:SetParticleControl(index, 0, target:GetOrigin())
            ParticleManager:SetParticleControl(index, 1, target:GetOrigin())
            ParticleManager:SetParticleControlEnt(index, 2, attacker, PATTACH_POINT_FOLLOW, "", attacker:GetOrigin(), true)
            ParticleManager:ReleaseParticleIndex(index)
            attacker:PerformAttack(target, false, true, true, false, true, false, true) 
        end
    end
end

function modifier_treasure_shadows_lord:OnAbilityExecuted(event)
    local ability = event.ability
    local caster = ability:GetCaster()
    if caster == self:GetParent() and ability:GetManaCost(ability:GetLevel()) > 0 and RollPercentage(20) then
        local illusion = CreateIllusions(caster, caster, nil, 1, 50, false, true)[1]
        for i = 0, 31 do
            if illusion:GetAbilityByIndex(i) then
                illusion:RemoveAbilityByHandle(illusion:GetAbilityByIndex(i))
            end
        end
        illusion:SetOwner(caster)
        illusion:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        illusion:SetMana(caster:GetMaxMana())
        illusion.dynamic_properties = caster.dynamic_properties
        illusion.call_unit = caster.call_unit
        illusion:AddNewModifier(caster, ability, "modifier_treasure_shadows_lord_auto_cast", nil)
    end
end

function modifier_treasure_shadows_lord:IsPurgable()
    return false
end

function modifier_treasure_shadows_lord:RemoveOnDeath()
    return false
end

------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_shadows_lord_auto_cast","treasuresystem/treasure_lua/modifier_treasure_shadows_lord", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_shadows_lord_auto_cast == nil then 
    modifier_treasure_shadows_lord_auto_cast = class({})
end

function modifier_treasure_shadows_lord_auto_cast:CheckState()
	return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end

function modifier_treasure_shadows_lord_auto_cast:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_treasure_shadows_lord_auto_cast:OnAbilityExecuted(event)
    local ability = event.ability
    local caster = ability:GetCaster()
    if caster == self:GetParent() then
        Timers(ability.delay or 0.2, function ()
            if caster:IsChanneling() then
                return 1
            end
            UTIL_Remove(self:GetParent())
        end)
    end
end

function modifier_treasure_shadows_lord_auto_cast:IsHidden()
    return true
end

function modifier_treasure_shadows_lord_auto_cast:IsPurgable()
    return false
end

function modifier_treasure_shadows_lord_auto_cast:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local ability_name = ability:GetAbilityName()
        parent:AddAbility(ability_name):SetLevel(1)
        self:StartIntervalThink(0.1)
    end
end

function modifier_treasure_shadows_lord_auto_cast:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local ability_name = ability:GetAbilityName()
        if ability:GetCursorTarget() then
            parent:CastAbilityOnTarget(ability:GetCursorTarget(), parent:FindAbilityByName(ability_name), parent:GetEntityIndex())
        elseif ability:GetCursorPosition() and ability:GetCursorPosition() ~= Vector(0, 0, 0) then
            parent:CastAbilityOnPosition(ability:GetCursorPosition() + RandomVector(200), parent:FindAbilityByName(ability_name), parent:GetEntityIndex())
        else
            parent:CastAbilityNoTarget(parent:FindAbilityByName(ability_name), parent:GetEntityIndex())
        end
        self:StartIntervalThink(-1)
    end
end