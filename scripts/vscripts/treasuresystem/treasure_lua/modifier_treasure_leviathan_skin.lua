-- 宝物: 利维坦的外壳

if modifier_treasure_leviathan_skin == nil then 
    modifier_treasure_leviathan_skin = class({})
end

function modifier_treasure_leviathan_skin:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_leviathan_skin"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_leviathan_skin:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_leviathan_skin:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_leviathan_skin:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    }
end

function modifier_treasure_leviathan_skin:GetModifierPhysical_ConstantBlock(params)
    if self:GetParent():HasModifier("modifier_treasure_beerbung") then
        return 500
    else 
        return 100
    end
end