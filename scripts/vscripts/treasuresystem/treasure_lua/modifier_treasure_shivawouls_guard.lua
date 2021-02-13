---------------------------------------------------------------------------
-- 宝物：希瓦之守护
---------------------------------------------------------------------------

if modifier_treasure_shivawouls_guard == nil then 
    modifier_treasure_shivawouls_guard = class({})
end
function modifier_treasure_shivawouls_guard:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_shivawouls_guard"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_shivawouls_guard:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_treasure_shivawouls_guard:GetModifierPhysicalArmorBonus()
    return 15
end

function modifier_treasure_shivawouls_guard:IsPurgable()
    return false
end

function modifier_treasure_shivawouls_guard:RemoveOnDeath()
    return false
end

-- function modifier_treasure_shivawouls_guard:OnCreated(table)
--     if IsServer() then
--         self:StartIntervalThink(1)
--     end
-- end

function modifier_treasure_shivawouls_guard:IsAura()
    return true
end

function modifier_treasure_shivawouls_guard:GetAuraRadius()
    return 400
end

function modifier_treasure_shivawouls_guard:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_treasure_shivawouls_guard:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_treasure_shivawouls_guard:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_treasure_shivawouls_guard:GetModifierAura()
    return "modifier_treasure_shivawouls_guard_attack_speed"
end

--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_shivawouls_guard_attack_speed","treasuresystem/treasure_lua/modifier_treasure_shivawouls_guard", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_shivawouls_guard_attack_speed == nil then 
    modifier_treasure_shivawouls_guard_attack_speed = class({})
end

function modifier_treasure_shivawouls_guard_attack_speed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_shivawouls_guard_attack_speed:GetModifierAttackSpeedBonus_Constant(params)
	return -45
end

function modifier_treasure_shivawouls_guard_attack_speed:IsPurgable()
    return false
end

function modifier_treasure_shivawouls_guard_attack_speed:RemoveOnDeath()
    return true
end