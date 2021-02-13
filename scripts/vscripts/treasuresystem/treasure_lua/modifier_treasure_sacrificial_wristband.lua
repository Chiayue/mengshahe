---------------------------------------------------------------------------
-- 宝物：牺牲护腕
---------------------------------------------------------------------------

if modifier_treasure_sacrificial_wristband == nil then 
    modifier_treasure_sacrificial_wristband = class({})
end

function modifier_treasure_sacrificial_wristband:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_sacrificial_wristband"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_sacrificial_wristband:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_treasure_sacrificial_wristband:OnDeath(event)
    if event.unit == self:GetParent() then
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), 
            self:GetParent():GetOrigin(), 
            nil,
            400, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TYPE_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false 
        )
        for _, enemy in pairs(enemies) do
            ApplyDamage({
                victim = enemy,
                attacker =  self:GetParent(),
                damage =  self:GetParent():GetMaxHealth() * 0.5,
                damage_type = DAMAGE_TYPE_MAGICAL,
            })
        end
    end
end

function modifier_treasure_sacrificial_wristband:IsPurgable()
    return false
end

function modifier_treasure_sacrificial_wristband:RemoveOnDeath()
    return false
end
