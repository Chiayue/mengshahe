if modifier_gem_god_left_hand == nil then
	modifier_gem_god_left_hand = class({})
end

function modifier_gem_god_left_hand:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end

function modifier_gem_god_left_hand:IsHidden()
	return false
end

function modifier_gem_god_left_hand:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        self.strength_add = math.ceil(hero:GetBaseStrength() * self:GetAbility():GetSpecialValueFor( "strength_add" ) / 100)
        local suit_damage_add = ability:GetSpecialValueFor( "suit_damage_add" )
        local suit_strength_add = ability:GetSpecialValueFor( "suit_strength_add" )
        if hero:HasModifier("modifier_gem_god_right_hand") and not hero:HasModifier("modifier_gem_god_hand") then
            hero:AddNewModifier( hero, nil, "modifier_gem_god_hand", {suit_strength_add = suit_strength_add,suit_damage_add = suit_damage_add} )
        end
        self:StartIntervalThink(1)
    end
end

function modifier_gem_god_left_hand:OnRefresh(params)
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local strength_add_new = math.ceil(hero:GetBaseStrength() * self:GetAbility():GetSpecialValueFor( "strength_add" ) / 100)
        if strength_add_new ~= self.strength_add then
            self.strength_add = strength_add_new
            local suit_damage_add = ability:GetSpecialValueFor( "suit_damage_add" )
            local suit_strength_add = ability:GetSpecialValueFor( "suit_strength_add" )
            if  hero:HasModifier("modifier_gem_god_hand") then
                hero:AddNewModifier( hero, nil, "modifier_gem_god_hand", {suit_strength_add = suit_strength_add,suit_damage_add = suit_damage_add} )
            end
        end
        
    end
end

function modifier_gem_god_left_hand:OnIntervalThink()
    self:ForceRefresh()
end

function modifier_gem_god_left_hand:GetModifierBonusStats_Strength()
    return self.strength_add
end

function modifier_gem_god_left_hand:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_god_left_hand:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_god_left_hand:GetTexture(  )
    return "baowu/gem_god_left_hand"
end
