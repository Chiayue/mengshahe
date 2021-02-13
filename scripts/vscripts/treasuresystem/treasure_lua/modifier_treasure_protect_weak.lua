---------------------------------------------------------------------------
-- 宝物：捍卫弱者
---------------------------------------------------------------------------

if modifier_treasure_protect_weak == nil then 
    modifier_treasure_protect_weak = class({})
end
function modifier_treasure_protect_weak:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_protect_weak"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_protect_weak:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_treasure_protect_weak:GetModifierPreAttack_BonusDamage()
    if IsServer() then
        local bonus_damage = 0
        local parent = self:GetParent()
        local parent_damage = parent:GetDamageMax()
        for _, hero in pairs(HeroList:GetAllHeroes()) do
            if hero ~= parent and hero:IsAlive() and hero:IsRealHero() then
                local temp = hero:GetDamageMax()
                if parent_damage > temp then
                    bonus_damage = bonus_damage + 1000
                end
            end
        end
        self:SetStackCount(bonus_damage)
    end
    return self:GetStackCount()
end

function modifier_treasure_protect_weak:IsPurgable()
    return false
end
 
function modifier_treasure_protect_weak:RemoveOnDeath()
    return false
end