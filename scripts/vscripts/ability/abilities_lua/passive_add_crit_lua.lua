
LinkLuaModifier("modifier_passive_add_crit_lua","ability/abilities_lua/passive_add_crit_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_add_crit_lua_d = class({})
function passive_add_crit_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_add_crit_lua"
end

passive_add_crit_lua_c = class({})
function passive_add_crit_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_add_crit_lua"
end

passive_add_crit_lua_b = class({})
function passive_add_crit_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_add_crit_lua"
end

if modifier_passive_add_crit_lua == nil then
	modifier_passive_add_crit_lua = class({})
end


function modifier_passive_add_crit_lua:IsHidden()
    return true
end

function modifier_passive_add_crit_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_add_crit_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_add_crit_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end
function modifier_passive_add_crit_lua:OnCreated(params)
    if IsServer( ) then
        Timers:CreateTimer({
                endTime = 0.1, 
                callback = function()
                    local steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
                    game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
                end
            })
        
    end
end

function modifier_passive_add_crit_lua:OnDestroy()
    if IsServer() then
        local steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
        game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -self:GetAbility():GetSpecialValueFor( "crit" ))
    end
end

