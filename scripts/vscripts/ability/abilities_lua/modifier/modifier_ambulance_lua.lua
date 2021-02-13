require("info/game_playerinfo")

modifier_ambulance_lua = class({})
--------------------------------------------------------------------------------

function modifier_ambulance_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_ambulance_lua:IsHidden()
    return true
end
function modifier_ambulance_lua:OnCreated( kv )
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
    if IsServer( ) then
        ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_ambulance_lua,'killed_monster'),self)
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chen/ti9_cache_chen_emperor_of_the_sun_arms/ti9_cache_chen_emperor_of_the_sun_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chen/ti9_cache_chen_emperor_of_the_sun_head/ti9_cache_chen_emperor_of_the_sun_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/chen/ti9_emperor_of_the_sun/chen_ti9_head_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "head_attachment", item:GetOrigin(), true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chen/ti9_cache_chen_emperor_of_the_sun_mount/ti9_cache_chen_emperor_of_the_sun_mount.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/chen/ti9_emperor_of_the_sun/chen_ti9_mount_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "head_attachment", item:GetOrigin(), true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chen/ti9_cache_chen_emperor_of_the_sun_shoulder/ti9_cache_chen_emperor_of_the_sun_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/chen/ti9_cache_chen_emperor_of_the_sun_weapon/ti9_cache_chen_emperor_of_the_sun_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)
    end
end


function modifier_ambulance_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    if 50 >= count_unit_table_num() then
        return
    end
    local monster = EntIndexToHScript(evt.entindex_killed)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
    -- 技能所有者
    local self_hero = self:GetParent()

    -- print(">>>>>>>>>>> hero: "..hero:GetPlayerOwnerID())
    -- print(">>>>>>>>>>> self_hero: "..self_hero:GetPlayerOwnerID())

    if not hero:IsHero() or not self_hero:IsHero() then
        return
    end
    if hero:GetPlayerOwnerID()~=self_hero:GetPlayerOwnerID() then
        -- 怪必须是自己击杀的
        return
    end
    if ContainUnitTypeFlag(monster, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_FINALLY) then
        -- 世界BOSS不做判断
        return
    end
    local monster_owner_id = tonumber(monster.player_id)
    -- print(">>>>>>>>>>> monster_owner: "..monster_owner_id)
    -- 获取怪物的所有者
    local monster_owner = EntIndexToHScript(monster_owner_id)

    -- 击杀的不是自己的怪物
    if self_hero:GetPlayerOwnerID() ~= monster_owner_id then
        if RollPercentage(10) then
            SetBaseStrength(hero, 2)
            SetBaseAgility(hero, 2)
            SetBaseIntellect(hero, 2)

            local monster_owner_hero = monster_owner:GetAssignedHero()

            SetBaseStrength(monster_owner_hero, 1)
            SetBaseAgility(monster_owner_hero, 1)
            SetBaseIntellect(monster_owner_hero, 1)
        end
    end
end