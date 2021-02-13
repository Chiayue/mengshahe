require("info/game_playerinfo")

LinkLuaModifier("modifier_bukezhansheng_lua","ability/abilities_lua/innateskill_bukezhansheng_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_damagevoid_lua","ability/abilities_lua/innateskill_bukezhansheng_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
bukezhansheng_lua = class({})

function bukezhansheng_lua:GetIntrinsicModifierName()
	return "modifier_bukezhansheng_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_bukezhansheng_lua = class({})
--------------------------------------------------------------------------------

function modifier_bukezhansheng_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_bukezhansheng_lua:IsHidden()
    return true
end

function modifier_bukezhansheng_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink(1)
    table.insert(global_var_func.championgroup, self:GetCaster():GetPlayerID())
end

function modifier_bukezhansheng_lua:OnIntervalThink()
    if #global_var_func.championgroup >= 2 and global_var_func.championgroupnumber < #global_var_func.championgroup then
        for key, value in ipairs(global_var_func.championgroup) do
            local hero = PlayerResource:GetPlayer(value):GetAssignedHero()
            if not hero:FindModifierByName("modifier_attribute_50_lua") then
                hero:AddNewModifier(hero, nil, "modifier_attribute_50_lua", {})
                global_var_func.championgroupnumber = global_var_func.championgroupnumber + 1
            end
        end
    end
end

modifier_damagevoid_lua = class({})

function modifier_damagevoid_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
    return funcs
end

function modifier_damagevoid_lua:GetTexture()
    return "sk47"
end

function modifier_damagevoid_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
end

function modifier_damagevoid_lua:GetModifierAvoidDamage(params)
    return params.damage
end

function modifier_damagevoid_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    self:GetParent():Kill(nil, self:GetParent())
end