xinsheng_qiangzhuang_lua = class({})
LinkLuaModifier("modifier_xinsheng_qiangzhuang_lua","ability/abilities_lua/xinsheng_qiangzhuang_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_xinsheng_qiangzhuang_buff_lua","ability/abilities_lua/modifier/modifier_xinsheng_qiangzhuang_buff_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function xinsheng_qiangzhuang_lua:GetIntrinsicModifierName()
	return "modifier_xinsheng_qiangzhuang_lua"
end

modifier_xinsheng_qiangzhuang_lua = class({})
function modifier_xinsheng_qiangzhuang_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_RESPAWN,
        
    }
    return funcs
end

function modifier_xinsheng_qiangzhuang_lua:IsHidden()
    return true
end
function modifier_xinsheng_qiangzhuang_lua:OnCreated( kv )
    if IsServer() then
        self.parent = self:GetParent()
        local item = nil
        local index = nil
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/huskar/ti9_cache_huskar_baptism_of_melting_fire_arms/ti9_cache_huskar_baptism_of_melting_fire_arms.vmdl",
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/huskar/ti9_cache_huskar_baptism_of_melting_fire_head/ti9_cache_huskar_baptism_of_melting_fire_head.vmdl",
        })
        item:FollowEntity(self.parent, true)
        index = ParticleManager:CreateParticle("particles/econ/items/huskar/ti9_cache_huskar_baptism_head/ti9_cache_huskar_baptism_head_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_eye_l", item:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 1, item, PATTACH_POINT_FOLLOW, "attach_eye_r", item:GetOrigin(), true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/huskar/ti9_cache_huskar_baptism_of_melting_fire_off_hand/ti9_cache_huskar_baptism_of_melting_fire_off_hand.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/huskar/ti9_cache_huskar_baptism_off_hand/ti9_cache_huskar_baptism_off_hand_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/huskar/ti9_cache_huskar_baptism_of_melting_fire_shoulder/ti9_cache_huskar_baptism_of_melting_fire_shoulder.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/huskar/ti9_cache_huskar_baptism_shoulder/ti9_cache_huskar_baptism_shoulder_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)

        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/huskar/ti9_cache_huskar_baptism_of_melting_fire_weapon/ti9_cache_huskar_baptism_of_melting_fire_weapon.vmdl",
        })
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/huskar/ti9_cache_huskar_baptism_weapon/ti9_cache_huskar_baptism_weapon_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        
    end
end

function modifier_xinsheng_qiangzhuang_lua:OnRespawn(params)
    if not IsServer( ) then
        return
    end
    if params.unit == self:GetParent() then
        -- 判断重生对象是否是自己
        -- local hTarget = params.target
        -- local kv = {}
        params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_xinsheng_qiangzhuang_buff_lua", { duration = 10.0 })
        -- CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_xinsheng_qiangzhuang_buff_lua", kv, hTarget:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
