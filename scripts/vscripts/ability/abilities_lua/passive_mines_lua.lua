passive_mines_lua = class({})

LinkLuaModifier("modifier_passive_mines_lua","ability/abilities_lua/passive_mines_lua",LUA_MODIFIER_MOTION_NONE )

function passive_mines_lua:GetIntrinsicModifierName()
	return "modifier_passive_mines_lua"
end

if modifier_passive_mines_lua == nil then
    modifier_passive_mines_lua = class({})
end

function modifier_passive_mines_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_mines_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_mines_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_mines_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_mines_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_passive_mines_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster()
end

function modifier_passive_mines_lua:OnDeath(params)
    if not IsServer( ) then
        return
    end
--死亡后原地生成一枚地雷   
    if params.unit == self.caster then
        local player = params.unit:GetOwner(  )
        local ability = self:GetAbility()
        local position = params.unit:GetAbsOrigin()
        local duration = 30
        local unit = CreateUnitByName("mines", position, true, params.unit,player, DOTA_TEAM_BADGUYS )
        unit:SetOwner(params.unit)
        local explosion = unit:AddAbility("passive_mines_explosion_lua")
        explosion:SetLevel(1)
    end 
end