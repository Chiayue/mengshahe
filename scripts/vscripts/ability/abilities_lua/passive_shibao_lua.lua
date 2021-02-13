LinkLuaModifier( "modifier_passive_shibao_lua", "ability/abilities_lua/passive_shibao_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if passive_shibao_lua_c == nil then
	passive_shibao_lua_c = class({})
end

function passive_shibao_lua_c:GetIntrinsicModifierName()
 	return "modifier_passive_shibao_lua"
end
if passive_shibao_lua_b == nil then
	passive_shibao_lua_b = class({})
end

function passive_shibao_lua_b:GetIntrinsicModifierName()
 	return "modifier_passive_shibao_lua"
end
if passive_shibao_lua_a == nil then
	passive_shibao_lua_a = class({})
end

function passive_shibao_lua_a:GetIntrinsicModifierName()
 	return "modifier_passive_shibao_lua"
end
--------------------------------------------------
if modifier_passive_shibao_lua == nil then
	modifier_passive_shibao_lua = class({})
end

function modifier_passive_shibao_lua:IsHidden()
    return true
end

function modifier_passive_shibao_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_passive_shibao_lua:OnDeath(params)
    if not IsServer( ) then
        return
    end
    -- DeepPrintTable(params)
    
    local attacker = params.attacker
    local hero = self:GetParent()
    local Caster = self:GetCaster()
    if attacker ~= Caster then
        return
    end
    -- print(">>>>>>>>>  tongigeren!!")
    local vec = self:GetParent():GetOrigin()		--获取施法者的位置，及三围坐标
    local aoe = self:GetAbility():GetSpecialValueFor( "aoe" )
    if params.unit:GetTeam() ~= hero:GetTeam() then
        -- 敌人死亡
        local hTarget = params.unit
        
        local abil_damage = Caster:GetIntellect() * self:GetAbility():GetSpecialValueFor( "coefficient" ) + self:GetAbility():GetSpecialValueFor( "basedamage" )
        -- local str = Caster:GetStrength()
        local enemies = FindUnitsInRadius(
            Caster:GetTeamNumber(), 
            hTarget:GetOrigin(), 
            hTarget, 
            aoe, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            0, 0, false 
        )

        local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_WORLDORIGIN, hTarget, hTarget:GetTeamNumber() )
        ParticleManager:SetParticleControl( nFXIndex, 0, vec )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( aoe, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        for _,enemy in pairs(enemies) do
            if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
                local damage = {
                    victim = enemy,
                    attacker = Caster,
                    damage = abil_damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                }
                ApplyDamage( damage )
            end
        end
    end
end
-----------------------------
