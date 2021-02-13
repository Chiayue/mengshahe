require("info/game_playerinfo")

modifier_caijibianfenghuang_lua = class({})
--------------------------------------------------------------------------------

function modifier_caijibianfenghuang_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_caijibianfenghuang_lua:OnCreated( kv )
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
            model = "models/items/beastmaster/ti9_cache_bm_chieftain_of_the_primal_shoulder/ti9_cache_bm_chieftain_of_the_primal_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/beastmaster/ti9_cache_bm_chieftain_of_the_primal_tribes_arms/ti9_cache_bm_chieftain_of_the_primal_tribes_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/beastmaster/ti9_cache_bm_chieftain_of_the_primal_tribes_belt/ti9_cache_bm_chieftain_of_the_primal_tribes_belt.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/beastmaster/ti9_cache_bm_chieftain_of_the_primal_tribes_head/ti9_cache_bm_chieftain_of_the_primal_tribes_head.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/beastmaster/ti9_cache_bm_chieftain_of_the_primal_tribes_weapon/ti9_cache_bm_chieftain_of_the_primal_tribes_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)        
    end


end


function modifier_caijibianfenghuang_lua:OnDeath(params)
    if not IsServer( ) then
        return
    end
    local hero = self:GetParent()
    if params.unit == hero then
        -- 判断死亡对象是否是自己
        self:IncrementStackCount();

        SetBaseStrength(hero, 7)
        SetBaseAgility(hero, 7)
        SetBaseIntellect(hero, 7)

        -- hero:SetModelScale(hero:GetModelScale() + 0.1)
        if self:GetStackCount() == 16 then
            hero:SetModelScale(hero:GetModelScale() + 2)
        elseif self:GetStackCount() == 32 then
            hero:SetModelScale(hero:GetModelScale() + 3)
        elseif self:GetStackCount() == 64 then
            hero:SetModelScale(hero:GetModelScale() + 5)
        elseif self:GetStackCount() == 128 then
            hero:SetModelScale(hero:GetModelScale() + 8)
        end

        if self:GetStackCount() == 16 then
            SetBaseStrength(hero, 100)
            SetBaseAgility(hero, 100)
            SetBaseIntellect(hero, 100)
        elseif self:GetStackCount() == 32 then
            SetBaseStrength(hero, 200)
            SetBaseAgility(hero, 200)
            SetBaseIntellect(hero, 200)
        elseif self:GetStackCount() == 64 then
            SetBaseStrength(hero, 400)
            SetBaseAgility(hero, 400)
            SetBaseIntellect(hero, 400)
        elseif self:GetStackCount() == 128 then
            SetBaseStrength(hero, 800)
            SetBaseAgility(hero, 800)
            SetBaseIntellect(hero, 800)
        end
    end
end