require("config/drop_config")


LinkLuaModifier("modifier_shenfu_zhufu_lua", "ability/abilities_lua/innateskill_shenfu_zhufu_lua.lua", LUA_MODIFIER_MOTION_NONE)

shenfu_zhufu_lua = class({})

--------------------------------------------------------------------------------

function shenfu_zhufu_lua:OnSpellStart()
    local item_name = drop_config:get_random_rune_name()
    local hero = self:GetCaster()
    local player = PlayerResource:GetPlayer(hero:GetPlayerID())
    local item = CreateItem(item_name, hero, player)
    -- item:SetOwner(PlayerResource:GetPlayer(player_id))
    item:SetPurchaseTime(0)
    local pos = hero:GetAbsOrigin()

    CreateItemOnPositionSync( pos, item )
end

function shenfu_zhufu_lua:GetIntrinsicModifierName()
	return "modifier_shenfu_zhufu_lua"
end


modifier_shenfu_zhufu_lua = class({})

function modifier_shenfu_zhufu_lua:IsHidden()
    return true
end

function modifier_shenfu_zhufu_lua:IsPurgable()
    return false
end
 
function modifier_shenfu_zhufu_lua:RemoveOnDeath()
    return false
end

function modifier_shenfu_zhufu_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_shenfu_zhufu_lua:GetModifierBaseAttack_BonusDamage(params)
    return 1000    
end

function modifier_shenfu_zhufu_lua:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/arc_warden/wicked_space_knight_arms/wicked_space_knight_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_bracer_ambient.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti10_cache/arc_warden_ti10_cache_arms.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/arc_warden/wicked_space_knight_back/wicked_space_knight_back.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti10_cache/arc_warden_ti10_cache_back.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/arc_warden/wicked_space_knight_head/wicked_space_knight_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti10_cache/arc_warden_ti10_cache_head.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/arc_warden/wicked_space_knight_shoulder/wicked_space_knight_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti10_cache/arc_warden_ti10_cache_shoulder.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

    end
end


------------------------------------升化技能--------------------------------------------

sublime_shenfu_zhufu_lua = class({})

--------------------------------------------------------------------------------

function sublime_shenfu_zhufu_lua:OnSpellStart()
    local item_name = drop_config:get_random_rune_name()
    local hero = self:GetCaster()
    local player = PlayerResource:GetPlayer(hero:GetPlayerID())
    local item = CreateItem(item_name, hero, player)
    -- item:SetOwner(PlayerResource:GetPlayer(player_id))
    item:SetPurchaseTime(0)
    local pos = hero:GetAbsOrigin()
    CreateItemOnPositionSync( pos, item )


    local item_name_2 = drop_config:get_random_rune_name()
    while item_name_2==item_name do
        item_name_2 = drop_config:get_random_rune_name()
    end

    local item_2 = CreateItem(item_name_2, hero, player)
    -- item:SetOwner(PlayerResource:GetPlayer(player_id))
    item_2:SetPurchaseTime(0)
    local pos_2 = Vector(hero:GetAbsOrigin().x+100, hero:GetAbsOrigin().y, hero:GetAbsOrigin().z)
    CreateItemOnPositionSync( pos_2, item_2 )

    if RollPercentage(20) then
        local item_name_3 = drop_config:get_random_rune_name()
        while item_name_3==item_name do
            item_name_3 = drop_config:get_random_rune_name()
        end

        local item_3 = CreateItem(item_name_3, hero, player)
        -- item:SetOwner(PlayerResource:GetPlayer(player_id))
        item_3:SetPurchaseTime(0)
        local pos_3 = Vector(hero:GetAbsOrigin().x-100, hero:GetAbsOrigin().y, hero:GetAbsOrigin().z)
        CreateItemOnPositionSync( pos_3, item_3 )
    end
end