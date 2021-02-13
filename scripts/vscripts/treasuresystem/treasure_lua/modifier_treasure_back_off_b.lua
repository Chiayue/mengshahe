-- 宝物: 倒车

if modifier_treasure_back_off_b == nil then 
    modifier_treasure_back_off_b = class({})
end

function modifier_treasure_back_off_b:GetTexture()
    return "buff/modifier_treasure_back_off_b"
end

function modifier_treasure_back_off_b:IsPurgable()
    return false
end

function modifier_treasure_back_off_b:RemoveOnDeath()
    return false
end

function modifier_treasure_back_off_b:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        self:SetStackCount(2)
        local count = self:GetStackCount()
        if parent:HasModifier("modifier_treasure_back_off_a") then
            count = count + parent:FindModifierByName("modifier_treasure_back_off_a"):GetStackCount()
        end
        if parent:HasModifier("modifier_treasure_back_off_c") then
            count = count + parent:FindModifierByName("modifier_treasure_back_off_c"):GetStackCount()
        end
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerID()), "response_overload", {
            stackcount = count, 
            record = global_var_func.overload_record[self:GetParent():GetPlayerID() + 1],
        })
    end
end