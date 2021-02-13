if modifier_gem_blacksmith_power == nil then
	modifier_gem_blacksmith_power = class({})
end

function modifier_gem_blacksmith_power:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end

function modifier_gem_blacksmith_power:IsHidden()
	return false
end

function modifier_gem_blacksmith_power:OnCreated(params)
    if IsServer() then 
        self.suit_intellect_add = math.ceil(self:GetParent():GetBaseIntellect() * params.suit_intellect_add / 100)
        self.suit_health_add = math.ceil(self:GetParent():GetBaseMaxHealth() * params.suit_health_add / 100)
    end
end

function modifier_gem_blacksmith_power:OnRefresh(params)
    if IsServer then
        if not self:GetParent() then
            return
        end
        self.suit_intellect_add = math.ceil(self:GetParent():GetBaseIntellect() * params.suit_intellect_add / 100)
        self.suit_health_add = math.ceil(self:GetParent():GetBaseMaxHealth() * params.suit_health_add / 100)
    end
end

function modifier_gem_blacksmith_power:GetModifierBonusStats_Intellect()
    return self.suit_intellect_add
end

function modifier_gem_blacksmith_power:GetModifierHealthBonus()
    return self.suit_health_add
end

function modifier_gem_blacksmith_power:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_blacksmith_power:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_blacksmith_power:GetTexture()
    return "ember_spirit_sleight_of_fist"
end
