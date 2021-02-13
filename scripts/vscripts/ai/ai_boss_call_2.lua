function Spawn(entityKeyValues)
	if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
			end
	
			if CanBossCallOne() then
			    local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    300, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
                    FIND_ANY_ORDER, 
                    true
                )
				thisEntity:CastAbilityOnTarget(enemies[1], BossCallOne, thisEntity:GetEntityIndex())
				return 1
			end
	
			return 1
		end)
	end
end


function CanBossCallOne()
	if not BossCallOne then
		BossCallOne = thisEntity:FindAbilityByName("initiative_boss_call_2_one_lua")
	end
	return BossCallOne and BossCallOne:IsFullyCastable()
end
-- function CanScorpionKingTwo()
-- 	if not ScorpionKingTwo then
-- 		ScorpionKingTwo = thisEntity:FindAbilityByName("initiative_scorpion_king_two_lua")
-- 	end
-- 	return ScorpionKingTwo and ScorpionKingTwo:IsFullyCastable()
-- end
-- function CanScorpionKingThree()
-- 	if not ScorpionKingThree then
-- 		ScorpionKingThree = thisEntity:FindAbilityByName("initiative_scorpion_king_three_lua")
-- 	end
-- 	return ScorpionKingThree and ScorpionKingThree:IsFullyCastable()
-- end
