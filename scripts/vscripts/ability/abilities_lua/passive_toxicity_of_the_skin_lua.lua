
LinkLuaModifier("modifier_passive_toxicity_of_the_skin_lua","ability/abilities_lua/passive_toxicity_of_the_skin_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_slow_debuff_lua","ability/abilities_lua/passive_toxicity_of_the_skin_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_toxicity_of_the_skin_lua_d = class({})
function passive_toxicity_of_the_skin_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_toxicity_of_the_skin_lua"
end

passive_toxicity_of_the_skin_lua_c = class({})
function passive_toxicity_of_the_skin_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_toxicity_of_the_skin_lua"
end

passive_toxicity_of_the_skin_lua_b = class({})
function passive_toxicity_of_the_skin_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_toxicity_of_the_skin_lua"
end

passive_toxicity_of_the_skin_lua_a = class({})
function passive_toxicity_of_the_skin_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_toxicity_of_the_skin_lua"
end

if modifier_passive_toxicity_of_the_skin_lua == nil then
	modifier_passive_toxicity_of_the_skin_lua = class({})
end


function modifier_passive_toxicity_of_the_skin_lua:IsHidden()
    return true
end

function modifier_passive_toxicity_of_the_skin_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_toxicity_of_the_skin_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_toxicity_of_the_skin_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_passive_toxicity_of_the_skin_lua:OnCreated(params)
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

function modifier_passive_toxicity_of_the_skin_lua:OnAttacked(params)
    -- DeepPrintTable(params)
    local caster = self:GetAbility():GetCaster()
    local attacker = params.attacker
    if caster ~= params.target then
        return
    end
    if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
        return
    end
    
    local damage = {
        victim = attacker,
        attacker = self:GetAbility():GetCaster(),
        damage = self:GetAbility():GetSpecialValueFor("basedamage") + (self:GetAbility():GetCaster():GetStrength()*self:GetAbility():GetSpecialValueFor("scale")),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }
    -- print(">>>>>>>>>>> damage: "..damage.damage);
    ApplyDamage( damage )
    attacker:AddNewModifier(self:GetAbility():GetCaster(), nil, "modifier_slow_debuff_lua", { duration = self:GetAbility():GetSpecialValueFor("duration") })
    return 
end

if modifier_slow_debuff_lua == nil then
	modifier_slow_debuff_lua = class({})
end

function modifier_slow_debuff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_slow_debuff_lua:OnCreated(params)
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

function modifier_slow_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
    return -20
end

function modifier_slow_debuff_lua:GetModifierAttackSpeedBonus_Constant()
    return -40
end