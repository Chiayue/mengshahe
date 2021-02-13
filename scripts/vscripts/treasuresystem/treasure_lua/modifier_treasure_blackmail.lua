---------------------------------------------------------------------------
-- 宝物：碰瓷
---------------------------------------------------------------------------

if modifier_treasure_blackmail == nil then 
    modifier_treasure_blackmail = class({})
end

function modifier_treasure_blackmail:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_treasure_blackmail:OnAttackLanded(event)
    local parent = self:GetParent()
    local target = event.target
    if target == parent then
        game_playerinfo:set_player_gold(parent:GetPlayerID(), 5)
    end
end

function modifier_treasure_blackmail:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_blackmail"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_blackmail:IsPurgable()
    return false
end
 
function modifier_treasure_blackmail:RemoveOnDeath()
    return false
end