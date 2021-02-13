-- 宝物: 欧西里斯的祭品2


if modifier_treasure_osiris_2 == nil then 
    modifier_treasure_osiris_2 = class({})
end
function modifier_treasure_osiris_2:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_osiris_2"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_osiris_2:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_osiris_2:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_osiris_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_treasure_osiris_2:OnCreated(params)
    if not IsServer() then
        return
    end
end

function modifier_treasure_osiris_2:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_osiris_fight")
    end
end

function modifier_treasure_osiris_2:GetModifierPhysicalArmorBonus()
	return 4
end