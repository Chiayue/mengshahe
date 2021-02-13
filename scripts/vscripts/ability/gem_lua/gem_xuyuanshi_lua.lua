gem_xuyuanshi_lua = class({})
LinkLuaModifier("modifier_gem_xuyuanshi_lua","ability/gem_lua/gem_xuyuanshi_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_xuyuanshi_lua:GetIntrinsicModifierName()
	return "modifier_gem_xuyuanshi_lua"
end

if modifier_gem_xuyuanshi_lua == nil then
	modifier_gem_xuyuanshi_lua = class({})
end

function modifier_gem_xuyuanshi_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_gem_xuyuanshi_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_xuyuanshi_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_xuyuanshi_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    local hTarget = self:GetAbility():GetCaster()
    -- 扣钱最多30000,给一本A级技能书
    local player_id = hTarget:GetPlayerID()
    local player_gold = game_playerinfo:get_player_gold(player_id) 
    if player_gold > 30000 then
        game_playerinfo:set_player_gold(player_id,-30000)
    else
        game_playerinfo:set_player_gold(player_id,-player_gold)
    end

    hTarget:AddItemByName("item_book_passive_a")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
