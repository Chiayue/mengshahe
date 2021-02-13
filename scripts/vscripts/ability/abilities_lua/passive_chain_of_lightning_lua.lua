--闪电链
passive_chain_of_lightning_lua = class({})
-- chain_of_lightning = passive_chain_of_lightning_lua

LinkLuaModifier("modifier_passive_chain_of_lightning","ability/abilities_lua/passive_chain_of_lightning_lua",LUA_MODIFIER_MOTION_NONE )

function passive_chain_of_lightning_lua:GetIntrinsicModifierName()
	return "modifier_passive_chain_of_lightning"
end

if modifier_passive_chain_of_lightning == nil then
    modifier_passive_chain_of_lightning = class({})
end

function modifier_passive_chain_of_lightning:IsHidden()
    return true -- 隐藏
end

function modifier_passive_chain_of_lightning:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_chain_of_lightning:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_chain_of_lightning:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_chain_of_lightning:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START ,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_passive_chain_of_lightning:OnCreated(params)
    if not IsServer( ) then
        return
	end
	self.ability = self:GetAbility()
end
function modifier_passive_chain_of_lightning:OnAttackStart(params)
    if IsServer( ) then
		local caster = self:GetCaster()
		self.isLightnig = false
		if params.attacker == caster then
			if PseudoRandom:RollPseudoRandom(self.ability, self.ability:GetSpecialValueFor("chance")+(GameRules:GetCustomGameDifficulty()-1)*2) then
				self.isLightnig = true
				local ability = self.ability
				local target = params.target
				if ability.instance == nil then
					ability.instance = 0
					ability.jump_count = {}
					ability.target = {}
				else
					ability.instance = ability.instance + 1
				end
				ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1))
				ability.target[ability.instance] = target

				local info = {
					EffectName = "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf",
					Ability = self,
					iMoveSpeed = 900,
					Source = caster,
					Target = target,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_HITLOCATION,
				  }
				ProjectileManager:CreateTrackingProjectile(info)
            end
        end
    end
end 


function modifier_passive_chain_of_lightning:OnAttackLanded(params)
    if not IsServer() then
        return 
	end
	if(self.ability ~=nil and self.isLightnig == true)then
		local caster = self:GetCaster()
		local ability =  self.ability
		local target = params.target
		local jump_delay = ability:GetLevelSpecialValueFor("jump_delay", (ability:GetLevel() -1))
		local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
		ApplyDamage({victim = target, attacker = caster, damage = params.damage+caster:GetDamageMax(), damage_type = ability:GetAbilityDamageType()})
		Timers:CreateTimer(jump_delay,
			function()
				local current
				for i=0,ability.instance do
					if ability.target[i] ~= nil then
						if ability.target[i] == target then
							current = i
						end
					end
				end
				if target.hit == nil then
					target.hit = {}
				end
				target.hit[current] = true
				ability.jump_count[current] = ability.jump_count[current] - 1
				if ability.jump_count[current] > 0 then
					local units = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,1,false)
					local closest = radius
					local new_target
					for i,unit in ipairs(units) do
						local unit_location = unit:GetAbsOrigin()
						local vector_distance = target:GetAbsOrigin() - unit_location
						local distance = (vector_distance):Length2D()
						if distance < closest then
							if unit.hit == nil then
								new_target = unit
								closest = distance
							elseif unit.hit[current] == nil then
								new_target = unit
								closest = distance
							end
						end
					end
					if new_target ~= nil then
						local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, target)
						ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
						ParticleManager:SetParticleControl(lightningBolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
						ability.target[current] = new_target
					else
						ability.target[current] = nil
					end
				else
					ability.target[current] = nil
				end
			end
		)
	end
end



	
