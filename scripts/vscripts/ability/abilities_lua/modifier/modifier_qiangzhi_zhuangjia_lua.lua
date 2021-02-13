require("global/global_var_func")

modifier_qiangzhi_zhuangjia_lua = class({})
--------------------------------------------------------------------------------

function modifier_qiangzhi_zhuangjia_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_qiangzhi_zhuangjia_lua:IsHidden()
    return true
end

function modifier_qiangzhi_zhuangjia_lua:OnCreated( kv )
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
            model = "models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_arms/ti9_cache_dk_scorching_amber_dragoon_arms.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_back/ti9_cache_dk_scorching_amber_dragoon_back.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_head/ti9_cache_dk_scorching_amber_dragoon_head.vmdl"
        })
        item:FollowEntity(self.parent, true)
		ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_scorching_amber/dk_scorching_head_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
		
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_off_hand/ti9_cache_dk_scorching_amber_dragoon_off_hand.vmdl"
        })
        item:FollowEntity(self.parent, true)
		ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_scorching_amber/dk_scorching_shield_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
    
		item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_shoulder/ti9_cache_dk_scorching_amber_dragoon_shoulder.vmdl"
        })
        item:FollowEntity(self.parent, true)
		ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_scorching_amber/dk_scorching_chest_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
    
		item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_weapon/ti9_cache_dk_scorching_amber_dragoon_weapon.vmdl"
        })
        item:FollowEntity(self.parent, true)
		ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_scorching_amber/dk_scorching_sword_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
		
	end
end

function modifier_qiangzhi_zhuangjia_lua:GetModifierPhysicalArmorBonus(params)
    return 100
end