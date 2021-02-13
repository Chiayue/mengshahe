---------------------------------------------------------------------------
-- 宝物：守夜大剑
---------------------------------------------------------------------------

if modifier_treasure_vigil_big_sword == nil then 
    modifier_treasure_vigil_big_sword = class({})
end
function modifier_treasure_vigil_big_sword:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_vigil_big_sword"
    end
    return "buff/modifier_treasure_keep_changing"
end
function modifier_treasure_vigil_big_sword:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACKED,
    }
end

function modifier_treasure_vigil_big_sword:OnAttacked(params)
    if self.last_find_time and GameRules:GetGameTime() - self.last_find_time < global_var_func.split_cd then
        return
    else
        self.last_find_time = GameRules:GetGameTime()
    end
    local parent = self:GetParent()
    local position = parent:GetOrigin()
    if params.attacker == self:GetParent() then
        if RollPercentage(50) then
            local enemies = FindUnitsInRadius(
                parent:GetTeamNumber(),
                parent:GetOrigin(),
                nil,
                500,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_ALL,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_ANY_ORDER,
                false
            )
            for _, enemy in pairs(enemies) do
                if enemy ~= params.target then
                    if CalculationAngle(parent, enemy) >= 100 then
                        ApplyDamage({
                            victim = enemy,
                            attacker = parent,
                            damage = params.original_damage * 0.8,
                            damage_type = params.damage_type,
                        }) 
                    end
                end
            end
        end
    end
end

function modifier_treasure_vigil_big_sword:IsPurgable()
    return false
end
 
function modifier_treasure_vigil_big_sword:RemoveOnDeath()
    return false
end