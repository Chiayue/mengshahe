require("info/game_playerinfo")

modifier_chongzu_jinhua_lua = class({})
--------------------------------------------------------------------------------

function modifier_chongzu_jinhua_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_chongzu_jinhua_lua:IsHidden()
    return true
end
function modifier_chongzu_jinhua_lua:OnCreated( kv )
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
        ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_chongzu_jinhua_lua,'killed_monster'),self)

        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/nerubian_assassin/crawler_from_the_deep_back/crawler_from_the_deep_back.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/nerubian_assassin/crawler_from_the_deep_head/crawler_from_the_deep_head.vmdl",
        })
        item:SetSkin(1)
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/nerubian_assassin/crawler_from_the_deep_misc/crawler_from_the_deep_misc.vmdl",
        })
        item:FollowEntity(self.parent, true)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/nerubian_assassin/crawler_from_the_deep_weapon/crawler_from_the_deep_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)
    end

end


function modifier_chongzu_jinhua_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
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
    if RollPercentage(10) then
        local rand = RandomInt(1, 3)
        if 1 == rand then
            SetBaseAgility(hero, 1)
        elseif 2 == rand then
            SetBaseIntellect(hero, 1)
        else
            SetBaseStrength(hero, 1)
        end
    end
end