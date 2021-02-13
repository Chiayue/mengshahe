gem_xueshiyuanbo_lua = class({})
LinkLuaModifier("modifier_gem_xueshiyuanbo_lua","ability/gem_lua/gem_xueshiyuanbo_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_xueshiyuanbo_lua:GetIntrinsicModifierName()
	return "modifier_gem_xueshiyuanbo_lua"
end

if modifier_gem_xueshiyuanbo_lua == nil then
	modifier_gem_xueshiyuanbo_lua = class({})
end

function modifier_gem_xueshiyuanbo_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_gem_xueshiyuanbo_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_xueshiyuanbo_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_xueshiyuanbo_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    local hTarget = self:GetAbility():GetCaster()
    
    hTarget:AddItemByName("item_book_passive_b")
    hTarget:AddItemByName("item_book_passive_b")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
