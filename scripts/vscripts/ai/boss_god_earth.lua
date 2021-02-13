function Spawn(entityKeyValues)
	if not IsServer() or thisEntity == nil then
		return
	end
	thisEntity.can_spell_ability = true

	CallAbility = thisEntity:FindAbilityByName("boss_god_earth_call")
	AvalancheAbility = thisEntity:FindAbilityByName("boss_god_earth_avalanche")
	SlamAbility = thisEntity:FindAbilityByName("boss_god_earth_slam")
	GrabAbility = thisEntity:FindAbilityByName("boss_god_earth_grab")

	thisEntity:SetContextThink("Think", function ()
		if not thisEntity:IsAlive() then
			return -1
		end
		if GameRules:IsGamePaused() == true then
			return 0.1
		end
		if thisEntity:IsChanneling() then
			return 0.1
		end
		if CanCall() then
			thisEntity:CastAbilityNoTarget(CallAbility, thisEntity:GetEntityIndex())
			return 1
		end
		if CanAvalanche() then
			thisEntity:CastAbilityNoTarget(AvalancheAbility, thisEntity:GetEntityIndex())
			return 1
		end
		if CanSlam() then
			thisEntity:CastAbilityOnPosition(thisEntity.slam_target:GetOrigin(), SlamAbility, thisEntity:GetEntityIndex())
			return 1
		end
		if CanGrab() then
			thisEntity:CastAbilityOnTarget(thisEntity.grab_target, GrabAbility, thisEntity:GetEntityIndex())
		end
		return 1
	end, 5)
end

function CanCall()
	return CallAbility:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.3
end

function CanAvalanche()
	return AvalancheAbility:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.6
end

function CanSlam()
	thisEntity.slam_target = nil
	local units = FindUnitsInRadius(
		thisEntity:GetTeamNumber(), 
		thisEntity:GetOrigin(), 
		nil, 
		500, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	if #units > 0 then
		thisEntity.slam_target = units[1]
	end
	return SlamAbility:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() and thisEntity.slam_target ~= nil
end

function CanGrab()
	thisEntity.grab_target = nil
	local units = FindUnitsInRadius(
		thisEntity:GetTeamNumber(), 
		thisEntity:GetOrigin(), 
		nil, 
		600, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)
	if #units > 0 then
		thisEntity.grab_target = units[1]
	end
	return GrabAbility: IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.9 and thisEntity.grab_target ~= nil
end