modifier_vip_show_buff_lua = class({})
--------------------------------------------------------------------------------

function modifier_vip_show_buff_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_vip_show_buff_lua:IsHidden()
    return true
end

function modifier_vip_show_buff_lua:RemoveOnDeath()
	return false -- 死亡不移除
end

function modifier_vip_show_buff_lua:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/ambient3.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 
		-- local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/ambient13.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 红鱼转圈
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end



-------------------------------------------------------------------------------------------
modifier_show_box_lua = class({})

function modifier_show_box_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_show_box_lua:IsHidden()
    return true
end

function modifier_show_box_lua:RemoveOnDeath()
	return false -- 死亡不移除
end

function modifier_show_box_lua:OnCreated( kv )
	if IsServer() then
		local quality = kv.quality
		if quality=="N" then
			local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/baoxiang_n.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		elseif quality=="R" then
			local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/baoxiang_r.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		elseif quality=="SR" then
			local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/baoxiang_sr.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		elseif quality=="SSR" then
			local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/baoxiang_ssr.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() ) -- 
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		end
	end
end
