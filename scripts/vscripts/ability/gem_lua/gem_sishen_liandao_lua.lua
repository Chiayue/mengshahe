gem_sishen_liandao_lua = class({})
LinkLuaModifier("modifier_gem_sishen_liandao_lua","ability/gem_lua/gem_sishen_liandao_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_sishen_liandao_lua:GetIntrinsicModifierName()
	return "modifier_gem_sishen_liandao_lua"
end

if modifier_gem_sishen_liandao_lua == nil then
	modifier_gem_sishen_liandao_lua = class({})
end

function modifier_gem_sishen_liandao_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_RESPAWN,
    }
    return funcs
end

function modifier_gem_sishen_liandao_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_sishen_liandao_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_gem_sishen_liandao_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    local hTarget = self:GetAbility():GetCaster()
    -- 改变护甲
    hTarget:AddNewModifier( 
        self:GetAbility():GetCaster(), 
        self:GetAbility(), 
        "modifier_physical_armor_lua", 
        { duration = 9999999 } 
    )

    -- 改变智力
    hTarget:AddNewModifier( 
        self:GetAbility():GetCaster(), 
        self:GetAbility(), 
        "modifier_extra_strength_lua", 
        { duration = 9999999 } 
    )

end

function modifier_gem_sishen_liandao_lua:OnRespawn(params)
    if not IsServer( ) then
        return
    end
    -- if params.unit == self:GetParent() then
    --     -- 判断重生对象是否是自己
    --     -- local hTarget = params.target
    --     -- local kv = {}
    --     -- 改变护甲
    --     params.unit:AddNewModifier( 
    --         self:GetAbility():GetCaster(), 
    --         self:GetAbility(), 
    --         "modifier_physical_armor_lua", 
    --         { duration = 9999999 } 
    --     )

    --     -- 改变力量
    --     params.unit:AddNewModifier( 
    --         self:GetAbility():GetCaster(), 
    --         self:GetAbility(), 
    --         "modifier_extra_strength_lua", 
    --         { duration = 9999999 } 
    --     )
    -- end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
