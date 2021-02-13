function go_point(params)
	local caster = params.caster
	-- local hero = caster:GetOwner(  )
	-- local position = hero:GetCursorPosition()
	local position = params.target_points[1]
	caster:SetAbsOrigin(position)

	local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlForward( nFXIndex1, 0, position )
	ParticleManager:ReleaseParticleIndex( nFXIndex1 )

	Timers:CreateTimer(0.1, function()
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlForward( nFXIndex2, 0, position )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )
	end)
	caster:EmitSound("xingshi.shansuo")
end


