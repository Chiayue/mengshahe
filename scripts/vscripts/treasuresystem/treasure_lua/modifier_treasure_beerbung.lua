-- 宝物: 啤酒桶盖

if modifier_treasure_beerbung == nil then 
    modifier_treasure_beerbung = class({})
end

function modifier_treasure_beerbung:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_beerbung"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_beerbung:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_beerbung:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_beerbung:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_treasure_beerbung:GetModifierConstantHealthRegen()
    if self:GetParent():HasModifier("modifier_treasure_leviathan_skin") then
        return 2000
    else 
        return 500
    end
end