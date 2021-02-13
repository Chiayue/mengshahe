gem_break_then_set_lua = class({})
LinkLuaModifier("modifier_gem_break_then_set_lua","ability/gem_lua/gem_break_then_set_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_break_then_set_lua:GetIntrinsicModifierName()
	return "modifier_gem_break_then_set_lua"
end

if modifier_gem_break_then_set_lua == nil then
	modifier_gem_break_then_set_lua = class({})
end

function modifier_gem_break_then_set_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_gem_break_then_set_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_gem_break_then_set_lua:RemoveOnDeath()
    return false -- 死亡不移除
end


function modifier_gem_break_then_set_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    local hero = self:GetParent()
    hero:SetBaseAgility(1)
    hero:SetBaseIntellect(1)
    hero:SetBaseStrength(1)

    local hTarget = self:GetAbility():GetCaster()
    -- 增加敏捷成长
    hero:AddNewModifier( 
        hero, 
        self:GetAbility(), 
        "modifier_agility_gain_lua", 
        { duration = 9999999 } 
    )

    -- 增加智力成长
    hero:AddNewModifier( 
        hero, 
        self:GetAbility(), 
        "modifier_intellect_gain_lua", 
        { duration = 9999999 } 
    )

    -- 增加力量成长
    hero:AddNewModifier( 
        hero, 
        self:GetAbility(), 
        "modifier_strength_gain_lua", 
        { duration = 9999999 } 
    )

end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
