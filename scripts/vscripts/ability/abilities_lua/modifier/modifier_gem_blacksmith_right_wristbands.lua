if modifier_gem_blacksmith_right_wristbands == nil then
	modifier_gem_blacksmith_right_wristbands = class({})
end

function modifier_gem_blacksmith_right_wristbands:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end


function modifier_gem_blacksmith_right_wristbands:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        self.health_add = math.ceil(hero:GetBaseMaxHealth() * self:GetAbility():GetSpecialValueFor( "health_add" ) / 100)
        local suit_intellect_add = ability:GetSpecialValueFor( "suit_intellect_add" )
        local suit_health_add = ability:GetSpecialValueFor( "suit_health_add" )
        if hero:HasModifier("modifier_gem_blacksmith_left_wristbands") and not hero:HasModifier("modifier_gem_blacksmith_power") then
            hero:AddNewModifier( hero, nil, "modifier_gem_blacksmith_power", {suit_intellect_add = suit_intellect_add,suit_health_add = suit_health_add} )
        end
        self:StartIntervalThink(1)
    end
end

function modifier_gem_blacksmith_right_wristbands:OnIntervalThink()
    local hero = self:GetParent()
    local health_add_new = math.ceil(hero:GetBaseMaxHealth() * self:GetAbility():GetSpecialValueFor( "health_add" ) / 100)
    if health_add_new ~= self.health_add then
        self.health_add =  health_add_new
    end
end

function modifier_gem_blacksmith_right_wristbands:GetModifierHealthBonus()
    return self.health_add
end

function modifier_gem_blacksmith_right_wristbands:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_blacksmith_right_wristbands:RemoveOnDeath()
    return false -- 死亡不移除
end


function modifier_gem_blacksmith_right_wristbands:GetTexture()
    return "baowu/gem_blacksmith_right_wristbands"
end