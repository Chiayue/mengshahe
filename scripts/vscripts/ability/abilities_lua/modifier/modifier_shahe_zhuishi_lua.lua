require("info/game_playerinfo")

modifier_shahe_zhuishi_lua = class({})
--------------------------------------------------------------------------------
local kill_number = 0
local kill_number_7_bonus = true

local add_attr = {
    66,
    78,
    89,
    89,
    89,
}

function modifier_shahe_zhuishi_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_shahe_zhuishi_lua:IsHidden()
    return true
end
function modifier_shahe_zhuishi_lua:OnCreated( kv )
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
        ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_shahe_zhuishi_lua,'killed_monster'),self)

        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/heroes/shadow_fiend/head_arcana.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_ambient.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_ambient_eyes.vpcf", PATTACH_POINT_FOLLOW, self.parent)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/heroes/shadow_fiend/fx_shadow_fiend_arcana_hand.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/shadow_fiend/arms_deso/arms_deso.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_desolation/shadow_fiend_desolation_ambient.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_arm_L", self.parent:GetOrigin(), true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", PATTACH_POINT_FOLLOW, item)

        ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)

        self.parent:SetContextThink(DoUniqueString("continuous_effects"), function ()
            ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf", PATTACH_POINT_FOLLOW, self.parent)
            ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout.vpcf", PATTACH_POINT_FOLLOW, self.parent)
            return 3
        end, 0)
    end
end


function modifier_shahe_zhuishi_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)

    local monster_name = monster:GetUnitName()
    if monster_name ~= "task_golem" then
        return
    end

    local parent = self:GetParent()
    print(monster.player_id.."==========="..parent:GetPlayerID())
    if monster.player_id ~= parent:GetPlayerID() then
        return
    end
    
    -- local monster_owner_id = tonumber(monster.player_id)
    -- local hero = PlayerResource:GetPlayer(monster_owner_id):GetAssignedHero()
    -- 击杀的是自己的怪物
    kill_number = kill_number + 1
    
    -- SetBaseStrength(hero, add_attr[kill_number])
    -- SetBaseAgility(hero, add_attr[kill_number])
    -- SetBaseIntellect(hero, add_attr[kill_number])
    
    SetBaseStrength(parent, 66)
    SetBaseAgility(parent, 66)
    SetBaseIntellect(parent, 66)

    if kill_number_7_bonus and kill_number >= 7 then
        kill_number_7_bonus = false
        SetBaseStrength(parent, 500)
        SetBaseAgility(parent, 500)
        SetBaseIntellect(parent, 500)
    end

end