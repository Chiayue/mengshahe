
LinkLuaModifier("modifier_feixing_moshi_lua","ability/abilities_lua/feixing_moshi_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

feixing_moshi_lua = class({})

function feixing_moshi_lua:GetIntrinsicModifierName()
	return "modifier_feixing_moshi_lua"
end

--------------------------------------------------------------------------------

modifier_feixing_moshi_lua = class({})

function modifier_feixing_moshi_lua:IsHidden()
    return true
end

function modifier_feixing_moshi_lua:IsPurgable()
    return false
end
 
function modifier_feixing_moshi_lua:RemoveOnDeath()
    return false
end

function modifier_feixing_moshi_lua:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/gyrocopter/gyro_allied_commander_back/gyro_allied_commander_back.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/gyrocopter/gyro_allied_commander_head/gyro_allied_commander_head.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/gyrocopter/gyro_allied_commander_misc/gyro_allied_commander_misc.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/gyrocopter/gyro_allied_commander_off_hand/gyro_allied_commander_off_hand.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/gyrocopter/gyro_allied_commander_weapon/gyro_allied_commander_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)

    end
end