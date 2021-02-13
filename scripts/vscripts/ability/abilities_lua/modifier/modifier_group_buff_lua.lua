require("global/global_var_func")
require("info/game_playerinfo")

modifier_group_buff_lua = class({})
--------------------------------------------------------------------------------

function modifier_group_buff_lua:DeclareFunctions()
    local funcs = {
        --增伤
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_group_buff_lua:IsHidden()
    return true
end

function modifier_group_buff_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_group_buff_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_group_buff_lua:OnCreated( kv )
    if not IsServer( ) then
        self:IncrementStackCount()
        return
    end
end

function modifier_group_buff_lua:OnRefresh(params)
    if not IsServer( ) then
        self:IncrementStackCount()
        return
    end
end

function modifier_group_buff_lua:GetModifierTotalDamageOutgoing_Percentage()
    return 10*self:GetStackCount()
end

