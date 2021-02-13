LinkLuaModifier( "modifier_haigu_lingyu_time_lua","ability/abilities_lua/innateskill_haigu_lingyu_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_haigu_lingyu_lua","ability/abilities_lua/innateskill_haigu_lingyu_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aure_call_death_lua","ability/abilities_lua/innateskill_haigu_lingyu_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_big_jump_lua","ability/abilities_lua/innateskill_haigu_lingyu_lua", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

haigu_lingyu_lua = class({})

-- function haigu_lingyu_lua:GetAOERadius()
-- 	return 1100
-- end

--------------------------------------------------------------------------------

function haigu_lingyu_lua:OnSpellStart()
	self.time = self:GetSpecialValueFor( "time" )
	self.radius = self:GetSpecialValueFor( "radius" )
    self.target_position = self:GetCursorPosition()
	local kv = {duration = self.time, x = self.target_position.x, y = self.target_position.y, z = self.target_position.z, radius = self.radius}
	CreateModifierThinker( self:GetCaster(), self, "modifier_haigu_lingyu_lua", kv, self.target_position, self:GetCaster():GetTeamNumber(), false )

    local self_modifier = self:GetCaster():FindModifierByName("modifier_haigu_lingyu_time_lua")
    if self_modifier then
        self_modifier:StartIntervalThink(self.time-0.5)
    end
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster, self, "modifier_big_jump_lua", {time = self.time-0.5, x = self:GetCursorPosition().x, y = self:GetCursorPosition().y, z = self:GetCursorPosition().z})
end

function haigu_lingyu_lua:GetIntrinsicModifierName()
	return "modifier_haigu_lingyu_time_lua"
end

modifier_haigu_lingyu_time_lua = class({})
--------------------------------------------------------------------------------

function modifier_haigu_lingyu_time_lua:DeclareFunctions()
    local funcs = {
		
    }
    return funcs
end

function modifier_haigu_lingyu_time_lua:IsHidden()
    return true
end

function modifier_haigu_lingyu_time_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    local caster = self:GetParent()
    local wearTable = {
        "models/items/wraith_king/blistering_shade/mesh/blistering_shade.vmdl",
        "models/items/wraith_king/wk_ti8_weapon/wk_ti8_weapon.vmdl",
        "models/items/wraith_king/the_scourge_of_winter_shoulder/the_scourge_of_winter_shoulder.vmdl",
        "models/items/wraith_king/the_scourge_of_winter_head/the_scourge_of_winter_head.vmdl",
        "models/items/wraith_king/the_scourge_of_winter_back/the_scourge_of_winter_back.vmdl",
        "models/items/wraith_king/the_scourge_of_winter_armor/the_scourge_of_winter_armor.vmdl",
    }
    WearForHero(wearTable,caster)
    caster.wear_table[2]:SetSkin(1)
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/wraith_king/wraith_king_ti8/wk_ti8_sword_crimson_ambient.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[2] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_blade", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 4, caster.wear_table[2], PATTACH_ABSORIGIN	, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 10, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 11, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_eye_a", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 12, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_eye_b", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 13, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_eye_c", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 14, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_eye_d", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 15, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_skull_a", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 16, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_skull_b", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 20, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 21, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_gem", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 22, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_gem_b", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 30, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_ray_a", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 31, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_ray_b", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 32, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_ray_c", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 33, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_ray_d", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 34, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_ray_e", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 35, caster.wear_table[2], PATTACH_POINT_FOLLOW	, "attach_ray_f", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf", PATTACH_POINT_FOLLOW	,  caster );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 16, caster, PATTACH_ABSORIGIN_FOLLOW, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    
    nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf", PATTACH_POINT_FOLLOW	,  caster );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW	, "attach_weapon", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    
    
	-- self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("time") - 0.5)
end

function modifier_haigu_lingyu_time_lua:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_big_jump_lua", {x = self:GetAbility().target_position.x, y = self:GetAbility().target_position.y, z = self:GetAbility().target_position.z})
    self:StartIntervalThink(-1)
end
-- function haigu_lingyu_lua:GetIntrinsicModifierName()
-- 	return "modifier_haigu_lingyu_lua"
-- end
--------------------------------------------------------------------------------

if modifier_haigu_lingyu_lua == nil then
	modifier_haigu_lingyu_lua = class({})
end


function modifier_haigu_lingyu_lua:IsHidden()
    return true
end

function modifier_haigu_lingyu_lua:IsAura()
    return true
end

function modifier_haigu_lingyu_lua:IsAuraActiveOnDeath()
    return true
end

function modifier_haigu_lingyu_lua:GetAuraRadius()
    return 1100
end

function modifier_haigu_lingyu_lua:GetModifierAura()
    return "modifier_aure_call_death_lua"
end

function modifier_haigu_lingyu_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_haigu_lingyu_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_haigu_lingyu_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_haigu_lingyu_lua:OnCreated( kv )
    if not IsServer() then
        return
	end

	-- 创建一个目标点的特效
	self.index = ParticleManager:CreateParticle(
                "particles/diy_particles/head_ring.vpcf",
                PATTACH_WORLDORIGIN,
                nil
            )
	local target_position = Vector(kv.x, kv.y, kv.z)
	-- print(" >>>>>>>>>>>> createindex: "..self.index)
	-- print(" >>>>>>>>>>>> y: "..kv.y)
	-- print(" >>>>>>>>>>>> z: "..kv.z)
	ParticleManager:SetParticleControl(self.index, 0, target_position)
	ParticleManager:SetParticleControl(self.index, 1, Vector(kv.radius-300, 0, 0))
	ParticleManager:SetParticleControl(self.index, 2, target_position)
	-- EmitSoundOn("storegga.slam.up", self.caster)
end

function modifier_haigu_lingyu_lua:OnDestroy()
	if not IsServer() then
        return
	end
	-- print(" >>>>>>>>>>>> destoryindex: "..self.index)
	ParticleManager:DestroyParticle(self.index, true)
	ParticleManager:ReleaseParticleIndex(self.index)
end

modifier_aure_call_death_lua = class({})
--------------------------------------------------------------------------------

function modifier_aure_call_death_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end


function modifier_aure_call_death_lua:OnCreated( kv )
    if not IsServer( ) then
        return
	end
	self.caster = self:GetCaster()
end

function modifier_aure_call_death_lua:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() then
		local playerID = self.caster:GetPlayerID()
		-- print(" >>>>>>>>>>>> playerID: "..playerID)
		if RollPercentage(20) then
			local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
			if RollPercentage(50) then
				hero:SetBaseStrength(hero:GetBaseStrength()+2)
			else
				hero:SetBaseIntellect(hero:GetBaseIntellect()+2)
			end
		end
	end
end


----------------------------------------------------------------------
modifier_big_jump_lua = class({})

function modifier_big_jump_lua:IsHidden()
    return true
end

function modifier_big_jump_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.scale = self:GetAbility():GetSpecialValueFor("scale")

    self.start_positon = self:GetParent():GetAbsOrigin()
    self.target_position = Vector(kv.x, kv.y, kv.z)
    self.distance = (self.target_position - self.start_positon):Length2D()
    self.speed = 5000
    self.duration = self.distance / self.speed
    self.direction = (self.target_position - self.start_positon):Normalized()
    self.height = 5000
    -- self.flag = true
    self.damage_total = (self:GetParent():GetStrength()+self:GetParent():GetIntellect()) * self.scale

    self:ApplyHorizontalMotionController()
    self:ApplyVerticalMotionController()

    self:GetParent():EmitSound("tornado.fly")
end

function modifier_big_jump_lua:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
    self:GetParent():RemoveVerticalMotionController(self)
end

function modifier_big_jump_lua:UpdateHorizontalMotion(me, dt)
    if not IsServer() then
        return
    end
    local position = me:GetAbsOrigin()
    local distance = self.speed * dt
    if distance > self.distance then
        distance = self.distance
    end
    position = position + self.direction * distance
    me:SetAbsOrigin(position)
end

function modifier_big_jump_lua:UpdateVerticalMotion(me, dt)
    if not IsServer() then
        return
    end

    local position = me:GetAbsOrigin()
    local distance = (position - self.start_positon):Length2D()
    position.z = - 4 * self.height / (self.distance * self.distance) * (distance * distance) + 4 * self.height / self.distance * distance

    local ground_height = GetGroundHeight( position, self:GetParent() )
    local landed = false

    if ( position.z < ground_height and distance > self.distance / 2 ) then
        position.z = ground_height
        landed   = true
    end

    me:SetAbsOrigin(position)

    -- if self.flag and position.z > self.distance - 100 then
    --     me:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_active_big_jump_bianshen_lua", {duration = 20})
    --     self.flag = false
    -- end

    if landed == true then
        local units = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            me:GetAbsOrigin(), 
            nil, 
            500, 
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false
        )

        for _, unit in pairs(units) do
            ApplyDamage({
                victim = unit,
                attacker = self:GetAbility():GetCaster(),
                damage = self.damage_total,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility()
            })
        end

        local particle = ParticleManager:CreateParticle(
            "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_physical.vpcf", 
            PATTACH_WORLDORIGIN,
            self:GetParent()
        )
        ParticleManager:SetParticleControl(particle, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        me:EmitSound("tornado.drop")

        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():RemoveModifierByName("modifier_big_jump_lua")
    end
end