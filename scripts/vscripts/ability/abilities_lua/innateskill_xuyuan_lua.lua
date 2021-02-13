require("config/drop_config")
LinkLuaModifier("modifier_xuyuan_lua","ability/abilities_lua/innateskill_xuyuan_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
xuyuan_lua = class({})
function xuyuan_lua:GetIntrinsicModifierName()
	return "modifier_xuyuan_lua"
end

if modifier_xuyuan_lua == nil then
	modifier_xuyuan_lua = class({})
end


function modifier_xuyuan_lua:IsHidden()
    return true
end

function modifier_xuyuan_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_xuyuan_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_xuyuan_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_xuyuan_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_xuyuan_lua:OnDestroy()
	if not IsServer( ) then
        return
    end
end

function modifier_xuyuan_lua:OnAttacked(params)
    local caster = self:GetAbility():GetCaster()
    local attacker = params.attacker
    if caster ~= params.target then
        return
    end
    if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
        return
    end
    
    local item_name = drop_config:get_xuyuan_random_name()
    local player = PlayerResource:GetPlayer(caster:GetPlayerID())
    local item = CreateItem(item_name, caster, player)
    -- item:SetOwner(PlayerResource:GetPlayer(player_id))
    item:SetSellable(false)
    item:SetPurchaseTime(0)
    local pos = caster:GetAbsOrigin()

    CreateItemOnPositionSync( pos, item )

    return 
end