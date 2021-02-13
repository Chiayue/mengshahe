--御兽大师

if modifier_treasure_beasts_royal == nil then 
    modifier_treasure_beasts_royal = class({})
end

function modifier_treasure_beasts_royal:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_beasts_royal"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_beasts_royal:IsHidden() 
    return false 
end

function modifier_treasure_beasts_royal:IsPurgable() 
    return false 
end

function modifier_treasure_beasts_royal:RemoveOnDeath() 
    return false 
end

function modifier_treasure_beasts_royal:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_beasts_royal:OnIntervalThink()
    local parent = self:GetParent()
    if IsAlive(parent) then
        local stack_count = 50
        if parent:HasModifier("modifier_treasure_beast_magic") then
            stack_count = 100
        end
        for _, unit in pairs(parent.call_unit) do
            unit:AddNewModifier(parent, nil, "modifier_treasure_beasts_royal_buff", {duration = 1}):SetStackCount(stack_count)
        end 
    end
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_beasts_royal_buff","treasuresystem/treasure_lua/modifier_treasure_beasts_royal", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_beasts_royal_buff == nil then 
    modifier_treasure_beasts_royal_buff = class({})
end

function modifier_treasure_beasts_royal_buff:IsHidden() 
    return true 
end

function modifier_treasure_beasts_royal_buff:IsPurgable() 
    return false 
end

function modifier_treasure_beasts_royal_buff:RemoveOnDeath() 
    return false 
end

function modifier_treasure_beasts_royal_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_beasts_royal_buff:GetModifierAttackSpeedBonus_Constant()
    return self:GetStackCount()
end