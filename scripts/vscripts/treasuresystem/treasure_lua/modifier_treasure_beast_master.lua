-- 兽王

if modifier_treasure_beast_master == nil then
    modifier_treasure_beast_master = class({})
end

function modifier_treasure_beast_master:GetTexture()
    return "buff/modifier_treasure_beast_master"
end

function modifier_treasure_beast_master:IsHidden()
    return false
end

function modifier_treasure_beast_master:IsPurgable()
    return false
end

function modifier_treasure_beast_master:RemoveOnDeath()
    return false
end

function modifier_treasure_beast_master:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_beast_magic")
        parent:RemoveModifierByName("modifier_treasure_beasts_royal")
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_beast_master:OnIntervalThink()
    local parent = self:GetParent()
    for _, unit in pairs(parent.call_unit) do
        if IsAlive(unit) and not unit:HasModifier("modifier_treasure_beast_master_buff") then
            unit:AddNewModifier(parent, nil, "modifier_treasure_beast_master_buff", nil)
        end
    end
end

function modifier_treasure_beast_master:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
        local parent = self:GetParent()
        for _, unit in pairs(parent.call_unit) do
            if IsAlive(unit) then
                unit:RemoveModifierByName("modifier_treasure_beast_master_buff")
            end
        end
    end
end

----------------------------------------------------------------

LinkLuaModifier("modifier_treasure_beast_master_buff","treasuresystem/treasure_lua/modifier_treasure_beast_master", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_beast_master_buff == nil then
    modifier_treasure_beast_master_buff = class({})
end

function modifier_treasure_beast_master_buff:IsHidden() 
    return true
end

function modifier_treasure_beast_master_buff:IsPurgable() 
    return false
end

function modifier_treasure_beast_master_buff:RemoveOnDeath() 
    return true
end

function modifier_treasure_beast_master_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_beast_master_buff:GetModifierDamageOutgoing_Percentage()
    return 100 
end

function modifier_treasure_beast_master_buff:GetModifierAttackSpeedBonus_Constant()
    return 100 
end