-- 杀戮之心

if modifier_killing_heart == nil then 
    modifier_killing_heart = class({})
end

function modifier_killing_heart:GetTexture()
    return "buff/modifier_killing_heart"
end

function modifier_killing_heart:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_killing_heart:OnDeath(params)
	local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
		game_playerinfo:set_player_gold(parent:GetPlayerID(), self:GetStackCount())
    end
end

function modifier_killing_heart:IsHidden()
    if self:GetStackCount() > 0 then
        return false
    else
        return true
    end
end

function modifier_killing_heart:IsPurgable()
    return false
end
 
function modifier_killing_heart:RemoveOnDeath()
    return false
end

function modifier_killing_heart:OnCreated(kv)
    if IsServer() then
        self:SetStackCount(0)
    end
end