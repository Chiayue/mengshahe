LinkLuaModifier( "modifier_initiative_elf_fire_tower_lua", "ability/abilities_lua/initiative_elf_fire_tower_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elf_fire_debuff_lua", "ability/abilities_lua/initiative_elf_fire_tower_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
if initiative_elf_fire_tower_lua == nil then
	initiative_elf_fire_tower_lua = class({})
end

function initiative_elf_fire_tower_lua:GetIntrinsicModifierName()
 	return "modifier_initiative_elf_fire_tower_lua"
end

function initiative_elf_fire_tower_lua:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		hTarget:AddNewModifier(hTarget, nil, "modifier_elf_fire_debuff_lua", {duration = self:GetSpecialValueFor("duration")})
	end
	return false
end
--------------------------------------------------
if modifier_initiative_elf_fire_tower_lua == nil then
	modifier_initiative_elf_fire_tower_lua = class({})
end

function modifier_initiative_elf_fire_tower_lua:IsHidden()
	return true
end
function modifier_initiative_elf_fire_tower_lua:DeclareFunctions()
	local funcs = {
	}
	return funcs
end

function modifier_initiative_elf_fire_tower_lua:OnCreated( kv )
    if not IsServer() then
        return
	end
	self.cooldown = self:GetAbility():GetCooldown(1)
	self:StartIntervalThink(self.cooldown)
end

function modifier_initiative_elf_fire_tower_lua:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.Origin = caster:GetOrigin()
	for _, enemy in pairs(enemies) do
		if enemy:GetUnitName() ~= "boss_finally" then
			self.speed = 1800
			local info = {
				EffectName = "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf",
				Ability = self:GetAbility(),
				iMoveSpeed = self.speed,
				Source = caster:GetOwner(),
				Target = enemy,
				bDodgeable = true,
				bProvidesVision = true,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iVisionRadius = self:GetAbility():GetSpecialValueFor("radius"),
			}
			ProjectileManager:CreateTrackingProjectile( info )
			self:GetAbility():StartCooldown(self.cooldown)
			break
		end
	end
end
-----------------------------


if modifier_elf_fire_debuff_lua == nil then
	modifier_elf_fire_debuff_lua = class({})
end

function modifier_elf_fire_debuff_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_elf_fire_debuff_lua:OnCreated( kv )
	if not IsServer() then
		return
	end
	local EffectName = "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf" -- 燃烧标志特效
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(nFXIndex, false, false, -1, false, false)
end

function modifier_elf_fire_debuff_lua:GetTexture()
	return "youxia_fire_rain"
end

function modifier_elf_fire_debuff_lua:GetModifierPhysicalArmorBonus( params )
	return -30
end