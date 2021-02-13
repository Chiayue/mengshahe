require("info/game_playerinfo")

LinkLuaModifier( "modifier_initiative_soul_fire_tower_lua", "ability/abilities_lua/initiative_soul_fire_tower_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_soul_fire_buff_lua", "ability/abilities_lua/initiative_soul_fire_tower_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if initiative_soul_fire_tower_lua == nil then
	initiative_soul_fire_tower_lua = class({})
end

function initiative_soul_fire_tower_lua:GetIntrinsicModifierName()
 	return "modifier_initiative_soul_fire_tower_lua"
end

function initiative_soul_fire_tower_lua:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		hTarget:AddNewModifier(hTarget, nil, "modifier_soul_fire_buff_lua", {duration = self:GetSpecialValueFor("duration")})
	end

	return false
end
--------------------------------------------------
if modifier_initiative_soul_fire_tower_lua == nil then
	modifier_initiative_soul_fire_tower_lua = class({})
end

function modifier_initiative_soul_fire_tower_lua:IsHidden()
	return true
end
function modifier_initiative_soul_fire_tower_lua:DeclareFunctions()
	local funcs = {
	}
	return funcs
end

function modifier_initiative_soul_fire_tower_lua:OnCreated( kv )
    if not IsServer() then
        return
	end
	self.cooldown = self:GetAbility():GetCooldown(1)
	self:StartIntervalThink(0.5)
end

function modifier_initiative_soul_fire_tower_lua:OnIntervalThink()
	if not self:GetAbility():IsCooldownReady() then
		return
	end
    local caster = self:GetAbility():GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.Origin = caster:GetOrigin()
	for _, enemy in pairs(enemies) do
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
			-- iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
		}

		ProjectileManager:CreateTrackingProjectile( info )
		
		self:GetAbility():StartCooldown(self.cooldown)
		break
	end
end
-----------------------------


if modifier_soul_fire_buff_lua == nil then
	modifier_soul_fire_buff_lua = class({})
end

function modifier_soul_fire_buff_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_soul_fire_buff_lua:OnCreated( kv )
	if not IsServer() then
		return
	end
	-- local EffectName_1 = "particles/killstreak/killstreak_ice_topbar_lv1.vpcf" -- 冰系特效
	local EffectName_1 = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff.vpcf" -- 冰系特效
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)

	-- local EffectName = "particles/killstreak/killstreak_ice_topbar_lv1.vpcf" -- 冰系特效
	-- local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	-- self:AddParticle(nFXIndex, false, false, -1, false, false)
	-- local steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
	-- game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", 200)
end

function modifier_soul_fire_buff_lua:OnDestroy()
	if not IsServer() then
		return
	end
	-- local steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
	-- game_playerinfo:set_dynamic_properties(steam_id, "extra_attack_speed", -200)
end

function modifier_soul_fire_buff_lua:GetTexture()
	return "ember_spirit_flame_guard"
end

function modifier_soul_fire_buff_lua:GetModifierPhysicalArmorBonus()
	return 50
end

function modifier_soul_fire_buff_lua:GetModifierDamageOutgoing_Percentage()
	-- print(" >>>>>>>>>>>>>> OnAttacked <<<<<<<<<<<<<<<<<<<<<<")
	return 200
end