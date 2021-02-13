---------------------------------------------------------------------------
-- 宝物：休假用品 - 沙滩拖鞋
---------------------------------------------------------------------------

if modifier_treasure_holiday_beach_slippers == nil then 
    modifier_treasure_holiday_beach_slippers = class({})
end

function modifier_treasure_holiday_beach_slippers:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_holiday_beach_slippers"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_holiday_beach_slippers:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_holiday_beach_slippers:GetModifierBonusStats_Strength()
    return 50
end

function modifier_treasure_holiday_beach_slippers:GetModifierBonusStats_Agility()
    return 50
end

function modifier_treasure_holiday_beach_slippers:GetModifierBonusStats_Intellect()
    return 50
end

function modifier_treasure_holiday_beach_slippers:IsPurgable()
    return false
end
 
function modifier_treasure_holiday_beach_slippers:RemoveOnDeath()
    return false
end

function modifier_treasure_holiday_beach_slippers:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
        self:StartIntervalThink(30)
    end
end

function modifier_treasure_holiday_beach_slippers:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
        local mdf = self:GetParent():FindModifierByName("modifier_treasure_holiday_note")
        if mdf then
            mdf:OnModifierAdded()
        end
    end
end

function modifier_treasure_holiday_beach_slippers:OnIntervalThink()
    local parent = self:GetParent()
    local enemies = FindUnitsInRadius(
        parent:GetTeamNumber(), 
        parent:GetOrigin(), 
        nil, 
        800, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, 
        false
    )
    if #enemies > 0 then
        local enemy = enemies[RandomInt(1, #enemies)]
        enemy:Purge(true, false, false, false, false)
        local index = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ROOTBONE_FOLLOW, enemy)
        ParticleManager:SetParticleControl(index, 0, enemy:GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)
    end
end
