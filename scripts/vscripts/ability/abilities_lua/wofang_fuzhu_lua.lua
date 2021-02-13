
require("info/game_playerinfo")
require("global/utils_popups")

LinkLuaModifier("modifier_wofang_fuzhu_lua","ability/abilities_lua/wofang_fuzhu_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

wofang_fuzhu_lua = class({})

function wofang_fuzhu_lua:GetIntrinsicModifierName()
	return "modifier_wofang_fuzhu_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_wofang_fuzhu_lua = class({})

--------------------------------------------------------------------------------

function modifier_wofang_fuzhu_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_wofang_fuzhu_lua:IsHidden()
    return true
end

function modifier_wofang_fuzhu_lua:OnCreated( kv )
    if not IsServer() then
        return
    end
    self.listenid = ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_wofang_fuzhu_lua,'killed_monster'),self)
end

function modifier_wofang_fuzhu_lua:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)
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
    local monster_owner_id = tonumber(monster.player_id)
    -- print(">>>>>>>>>>> monster_owner: "..monster_owner_id)

    -- 击杀的不是自己的怪物
    if self_hero:GetPlayerOwnerID() ~= monster_owner_id then
        game_playerinfo:set_player_gold(hero:GetPlayerOwnerID(),30)
        utils_popups:ShowGoldGain(hero, 200)
        local pindex = ParticleManager:CreateParticle( "particles/econ/courier/courier_flopjaw_gold/flopjaw_death_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:ReleaseParticleIndex(pindex)
    end
end

function modifier_wofang_fuzhu_lua:GetModifierBaseAttack_BonusDamage()
	return 1000;
end

function modifier_wofang_fuzhu_lua:OnDestroy()
    if IsServer() then
	    StopListeningToGameEvent(self.listenid)
    end
end

