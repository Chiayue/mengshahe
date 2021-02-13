
LinkLuaModifier( "modifier_hit_jump_lua","ability/abilities_lua/initiative_hit_jump_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier("modifier_stun_lua", "ability/abilities_lua/modifier/modifier_stun_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_blade_dance_lua","ability/abilities_lua/initiative_hit_jump_lua", LUA_MODIFIER_MOTION_NONE)
--重击跳斩
initiative_hit_jump_lua = class({})
initiative_hit_jump_lua_d = initiative_hit_jump_lua
initiative_hit_jump_lua_c = initiative_hit_jump_lua
initiative_hit_jump_lua_b = initiative_hit_jump_lua
initiative_hit_jump_lua_a = initiative_hit_jump_lua
initiative_hit_jump_lua_s = initiative_hit_jump_lua

function initiative_hit_jump_lua:OnSpellStart()
    local caster = self:GetCaster()
	local ability = self
	local ability_level = 1	
	-- 清除所有当前命令并断开投射物
	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)
	-- 技能变量
	ability.leap_direction = caster:GetForwardVector()
	ability.leap_distance = ability:GetLevelSpecialValueFor("leap_distance", ability_level)
	ability.leap_speed = ability:GetLevelSpecialValueFor("leap_speed", ability_level) * 1/30
	ability.leap_traveled = 0
    ability.leap_z = 0
    caster:AddNewModifier(caster, self, "modifier_hit_jump_lua", {})
    caster:EmitSound("hero.attack.npc_dota_hero_shadowshaman")


end
----------------------------------------------------------------------
modifier_hit_jump_lua = class({})

function modifier_hit_jump_lua:IsHidden()
    return true
end

function modifier_hit_jump_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:ApplyHorizontalMotionController()
    self:ApplyVerticalMotionController()
end

function modifier_hit_jump_lua:OnDestroy()
    if not IsServer() then
        return
    end

    self:GetParent():RemoveHorizontalMotionController(self)
    self:GetParent():RemoveVerticalMotionController(self)

end

function modifier_hit_jump_lua:UpdateHorizontalMotion(me, dt)
    if not IsServer() then
        return
    end
    local caster = me
	local ability = self:GetAbility()

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else
        caster:InterruptMotionControllers(true)
        local FXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( FXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( FXIndex )  
        local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )   
        self.enemys = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetOrigin(),
            self,
            400,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES ,
            1,
            false
        )
        if(#self.enemys > 0 and self.enemys ~= nil) then
            for a,enemy in pairs(self.enemys) do
                if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                    local damageTable = {
                        victim  =  enemy,--
                        attacker = caster,
                        damage = ability:GetSpecialValueFor("base_damage")+caster:GetStrength()*ability:GetSpecialValueFor("str_scale"),
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        ability = ability,
                    }
                    ApplyDamage(damageTable)
                    --添加修饰器
                    enemy:AddNewModifier(caster, ability, "modifier_stun_lua", {duration = 1})
                end
            end
        end
        self:GetParent():RemoveModifierByName("modifier_hit_jump_lua")
        me:AddNewModifier(caster, ability, "modifier_blade_dance_lua", {duration = 5})
	end
end

function modifier_hit_jump_lua:UpdateVerticalMotion(me, dt)
    if not IsServer() then
        return
    end
    local caster = me
	local ability = self:GetAbility()

	-- 在前半段距离内，单位向上，下半段则下降
	if ability.leap_traveled < ability.leap_distance/2 then
		-- 向上
		ability.leap_z = ability.leap_z + ability.leap_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	else
		-- 向下
		ability.leap_z = ability.leap_z - ability.leap_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
    end
    

 
end
--修饰器
modifier_blade_dance_lua = class({})

function modifier_blade_dance_lua:IsHidden()
    return true
end
function modifier_blade_dance_lua:OnCreated()
    local caster = self:GetParent()
    local scale = self:GetAbility():GetSpecialValueFor("int_scale")
    self.damage = self:GetAbility():GetSpecialValueFor("base_damage")+caster:GetIntellect()*scale
    if not IsServer() then
        return
    end
    --设置计时器
    self:StartIntervalThink(0.33)
    --启动计时器
    self:OnIntervalThink()
end
--伤害
function modifier_blade_dance_lua:OnIntervalThink()
    local caster = self:GetParent()
    self.enemys = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetOrigin(),
        self:GetAbility(),
        400,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES ,
        1,
        false
    )   
    if(#self.enemys > 0 and self.enemys ~= nil) then
        for a,enemy in pairs(self.enemys) do
                if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                    local damageTable = {
                        victim  =  enemy,
                        attacker = self:GetAbility():GetCaster(),
                        damage = self.damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility(),
                    }
                    ApplyDamage(damageTable)
                end
        end
   end
end

--加特效
function modifier_blade_dance_lua:GetEffectName()
    -- return "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf"
    return "particles/diy_particles/storm.vpcf"
end
function modifier_blade_dance_lua:StatusEffectPriority() return 5 end
