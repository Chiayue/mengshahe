
LinkLuaModifier("modifier_passive_fumo_weapon_lua","ability/abilities_lua/passive_fumo_weapon_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_fumo_weapon_lua_d = class({})
function passive_fumo_weapon_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_fumo_weapon_lua"
end

passive_fumo_weapon_lua_c = class({})
function passive_fumo_weapon_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_fumo_weapon_lua"
end

passive_fumo_weapon_lua_b = class({})
function passive_fumo_weapon_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_fumo_weapon_lua"
end

if modifier_passive_fumo_weapon_lua == nil then
	modifier_passive_fumo_weapon_lua = class({})
end


function modifier_passive_fumo_weapon_lua:IsHidden()
    return false
end

function modifier_passive_fumo_weapon_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_fumo_weapon_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_fumo_weapon_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_passive_fumo_weapon_lua:OnCreated(params)
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

function modifier_passive_fumo_weapon_lua:OnAttackLanded(params)
    -- DeepPrintTable(target)
    local percent = 0
    -- local percentvalue = 0
    local target = params.target
    local caster = self:GetAbility():GetCaster()
    if caster == params.attacker then
        if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
            return
        end
        local damage = {
            victim = target,
            attacker = self:GetAbility():GetCaster(),
            damage = self:GetAbility():GetSpecialValueFor("basedamage") + (self:GetAbility():GetCaster():GetIntellect()*self:GetAbility():GetSpecialValueFor("scale")),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }
        -- print(">>>>>>>>>>> damage: "..damage.damage);
        ApplyDamage( damage )

        caster:GiveMana(self:GetAbility():GetSpecialValueFor("mana"))
    end
    return
end