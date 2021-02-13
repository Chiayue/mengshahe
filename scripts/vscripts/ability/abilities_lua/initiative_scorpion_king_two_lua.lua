
LinkLuaModifier( "modifier_scorpion_king_jump_lua","ability/abilities_lua/initiative_scorpion_king_two_lua.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_stun_lua", "ability/abilities_lua/modifier/modifier_stun_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scorpion_king_attackspeed_lua", "ability/abilities_lua/initiative_scorpion_king_two_lua.lua", LUA_MODIFIER_MOTION_NONE)
--蝎子王技能2
initiative_scorpion_king_two_lua = class({})

function initiative_scorpion_king_two_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local ability_level = 1	

	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)

    ability.leap_direction = caster:GetForwardVector()
	ability.leap_distance = ability:GetLevelSpecialValueFor("leap_distance", ability_level)
	ability.leap_speed = ability:GetLevelSpecialValueFor("leap_speed", ability_level) * 1/30
	ability.leap_traveled = 0
    ability.leap_z = 0
    caster:AddNewModifier(caster, self, "modifier_scorpion_king_jump_lua", {})
end

----------------------------------------------------------------------
modifier_scorpion_king_jump_lua = class({})

function modifier_scorpion_king_jump_lua:IsHidden()
    return true
end

function modifier_scorpion_king_jump_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:ApplyHorizontalMotionController()
    self:ApplyVerticalMotionController()
end

function modifier_scorpion_king_jump_lua:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
    self:GetParent():RemoveVerticalMotionController(self)

end

function modifier_scorpion_king_jump_lua:UpdateHorizontalMotion(me, dt)
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
        local nFXIndex = ParticleManager:CreateParticleForTeam("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_shockwave.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() +Vector( 0, 0, 200 ))
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
                    --添加修饰器
                    enemy:AddNewModifier(caster, ability, "modifier_stun_lua", {duration = 3})
                    
                end
            end
        end
        self:GetParent():AddNewModifier(caster, ability, "modifier_scorpion_king_attackspeed_lua", {duration = 3})
        self:GetParent():RemoveModifierByName("modifier_scorpion_king_jump_lua")
        -- me:AddNewModifier(caster, ability, "modifier_blade_dance_lua", {duration = 5})
	end
end

function modifier_scorpion_king_jump_lua:UpdateVerticalMotion(me, dt)
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

if modifier_scorpion_king_attackspeed_lua == nil then
    modifier_scorpion_king_attackspeed_lua = ({})
end
function modifier_scorpion_king_attackspeed_lua:IsHidden()
    return false
end

function modifier_scorpion_king_attackspeed_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_scorpion_king_attackspeed_lua:GetModifierAttackSpeedBonus_Constant()
    return 50
end