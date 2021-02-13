
require("filter/game_filter")
modifier_sale_lua = class({})
--------------------------------------------------------------------------------

function modifier_sale_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end

function modifier_sale_lua:IsHidden()
    return true
end
function modifier_sale_lua:OnCreated( kv )
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
	-- local GameMode = GameRules:GetGameModeEntity()
	-- GameMode:SetModifyGoldFilter(Dynamic_Wrap(Filter,"ShopBuyFilter"),Filter)


	-- if IsServer() then
    --     self.parent = self:GetParent()
	-- 	local item = nil
	-- 	local index = nil
		
    --     -- item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/keeper_of_the_light/kotl_the_king_of_thieves_belt/kotl_the_king_of_thieves_belt.vmdl"})
	-- 	-- item:FollowEntity(self.parent, true)
	-- 	-- ParticleManager:CreateParticle("particles/econ/items/keeper_of_the_light/kotl_ti10_cache/kotl_ti10_cache_belt_sparkle.vpcf", PATTACH_POINT_FOLLOW, item)
		
    --     -- item = SpawnEntityFromTableSynchronous("prop_dynamic", {
	-- 	-- 	model = "models/items/keeper_of_the_light/kotl_the_king_of_thieves_head/kotl_the_king_of_thieves_head.vmdl",
	-- 	-- 	DefaultAnim = "ACT_DOTA_IDLE"
	-- 	-- })
	-- 	-- item:FollowEntity(self.parent, true)
    --     -- ParticleManager:CreateParticle("particles/econ/items/keeper_of_the_light/kotl_ti10_cache/kotl_ti10_cache_head.vpcf", PATTACH_POINT_FOLLOW, item)

    --     -- item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/keeper_of_the_light/kotl_the_king_of_thieves_mount/kotl_the_king_of_thieves_mount.vmdl"})
	-- 	-- item:FollowEntity(self.parent, true)
    --     -- ParticleManager:CreateParticle("particles/econ/items/keeper_of_the_light/kotl_ti10_cache/kotl_ti10_cache_mount.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

    --     -- item = SpawnEntityFromTableSynchronous("prop_dynamic", {
	-- 	-- 	model = "models/items/keeper_of_the_light/kotl_the_king_of_thieves_weapon/kotl_the_king_of_thieves_weapon.vmdl",
	-- 	-- 	DefaultAnim = "ACT_DOTA_IDLE"
	-- 	-- })
	-- 	-- item:FollowEntity(self.parent, true)
	-- 	-- index = ParticleManager:CreateParticle("particles/econ/items/keeper_of_the_light/kotl_ti10_cache/kotl_ti10_cache_weapon.vpcf", PATTACH_POINT_FOLLOW, item)
	-- 	-- ParticleManager:SetParticleControlEnt(index, 3, item, PATTACH_POINT_FOLLOW, "attach_weapon_fx", item:GetOrigin(), true)


		

	-- 	-- item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/keeper_of_the_light/kotl_the_king_of_thieves_belt/kotl_the_king_of_thieves_belt.vmdl"})
	-- 	-- item:FollowEntity(self.parent, true)
	-- 	-- ParticleManager:CreateParticle("particles/diy_particles/diy_steam_ambient.vpcf", PATTACH_POINT_FOLLOW, item)

	-- 	local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/diy_steam_ambient.vpcf", PATTACH_WORLDORIGIN, self.parent );
	-- 	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.parent, PATTACH_WORLDORIGIN, "", self.parent:GetOrigin(), true );

		
	-- end
	
	if IsServer() then
        -- print(" >>>>>>>>>>>>>>>> self.space_time: "..self.space_time)
        -- self:StartIntervalThink( self.space_time )

        self.parent = self:GetParent()
        local index = nil

        index = ParticleManager:CreateParticle("particles/diy_particles/diy_steam_ambient.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_dark_swirl.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_nebula.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_core_glow.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ember.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ember_streak.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_flare.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_flare_b.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_flare_c.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ground_scorch.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        -- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        -- index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_world_chasm_ring_pnt.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        -- ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        
    end
end

-- function modifier_sale_lua:GetModifierConstantManaRegen()
--     return -4
-- end
