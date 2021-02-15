-- 宝物： 王者荣耀

if modifier_treasure_king_glory == nil then 
    modifier_treasure_king_glory = class({})
end

LinkLuaModifier("modifier_treasure_king_increases_damage","treasuresystem/treasure_lua/modifier_treasure_king_brilliant",LUA_MODIFIER_MOTION_NONE)

function modifier_treasure_king_glory:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_king_glory"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_king_glory:IsPurgable()
    return false -- 无法驱散
end
function modifier_treasure_king_glory:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_king_glory:OnCreated(params)
    if not IsServer() then
        return
    end
    if self:GetCaster():HasModifier("modifier_treasure_king_increases_damage") then
       return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_treasure_king_increases_damage", {})
end
