-- 宝物: 倒车

if modifier_treasure_back_off_a == nil then 
    modifier_treasure_back_off_a = class({})
end

function modifier_treasure_back_off_a:GetTexture()
    return "buff/modifier_treasure_back_off_a"
end

function modifier_treasure_back_off_a:IsPurgable()
    return false
end

function modifier_treasure_back_off_a:RemoveOnDeath()
    return false
end

function modifier_treasure_back_off_a:OnCreated(kv)
    if IsServer() then
        -- local parent = self:GetParent()
        -- self:SetStackCount(1)
        -- local count = self:GetStackCount()
        -- if parent:HasModifier("modifier_treasure_back_off_b") then
        --     count = count + parent:FindModifierByName("modifier_treasure_back_off_b"):GetStackCount()
        -- end
        -- if parent:HasModifier("modifier_treasure_back_off_c") then
        --     count = count + parent:FindModifierByName("modifier_treasure_back_off_c"):GetStackCount()
        -- end
        -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerID()), "response_overload", {
        --     stackcount = count, 
        --     record = global_var_func.overload_record[self:GetParent():GetPlayerID() + 1],
        -- })
    end
end