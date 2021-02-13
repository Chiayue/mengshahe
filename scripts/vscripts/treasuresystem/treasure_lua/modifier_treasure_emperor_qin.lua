---------------------------------------------------------------------------
-- 宝物：我，秦始皇，打钱
---------------------------------------------------------------------------

if modifier_treasure_emperor_qin == nil then 
    modifier_treasure_emperor_qin = class({})
end

function modifier_treasure_emperor_qin:GetTexture()
    return "buff/modifier_treasure_emperor_qin"
end

function modifier_treasure_emperor_qin:IsPurgable()
    return false
end
 
function modifier_treasure_emperor_qin:RemoveOnDeath()
    return false
end

function modifier_treasure_emperor_qin:OnCreated(kv)
    if IsServer() then
        game_playerinfo:set_player_gold(self:GetParent():GetPlayerID(), -10000)
        self:SetStackCount(10)
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_emperor_qin:OnIntervalThink()
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then
        local errortext = "你被骗了，秦始皇拿着你的钱去泡嫩模了"
        if RollPercentage(50) then
            game_playerinfo:set_player_gold(self:GetParent():GetPlayerID(), 50000)
            errortext = "秦始皇把兵马俑挖出来了，他很开心，给了你5万块钱"
        end
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerID()), "response_errortext",{errortext = errortext})
        self:StartIntervalThink(-1) 
    end
end