require("global/random_affix")
LinkLuaModifier("modifier_passive_jingji_pifu_lua","ability/abilities_lua/passive_jingji_pifu_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_jingji_pifu_lua_d = class({})
function passive_jingji_pifu_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_jingji_pifu_lua"
end

passive_jingji_pifu_lua_c = class({})
function passive_jingji_pifu_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_jingji_pifu_lua"
end

passive_jingji_pifu_lua_b = class({})
function passive_jingji_pifu_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_jingji_pifu_lua"
end

if modifier_passive_jingji_pifu_lua == nil then
	modifier_passive_jingji_pifu_lua = class({})
end


function modifier_passive_jingji_pifu_lua:IsHidden()
    return true
end

function modifier_passive_jingji_pifu_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_jingji_pifu_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_jingji_pifu_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_passive_jingji_pifu_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
end

function modifier_passive_jingji_pifu_lua:OnDestroy()
	if not IsServer( ) then
        return
    end
end

function modifier_passive_jingji_pifu_lua:OnAttacked(params)
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
    return 
end