---------------------------------------------------------------------------
-- 宝物：狡诈计谋
---------------------------------------------------------------------------

if modifier_treasure_wile == nil then 
    modifier_treasure_wile = class({})
end

function modifier_treasure_wile:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_wile"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_wile:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
end

function modifier_treasure_wile:GetModifierAvoidDamage(event)
    local parent = self:GetParent()
    if self:GetStackCount() <= 0 and event.damage >= parent:GetHealth() then
        parent:SetHealth(parent:GetMaxHealth() * 0.5)
        self:SetStackCount(60)
        for _, hero in pairs(HeroList:GetAllHeroes()) do
            if hero ~= parent then
                if hero and not hero:IsNull() and hero:IsAlive() then
                    local position = hero:GetOrigin()
                    hero:SetOrigin(parent:GetOrigin())                    
                    parent:SetOrigin(position)                    
                    break
                end
            end
        end
        return 1
    end
    return 0
end

function modifier_treasure_wile:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_wile:OnIntervalThink()
    if self:GetStackCount() > 0 then
        self:DecrementStackCount()
    end
end
 
function modifier_treasure_wile:IsPurgable()
    return false
end
 
function modifier_treasure_wile:RemoveOnDeath()
    return false
end