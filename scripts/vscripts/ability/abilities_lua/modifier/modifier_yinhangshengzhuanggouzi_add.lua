if modifier_yinhangshengzhuanggouzi_intell == nil then 
    modifier_yinhangshengzhuanggouzi_intell = class({})
end

function modifier_yinhangshengzhuanggouzi_intell:IsPurgable() return false end
function modifier_yinhangshengzhuanggouzi_intell:RemoveOnDeath() return false end
function modifier_yinhangshengzhuanggouzi_intell:IsHidden() return true end

function modifier_yinhangshengzhuanggouzi_intell:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
        self.add_intell = self:GetAbility():GetSpecialValueFor("add_amount") * self:GetStackCount()
    end
end

function modifier_yinhangshengzhuanggouzi_intell:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        self.add_intell = self:GetAbility():GetSpecialValueFor("add_amount") * self:GetStackCount()
    end
end

function modifier_yinhangshengzhuanggouzi_intell:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_yinhangshengzhuanggouzi_intell:GetModifierBonusStats_Intellect()
    return self.add_intell 
end

--------------------------------------

if modifier_yinhangshengzhuanggouzi_strength == nil then 
    modifier_yinhangshengzhuanggouzi_strength = class({})
end

function modifier_yinhangshengzhuanggouzi_strength:IsPurgable() return false end
function modifier_yinhangshengzhuanggouzi_strength:RemoveOnDeath() return false end
function modifier_yinhangshengzhuanggouzi_strength:IsHidden() return true end

function modifier_yinhangshengzhuanggouzi_strength:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
        self.add_strength = self:GetAbility():GetSpecialValueFor("add_amount") * self:GetStackCount()
    end
end

function modifier_yinhangshengzhuanggouzi_strength:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        self.add_strength = self:GetAbility():GetSpecialValueFor("add_amount") * self:GetStackCount()
    end
end

function modifier_yinhangshengzhuanggouzi_strength:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end

function modifier_yinhangshengzhuanggouzi_strength:GetModifierBonusStats_Strength()
    return self.add_strength
end

--------------------------------------

if modifier_yinhangshengzhuanggouzi_agility == nil then 
    modifier_yinhangshengzhuanggouzi_agility = class({})
end

function modifier_yinhangshengzhuanggouzi_agility:IsPurgable() return false end
function modifier_yinhangshengzhuanggouzi_agility:RemoveOnDeath() return false end
function modifier_yinhangshengzhuanggouzi_agility:IsHidden() return true end

function modifier_yinhangshengzhuanggouzi_agility:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
        self.add_agility = self:GetAbility():GetSpecialValueFor("add_amount") * self:GetStackCount()
    end
end

function modifier_yinhangshengzhuanggouzi_agility:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        self.add_agility = self:GetAbility():GetSpecialValueFor("add_amount") * self:GetStackCount()
    end
end

function modifier_yinhangshengzhuanggouzi_agility:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_yinhangshengzhuanggouzi_agility:GetModifierBonusStats_Agility()
        return  self.add_agility
end

