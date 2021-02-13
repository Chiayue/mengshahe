initiative_recovery_lua = class({})
initiative_recovery_lua_d = initiative_recovery_lua
initiative_recovery_lua_c = initiative_recovery_lua
initiative_recovery_lua_b = initiative_recovery_lua
initiative_recovery_lua_a = initiative_recovery_lua
initiative_recovery_lua_s = initiative_recovery_lua

LinkLuaModifier("modifier_initiative_recovery_lua","ability/abilities_lua/initiative_recovery_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_recovery_reduction_lua","ability/abilities_lua/initiative_recovery_lua",LUA_MODIFIER_MOTION_NONE)

--范围
function initiative_recovery_lua:GetAOERadius()
	return 550
end
--开始施法
function initiative_recovery_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.time = GameRules:GetGameTime()
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_recovery_lua",
		{
            duration = 10,
		}, 
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
    )
end
-- --持续施法
-- function initiative_recovery_lua:OnChannelThink(flInterval)
--     if IsServer() then
--         local now = GameRules:GetGameTime()
--         if now - self.time >= 1 then
--             self.time = now
--             -- self:GetCaster():StartGesture(ACT_DOTA_SPAWN)
--         end 
--     end
-- end
-- --持续施法完
-- function initiative_recovery_lua:OnChannelFinish(bInterrupted)
--     if self.recovery then
--         self.recovery:Destroy()
--     end
-- end

----------------------------------------------------------------------------------------------------------------
modifier_initiative_recovery_lua = class({})

function modifier_initiative_recovery_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.ability = self:GetAbility()
    self.cursor_position = self.ability:GetCursorPosition()
    self.ability:GetSpecialValueFor("restore")
    self.restore = self.ability:GetSpecialValueFor("restore")
    self.reduction = self.ability:GetSpecialValueFor("reduction")
    self.nFXIndex = ParticleManager:CreateParticle(
        "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo.vpcf", 
        PATTACH_CUSTOMORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self.cursor_position)
    self:AddParticle(self.nFXIndex, false, false, 15, false, false)
    self:StartIntervalThink(1)
end

function modifier_initiative_recovery_lua:OnIntervalThink()
    local ally = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
		self.cursor_position,
		nil,
		550,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
    )
    for i=1,#ally do 
        ally[i]:Heal(self.restore, self)
        ally[i]:AddNewModifier(self:GetCaster(), self, "modifier_initiative_recovery_reduction_lua", {duration = 1, reduction = self.reduction})--调用修饰器
    end
end

function modifier_initiative_recovery_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end
----------------------------------------------------------------------------------------------------------------
modifier_initiative_recovery_reduction_lua = class({})

function modifier_initiative_recovery_reduction_lua:IsDebuff()
	return false 
end
function modifier_initiative_recovery_reduction_lua:IsHidden()
	return true
end
function modifier_initiative_recovery_reduction_lua:IsPurgable()
	return false
end
function modifier_initiative_recovery_reduction_lua:IsPurgeException()
	return false
end
function modifier_initiative_recovery_reduction_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end
function modifier_initiative_recovery_reduction_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.reduction = kv.reduction
end

function modifier_initiative_recovery_reduction_lua:GetModifierIncomingDamage_Percentage(kv)
    local reduction = -1*self.reduction
    return reduction
end