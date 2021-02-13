initiative_jixingjianqi_lua = class({})
initiative_jixingjianqi_lua_d = initiative_jixingjianqi_lua
initiative_jixingjianqi_lua_c = initiative_jixingjianqi_lua
initiative_jixingjianqi_lua_b = initiative_jixingjianqi_lua
initiative_jixingjianqi_lua_a = initiative_jixingjianqi_lua
initiative_jixingjianqi_lua_s = initiative_jixingjianqi_lua

LinkLuaModifier("modifier_initiative_jixingjianqi_lua","ability/abilities_lua/initiative_jixingjianqi_lua",LUA_MODIFIER_MOTION_NONE)

--范围
function initiative_jixingjianqi_lua:GetAOERadius()
	return 450
end
--开始施法
function initiative_jixingjianqi_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.recovery = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_jixingjianqi_lua",
		{
            duration = 5,
		}, 
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
    )
    self:GetCaster():EmitSound("winds.jianzhen")
end

modifier_initiative_jixingjianqi_lua = class({})

function modifier_initiative_jixingjianqi_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.ability = self:GetAbility()
    self.cursor_position = self.ability:GetCursorPosition()
    self.caster = self:GetCaster()
    self.num = 1
    self.num_max = 0
    self.interval = 0
    self.damagetable = {                                
        attacker = self.caster,								 
        damage = self.ability:GetSpecialValueFor("damage")+self.caster:GetStrength()*self.ability:GetSpecialValueFor("attr_damage"),
        damage_type = DAMAGE_TYPE_PHYSICAL,				 
    }
    if self.ability:GetAbilityName() == "initiative_jixingjianqi_lua_d" then
		self.num_max = 5
        self.interval = 1
	elseif self.ability:GetAbilityName() == "initiative_jixingjianqi_lua_c" then
		self.num_max = 6
        self.interval = 0.8
	elseif self.ability:GetAbilityName() == "initiative_jixingjianqi_lua_b" then
		self.num_max = 7
        self.interval = 0.7
	elseif self.ability:GetAbilityName() == "initiative_jixingjianqi_lua_a" then
		self.num_max = 8
        self.interval = 0.6
	elseif self.ability:GetAbilityName() == "initiative_jixingjianqi_lua_s" then
		self.num_max = 10
        self.interval = 0.5
	end
    self.nFXIndex = ParticleManager:CreateParticle(
        "particles/diy_particles/dg.vpcf", 
        PATTACH_CUSTOMORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self.cursor_position)
    self:AddParticle(self.nFXIndex, false, false, 15, false, false)
    self:StartIntervalThink(self.interval)
end

function modifier_initiative_jixingjianqi_lua:OnIntervalThink()  
    local enemies = FindUnitsInRadius(
		self.caster:GetTeam(),
		self.cursor_position,
		nil,
		450,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_ANY_ORDER, 
        false
    )
    for i=1,#enemies do 
        self.damagetable.victim = enemies[i], 
        ApplyDamage(self.damagetable)
    end 
    if self.num < self.num_max then
        self.num = self.num + 1
    else
        ParticleManager:DestroyParticle(self.nFXIndex, false)
        self:StartIntervalThink(-1)
    end 
end

function modifier_initiative_jixingjianqi_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end
