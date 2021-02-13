require("info/game_playerinfo")

modifier_butian_kongdong_lua = class({})
--------------------------------------------------------------------------------
function modifier_butian_kongdong_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, -- GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, -- GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, -- GetModifierBonusStats_Strength
    }
    return funcs
end

function modifier_butian_kongdong_lua:IsHidden()
    return true
end

function modifier_butian_kongdong_lua:OnCreated( kv )
    self.space_time = self:GetAbility():GetSpecialValueFor( "space_time" )
    self.value = self:GetAbility():GetSpecialValueFor( "value" )

    if IsServer() then
        self:StartIntervalThink( self.space_time )

        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chaos_knight/diabolic_aspect/diabolic_aspect.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_diabolic_aspect/chaos_knight_diabolic_aspect_horns.vpcf", PATTACH_POINT_FOLLOW, item)
        ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_horn_l", item:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_horn_r", item:GetOrigin(), true)
        ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_ambient_helmet.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_shield.vmdl",
        })
        item:SetSkin(1)
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_golden_shield_ambient.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chaos_knight/burning_nightmare_chaos_knight_shoulder/burning_nightmare_chaos_knight_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chaos_knight/ck_ti9_immortal_weapon/ck_ti9_immortal_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chaos_knight/burning_nightmare_chaos_knight_mount/burning_nightmare_chaos_knight_mount.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_horse_ambient.vpcf", PATTACH_POINT_FOLLOW, item)

    end
end

function modifier_butian_kongdong_lua:OnDeath(params)
    if not IsServer( ) then
        return
    end
    if params.unit == self:GetParent() then
        -- 判断死亡对象是否是自己
        self:SetStackCount(0)
    end
end

function modifier_butian_kongdong_lua:OnIntervalThink()
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + 1)
        self:GetParent():CalculateStatBonus(true)
    end
end

function modifier_butian_kongdong_lua:GetModifierBonusStats_Agility(params)
    -- 修改敏捷
    return self:GetStackCount() * 20
end

function modifier_butian_kongdong_lua:GetModifierBonusStats_Intellect(params)
    -- 修改智力
    return self:GetStackCount() * 20
end

function modifier_butian_kongdong_lua:GetModifierBonusStats_Strength(params)
    -- 修改力量
    return self:GetStackCount() * 20
end