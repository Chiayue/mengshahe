---------------------------------------------------------------------------
-- 宝物：军团旗帜
---------------------------------------------------------------------------

if modifier_treasure_legion_flag == nil then 
    modifier_treasure_legion_flag = class({})
end

function modifier_treasure_legion_flag:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_legion_flag"
    end
    return "buff/modifier_treasure_keep_changing"
end

-- function modifier_treasure_legion_flag:IsPurgable()
--     return false
-- end

-- function modifier_treasure_legion_flag:RemoveOnDeath()
--     return false
-- end

-- function modifier_treasure_legion_flag:IsAura()
--     return true
-- end

-- function modifier_treasure_legion_flag:GetAuraRadius()
--     return 400
-- end

-- function modifier_treasure_legion_flag:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_FRIENDLY
-- end

-- function modifier_treasure_legion_flag:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_treasure_legion_flag:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- function modifier_treasure_legion_flag:GetModifierAura()
--     return "modifier_treasure_legion_flag_attack_speed"
-- end

function modifier_treasure_legion_flag:IsDebuff()
	return false 
end
function modifier_treasure_legion_flag:IsHidden()
	return false
end
function modifier_treasure_legion_flag:IsPurgable()
	return false
end
function modifier_treasure_legion_flag:IsPurgeException()
	return false
end
function modifier_treasure_legion_flag:RemoveOnDeath()
    return false -- 死亡不移除
end
function modifier_treasure_legion_flag:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
end
function modifier_treasure_legion_flag:OnIntervalThink() 
    local ally = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		self:GetCaster():GetAbsOrigin(),
		nil,
		400,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
    )
    for i=1,#ally do 
        ally[i]:AddNewModifier(self:GetCaster(), self, "modifier_treasure_legion_flag_attack_speed", {duration = 5})
    end       
    self:StartIntervalThink(5)
end
--------------------------------------------------------------------------
LinkLuaModifier( "modifier_treasure_legion_flag_attack_speed","treasuresystem/treasure_lua/modifier_treasure_legion_flag", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_legion_flag_attack_speed == nil then 
    modifier_treasure_legion_flag_attack_speed = class({})
end

function modifier_treasure_legion_flag_attack_speed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_treasure_legion_flag_attack_speed:GetModifierAttackSpeedBonus_Constant()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_treasure_legion_mystique") and caster:HasModifier("modifier_treasure_legion_arcanum") and caster:HasModifier("modifier_treasure_legion_drum") then
        return 100
    else 
        return 20
    end
end

function modifier_treasure_legion_flag_attack_speed:IsHidden()
    return true
end