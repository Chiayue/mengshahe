function Spawn(entityKeyValues)
	if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
			end
			if CanScorpionKingOne() then
				thisEntity:CastAbilityNoTarget(ScorpionKingOne, thisEntity:GetEntityIndex())
				return 1
			end
			if CanScorpionKingTwo() then
				local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    true
                )
				thisEntity:CastAbilityOnTarget(enemies[1], ScorpionKingTwo, thisEntity:GetEntityIndex())
				return 1
			end
			if CanScorpionKingThree() then
				thisEntity:CastAbilityNoTarget(ScorpionKingThree, thisEntity:GetEntityIndex())
				return 1
			end
			return 1
		end)
	end
end


function CanScorpionKingOne()
	if not ScorpionKingOne then
		ScorpionKingOne = thisEntity:FindAbilityByName("initiative_scorpion_king_one_lua")
	end
	return ScorpionKingOne and ScorpionKingOne:IsFullyCastable()
end
function CanScorpionKingTwo()
	if not ScorpionKingTwo then
		ScorpionKingTwo = thisEntity:FindAbilityByName("initiative_scorpion_king_two_lua")
	end
	return ScorpionKingTwo and ScorpionKingTwo:IsFullyCastable()
end
function CanScorpionKingThree()
	if not ScorpionKingThree then
		ScorpionKingThree = thisEntity:FindAbilityByName("initiative_scorpion_king_three_lua")
	end
	return ScorpionKingThree and ScorpionKingThree:IsFullyCastable()
end
