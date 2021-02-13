
require("info/game_playerinfo")

LinkLuaModifier("modifier_jiangdi_fangyu_lua","ability/abilities_lua/jiangdi_fangyu_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

jiangdi_fangyu_lua = class({})

function jiangdi_fangyu_lua:GetIntrinsicModifierName()
	return "modifier_jiangdi_fangyu_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_jiangdi_fangyu_lua = class({})

--------------------------------------------------------------------------------

function modifier_jiangdi_fangyu_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function modifier_jiangdi_fangyu_lua:IsHidden()
    return false
end

function modifier_jiangdi_fangyu_lua:IsAura()
    return true
end

function modifier_jiangdi_fangyu_lua:IsAuraActiveOnDeath()
    return true
end

function modifier_jiangdi_fangyu_lua:GetAuraRadius()
    return 99999
end

function modifier_jiangdi_fangyu_lua:GetModifierAura()
    return "modifier_physical_armor_lua"
end

function modifier_jiangdi_fangyu_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_jiangdi_fangyu_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_jiangdi_fangyu_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_jiangdi_fangyu_lua:GetAuraEntityReject(unit)
    if unit ~= self:GetCaster() then
        return false
    end
    return true
end

function modifier_jiangdi_fangyu_lua:OnCreated( kv )
    if IsServer() then

		self.parent = self:GetParent()
        local item = nil
        local index = nil
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/witchdoctor/vermilion_juju_of_the_south_back/vermilion_juju_of_the_south_back.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/witchdoctor/vermilion_juju_of_the_south_belt/vermilion_juju_of_the_south_belt.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/witchdoctor/vermilion_juju_of_the_south_head/vermilion_juju_of_the_south_head.vmdl"
        })
        item:FollowEntity(self.parent, true)
		
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/witchdoctor/vermilion_juju_of_the_south_shoulder/vermilion_juju_of_the_south_shoulder.vmdl"
        })
        item:FollowEntity(self.parent, true)
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/witchdoctor/vermilion_juju_of_the_south_weapon/vermilion_juju_of_the_south_weapon.vmdl"
        })
		item:FollowEntity(self.parent, true)
		
    end
end

function modifier_jiangdi_fangyu_lua:GetModifierPhysicalArmorBonus()
	return 10;
end
