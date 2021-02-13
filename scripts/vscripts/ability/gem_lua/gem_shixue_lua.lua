gem_shixue_lua = class({})
LinkLuaModifier("modifier_gem_shixue_lua","ability/gem_lua/gem_shixue_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_shixue_lua:GetIntrinsicModifierName()
	return "modifier_gem_shixue_lua"
end

if modifier_gem_shixue_lua == nil then
	modifier_gem_shixue_lua = class({})
end

function modifier_gem_shixue_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_RESPAWN,
    }
    return funcs
end

function modifier_gem_shixue_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_shixue_lua:RemoveOnDeath()
    return false -- 死亡不移除
end


function modifier_gem_shixue_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    local hTarget = self:GetAbility():GetCaster()
    -- 增加攻速BUFF
    hTarget:AddNewModifier( 
        self:GetAbility():GetCaster(), 
        self:GetAbility(), 
        "modifier_attack_speed_lua", 
        { duration = 9999999 } 
    )
end

function modifier_gem_shixue_lua:OnRespawn(params)
    if not IsServer( ) then
        return
    end
    -- if params.unit == self:GetParent() then
    --     -- 判断重生对象是否是自己
    --     -- local hTarget = params.target
    --     -- local kv = {}
    --     -- 增加攻速BUFF
    --     params.unit:AddNewModifier( 
    --         self:GetAbility():GetCaster(), 
    --         self:GetAbility(), 
    --         "modifier_attack_speed_lua", 
    --         { duration = 9999999 } 
    --     )
    --     -- CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_xinsheng_qiangzhuang_buff_lua", kv, hTarget:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
    -- end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
