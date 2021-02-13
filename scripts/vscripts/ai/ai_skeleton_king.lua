function Spawn(entityKeyValues)
	if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
			end
			if CanSkeletonKingOne() then
				-- thisEntity:CastAbilityNoTarget(SkeletonKingOne, thisEntity:GetEntityIndex())
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

	
				if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], SkeletonKingOne, thisEntity:GetEntityIndex())
                end
				return 1
			end
			if CanSkeletonKingTwo() then
				thisEntity:CastAbilityNoTarget(SkeletonKingTwo, thisEntity:GetEntityIndex())
				return 1
			end
			if CanSkeletonKingThree() then
				local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )

				if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], SkeletonKingThree, thisEntity:GetEntityIndex())
                end
				return 1
			end
			if CanSkeletonKingFour() and GameRules:GetCustomGameDifficulty() > 7 then
				local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )

	
				if #enemies > 0  then --
                    thisEntity:CastAbilityOnTarget(enemies[1], SkeletonKingFour, thisEntity:GetEntityIndex())
                end
				return 1
			end
			if CanSkeletonKingFive() and GameRules:GetCustomGameDifficulty() > 7 then
				local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )


				if #enemies > 0  then --
                    thisEntity:CastAbilityOnTarget(enemies[1], SkeletonKingFive, thisEntity:GetEntityIndex())
                end
				return 1
			end
			return 1
		end)
	end
end
function CanSkeletonKingOne()
	if not SkeletonKingOne then
		SkeletonKingOne = thisEntity:FindAbilityByName("initiative_skeleton_king_one_lua")
	end
	return SkeletonKingOne and SkeletonKingOne:IsFullyCastable()
end
function CanSkeletonKingTwo()
	if not SkeletonKingTwo then
		SkeletonKingTwo = thisEntity:FindAbilityByName("initiative_skeleton_king_two_lua")
	end
	return SkeletonKingTwo and SkeletonKingTwo:IsFullyCastable()
end
function CanSkeletonKingThree()
	if not SkeletonKingThree then
		SkeletonKingThree = thisEntity:FindAbilityByName("initiative_skeleton_king_three_lua")
	end
	return SkeletonKingThree and SkeletonKingThree:IsFullyCastable()
end
function CanSkeletonKingFour()
	if not SkeletonKingFour then
		SkeletonKingFour = thisEntity:FindAbilityByName("initiative_skeleton_king_four_lua")
	end
	return SkeletonKingFour and SkeletonKingFour:IsFullyCastable()
end
function CanSkeletonKingFive()
	if not SkeletonKingFive then
		SkeletonKingFive = thisEntity:FindAbilityByName("initiative_skeleton_king_five_lua")
	end
	return SkeletonKingFive and SkeletonKingFive:IsFullyCastable()
end
