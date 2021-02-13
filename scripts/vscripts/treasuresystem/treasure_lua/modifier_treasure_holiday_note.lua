---------------------------------------------------------------------------
-- 宝物：假期休闲 - 假期申请
---------------------------------------------------------------------------

if modifier_treasure_holiday_note == nil then 
    modifier_treasure_holiday_note = class({})
end

function modifier_treasure_holiday_note:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
    }
end

function modifier_treasure_holiday_note:OnAttackStart(event)
    if event.attacker == self:GetParent() then
        event.target:AddNewModifier(event.attacker, nil, "modifier_treasure_holiday_note_physical_armor", {duration = 3})
    end
end

function modifier_treasure_holiday_note:OnModifierAdded(event)
    self:SetStackCount(0)
    local mdfs = self:GetParent():FindAllModifiers()
    for _, mdf in pairs(mdfs) do
        if string.find(mdf:GetName(), "modifier_treasure_holiday_") and mdf:GetName() ~= "modifier_treasure_holiday_note" then
            local count = self:GetStackCount() + mdf:GetStackCount()
            if count > 5 then
                count = 5
            end
            self:SetStackCount(count)                
        end
    end
end

function modifier_treasure_holiday_note:IsPurgable()
    return false
end
 
function modifier_treasure_holiday_note:IsPurgable()
    return false
end
 
function modifier_treasure_holiday_note:RemoveOnDeath()
    return false
end

function modifier_treasure_holiday_note:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holiday_note"
    end
    return "buff/modifier_treasure_keep_changing"
end

---------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_holiday_note_physical_armor","treasuresystem/treasure_lua/modifier_treasure_holiday_note", LUA_MODIFIER_MOTION_NONE )

modifier_treasure_holiday_note_physical_armor = class({})

function modifier_treasure_holiday_note_physical_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_treasure_holiday_note_physical_armor:GetModifierPhysicalArmorBonus()
	return -5 - self:GetCaster():GetModifierStackCount("modifier_treasure_holiday_note", nil) * 2
end

function modifier_treasure_holiday_note_physical_armor:GetTexture()
    return "buff/desolator"
end

function modifier_treasure_holiday_note_physical_armor:IsPurgable()
    return false
end