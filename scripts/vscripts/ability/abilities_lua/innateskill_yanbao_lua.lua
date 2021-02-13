LinkLuaModifier( "modifier_yanbao_lua", "ability/abilities_lua/innateskill_yanbao_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if yanbao_lua == nil then
	yanbao_lua = class({})
end

function yanbao_lua:GetIntrinsicModifierName()
 	return "modifier_yanbao_lua"
end
--------------------------------------------------
if modifier_yanbao_lua == nil then
	modifier_yanbao_lua = class({})
end

function modifier_yanbao_lua:IsHidden()
    return true
end

function modifier_yanbao_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_yanbao_lua:OnCreated(table)
    if IsServer( ) then
        self.parent = self:GetParent() 
        local item = nil
        local index = nil
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/necrolyte/necronub_head/necronub_head.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/necrolyte/necronub_scythe/necronub_scythe.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/necrolyte/necronub_top/necronub_top.vmdl"
        })
        item:FollowEntity(self.parent, true)
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/necrolyte/necronub_coffin/necronub_coffin.vmdl"
        })
        item:FollowEntity(self.parent, true)
    
    end
end

function modifier_yanbao_lua:OnDeath(params)
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
        
        local abil_damage = Caster:GetAgility() * self:GetAbility():GetSpecialValueFor( "coefficient" )
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

LinkLuaModifier( "modifier_sublime_yanbao_lua", "ability/abilities_lua/innateskill_yanbao_lua.lua",LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------
--Abilities
if sublime_yanbao_lua == nil then
	sublime_yanbao_lua = class({})
end

function sublime_yanbao_lua:GetIntrinsicModifierName()
 	return "modifier_sublime_yanbao_lua"
end
--------------------------------------------------
if modifier_sublime_yanbao_lua == nil then
	modifier_sublime_yanbao_lua = class({})
end

function modifier_sublime_yanbao_lua:IsHidden()
    return true
end

function modifier_sublime_yanbao_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_ATTACK ,
	}
	return funcs
end

function modifier_sublime_yanbao_lua:OnDeath(params)
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
        
        local abil_damage = Caster:GetAgility() * self:GetAbility():GetSpecialValueFor( "coefficient" )
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