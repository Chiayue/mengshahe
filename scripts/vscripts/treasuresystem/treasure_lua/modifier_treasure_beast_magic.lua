--幻兽大师

if modifier_treasure_beast_magic == nil then
    modifier_treasure_beast_magic = class({})
end

function modifier_treasure_beast_magic:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_beast_magic"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_beast_magic:IsHidden()
    return false
end

function modifier_treasure_beast_magic:IsPurgable()
    return false
end

function modifier_treasure_beast_magic:RemoveOnDeath()
    return false
end

function modifier_treasure_beast_magic:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_beast_magic:OnIntervalThink()
    local parent = self:GetParent()
    if IsAlive(parent) then
        local stack_count = 50
        if parent:HasModifier("modifier_treasure_beasts_royal") then
            stack_count = 100
        end
        for _, unit in pairs(parent.call_unit) do
            unit:AddNewModifier(parent, nil, "modifier_treasure_beast_magic_buff", {duration = 1}):SetStackCount(stack_count)
        end
    end
end

----------------------------------------------------------------

LinkLuaModifier("modifier_treasure_beast_magic_buff","treasuresystem/treasure_lua/modifier_treasure_beast_magic", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_beast_magic_buff == nil then
    modifier_treasure_beast_magic_buff = class({})
end

function modifier_treasure_beast_magic_buff:IsHidden() 
    return true
end

function modifier_treasure_beast_magic_buff:IsPurgable() 
    return false
end

function modifier_treasure_beast_magic_buff:RemoveOnDeath() 
    return false 
end

function modifier_treasure_beast_magic_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_treasure_beast_magic_buff:GetModifierDamageOutgoing_Percentage()
    return self:GetStackCount()
end