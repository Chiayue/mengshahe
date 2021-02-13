-- 宝物: 我也来一个


if modifier_treasure_have_one_too == nil then 
    modifier_treasure_have_one_too = class({})
end

function modifier_treasure_have_one_too:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_have_one_too"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_have_one_too:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_have_one_too:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_have_one_too:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_treasure_have_one_too:OnCreated(params)
    if not IsServer() then
        return
    end
    if global_var_func.all_player_amount <= 1 then
        return
    end
    local player_id = self:GetCaster():GetPlayerID()
    local randomid = RandomInt(1, global_var_func.all_player_amount) - 1
    if player_id == randomid then
        randomid = player_id + 1
    end
    if randomid > global_var_func.all_player_amount-1 then
        randomid = 0
    end
    local target = PlayerResource:GetPlayer(randomid):GetAssignedHero()
    if target then
        -- local 
        local target_treasures = game_playerinfo:get_treasures_by_id(target:GetPlayerID())
        -- DeepPrintTable(target_treasures)
        local randomindex = RandomInt(1, #target_treasures)
        local treasurename = target_treasures[randomindex]
        AddTreasureForHero(self:GetCaster(), treasurename, {})
    end
end
