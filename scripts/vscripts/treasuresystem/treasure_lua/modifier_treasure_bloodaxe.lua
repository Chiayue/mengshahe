---------------------------------------------------------------------------
-- 宝物：饮血斧
---------------------------------------------------------------------------

if modifier_treasure_bloodaxe == nil then 
    modifier_treasure_bloodaxe = class({})
end

function modifier_treasure_bloodaxe:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_bloodaxe"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_bloodaxe:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_bloodaxe:OnDeath(params)
    if IsMyKilledBadGuys(self:GetParent(), params) then
        if self:GetStackCount() < 600 then
            self:IncrementStackCount()
            if self:GetStackCount() >= 600 then
                local parent = self:GetParent()
                parent:AddNewModifier(parent, nil, "modifier_treasure_bloodaxe_buff", nil)
            end
        end
    end
end

function modifier_treasure_bloodaxe:IsPurgable()
    return false
end
 
function modifier_treasure_bloodaxe:RemoveOnDeath()
    return false
end

function modifier_treasure_bloodaxe:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)
        local parent = self:GetParent()
        if parent:HasModifier("modifier_treasure_bloodthirster") and parent:HasModifier("modifier_treasure_bloodknife") then
            parent:AddNewModifier(parent, nil, "modifier_treasure_bloodpower", nil)
        end
    end
end

function modifier_treasure_bloodaxe:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_treasure_bloodaxe_buff")
        self:GetParent():RemoveModifierByName("modifier_treasure_bloodpower")
    end
end

-------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_bloodaxe_buff","treasuresystem/treasure_lua/modifier_treasure_bloodaxe", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_bloodaxe_buff == nil then 
    modifier_treasure_bloodaxe_buff = class({})
end

function modifier_treasure_bloodaxe_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_bloodaxe_buff:GetModifierBonusStats_Strength()
    return 300
end

function modifier_treasure_bloodaxe_buff:GetModifierBonusStats_Agility()
    return 300
end

function modifier_treasure_bloodaxe_buff:GetModifierBonusStats_Intellect()
    return 300
end

function modifier_treasure_bloodaxe_buff:IsHidden()
    return true
end

function modifier_treasure_bloodaxe_buff:IsPurgable()
    return false
end
 
function modifier_treasure_bloodaxe_buff:RemoveOnDeath()
    return false
end

