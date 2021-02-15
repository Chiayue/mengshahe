require("info/game_playerinfo")

modifier_siwan_zhili_lua = class({})
--------------------------------------------------------------------------------
local attack_add = 0

function modifier_siwan_zhili_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_siwan_zhili_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_siwan_zhili_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_siwan_zhili_lua:OnCreated( kv )
    if IsServer() then
        ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_siwan_zhili_lua,'killed_monster'),self)

        self.parent = self:GetParent()
        if self.parent:GetUnitName() == "npc_dota_hero_drow_ranger" then
            local item = nil
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_arms/secret_witch_arms.vmdl",
            })
            item:FollowEntity(self.parent, true)
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_back/secret_witch_back.vmdl",
            })
            item:FollowEntity(self.parent, true)
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_head/secret_witch_head.vmdl",
            })
            item:FollowEntity(self.parent, true)
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_legs/secret_witch_legs.vmdl",
            })
            item:FollowEntity(self.parent, true)
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_misc/secret_witch_misc.vmdl",
            })
            item:FollowEntity(self.parent, true)
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_shoulder/secret_witch_shoulder.vmdl",
            })
            item:FollowEntity(self.parent, true)
            
            item = SpawnEntityFromTableSynchronous("prop_dynamic", {
                model = "models/items/drow/secret_witch_weapon/secret_witch_weapon.vmdl",
            })
            item:FollowEntity(self.parent, true)
            ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_bowstring.vpcf", PATTACH_POINT_FOLLOW, item)

        end
    end
end


function modifier_siwan_zhili_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
    -- 技能所有者
    if self:IsNull() then
        return
    end
    if not self:GetAbility() then
		return
	end
    local self_hero = self:GetAbility():GetCaster()

    if not hero:IsHero() or not self_hero:IsHero() then
        return
    end
    if hero:GetPlayerOwnerID()~=self_hero:GetPlayerOwnerID() then
        -- 怪必须是自己击杀的
        return
    end
    if RollPercentage(50) then
        attack_add = attack_add + self_hero:GetLevel()
    end
    self:SetStackCount(attack_add)
    -- end
end

function modifier_siwan_zhili_lua:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount();
end