-- 宝物: 欧西里斯的祭品1


if modifier_treasure_osiris_1 == nil then 
    modifier_treasure_osiris_1 = class({})
end

function modifier_treasure_osiris_1:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_osiris_1"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_osiris_1:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_osiris_1:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_osiris_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_treasure_osiris_1:OnCreated(params)
    if not IsServer() then
        return
    end
end

function modifier_treasure_osiris_1:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_osiris_fight")
    end
end

function modifier_treasure_osiris_1:GetModifierPhysicalArmorBonus()
	return 3
end