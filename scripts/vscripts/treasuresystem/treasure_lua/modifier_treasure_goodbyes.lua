---------------------------------------------------------------------------
-- 告辞
---------------------------------------------------------------------------

if modifier_treasure_goodbyes == nil then 
    modifier_treasure_goodbyes = class({})
end

function modifier_treasure_goodbyes:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_goodbyes"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_goodbyes:IsPurgable()
    return false
end
 
function modifier_treasure_goodbyes:RemoveOnDeath()
    return false
end 

function modifier_treasure_goodbyes:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_goodbyes_buff", nil):SetStackCount(40)
        if parent:HasModifier("modifier_treasure_extra_exp") then
            parent:FindModifierByName("modifier_treasure_extra_exp_buff"):SetStackCount(30)
            parent:FindModifierByName("modifier_treasure_goodbyes_buff"):SetStackCount(100)
        end
    end
end

function modifier_treasure_goodbyes:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_goodbyes_buff")
        if parent:HasModifier("modifier_treasure_extra_exp") then
            parent:FindModifierByName("modifier_treasure_extra_exp_buff"):SetStackCount(3)
        end
    end
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_goodbyes_buff","treasuresystem/treasure_lua/modifier_treasure_goodbyes", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_goodbyes_buff == nil then 
    modifier_treasure_goodbyes_buff = class({})
end

function modifier_treasure_goodbyes_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_goodbyes_buff:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount()
end

function modifier_treasure_goodbyes_buff:IsHidden() 
    return true
end

function modifier_treasure_goodbyes_buff:IsPurgable() 
    return false
end

function modifier_treasure_goodbyes_buff:RemoveOnDeath() 
    return false
end