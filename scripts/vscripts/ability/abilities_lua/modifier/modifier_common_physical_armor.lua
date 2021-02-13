
modifier_common_physical_armor = class({})

function modifier_common_physical_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_common_physical_armor:GetModifierPhysicalArmorBonus()
	return 999
end

function modifier_common_physical_armor:GetTexture()
    return "buff/desolator"
end

function modifier_common_physical_armor:IsPurgable()
    return false
end