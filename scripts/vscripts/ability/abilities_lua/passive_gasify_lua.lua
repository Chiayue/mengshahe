
LinkLuaModifier("modifier_passive_gasify_lua","ability/abilities_lua/passive_gasify_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_gasify_debuff_lua","ability/abilities_lua/passive_gasify_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_gasify_lua_d = class({})
function passive_gasify_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_gasify_lua"
end

passive_gasify_lua_c = class({})
function passive_gasify_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_gasify_lua"
end

passive_gasify_lua_b = class({})
function passive_gasify_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_gasify_lua"
end

passive_gasify_lua_a = class({})
function passive_gasify_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_gasify_lua"
end

passive_gasify_lua_s = class({})
function passive_gasify_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_gasify_lua"
end

if modifier_passive_gasify_lua == nil then
	modifier_passive_gasify_lua = class({})
end


function modifier_passive_gasify_lua:IsHidden()
    return true
end

function modifier_passive_gasify_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_gasify_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_gasify_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_passive_gasify_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )
end

function modifier_passive_gasify_lua:OnAttackLanded(params)
    -- DeepPrintTable(target)
    if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
        return
    end
    -- local percentvalue = 0
    local caster = self:GetAbility():GetCaster()
    if caster == params.attacker then
        
        -- local damage = {
        --     victim = target,
        --     attacker = self:GetAbility():GetCaster(),
        --     damage = self:GetAbility():GetSpecialValueFor("basedamage") + (self:GetAbility():GetCaster():GetStrength()*self:GetAbility():GetSpecialValueFor("scale")),
        --     damage_type = DAMAGE_TYPE_MAGICAL,
        --     ability = self:GetAbility()
        -- }
        -- -- print(">>>>>>>>>>> damage: "..damage.damage);
        -- ApplyDamage( damage )
        local targets = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)
        
        --利用Lua的循环迭代，循环遍历每一个单位组内的单位
        for i,unit in pairs(targets) do
            unit:AddNewModifier(self:GetAbility():GetCaster(), nil, "modifier_gasify_debuff_lua", { duration = 3 })
        end
    end
    return
end



if modifier_gasify_debuff_lua == nil then
	modifier_gasify_debuff_lua = class({})
end

function modifier_gasify_debuff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_gasify_debuff_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )

    -- local radius = 300
    -- local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/taunts/snapfire/snapfire_taunt_bubble.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetTeamNumber() )
    -- ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
    -- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
    -- ParticleManager:ReleaseParticleIndex( nFXIndex )

    local EffectName_1 = "particles/econ/taunts/snapfire/snapfire_taunt_bubble.vpcf" -- 气泡
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
    self:AddParticle(nFXIndex_1, false, false, -1, false, false)
end

function modifier_gasify_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
    return -30
end

function modifier_gasify_debuff_lua:GetModifierAttackSpeedBonus_Constant()
    return -30
end

function modifier_gasify_debuff_lua:GetModifierIncomingDamage_Percentage()
    return 50
end