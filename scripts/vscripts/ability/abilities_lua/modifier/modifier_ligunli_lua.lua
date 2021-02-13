require("info/game_playerinfo")

modifier_ligunli_lua = class({})
--------------------------------------------------------------------------------

function modifier_ligunli_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_ligunli_lua:IsHidden()
    return true
end
function modifier_ligunli_lua:OnCreated( kv )
    if IsServer() then
        ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_ligunli_lua,'killed_monster'),self)

        self.parent = self:GetParent()
        local item = nil
        local index = nil

        if self.parent:GetUnitName() == "npc_dota_hero_windrunner" then
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/windrunner/the_swift_pathfinder_swift_pathfinders_bow/the_swift_pathfinder_swift_pathfinders_bow.vmdl",
            })
            item:FollowEntity(self.parent, true)
            index = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf", PATTACH_POINT_FOLLOW, item)
            ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "bow_bot", item:GetOrigin(), true)
            ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "bow_mid", item:GetOrigin(), true)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/windrunner/the_swift_pathfinder_swift_pathfinders_cape/the_swift_pathfinder_swift_pathfinders_cape.vmdl",
            })
            item:FollowEntity(self.parent, true)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/windrunner/the_swift_pathfinder_swift_pathfinders_coat/the_swift_pathfinder_swift_pathfinders_coat.vmdl",
            })
            item:FollowEntity(self.parent, true)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/windrunner/the_swift_pathfinder_swift_pathfinders_hat_v2/the_swift_pathfinder_swift_pathfinders_hat_v2.vmdl",
            })
            item:FollowEntity(self.parent, true)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/windrunner/the_swift_pathfinder_swift_pathfinders_quiver/the_swift_pathfinder_swift_pathfinders_quiver.vmdl",
            })
            item:FollowEntity(self.parent, true)            
        end

        if self.parent:GetUnitName() == "npc_dota_hero_bounty_hunter" then
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/bounty_hunter/maniac_armor/maniac_armor.vmdl",
            })
            item:FollowEntity(self.parent, true)

            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/bounty_hunter/maniac_back/maniac_back.vmdl",
            })
            item:FollowEntity(self.parent, true)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/bounty_hunter/maniac_head/maniac_head.vmdl",
            })
            item:FollowEntity(self.parent, true)
            ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_maniac_head/bh_maniac_head_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/bounty_hunter/maniac_off_hand/maniac_off_hand.vmdl",
            })
            item:FollowEntity(self.parent, true)
    
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/bounty_hunter/maniac_shoulder/maniac_shoulder.vmdl",
            })
            item:FollowEntity(self.parent, true)   
            ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_maniac_shoulders/bh_maniac_shoulders_ambient.vpcf", PATTACH_POINT_FOLLOW, self.parent)

            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/bounty_hunter/maniac_weapon/maniac_weapon.vmdl",
            })
            item:FollowEntity(self.parent, true)   
            
        end

    end
end


function modifier_ligunli_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
    -- 技能所有者
    local self_hero = self:GetParent()

    if not hero:IsHero() or not self_hero:IsHero() then
        return
    end
    if hero:GetPlayerOwnerID()~=self_hero:GetPlayerOwnerID() then
        -- 怪必须是自己击杀的
        return
    end
    game_playerinfo:set_player_gold(hero:GetPlayerOwnerID(),25)
    -- end
end
