
-- 宝物: 欧西里斯的天空龙



LinkLuaModifier( "modifier_treasure_osiris_fight","treasuresystem/treasure_lua/modifier_treasure_osiris", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_osiris == nil then 
    modifier_treasure_osiris = class({})
end
function modifier_treasure_osiris:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_osiris"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_osiris:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_osiris:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_osiris:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
    }
end

function modifier_treasure_osiris:OnModifierAdded()
    local parent = self:GetParent()
    if parent:FindModifierByName("modifier_treasure_osiris_1") and parent:FindModifierByName("modifier_treasure_osiris_2") and parent:FindModifierByName("modifier_treasure_osiris_3") and not parent:FindModifierByName("modifier_treasure_osiris_fight") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_osiris_fight", nil)
    end
end

-- function modifier_treasure_osiris:OnCreated(params)
--     if not IsServer() then
--         return
--     end
--     self.caster = self:GetCaster()
    
--     if self.caster:FindModifierByName("modifier_treasure_osiris_1") and 
--     self.caster:FindModifierByName("modifier_treasure_osiris_2") and 
--     self.caster:FindModifierByName("modifier_treasure_osiris_3") then
--         self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_osiris_fight", {})
--     end
-- end

modifier_treasure_osiris_fight = class({})
--------------------------------------------------------------------------------

-- function modifier_treasure_osiris_fight:GetAttributes() 
--     return MODIFIER_ATTRIBUTE_MULTIPLE 
-- end
function modifier_treasure_osiris_fight:IsHidden()
    return true
end

function modifier_treasure_osiris_fight:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_osiris_fight:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_osiris_fight:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_osiris_fight:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster();
    self:OnIntervalThink()
    self:StartIntervalThink(20)
end

function modifier_treasure_osiris_fight:OnIntervalThink()

    self.index = ParticleManager:CreateParticleForTeam( "particles/items2_fx/shivas_guard_active.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
    ParticleManager:SetParticleControl( self.index, 0, self.caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.index, 1, Vector( 300, 1, 300 ) )
    ParticleManager:ReleaseParticleIndex( self.index )

    local  enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,target in pairs(enemies) do
        if target:GetBaseDamageMax() < 200 then
            -- local particle = ParticleManager:CreateParticle("particles/heroes/hero_leshrac/tg_lh_ls1.vpcf", PATTACH_WORLDORIGIN,target)
            -- ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 1000))
            -- ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
            -- ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
            target:Kill(nil, self.caster)
        end
    end
end