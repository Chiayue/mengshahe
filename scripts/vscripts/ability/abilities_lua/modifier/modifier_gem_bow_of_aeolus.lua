if modifier_gem_bow_of_aeolus == nil then
	modifier_gem_bow_of_aeolus = class({})
end

function modifier_gem_bow_of_aeolus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_gem_bow_of_aeolus:OnCreated(params)
    if IsServer() then 
        local hero = self:GetParent(  )
        local ability = self:GetAbility()
        self.agility_add =  math.ceil(hero:GetBaseAgility() * ability:GetSpecialValueFor( "agility_add" ) / 100)
        if hero:HasModifier("modifier_gem_arrow_of_aeolus") and not hero:HasModifier("modifier_gem_power_of_aeolus") then
            local suit_agility_add = ability:GetSpecialValueFor( "suit_agility_add" )
            local suit_attackspeed_add = ability:GetSpecialValueFor( "suit_attackspeed_add" )
            hero:AddNewModifier( hero, nil, "modifier_gem_power_of_aeolus", {suit_agility_add = suit_agility_add,suit_attackspeed_add = suit_attackspeed_add} )
        end
        self:StartIntervalThink(1)
    end
end

function modifier_gem_bow_of_aeolus:OnRefresh(params)
    if IsServer() then
        local hero = self:GetParent(  )
        local ability = self:GetAbility()
        local agility_add_new = math.ceil(hero:GetBaseAgility() * ability:GetSpecialValueFor( "agility_add" ) / 100)
        if agility_add_new~= self.agility_add then
            self.agility_add = agility_add_new
            if hero:HasModifier("modifier_gem_power_of_aeolus") then
                local suit_agility_add = ability:GetSpecialValueFor( "suit_agility_add" )
                local suit_attackspeed_add = ability:GetSpecialValueFor( "suit_attackspeed_add" )
                hero:AddNewModifier( hero, nil, "modifier_gem_power_of_aeolus", {suit_agility_add = suit_agility_add,suit_attackspeed_add = suit_attackspeed_add} )
            end
        end
    end
end

function modifier_gem_bow_of_aeolus:OnIntervalThink()
    self:ForceRefresh()
end

function modifier_gem_bow_of_aeolus:GetModifierBonusStats_Agility()
    return self.agility_add
end

function modifier_gem_bow_of_aeolus:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_bow_of_aeolus:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_bow_of_aeolus:GetTexture()
    return "baowu/gem_bow_of_aeolus"
end
