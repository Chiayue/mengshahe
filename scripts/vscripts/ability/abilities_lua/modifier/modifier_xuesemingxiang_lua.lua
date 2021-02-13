modifier_xuesemingxiang_lua = class({})
--------------------------------------------------------------------------------

function modifier_xuesemingxiang_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end

function modifier_xuesemingxiang_lua:IsHidden()
    return true
end
function modifier_xuesemingxiang_lua:OnCreated( kv )
	-- self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0

	-- if IsServer() then
	-- 	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- 	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
	-- 	self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	-- end

	if IsServer() then

		self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/lina/origins_flamehair/origins_flamehair.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/lina/blazing_cosmos_arms/blazing_cosmos_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/lina/lina_blazing_cosmos/lina_blazing_cosmos_arms.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/lina/blazing_cosmos_belt/blazing_cosmos_belt.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/lina/lina_blazing_cosmos/lina_blazing_cosmos_belt.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/lina/blazing_cosmos_neck/blazing_cosmos_neck.vmdl",
        })
        item:FollowEntity(self.parent, true)
		ParticleManager:CreateParticle("particles/econ/items/lina/lina_blazing_cosmos/lina_blazing_cosmos_neck.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
		
		index = ParticleManager:CreateParticle("particles/econ/items/lina/lina_head_headflame/lina_headflame.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_head", self.parent:GetOrigin(), true)

		index = ParticleManager:CreateParticle("particles/econ/items/lina/lina_head_headflame/lina_flame_hand_dual_headflame.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(index, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", self.parent:GetOrigin(), true)

	end

end

function modifier_xuesemingxiang_lua:GetModifierManaBonus()
    -- 天生多蓝
    return 1000
end

function modifier_xuesemingxiang_lua:GetModifierConstantManaRegen()
    return 4
end
