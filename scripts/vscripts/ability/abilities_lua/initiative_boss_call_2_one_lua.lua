--挑战boss2技能1
initiative_boss_call_2_one_lua = class({})
LinkLuaModifier( "modifier_boss_call_2_one_prompt_lua","ability/abilities_lua/initiative_boss_call_2_one_lua", LUA_MODIFIER_MOTION_NONE )
function initiative_boss_call_2_one_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    self:GetCaster():EmitSound("hero.attack.npc_dota_hero_alchemist")
	-- caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Ranged")
	caster:AddNewModifier(caster, self, "modifier_boss_call_2_one_prompt_lua", {duration = 2})
    local vPos = self:GetCursorPosition()
    --技能释放提示圈    
    self.prompt = CreateModifierThinker(
        caster,
        self,
        "modifier_boss_call_2_one_prompt_lua",
        {
            duration = 2,
        }, 
        vPos,
        caster:GetTeamNumber(),
        false
    )
    self.targetS = {}
	local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
    local endpos = caster:GetAbsOrigin() + direction * 450
	local axes = 9--self:GetSpecialValueFor("base_axes") + math.floor(caster:GetAgility() / self:GetSpecialValueFor("agility_per_axe"))
	local angles = 60--self:GetSpecialValueFor("spread_angle")
	local angle = angles / axes
	Timers:CreateTimer(2, function ()
		for i = 1, axes do
			local pos = RotatePosition(caster:GetAbsOrigin(), QAngle(0, (i-5) * angle, 0), endpos)
			local info = 
			{
				Ability = self,
				EffectName = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf",
				vSpawnOrigin = caster:GetAbsOrigin(),
				fDistance = 450,--self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
				fStartRadius = 100,--self:GetSpecialValueFor("radius"),
				fEndRadius = 100,--self:GetSpecialValueFor("radius"),
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = false,
				vVelocity = (pos - caster:GetAbsOrigin()):Normalized() * 1000,--(pos - caster:GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed")
				bProvidesVision = false,
				-- ExtraData = {thinker = thinker}
			}
			ProjectileManager:CreateLinearProjectile(info)
		end
	end)
end
function initiative_boss_call_2_one_lua:OnProjectileHit_ExtraData(target, location, keys)
    if target and not IsInTable(target, self.targetS) then
		ApplyDamage({
            attacker = self:GetCaster(), 
            victim = target, 
            damage = 3000,--
            damage_type = self:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE, 
            ability = self})
    end
    self.targetS[#self.targetS + 1] = target
end

modifier_boss_call_2_one_prompt_lua = class({})

function modifier_boss_call_2_one_prompt_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    local infor = {
        EffectName = "particles/diy_particles/sector.vpcf",
        Ability = self,
        vSpawnOrigin =  self:GetCaster():GetAbsOrigin(), --caster:GetOrigin()
        fStartRadius = 100,
        fEndRadius = 100,
        vVelocity = (self:GetAbility():GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
        fDistance = 450,
        Source = self:GetCaster(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    }
    ProjectileManager:CreateLinearProjectile( infor )
end

function modifier_boss_call_2_one_prompt_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
        ParticleManager:ReleaseParticleIndex(self.nFXIndex)
    end
end