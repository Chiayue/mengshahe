require("info/game_playerinfo")

cooldown_lua = class({})
LinkLuaModifier("modifier_cooldown_lua","ability/abilities_lua/cooldown_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function cooldown_lua:GetIntrinsicModifierName()
	return "modifier_cooldown_lua"
end

modifier_cooldown_lua = class({})
--------------------------------------------------------------------------------

function modifier_cooldown_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

function modifier_cooldown_lua:IsHidden()
    return true
end

function modifier_cooldown_lua:OnCreated( kv )
    if IsServer() then
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/tinker/mecha_hornet_back/mecha_hornet_back.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_mecha_hornet/tinker_mecha_hornet_back.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/tinker/mecha_hornet_head/mecha_hornet_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_mecha_hornet/tinker_mecha_hornet_head.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/tinker/mecha_hornet_off_hand/mecha_hornet_off_hand.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_mecha_hornet/tinker_mecha_hornet_offhand.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/tinker/mecha_hornet_shoulder/mecha_hornet_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_mecha_hornet/tinker_mecha_hornet_shoulder.vpcf", PATTACH_POINT_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/tinker/mecha_hornet_weapon/mecha_hornet_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_mecha_hornet/tinker_mecha_hornet_laser.vpcf", PATTACH_POINT_FOLLOW, item)

    end
end

local ability_list = {}

function modifier_cooldown_lua:OnAbilityExecuted(params)
    if not IsServer( ) then
        return
    end
    local name = params.ability:GetAbilityName()
    if string.find(name, "item_") then
        return
    end
    if params.unit == self:GetParent() then
        -- 判断技能是否本人释放
        
        table.insert(ability_list, params.ability)
        
        GameRules:GetGameModeEntity():SetThink("CoolDownThink", self, "CoolDownThink", 0.1);
    end
end

function modifier_cooldown_lua:CoolDownThink()
    for key, value in ipairs(ability_list) do
        value:EndCooldown()
    end
    if #ability_list > 0 then
        ability_list = {}
    end
    return nil
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


sublime_cooldown_lua = class({})
LinkLuaModifier("modifier_sublime_cooldown_lua","ability/abilities_lua/cooldown_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_mana_regen_buff_lua","ability/abilities_lua/cooldown_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sublime_cooldown_lua:GetIntrinsicModifierName()
	return "modifier_sublime_cooldown_lua"
end

modifier_sublime_cooldown_lua = class({})
--------------------------------------------------------------------------------

function modifier_sublime_cooldown_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

function modifier_sublime_cooldown_lua:IsHidden()
    return true
end

function modifier_sublime_cooldown_lua:OnCreated( kv )
	
end

local sublime_ability_list = {}

function modifier_sublime_cooldown_lua:OnAbilityExecuted(params)
    if not IsServer( ) then
        return
    end
    local name = params.ability:GetAbilityName()
    if string.find(name, "item_") then
        return
    end
    if params.unit == self:GetParent() then
        -- 判断技能是否本人释放
        
        table.insert(sublime_ability_list, params.ability)
        
        GameRules:GetGameModeEntity():SetThink("sublime_CoolDownThink", self, "sublime_CoolDownThink", 0.1);
    end
end

function modifier_sublime_cooldown_lua:sublime_CoolDownThink()
    for key, value in ipairs(sublime_ability_list) do
        value:EndCooldown()
    end
    if #sublime_ability_list > 0 then
        sublime_ability_list = {}
	end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mana_regen_buff_lua", {duration = 5})
    return nil
end

modifier_mana_regen_buff_lua = class({})
--------------------------------------------------------------------------------

function modifier_mana_regen_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_mana_regen_buff_lua:OnCreated( kv )
	
end

function modifier_mana_regen_buff_lua:OnAttackLanded( params )
	if params.attacker ~= self:GetParent() then
		return
	end
	self:GetParent():GiveMana((self:GetAbility():GetSpecialValueFor("mana") or 2))
	return
end