---------------------------------------------------------------------------
-- 宝物：饮血剑
---------------------------------------------------------------------------

if modifier_treasure_bloodthirster == nil then 
    modifier_treasure_bloodthirster = class({})
end

function modifier_treasure_bloodthirster:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_bloodthirster"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_bloodthirster:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_bloodthirster:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) then
        if self:GetStackCount() < 500 then
            self:IncrementStackCount()
            if self:GetStackCount() >= 500 then
                local parent = self:GetParent()
                parent:AddNewModifier(parent, nil, "modifier_treasure_bloodthirster_buff", nil)
            end
        end
    end
end

function modifier_treasure_bloodthirster:IsPurgable()
    return false
end
 
function modifier_treasure_bloodthirster:RemoveOnDeath()
    return false
end

function modifier_treasure_bloodthirster:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_bloodaxe") and parent:HasModifier("modifier_treasure_bloodknife") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_bloodpower", nil)
        end
    end
end

function modifier_treasure_bloodthirster:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_bloodthirster_buff")
        self:GetParent():RemoveModifierByName("modifier_treasure_bloodpower")
    end
end

-------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_bloodthirster_buff","treasuresystem/treasure_lua/modifier_treasure_bloodthirster", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_bloodthirster_buff == nil then 
    modifier_treasure_bloodthirster_buff = class({})
end

function modifier_treasure_bloodthirster_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_bloodthirster_buff:GetModifierBonusStats_Strength()
    return 200
end

function modifier_treasure_bloodthirster_buff:GetModifierBonusStats_Agility()
    return 200
end

function modifier_treasure_bloodthirster_buff:GetModifierBonusStats_Intellect()
    return 200
end

function modifier_treasure_bloodthirster_buff:IsHidden()
    return true
end

function modifier_treasure_bloodthirster_buff:IsPurgable()
    return false
end
 
function modifier_treasure_bloodthirster_buff:RemoveOnDeath()
    return false
end

