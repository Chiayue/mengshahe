--幻兽大师

if modifier_treasure_beast_magic == nil then
    modifier_treasure_beast_magic = class({})
end

function modifier_treasure_beast_magic:GetTexture()
    return "buff/modifier_treasure_beast_magic"
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
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_beasts_royal") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_beast_master", nil)
        else
            self:StartIntervalThink(1)
        end
    end
end

function modifier_treasure_beast_magic:OnIntervalThink()
    local parent = self:GetParent()
    for _, unit in pairs(parent.call_unit) do
        if IsAlive(unit) and not unit:HasModifier("modifier_treasure_beast_magic_buff") then
            unit:AddNewModifier(parent, nil, "modifier_treasure_beast_magic_buff", nil)
        end
    end
end

function modifier_treasure_beast_magic:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
        local parent = self:GetParent()
        for _, unit in pairs(parent.call_unit) do
            if IsAlive(unit) then
                unit:RemoveModifierByName("modifier_treasure_beast_magic_buff")
            end
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
    return true
end

function modifier_treasure_beast_magic_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_treasure_beast_magic_buff:GetModifierDamageOutgoing_Percentage()
    return 50
end