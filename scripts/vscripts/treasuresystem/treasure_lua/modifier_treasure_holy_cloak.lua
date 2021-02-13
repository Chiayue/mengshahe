-- 宝物: 神圣斗篷

if modifier_treasure_holy_cloak == nil then 
    modifier_treasure_holy_cloak = class({})
end

function modifier_treasure_holy_cloak:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holy_cloak"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_holy_cloak:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_holy_cloak:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_holy_cloak:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_zheguang", nil)
        self:StartIntervalThink(15)
    end
end

function modifier_treasure_holy_cloak:OnIntervalThink()
    local parent = self:GetParent()
	parent:AddNewModifier(parent, nil, "modifier_treasure_zheguang", nil)
end

---------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_zheguang","treasuresystem/treasure_lua/modifier_treasure_holy_cloak", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_zheguang == nil then 
    modifier_treasure_zheguang = class({})
end

function modifier_treasure_zheguang:IsHidden()
    return true
end

function modifier_treasure_zheguang:IsPurgable()
    return false
end
 
function modifier_treasure_zheguang:RemoveOnDeath()
    return false
end

function modifier_treasure_zheguang:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
end

function modifier_treasure_zheguang:GetModifierAvoidDamage(params)
    self:GetParent():RemoveModifierByName(self:GetClass())
    return 1
end

function modifier_treasure_zheguang:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        local index = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_POINT_FOLLOW, parent)
        ParticleManager:SetParticleControlEnt(index, 1, parent, PATTACH_POINT_FOLLOW, "", parent:GetOrigin(), true)
        self:AddParticle(index, false, false, 20, false, false)
    end
end