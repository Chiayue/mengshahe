---------------------------------------------------------------------------
-- 宝物：C位挑战
---------------------------------------------------------------------------

if modifier_treasure_center_challenge == nil then 
    modifier_treasure_center_challenge = class({})
end

function modifier_treasure_center_challenge:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_center_challenge"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_center_challenge:IsPurgable()
    return false
end
 
function modifier_treasure_center_challenge:RemoveOnDeath()
    return false
end

function modifier_treasure_center_challenge:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self.gold = game_playerinfo:get_player_gold(self.parent:GetPlayerID())
        self:SetStackCount(0)
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_center_challenge:OnIntervalThink()
    self:IncrementStackCount()
    if self:GetStackCount() > 90 then
        self:StartIntervalThink(-1)
        self:Destroy()
    else
        if game_playerinfo:get_player_gold(self.parent:GetPlayerID()) - self.gold >= 20000 then
            self:StartIntervalThink(-1)
            self:SetStackCount(0)
            AddItemByName(self.parent, "item_book_initiative_a")
        end
    end
end
