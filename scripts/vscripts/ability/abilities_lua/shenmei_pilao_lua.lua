
require("info/game_playerinfo")

LinkLuaModifier("modifier_shenmei_pilao_lua","ability/abilities_lua/shenmei_pilao_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

shenmei_pilao_lua = class({})

function shenmei_pilao_lua:GetIntrinsicModifierName()
	return "modifier_shenmei_pilao_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_shenmei_pilao_lua = class({})
--------------------------------------------------------------------------------

local attack_add = 0

function modifier_shenmei_pilao_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_shenmei_pilao_lua:IsHidden()
    return false
end

function modifier_shenmei_pilao_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_shenmei_pilao_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_shenmei_pilao_lua:OnCreated( kv )
    if IsServer() then
		ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_shenmei_pilao_lua,'killed_monster'),self)

		self.parent = self:GetParent()
        local item = nil
        local index = nil
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/zuus/the_return_of_the_king_of_gods_arms/the_return_of_the_king_of_gods_arms.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/zuus/the_return_of_the_king_of_gods_back/the_return_of_the_king_of_gods_back.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/zuus/the_return_of_the_king_of_gods_belt/the_return_of_the_king_of_gods_belt.vmdl"
        })
        item:FollowEntity(self.parent, true)
		
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/zuus/the_return_of_the_king_of_gods_head/the_return_of_the_king_of_gods_head_style1.vmdl"
        })
		item:FollowEntity(self.parent, true)
		
    end
end

function modifier_shenmei_pilao_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
	-- 技能所有者
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
	self:IncrementStackCount()
	if self:GetStackCount() >= 150 then
		self:SetStackCount(0)
		-- local my_mode = RandomInt(1, 6)
		local my_mode = 4
		if my_mode==1 then
			local add_str = self_hero:GetLevel()*5
            SetBaseStrength(self_hero, add_str)
		elseif my_mode==2 then
			local add_agi = self_hero:GetLevel()*5
            SetBaseAgility(self_hero, add_agi)
		elseif my_mode==3 then
			local add_int = self_hero:GetLevel()*5
            SetBaseIntellect(self_hero, add_int)
		elseif my_mode==4 then
			attack_add = self_hero:GetLevel()*20
		elseif my_mode==5 then
			local attrb = -self_hero:GetLevel()*1
            SetBaseStrength(self_hero, attrb)
            SetBaseAgility(self_hero, attrb)
            SetBaseIntellect(self_hero, attrb)
		elseif my_mode==6 then
			game_playerinfo:change_player_wood(self_hero, 5)
		end
	end
    -- end
end

function modifier_shenmei_pilao_lua:GetModifierBaseAttack_BonusDamage()
	return attack_add;
end