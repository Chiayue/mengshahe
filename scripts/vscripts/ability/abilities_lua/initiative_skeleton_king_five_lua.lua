
----骷髅王技能5
initiative_skeleton_king_five_lua = class({})
LinkLuaModifier( "modifier_skeleton_king_five_critical_strike","ability/abilities_lua/initiative_skeleton_king_five_lua", LUA_MODIFIER_MOTION_NONE )
function initiative_skeleton_king_five_lua:OnSpellStart()
    local caster = self:GetCaster()
    -- local enemies = FindUnitsInRadius(
    --     caster:GetTeamNumber(), 
    --     caster:GetOrigin(), 
    --     nil, 
    --     800, 
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
        800, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST, 
        true
    )
    if #enemies > 0 then
        local to_postion = enemies[1]:GetOrigin() 
        FindClearSpaceForUnit(caster, to_postion, true)
        caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
        caster:AddNewModifier(caster, self, "modifier_skeleton_king_five_critical_strike", { duration = 1 })
    end
end






modifier_skeleton_king_five_critical_strike = class({})

--暴击modifier
function modifier_skeleton_king_five_critical_strike:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
    return funcs
end


-- function modifier_skeleton_king_five_critical_strike:OnCreated( evt )
--     if not IsServer( ) then
--         return
--     end 
--     local critical_damage = evt.critical_damage or self:GetAbility():GetSpecialValueFor( "critical_damage" ) 
--     self.critical_damage =critical_damage * 100
-- end

function modifier_skeleton_king_five_critical_strike:OnAttackLanded(evt)
    if not IsServer( ) then
        return
    end
    -- local attacker = evt.attacker 
    -- if attacker:IsHero() then 
    -- self:GetParent():RemoveModifierByName("modifier_skeleton_king_five_critical_strike")
  
    -- end
end

function modifier_skeleton_king_five_critical_strike:GetModifierPreAttack_CriticalStrike(params)
    return 150
end

function modifier_skeleton_king_five_critical_strike:IsHidden()
    return true    
 end