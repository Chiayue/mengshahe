if modifier_attribute_50_lua == nil then
    modifier_attribute_50_lua = ({})
end

function modifier_attribute_50_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end

function modifier_attribute_50_lua:OnCreated(params)
    
end

function modifier_attribute_50_lua:GetModifierBonusStats_Agility()
	return 100
end

function modifier_attribute_50_lua:GetModifierBonusStats_Intellect()
	return 100
end

function modifier_attribute_50_lua:GetModifierBonusStats_Strength()
	return 100
end


function modifier_attribute_50_lua:IsHidden()
    return true
end
