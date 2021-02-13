modifier_open_baoxiang_lua = class({})
--------------------------------------------------------------------------------

function modifier_open_baoxiang_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_open_baoxiang_lua:IsHidden()
    return true
end
function modifier_open_baoxiang_lua:OnCreated( kv )
	if IsServer() then
		-- local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti9/ti9_emblem_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 紫花
        -- local nFXIndex = ParticleManager:CreateParticle( "particles/custom/saber_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 红鱼转圈
        -- print(" >>>>>>>>>>>>> modifier_open_baoxiang_lua")
		local nFXIndex = ParticleManager:CreateParticle( "particles/custom_particles/xuanzeyingxiong.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 红鱼转圈加强版
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        
        -- local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 
		-- -- ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        -- self:AddParticle( nFXIndex1, false, false, -1, false, true )

	end
end

