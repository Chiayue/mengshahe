
LinkLuaModifier( "modifier_passive_lightning_chain_lua", "ability/abilities_lua/passive_lightning_chain_lua.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_passive_lightning_chain_lua_thinker", "ability/abilities_lua/passive_lightning_chain_lua.lua",LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------
local sParticle = "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf"

--Abilities
if passive_lightning_chain_lua_c == nil then
	passive_lightning_chain_lua_c = class({})
end

function passive_lightning_chain_lua_c:GetIntrinsicModifierName()
 	return "modifier_passive_lightning_chain_lua"
end

function passive_lightning_chain_lua_c:Precache(context)
	PrecacheResource( "particle", sParticle, context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/arc_lightning.vsnd", context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/general_attack1.vsnd", context )

end

if passive_lightning_chain_lua_b == nil then
	passive_lightning_chain_lua_b = class({})
end

function passive_lightning_chain_lua_b:GetIntrinsicModifierName()
 	return "modifier_passive_lightning_chain_lua"
end

function passive_lightning_chain_lua_b:Precache(context)
	PrecacheResource( "particle", sParticle, context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/arc_lightning.vsnd", context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/general_attack1.vsnd", context )

end

if passive_lightning_chain_lua_a == nil then
	passive_lightning_chain_lua_a = class({})
end

function passive_lightning_chain_lua_a:GetIntrinsicModifierName()
 	return "modifier_passive_lightning_chain_lua"
end

function passive_lightning_chain_lua_a:Precache(context)
	PrecacheResource( "particle", sParticle, context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/arc_lightning.vsnd", context )
	PrecacheResource( "soundfile", "sounds/weapons/hero/zuus/general_attack1.vsnd", context )

end

--------------------------------------------------
if modifier_passive_lightning_chain_lua == nil then
	modifier_passive_lightning_chain_lua = class({})
end


function modifier_passive_lightning_chain_lua:IsHidden()
	return true
end

function modifier_passive_lightning_chain_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end


function modifier_passive_lightning_chain_lua:OnAttack( params )
	if IsServer() then
		if params.attacker ~= self:GetParent() then
			return 0
		end
		-- if self:GetCaster():HasModifier("modifier_item_archer_bow_multe")  == true then return end
		local nowChance = RandomInt(0,100)
		local chance = self:GetAbility():GetSpecialValueFor( "chance" )
		if nowChance  > chance then
			return 0
		end
		local hAttacker = params.attacker
		local hTarget = params.target
		local abil_damage = 1
		local hCaster = self:GetCaster()
		self:GetAbility().nDamage = self:GetAbility():GetSpecialValueFor( "scale" )*hCaster:GetIntellect() + self:GetAbility():GetSpecialValueFor( "basedamage" )
		self:GetAbility().hTargetsHit = {}
		self:HitTarget( hCaster,hTarget)
	end
end

function modifier_passive_lightning_chain_lua:HitTarget( hOrigin,hTarget)
	if hTarget == nil then
		return
	end
	local lightningBolt = ParticleManager:CreateParticle(
		sParticle, 
		PATTACH_WORLDORIGIN, 
		hOrigin
	)
	ParticleManager:SetParticleControl(
		lightningBolt,
		0,
		Vector(hOrigin:GetAbsOrigin().x,hOrigin:GetAbsOrigin().y,hOrigin:GetAbsOrigin().z + hOrigin:GetBoundingMaxs().z )
	)   
	ParticleManager:SetParticleControl(
		lightningBolt,
		1,
		Vector(hTarget:GetAbsOrigin().x,hTarget:GetAbsOrigin().y,hTarget:GetAbsOrigin().z + hTarget:GetBoundingMaxs().z )
	)
	
	hTarget:AddNewModifier( 
		self:GetCaster(), 
		self:GetAbility(), 
		"modifier_passive_lightning_chain_lua_thinker", 
		{ duration = 1} 
	)

	table.insert( self:GetAbility().hTargetsHit, hTarget )
end


--------------------------------------------------
if modifier_passive_lightning_chain_lua_thinker == nil then
	modifier_passive_lightning_chain_lua_thinker = class({})
end

function modifier_passive_lightning_chain_lua_thinker:IsHidden() 
	return true
end
-- 伤害公式 投资等级*投资等级/14
function modifier_passive_lightning_chain_lua_thinker:OnCreated()
	if IsServer() then
		self.nMaxTargets = 10
		self:StartIntervalThink( 0.1 )
	end
end

function modifier_passive_lightning_chain_lua_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_passive_lightning_chain_lua_thinker:OnIntervalThink()
	if IsServer() then
		local hTarget =  self:GetParent()
		local enemies = FindUnitsInRadius( 
			self:GetCaster():GetTeamNumber(), 
			hTarget:GetOrigin(), 
			hTarget, 
			600, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			0, 
			false 
		)
		local hClosestTarget = nil
		local flClosestDist = 0.0
		-- 选取范围最近的1个单位
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil then

					local bIsHit = false

					if self:GetAbility().hTargetsHit ~= nil then
						for _,hHitEnemy in ipairs(self:GetAbility().hTargetsHit) do
							if enemy == hHitEnemy then
								bIsHit = true
							end 
						end
					end
					-- 如果单位没有被击中过，计算距离
					if bIsHit == false then
						local vToTarget = enemy:GetOrigin() - self:GetParent():GetOrigin()
						local flDistToTarget = vToTarget:Length()

						if hClosestTarget == nil or flDistToTarget < flClosestDist then
							hClosestTarget = enemy
							flClosestDist = flDistToTarget
						end
					end			
				end
			end
		end
		

		if hClosestTarget ~= nil and #self:GetAbility().hTargetsHit < self.nMaxTargets then
			self:HitTarget( hTarget,hClosestTarget)
		end
		

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbility().nDamage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		}
		ApplyDamage( damage )

		self:Destroy()
	end
end

function modifier_passive_lightning_chain_lua_thinker:HitTarget( hOrigin,hTarget)
	if hTarget == nil then
		return
	end
	local lightningBolt = ParticleManager:CreateParticle(sParticle, PATTACH_WORLDORIGIN, hOrigin)
	ParticleManager:SetParticleControl(
		lightningBolt,
		0,
		Vector(hOrigin:GetAbsOrigin().x,hOrigin:GetAbsOrigin().y,hOrigin:GetAbsOrigin().z + hOrigin:GetBoundingMaxs().z )
	)   
	ParticleManager:SetParticleControl(
		lightningBolt,
		1,
		Vector(hTarget:GetAbsOrigin().x,hTarget:GetAbsOrigin().y,hTarget:GetAbsOrigin().z + hTarget:GetBoundingMaxs().z )
	)
	table.insert( self:GetAbility().hTargetsHit, hTarget )
	hTarget:AddNewModifier( 
		self:GetCaster(), 
		self:GetAbility(), 
		"modifier_passive_lightning_chain_lua_thinker", 
		{ duration = 1} 
	)
	
end