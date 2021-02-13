LinkLuaModifier("modifier_xiwuqicai_lua","ability/abilities_lua/xiwuqicai_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

xiwuqicai_lua = class({})

function xiwuqicai_lua:GetIntrinsicModifierName()
	return "modifier_xiwuqicai_lua"
end

--------------------------------------------------------------------------------

modifier_xiwuqicai_lua = class({})

function modifier_xiwuqicai_lua:IsHidden()
    return true
end

function modifier_xiwuqicai_lua:IsPurgable()
    return false
end
 
function modifier_xiwuqicai_lua:RemoveOnDeath()
    return false
end

function modifier_xiwuqicai_lua:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_armor/am_shinobi_armor.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_shinobi/antimage_shinobi_armor.vpcf", PATTACH_POINT_FOLLOW, item)
        ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_cape_fx_left", item:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 2, item, PATTACH_POINT_FOLLOW, "attach_cape_fx_right", item:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 3, item, PATTACH_POINT_FOLLOW, "attach_cape_fx_left_02", item:GetOrigin(), true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_arms/am_shinobi_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_shinobi/antimage_shinobi_arms.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_belt/am_shinobi_belt.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_head/am_shinobi_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_shinobi/antimage_shinobi_head.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_off_hand/am_shinobi_off_hand.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_shinobi/antimage_shinobi_offhand.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_shoulder/am_shinobi_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_shinobi/antimage_shinobi_shoulder.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/antimage/am_shinobi_weapon/am_shinobi_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_shinobi/antimage_shinobi_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

    end
end