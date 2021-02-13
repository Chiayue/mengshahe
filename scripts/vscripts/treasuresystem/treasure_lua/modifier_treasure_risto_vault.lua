---------------------------------------------------------------------------
-- 宝物：瑞斯托王庭金库
---------------------------------------------------------------------------

if modifier_treasure_risto_vault == nil then 
    modifier_treasure_risto_vault = class({})
end
function modifier_treasure_risto_vault:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_risto_vault"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_risto_vault:IsPurgable()
    return false
end
 
function modifier_treasure_risto_vault:RemoveOnDeath()
    return false
end 

function modifier_treasure_risto_vault:OnCreated(params)
    if IsServer() then
        self.current_round = global_var_func.current_round
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_risto_vault:OnIntervalThink()
    if self.current_round < global_var_func.current_round then
        self.current_round = global_var_func.current_round
        local parent = self:GetParent()
        game_playerinfo:set_player_gold(parent:GetPlayerID(), 200 * parent:GetLevel())
    end
end