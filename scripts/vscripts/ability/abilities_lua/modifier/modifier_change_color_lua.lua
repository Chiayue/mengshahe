require("info/game_playerinfo")

modifier_change_color_lua = class({})
--------------------------------------------------------------------------------
local my_mode = 0

function modifier_change_color_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, -- GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, -- GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, -- GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end

function modifier_change_color_lua:IsHidden()
    return true
end
function modifier_change_color_lua:OnCreated( kv )
    my_mode = RandomInt(0, 5)
    self.parent = self:GetParent()
    local item = nil
    local index = nil
    
    if IsServer() then
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/ancient_apparition/extremely_cold_shackles_head/extremely_cold_shackles_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_cold_shackles/aa_cold_shackles_head/aa_cold_shackles_head.vpcf", PATTACH_POINT_FOLLOW, item)
        ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_eye_L", item:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_eye_R", item:GetAbsOrigin(), true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/ancient_apparition/extremely_cold_shackles_shoulder/extremely_cold_shackles_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_cold_shackles/aa_cold_shackles_shoulder/aa_cold_shackles_shoulder.vpcf", PATTACH_POINT_FOLLOW, item)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/ancient_apparition/extremely_cold_shackles_tail/extremely_cold_shackles_tail.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_cold_shackles/aa_cold_shackles_tail/aa_cold_shackles_tail.vpcf", PATTACH_POINT_FOLLOW, item)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/ancient_apparition/extremely_cold_shackles_arms/extremely_cold_shackles_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_cold_shackles/aa_cold_shackles_arms/aa_cold_shackles_arms.vpcf", PATTACH_POINT_FOLLOW, item)
    
    end

end

-- 拥有这个技能英雄当前的模式,默认是0 红 1绿 2蓝 3白 4黄 5紫


function modifier_change_color_lua:OnDeath(params)
    if not IsServer( ) then
        return
    end
    if params.unit == self:GetParent() then
        -- 判断死亡对象是否是自己
        my_mode = RandomInt(0, 5)
    end
end

function modifier_change_color_lua:GetModifierBonusStats_Agility()
    -- 修改敏捷
    local value = 0;
    if 1 == my_mode then
        value = self:GetParent():GetLevel()*30
        self:GetParent():SetRenderColor(0, 255, 0)
    elseif 3 == my_mode then
        value = self:GetParent():GetLevel()*12
        self:GetParent():SetRenderColor(255, 250, 250)
    end
    return value
end

function modifier_change_color_lua:GetModifierBonusStats_Intellect()
    -- 修改智力
    local value = 0;
    if 2 == my_mode then
        value = self:GetParent():GetLevel()*30
        self:GetParent():SetRenderColor(0, 0, 255)
    elseif 3 == my_mode then
        value = self:GetParent():GetLevel()*12
        self:GetParent():SetRenderColor(255, 250, 250)
    end
    return value
end

function modifier_change_color_lua:GetModifierBonusStats_Strength()
    -- 修改力量
    local value = 0;
    if 0 == my_mode then
        value = self:GetParent():GetLevel()*30
        self:GetParent():SetRenderColor(255, 0, 0)
    elseif 3 == my_mode then
        value = self:GetParent():GetLevel()*12
        self:GetParent():SetRenderColor(255, 250, 250)
    end
    return value
end

function modifier_change_color_lua:GetModifierBaseAttack_BonusDamage()
    -- 修改攻击力
    local value = 0;
    if 5 == my_mode then
        value = self:GetParent():GetLevel()*200
        self:GetParent():SetRenderColor(255, 0, 255)
    end
    return value
end

function modifier_change_color_lua:GetModifierHealthBonus()
    -- 修改血量
    local value = 0;
    if 4 == my_mode then
        value = self:GetParent():GetLevel()*2000
        self:GetParent():SetRenderColor(255, 255, 0)
    end
    return value
end