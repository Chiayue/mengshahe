shenmi_zhili_lua = class({})
LinkLuaModifier("modifier_shenmi_zhili_lua","ability/abilities_lua/shenmi_zhili_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shenmi_zhili_lua_buff_lua","ability/abilities_lua/shenmi_zhili_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function shenmi_zhili_lua:GetIntrinsicModifierName()
	return "modifier_shenmi_zhili_lua"
end

modifier_shenmi_zhili_lua = class({})
function modifier_shenmi_zhili_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        
    }
    return funcs
end

function modifier_shenmi_zhili_lua:IsHidden()
    return true
end
function modifier_shenmi_zhili_lua:OnCreated( kv )
    if IsServer() then
        
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/storm_spirit/qilin_sorcerer_armor/qilin_sorcerer_armor.vmdl",
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/storm_spirit/qilin_sorcerer_arms/qilin_sorcerer_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/storm_spirit/qilin_sorcerer_head/qilin_sorcerer_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/storm_spirit_ambient_eyes.vpcf", PATTACH_POINT_FOLLOW, item)
        -- ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_eye_l", item:GetOrigin(), true)
        -- ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_eye_r", item:GetOrigin(), true)
        
    end
end

function modifier_shenmi_zhili_lua:OnAttackLanded(params)
    if not IsServer( ) then
        return
    end
    local attacker = params.attacker
    if attacker == self:GetParent() then
        -- 判断攻击方是否是自己
        if not RollPercentage(10) then
            return
        end
        -- local hTarget = params.target
        -- local kv = {}
        attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_shenmi_zhili_lua_buff_lua", { duration = 5.0 })
        -- CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_shenmi_zhili_lua_buff_lua", kv, hTarget:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
    end
end

modifier_shenmi_zhili_lua_buff_lua = class({})
--------------------------------------------------------------------------------
function modifier_shenmi_zhili_lua_buff_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_shenmi_zhili_lua_buff_lua:OnCreated( kv )
	
end

function modifier_shenmi_zhili_lua_buff_lua:GetModifierDamageOutgoing_Percentage()
	return 500
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
