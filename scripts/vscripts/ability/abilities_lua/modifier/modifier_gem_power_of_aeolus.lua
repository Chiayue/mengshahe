if modifier_gem_power_of_aeolus == nil then
	modifier_gem_power_of_aeolus = class({})
end

function modifier_gem_power_of_aeolus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_gem_power_of_aeolus:OnCreated(params)
    if IsServer() then 
        local hero = self:GetParent()
        self.suit_agility_add = math.ceil(hero:GetBaseAgility() * params.suit_agility_add / 100)
        self.suit_attackspeed_add =  hero:GetAttackSpeed() *params.suit_attackspeed_add / 100
    end
end

function modifier_gem_power_of_aeolus:OnRefresh(params)
    if IsServer() then 
        local hero = self:GetParent()
        self.suit_agility_add = math.ceil(hero:GetBaseAgility() * params.suit_agility_add / 100)
    end
end

function modifier_gem_power_of_aeolus:GetModifierAttackSpeedBonus_Constant()
    return self.suit_attackspeed_add
end

function modifier_gem_power_of_aeolus:GetModifierBonusStats_Agility()
    return self.suit_agility_add
end


function modifier_gem_power_of_aeolus:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_power_of_aeolus:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_power_of_aeolus:GetTexture()
    return "baowu/sk12"
end
