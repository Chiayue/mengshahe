passive_rebirth_lua = class({})

LinkLuaModifier("modifier_passive_rebirth_lua","ability/abilities_lua/passive_rebirth_lua",LUA_MODIFIER_MOTION_NONE )

function passive_rebirth_lua:GetIntrinsicModifierName()
	return "modifier_passive_rebirth_lua"
end

modifier_passive_rebirth_lua = class({})

function modifier_passive_rebirth_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_rebirth_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_rebirth_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_rebirth_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_rebirth_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,                                
    }
    return funcs
end

function modifier_passive_rebirth_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster()
    self.num = 1
    self.caster:SetUnitCanRespawn(true)
end

function modifier_passive_rebirth_lua:OnDeath(params)
 
    if not IsServer( ) then
        return
    end

    self.life = self.caster:GetMaxHealth()*self:GetAbility():GetSpecialValueFor("reply") + GameRules:GetCustomGameDifficulty()*0.1
    
    if self.caster ~= params.unit then
        return
    end

    if self.num < 1 then
        return
    end 
    if self.caster:UnitCanRespawn() then
        self.location = self.caster:GetOrigin()
        self.num = self.num - 1
        self:StartIntervalThink( 2 )
    end
end

function modifier_passive_rebirth_lua:OnIntervalThink()
    self.caster:RespawnUnit()
    self.caster:SetHealth(self.life)
    self:StartIntervalThink(-1)
end






