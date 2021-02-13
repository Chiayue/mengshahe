---------------------------------------------------------------------------
-- 宝物：经验加3
---------------------------------------------------------------------------

if modifier_treasure_extra_exp == nil then 
    modifier_treasure_extra_exp = class({})
end

function modifier_treasure_extra_exp:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_extra_exp"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_extra_exp:IsPurgable()
    return false
end
 
function modifier_treasure_extra_exp:RemoveOnDeath()
    return false
end
 
function modifier_treasure_extra_exp:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_treasure_extra_exp_buff", nil):SetStackCount(3)
        if parent:HasModifier("modifier_treasure_goodbyes") then
            parent:FindModifierByName("modifier_treasure_goodbyes_buff"):SetStackCount(100)
            parent:FindModifierByName("modifier_treasure_extra_exp_buff"):SetStackCount(30)
        end
    end
end 

function modifier_treasure_extra_exp:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_extra_exp_buff")
        if parent:HasModifier("modifier_treasure_goodbyes") then
            parent:FindModifierByName("modifier_treasure_goodbyes_buff"):SetStackCount(40)
        end
    end
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_treasure_extra_exp_buff","treasuresystem/treasure_lua/modifier_treasure_extra_exp", LUA_MODIFIER_MOTION_NONE)

if modifier_treasure_extra_exp_buff == nil then 
    modifier_treasure_extra_exp_buff = class({})
end

function modifier_treasure_extra_exp_buff:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_extra_exp_buff:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        parent:AddExperience(self:GetStackCount(), DOTA_ModifyXP_Unspecified, false, false)
    end
end

function modifier_treasure_extra_exp_buff:IsHidden() 
    return true
end

function modifier_treasure_extra_exp_buff:IsPurgable() 
    return false
end

function modifier_treasure_extra_exp_buff:RemoveOnDeath() 
    return false
end