require("info/game_playerinfo")

--------------------------------------------------------------------------------
--------------------------------升华技能----------------------------------------
sublime_one_pound_man_lua = class({})

--------------------------------------------------------------------------------
LinkLuaModifier("modifier_sublime_one_pound_man_lua","ability/abilities_lua/innateskill_one_pound_man_lua",LUA_MODIFIER_MOTION_NONE )

function sublime_one_pound_man_lua:GetIntrinsicModifierName()
	return "modifier_sublime_one_pound_man_lua"
end

function sublime_one_pound_man_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self.point = self:GetSpecialValueFor("point")
    self.distance = self:GetSpecialValueFor("distance")
    local self_modifier = self:GetCaster():FindModifierByName("modifier_sublime_one_pound_man_lua")
    
    if self_modifier:GetStackCount() < self.point then
        send_error_tip(self:GetCaster():GetPlayerID(), "error_Nopoint")
        return
    end

    local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/diy_particles/bolt.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = 300,
		fEndRadius = 300,
		vVelocity = vDirection * 1200,
		fDistance = self.distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

    self.projectileID = ProjectileManager:CreateLinearProjectile( info )
    
    self_modifier:SetStackCount(0)
end

function sublime_one_pound_man_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		-- local att_value = self:GetCaster():GetIntellect();
        
        -- hTarget:Kill(nil, self:GetCaster())
        if not ContainUnitTypeFlag(hTarget, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_FINALLY) then
            hTarget:Kill(nil, self:GetCaster())
        end
        
		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        
        -- ProjectileManager:DestroyLinearProjectile(self.projectileID)
	end

	return false
end

modifier_sublime_one_pound_man_lua = class({})
--------------------------------------------------------------------------------

function modifier_sublime_one_pound_man_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

-- function modifier_sublime_one_pound_man_lua:IsHidden()
--     return true
-- end

function modifier_sublime_one_pound_man_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
end

function modifier_sublime_one_pound_man_lua:OnDestroy()
    if not IsServer( ) then
        return
    end
    ProjectileManager:DestroyLinearProjectile(self.GetAbility().projectileID)
end

function modifier_sublime_one_pound_man_lua:OnAttackLanded(params)
    -- DeepPrintTable(params)
    if params.attacker ~= self:GetParent() then
		return 0
	end
    local target = params.target
    if not ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_FINALLY) then
        target:Kill(nil, params.attacker)
    end
    
    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("point") then
        self:IncrementStackCount()
    end
end