function Spawn(entityKeyValues)
	if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
			end
			if CanBloodThirsty() then
				thisEntity:CastAbilityNoTarget(BloodThirstyAbility, thisEntity:GetEntityIndex())
				return 1
			end
			if CanFrostNova() then
				thisEntity:CastAbilityNoTarget(FrostNovaAbility, thisEntity:GetEntityIndex())
				return 1
			end
			if CanBlameDuel() then
				thisEntity:CastAbilityNoTarget(BlameDuelAbility, thisEntity:GetEntityIndex())
				return 1
			end
			if CanShelter() then
				thisEntity:CastAbilityNoTarget(ShelterAbility, thisEntity:GetEntityIndex())
				return 1
			end
			if CanAphoticShield() then
				thisEntity:CastAbilityNoTarget(AphoticShieldAbility, thisEntity:GetEntityIndex())
				return 1
			end
			return 1
		end)
	end
end

function CanBloodThirsty()
	if not BloodThirstyAbility then
		BloodThirstyAbility = thisEntity:FindAbilityByName("initiative_blood_thirsty_lua")
	end
	return BloodThirstyAbility and BloodThirstyAbility:IsFullyCastable()
end

function CanFrostNova()
	if not FrostNovaAbility then
		FrostNovaAbility = thisEntity:FindAbilityByName("initiative_frost_nova_lua")
	end
	return FrostNovaAbility and FrostNovaAbility:IsFullyCastable()
end
function CanBlameDuel()
	if not BlameDuelAbility then
		BlameDuelAbility = thisEntity:FindAbilityByName("initiative_blame_duel_lua")
	end
	return BlameDuelAbility and BlameDuelAbility:IsFullyCastable()
end
function CanShelter()
	if not ShelterAbility then
		ShelterAbility = thisEntity:FindAbilityByName("initiative_shelter_lua")
	end
	return ShelterAbility and ShelterAbility:IsFullyCastable()
end
function CanAphoticShield()
	if not AphoticShieldAbility then
		AphoticShieldAbility = thisEntity:FindAbilityByName("initiative_aphotic_shield_lua")
	end
	return AphoticShieldAbility and AphoticShieldAbility:IsFullyCastable()
end