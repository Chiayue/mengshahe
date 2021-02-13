



----骷髅王技能4
initiative_skeleton_king_four_lua = class({})
-- LinkLuaModifier( "modifier_initiative_skeleton_king_lua","ability/abilities_lua/initiative_skeleton_king_four_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_stun_lua", "ability/abilities_lua/modifier/modifier_stun_lua", LUA_MODIFIER_MOTION_NONE)
function initiative_skeleton_king_four_lua:OnSpellStart()
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    -- local enemies = FindUnitsInRadius(
    --     caster:GetTeamNumber(), 
    --     caster:GetOrigin(), 
    --     nil, 
    --     250, 
    --     DOTA_UNIT_TARGET_TEAM_ENEMY, 
    --     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    --     DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
    --     FIND_ANY_ORDER, 
    --     true
    -- )
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), 
        caster:GetOrigin(), 
        nil, 
        250, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST, 
        true
    )
    if #enemies > 0 then
        enemies[1]:AddNewModifier(caster, self, "modifier_stun_lua", { duration = 3 })
    end
end


-- modifier_initiative_skeleton_king_lua = class({})

-- function modifier_initiative_skeleton_king_lua:IsDebuff()
-- 	return true 
-- end
-- function modifier_initiative_skeleton_king_lua:IsHidden()
-- 	return false
-- end
-- function modifier_initiative_skeleton_king_lua:IsPurgable()
-- 	return false
-- end
-- function modifier_initiative_skeleton_king_lua:IsPurgeException()
-- 	return false
-- end
-- function modifier_initiative_skeleton_king_lua:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_STUNNED] = true,
-- 		}
-- 	return state
-- end