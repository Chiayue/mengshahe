---------------------------------------------------------------------------
-- 宝物：精英杀手
---------------------------------------------------------------------------

if modifier_treasure_elite_killer == nil then 
    modifier_treasure_elite_killer = class({})
end

function modifier_treasure_elite_killer:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_elite_killer"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_elite_killer:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_treasure_elite_killer:GetModifierTotalDamageOutgoing_Percentage(params)
    -- 普通小怪
    if ContainUnitTypeFlag(params.target, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL) then
        -- 精英怪
        if ContainUnitTypeFlag(params.target, DOTA_UNIT_TYPE_FLAG_ELITE) then
            return -10
        end
        return -30
    end
    -- 普通BOSS、金币怪、金矿
    if ContainUnitTypeFlag(params.target, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_GENERAL, DOTA_UNIT_TYPE_FLAG_OPERATION + DOTA_UNIT_TYPE_FLAG_GOLD) then
        return 20
    end
    -- 炎魔
    if ContainUnitTypeFlag(params.target, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_OPERATION) then
        return 40
    end
    -- 关底BOSS
    if ContainUnitTypeFlag(params.target, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_FINALLY) then
        return 50
    end
    return 0
end

function modifier_treasure_elite_killer:IsPurgable()
    return false
end
 
function modifier_treasure_elite_killer:RemoveOnDeath()
    return false
end 
