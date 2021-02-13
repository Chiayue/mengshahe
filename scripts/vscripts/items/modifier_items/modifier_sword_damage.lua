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
        local ability = self:GetAbility()
        self.damage_multiple = ability:GetSpecialValueFor("damage_multiple")
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
    -- if self.last_find_time and GameRules:GetGameTime() - self.last_find_time < global_var_func.split_cd then
    --     return
    -- else
    --     self.last_find_time = GameRules:GetGameTime()
    -- end

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
        -- local aList = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,attacker:GetOrigin(),nil,250,DOTA_UNIT_TARGET_TEAM_ENEMY, 
        -- DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
        -- local attacker_team =  attacker:GetTeam()
        
        -- --伤害表
        -- local damageTable = {
        --     victim = {},
        --     damage = attacker:GetDamageMax() * self.damage_multiple, 
        --     damage_type = DAMAGE_TYPE_PHYSICAL,
        --     damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        --     attacker = attacker,
        --     ability = nil, --Optional.
        -- }
        -- for i,v in pairs(aList) do
        --     if v:IsAlive() then 
        --         local unit_team = v:GetTeam()
        --         if attacker_team ~= unit_team then
        --             damageTable.victim = v
        --             ApplyDamage(damageTable)
        --         end
        --     end
        -- end
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


