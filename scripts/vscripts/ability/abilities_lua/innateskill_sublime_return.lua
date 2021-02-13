--[[
	Author: Noya
	Date: 9.1.2015.
	Does base damage plus a percent of the hero strength
]]
function sublime_Return( event )
	-- Variables
	if not RollPercentage(70) then
		return
	end
	if not event.ability then
		return
	end
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local casterint = caster:GetStrength()
	local int_return = ability:GetSpecialValueFor("int_pct")
	local damage = ability:GetSpecialValueFor("return_damage")
	local damageType = ability:GetAbilityDamageType()
	local return_damage = damage + ( casterint * int_return )

	-- Damage
	if attacker:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({ victim = attacker, attacker = caster, damage = return_damage, damage_type = damageType })
	end
end
