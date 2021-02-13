
starfall_lua_d = class({})

LinkLuaModifier("modifier_starfall_lua_d_debuff", "ability/abilities_lua/initiative_starfall_lua", LUA_MODIFIER_MOTION_NONE)

local function StarFallAttack(ability, caster, target, damage, attr_scale)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
	Timers:CreateTimer(0.57, function()
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = damage + caster:GetAgility() * attr_scale,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		target:EmitSound("Ability.StarfallImpact")
		return nil
	end
	)
end

function starfall_lua_d:OnSpellStart()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	self.delay = self:GetSpecialValueFor("secondary_duration")
	for _,enemy in pairs(enemies) do
		StarFallAttack(self, caster, enemy, self:GetSpecialValueFor("damage"), self:GetSpecialValueFor("attr_scale"))
		enemy:AddNewModifier(enemy, self, "modifier_starfall_lua_d_debuff", {duration = self:GetSpecialValueFor("secondary_duration"), playerid = caster:GetPlayerID()})
	end
	caster:EmitSound("Ability.Starfall")
end


modifier_starfall_lua_d_debuff = class({})

function modifier_starfall_lua_d_debuff:IsHidden()
    return true
end

function modifier_starfall_lua_d_debuff:IsPurgable()
    return false
end

function modifier_starfall_lua_d_debuff:OnCreated(params)
    if not IsServer( ) then
        return
    end
	self.parent = self:GetParent()
	self.attacker = PlayerResource:GetPlayer(params.playerid):GetAssignedHero()
	self.ability = self:GetAbility()
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.attr_scale = self.ability:GetSpecialValueFor("attr_scale")
	-- self:OnIntervalThink()
    self:StartIntervalThink(0.5)
end

function modifier_starfall_lua_d_debuff:OnIntervalThink()
    StarFallAttack(self.ability, self.attacker, self.parent, self.damage, self.attr_scale)
end


-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------

starfall_lua_c = class({})

LinkLuaModifier("modifier_starfall_lua_c_debuff", "ability/abilities_lua/initiative_starfall_lua", LUA_MODIFIER_MOTION_NONE)

local function StarFallAttack(ability, caster, target, damage, attr_scale)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
	Timers:CreateTimer(0.57, function()
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = damage + caster:GetAgility() * attr_scale,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		target:EmitSound("Ability.StarfallImpact")
		return nil
	end
	)
end

function starfall_lua_c:OnSpellStart()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		StarFallAttack(self, caster, enemy, self:GetSpecialValueFor("damage"), self:GetSpecialValueFor("attr_scale"))
		enemy:AddNewModifier(enemy, self, "modifier_starfall_lua_c_debuff", {duration = self:GetSpecialValueFor("secondary_duration"), playerid = caster:GetPlayerID()})
	end
	caster:EmitSound("Ability.Starfall")
end


modifier_starfall_lua_c_debuff = class({})

function modifier_starfall_lua_c_debuff:IsHidden()
    return true
end

function modifier_starfall_lua_c_debuff:IsPurgable()
    return false
end

function modifier_starfall_lua_c_debuff:OnCreated(params)
    if not IsServer( ) then
        return
    end
	self.parent = self:GetParent()
	self.attacker = PlayerResource:GetPlayer(params.playerid):GetAssignedHero()
	self.ability = self:GetAbility()
	-- self:OnIntervalThink()
    self:StartIntervalThink(0.5)
end

function modifier_starfall_lua_c_debuff:OnIntervalThink()
    StarFallAttack(self.ability, self.attacker, self.parent, self.ability:GetSpecialValueFor("damage"), self.ability:GetSpecialValueFor("attr_scale"))
end


-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------

starfall_lua_b = class({})

LinkLuaModifier("modifier_starfall_lua_b_debuff", "ability/abilities_lua/initiative_starfall_lua", LUA_MODIFIER_MOTION_NONE)

local function StarFallAttack(ability, caster, target, damage, attr_scale)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
	Timers:CreateTimer(0.57, function()
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = damage + caster:GetAgility() * attr_scale,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		target:EmitSound("Ability.StarfallImpact")
		return nil
	end
	)
end

function starfall_lua_b:OnSpellStart()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		StarFallAttack(self, caster, enemy, self:GetSpecialValueFor("damage"), self:GetSpecialValueFor("attr_scale"))
		enemy:AddNewModifier(enemy, self, "modifier_starfall_lua_b_debuff", {duration = self:GetSpecialValueFor("secondary_duration"), playerid = caster:GetPlayerID()})
	end
	caster:EmitSound("Ability.Starfall")
end


modifier_starfall_lua_b_debuff = class({})

function modifier_starfall_lua_b_debuff:IsHidden()
    return true
end

function modifier_starfall_lua_b_debuff:IsPurgable()
    return false
end

function modifier_starfall_lua_b_debuff:OnCreated(params)
    if not IsServer( ) then
        return
    end
	self.parent = self:GetParent()
	self.attacker = PlayerResource:GetPlayer(params.playerid):GetAssignedHero()
	self.ability = self:GetAbility()
	-- self:OnIntervalThink()
    self:StartIntervalThink(0.5)
end

function modifier_starfall_lua_b_debuff:OnIntervalThink()
    StarFallAttack(self.ability, self.attacker, self.parent, self.ability:GetSpecialValueFor("damage"), self.ability:GetSpecialValueFor("attr_scale"))
end


-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------

starfall_lua_a = class({})

LinkLuaModifier("modifier_starfall_lua_a_debuff", "ability/abilities_lua/initiative_starfall_lua", LUA_MODIFIER_MOTION_NONE)

local function StarFallAttack(ability, caster, target, damage, attr_scale)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
	Timers:CreateTimer(0.57, function()
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = damage + caster:GetAgility() * attr_scale,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		target:EmitSound("Ability.StarfallImpact")
		return nil
	end
	)
end

function starfall_lua_a:OnSpellStart()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		StarFallAttack(self, caster, enemy, self:GetSpecialValueFor("damage"), self:GetSpecialValueFor("attr_scale"))
		enemy:AddNewModifier(enemy, self, "modifier_starfall_lua_a_debuff", {duration = self:GetSpecialValueFor("secondary_duration"), playerid = caster:GetPlayerID()})
	end
	caster:EmitSound("Ability.Starfall")
end


modifier_starfall_lua_a_debuff = class({})

function modifier_starfall_lua_a_debuff:IsHidden()
    return true
end

function modifier_starfall_lua_a_debuff:IsPurgable()
    return false
end

function modifier_starfall_lua_a_debuff:OnCreated(params)
    if not IsServer( ) then
        return
    end
	self.parent = self:GetParent()
	self.attacker = PlayerResource:GetPlayer(params.playerid):GetAssignedHero()
	self.ability = self:GetAbility()
	-- self:OnIntervalThink()
    self:StartIntervalThink(0.5)
end

function modifier_starfall_lua_a_debuff:OnIntervalThink()
    StarFallAttack(self.ability, self.attacker, self.parent, self.ability:GetSpecialValueFor("damage"), self.ability:GetSpecialValueFor("attr_scale"))
end


-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------

starfall_lua_s = class({})

LinkLuaModifier("modifier_starfall_lua_s_debuff", "ability/abilities_lua/initiative_starfall_lua", LUA_MODIFIER_MOTION_NONE)

local function StarFallAttack(ability, caster, target, damage, attr_scale)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
	Timers:CreateTimer(0.57, function()
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = damage + caster:GetAgility() * attr_scale,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		target:EmitSound("Ability.StarfallImpact")
		return nil
	end
	)
end

function starfall_lua_s:OnSpellStart()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		StarFallAttack(self, caster, enemy, self:GetSpecialValueFor("damage"), self:GetSpecialValueFor("attr_scale"))
		enemy:AddNewModifier(enemy, self, "modifier_starfall_lua_s_debuff", {duration = self:GetSpecialValueFor("secondary_duration"), playerid = caster:GetPlayerID()})
	end
	caster:EmitSound("Ability.Starfall")
end


modifier_starfall_lua_s_debuff = class({})

function modifier_starfall_lua_s_debuff:IsHidden()
    return true
end

function modifier_starfall_lua_s_debuff:IsPurgable()
    return false
end

function modifier_starfall_lua_s_debuff:OnCreated(params)
    if not IsServer( ) then
        return
    end
	self.parent = self:GetParent()
	self.attacker = PlayerResource:GetPlayer(params.playerid):GetAssignedHero()
	self.ability = self:GetAbility()
	-- self:OnIntervalThink()
    self:StartIntervalThink(0.5)
end

function modifier_starfall_lua_s_debuff:OnIntervalThink()
    StarFallAttack(self.ability, self.attacker, self.parent, self.ability:GetSpecialValueFor("damage"), self.ability:GetSpecialValueFor("attr_scale"))
end


-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------