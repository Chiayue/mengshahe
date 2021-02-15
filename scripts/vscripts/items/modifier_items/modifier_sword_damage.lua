if modifier_sword_damage == nil then 
    modifier_sword_damage = class({})
end

function modifier_sword_damage:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_sword_damage:OnCreated( params )
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsRealHero() then
            local ability = self:GetAbility()
            local extra_attack_scale = ability:GetSpecialValueFor("extra_attack_scale")
            local steam_id = PlayerResource:GetSteamAccountID(parent:GetPlayerID())
            local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id)  or {}
            if extra_attack_scale then 
                game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", extra_attack_scale)
            end
        end
    end
end

function modifier_sword_damage:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsRealHero() then
            local ability = self:GetAbility()
            local extra_attack_scale = ability:GetSpecialValueFor("extra_attack_scale") * -1
            local steam_id = PlayerResource:GetSteamAccountID(parent:GetPlayerID())
            local dynamic_properties = game_playerinfo:get_dynamic_properties(steam_id)  or {}
            if extra_attack_scale then 
                game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_scale", extra_attack_scale)
            end
        end
    end
end

function modifier_sword_damage:OnAttackLanded(params)
    if not IsServer( ) then
        return
    end 
    local attacker = params.attacker
    if attacker ~= self:GetParent() then 
        return
    end
    if attacker:IsIllusion() then
        return
    end
    local target = params.target
    if target == nil then 
        return
    end
    if RollPercentage(20) then
        local hero = self:GetParent()
        hero.sputterInfo.Ability =  self:GetAbility()
        hero.sputterDamageInfo.ability =  self:GetAbility()
        local spPosition = target:GetOrigin() + (attacker:GetOrigin() - target:GetOrigin()):Normalized()* 150
        spPosition.z = target:GetOrigin().z
        hero.sputterInfo.vSpawnOrigin = spPosition
        hero.sputterInfo.vVelocity = spPosition:Normalized()  * 3000
        ProjectileManager:CreateLinearProjectile( hero.sputterInfo )
        local pindex = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_n_cowlofice.vpcf",PATTACH_POINT,target)
        ParticleManager:ReleaseParticleIndex(pindex)
    end
end

function modifier_sword_damage:IsHidden()
    return true    
 end

function modifier_sword_damage:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_sword_damage:RemoveOnDeath()
    return false -- 死亡不移除
end


