---------------------------------------------------------------------------
-- 宝物：神速圣剑
---------------------------------------------------------------------------

if modifier_treasure_fast_sword == nil then 
    modifier_treasure_fast_sword = class({})
end

function modifier_treasure_fast_sword:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_fast_sword"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_fast_sword:IsPurgable()
    return false
end
 
function modifier_treasure_fast_sword:RemoveOnDeath()
    return false
end

function modifier_treasure_fast_sword:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
        self.parent = self:GetParent()
        self:OnRefresh()
    end
end

function modifier_treasure_fast_sword:OnRefresh(params)
    if IsServer() then
        if self:GetStackCount() < 3 then
            self:IncrementStackCount()
            if self:GetStackCount() == 1 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self.parent:GetPlayerID()), "extra_attack_speed", 10)
            end
            if self:GetStackCount() == 2 then
                game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(self.parent:GetPlayerID()), "extra_attack_speed", 20)
            end
            if self:GetStackCount() == 3 then
                global_var_func.max_atk_speed[self.parent:GetPlayerID() + 1] = 400
            end
        end
    end
end