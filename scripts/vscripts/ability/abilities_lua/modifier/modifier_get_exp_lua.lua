modifier_get_exp_lua = class({})
--------------------------------------------------------------------------------

function modifier_get_exp_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_get_exp_lua:IsHidden()
    return true
end

function modifier_get_exp_lua:RemoveOnDeath()
	return false -- 死亡不移除
end

function modifier_get_exp_lua:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/ambient11.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 获得经验
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		self:GetParent():EmitSound("drop.fireworks")
		-- local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/ambient3.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 获得经验
		-- ParticleManager:SetParticleControlEnt(nFXIndex, 5, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		-- self:AddParticle(nFXIndex, false, false, 15, false, false)
	end
end

