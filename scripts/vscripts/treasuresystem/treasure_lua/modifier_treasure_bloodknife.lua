---------------------------------------------------------------------------
-- 宝物：饮血刀
---------------------------------------------------------------------------

if modifier_treasure_bloodknife == nil then 
    modifier_treasure_bloodknife = class({})
end

function modifier_treasure_bloodknife:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_bloodknife"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_bloodknife:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_bloodknife:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) then
        if self:GetStackCount() < 700 then
            self:IncrementStackCount()
            if self:GetStackCount() >= 700 then
                local parent = self:GetParent()
                parent:AddNewModifier(parent, nil, "modifier_treasure_bloodknife_buff", nil)
            end
        end
    end
end

function modifier_treasure_bloodknife:IsPurgable()
    return false
end
 
function modifier_treasure_bloodknife:RemoveOnDeath()
    return false
end

function modifier_treasure_bloodknife:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_bloodthirster") and parent:HasModifier("modifier_treasure_bloodaxe") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_bloodpower", nil)
        end
    end
end

function modifier_treasure_bloodknife:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_bloodknife_buff")
        self:GetParent():RemoveModifierByName("modifier_treasure_bloodpower")
    end
end

-------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_bloodknife_buff","treasuresystem/treasure_lua/modifier_treasure_bloodknife", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_bloodknife_buff == nil then 
    modifier_treasure_bloodknife_buff = class({})
end

function modifier_treasure_bloodknife_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_bloodknife_buff:GetModifierBonusStats_Strength()
    return 400
end

function modifier_treasure_bloodknife_buff:GetModifierBonusStats_Agility()
    return 400
end

function modifier_treasure_bloodknife_buff:GetModifierBonusStats_Intellect()
    return 400
end

function modifier_treasure_bloodknife_buff:IsHidden()
    return true
end

function modifier_treasure_bloodknife_buff:IsPurgable()
    return false
end
 
function modifier_treasure_bloodknife_buff:RemoveOnDeath()
    return false
end

