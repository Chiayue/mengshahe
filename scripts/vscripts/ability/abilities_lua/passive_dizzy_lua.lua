LinkLuaModifier( "modifier_passive_dizzy_lua", "ability/abilities_lua/passive_dizzy_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_passive_dizzy_lua_buff", "ability/abilities_lua/passive_dizzy_lua.lua",LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------
--Abilities
if passive_dizzy_lua_d == nil then
    passive_dizzy_lua_d = class({})
end

function passive_dizzy_lua_d:GetIntrinsicModifierName()
    return "modifier_passive_dizzy_lua"
end

if passive_dizzy_lua_c == nil then
    passive_dizzy_lua_c = class({})
end

function passive_dizzy_lua_c:GetIntrinsicModifierName()
    return "modifier_passive_dizzy_lua"
end

if passive_dizzy_lua_b == nil then
    passive_dizzy_lua_b = class({})
end

function passive_dizzy_lua_b:GetIntrinsicModifierName()
    return "modifier_passive_dizzy_lua"
end

-----------------------------------------------
if modifier_passive_dizzy_lua == nil then
	modifier_passive_dizzy_lua = class({})
end
function modifier_passive_dizzy_lua:IsDebuff()
    return false
 end
 function modifier_passive_dizzy_lua:IsHidden()
    return true
end

function modifier_passive_dizzy_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end
function modifier_passive_dizzy_lua:OnAttackLanded(params)
    if not IsServer() then
        return 
    end
    local attacker = params.attacker
    local Caster = self:GetCaster()
    if attacker ~= Caster then
        return
    end
    local hTarget = params.target
    if PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("stun_chance")) and hTarget ~= nil then
        --攻击目标加修饰器
        hTarget:AddNewModifier(Caster,self:GetAbility(), "modifier_passive_dizzy_lua_buff", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
    end
end
----------------------------
--buff修饰器
if modifier_passive_dizzy_lua_buff == nil then
    modifier_passive_dizzy_lua_buff = class({})
end

function modifier_passive_dizzy_lua_buff:IsDebuff()
    return true
 end
 
 function modifier_passive_dizzy_lua_buff:IsHidden()
     return true
 end

 function modifier_passive_dizzy_lua_buff:IsStunDebuff()
     return true
 end

 function modifier_passive_dizzy_lua_buff:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
     return state
 end

 function modifier_passive_dizzy_lua_buff:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
function modifier_passive_dizzy_lua_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
