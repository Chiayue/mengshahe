--御兽大师

if modifier_treasure_beasts_royal == nil then 
    modifier_treasure_beasts_royal = class({})
end

function modifier_treasure_beasts_royal:GetTexture()
    return "buff/modifier_treasure_beasts_royal"
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
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_beast_magic") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_beast_master", nil)
        else
            self:StartIntervalThink(1)
        end
    end
end

function modifier_treasure_beasts_royal:OnIntervalThink()
    local parent = self:GetParent()
    for _, unit in pairs(parent.call_unit) do
        if IsAlive(unit) and not unit:HasModifier("modifier_treasure_beasts_royal_buff") then
            unit:AddNewModifier(parent, nil, "modifier_treasure_beasts_royal_buff", nil)
        end
    end 
end

function modifier_treasure_beasts_royal:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
        local parent = self:GetParent()
        for _, unit in pairs(parent.call_unit) do
            if IsAlive(unit) then
                unit:RemoveModifierByName("modifier_treasure_beasts_royal_buff")
            end
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
    return true
end

function modifier_treasure_beasts_royal_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_beasts_royal_buff:GetModifierAttackSpeedBonus_Constant()
    return 50
end