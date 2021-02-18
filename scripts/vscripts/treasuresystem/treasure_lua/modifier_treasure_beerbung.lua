-- 宝物: 啤酒桶盖

if modifier_treasure_beerbung == nil then 
    modifier_treasure_beerbung = class({})
end

function modifier_treasure_beerbung:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_treasure_beerbung:GetModifierConstantHealthRegen()
    return 500
end

function modifier_treasure_beerbung:GetTexture()
    return "buff/modifier_treasure_beerbung"
end

function modifier_treasure_beerbung:IsHidden()
    return false
end

function modifier_treasure_beerbung:IsPurgable()
    return false
end

function modifier_treasure_beerbung:RemoveOnDeath()
    return false
end

function modifier_treasure_beerbung:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_beerbung:OnIntervalThink()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_treasure_leviathan_skin") then
        parent:AddNewModifier(parent, nil, "modifier_treasure_marine_overlord", nil)
    end
    self:StartIntervalThink(-1)
end