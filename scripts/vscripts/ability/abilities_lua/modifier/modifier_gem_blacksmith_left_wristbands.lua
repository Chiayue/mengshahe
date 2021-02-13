if modifier_gem_blacksmith_left_wristbands == nil then
	modifier_gem_blacksmith_left_wristbands = class({})
end

function modifier_gem_blacksmith_left_wristbands:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_gem_blacksmith_left_wristbands:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        self.intellect_add = math.ceil(hero:GetBaseIntellect()* self:GetAbility():GetSpecialValueFor( "intellect_add" ) / 100)
        local suit_intellect_add = ability:GetSpecialValueFor( "suit_intellect_add" )
        local suit_health_add = ability:GetSpecialValueFor( "suit_health_add" )
        if hero:HasModifier("modifier_gem_blacksmith_right_wristbands") and not hero:HasModifier("modifier_gem_blacksmith_power") then
            hero:AddNewModifier( hero, nil, "modifier_gem_blacksmith_power", {suit_intellect_add = suit_intellect_add,suit_health_add = suit_health_add} )
        end
        self:StartIntervalThink(1)
    end
end


function modifier_gem_blacksmith_left_wristbands:OnIntervalThink()
    local hero = self:GetParent()
    local intellect_add_new = math.ceil(hero:GetBaseIntellect()* self:GetAbility():GetSpecialValueFor( "intellect_add" ) / 100)
    if intellect_add_new ~= self.intellect_add then
        self.intellect_add = intellect_add_new
        if hero:HasModifier("modifier_gem_blacksmith_power") then
            local ability = self:GetAbility()
            local suit_intellect_add = ability:GetSpecialValueFor( "suit_intellect_add" )
            local suit_health_add = ability:GetSpecialValueFor( "suit_health_add" )
            hero:AddNewModifier( hero, nil, "modifier_gem_blacksmith_power", {suit_intellect_add = suit_intellect_add,suit_health_add = suit_health_add} )
        end
    end
end

function modifier_gem_blacksmith_left_wristbands:GetModifierBonusStats_Intellect()
    return self.intellect_add
end

function modifier_gem_blacksmith_left_wristbands:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_blacksmith_left_wristbands:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_blacksmith_left_wristbands:GetTexture()
    return "baowu/gem_blacksmith_left_wristbands"
end
