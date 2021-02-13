---------------------------------------------------------------------------
-- 宝物：瑞斯托纹章
---------------------------------------------------------------------------

if modifier_treasure_risto_heraldry == nil then 
    modifier_treasure_risto_heraldry = class({})
end

function modifier_treasure_risto_heraldry:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_risto_heraldry"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_risto_heraldry:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_treasure_risto_heraldry:GetModifierExtraHealthPercentage()
    return 10
end

function modifier_treasure_risto_heraldry:GetModifierPhysicalArmorBonus()
    return -5
end

function modifier_treasure_risto_heraldry:OnAttackLanded(event)
    local attacker = event.attacker
    local target = event.target
    local parent = self:GetParent()
    if attacker ~= parent and target == parent then
        attacker:AddNewModifier(parent, nil, "modifier_treasure_risto_heraldry_buff", nil)
    end
end

function modifier_treasure_risto_heraldry:IsPurgable()
    return false
end

function modifier_treasure_risto_heraldry:RemoveOnDeath()
    return false
end

-----------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_risto_heraldry_buff","treasuresystem/treasure_lua/modifier_treasure_risto_heraldry", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_risto_heraldry_buff == nil then 
    modifier_treasure_risto_heraldry_buff = class({})
end

function modifier_treasure_risto_heraldry_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_treasure_risto_heraldry_buff:GetModifierPhysicalArmorBonus()
    return -5
end

function modifier_treasure_risto_heraldry_buff:IsHidden()
    return true
end

function modifier_treasure_risto_heraldry_buff:IsPurgable()
    return false
end

function modifier_treasure_risto_heraldry_buff:RemoveOnDeath()
    return false
end