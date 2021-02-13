

----骷髅王技能1
initiative_skeleton_king_one_lua = class({})
-- LinkLuaModifier( "modifier_skeleton_king_one_effect_lua","ability/abilities_lua/initiative_skeleton_king_one_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_one_effect_lua","ability/abilities_lua/initiative_skeleton_king_one_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_one_prompt_lua","ability/abilities_lua/initiative_skeleton_king_one_lua", LUA_MODIFIER_MOTION_NONE )
function initiative_skeleton_king_one_lua:OnSpellStart()
    local caster = self:GetCaster()
    -- caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, 0.5)
    self:GetCaster():EmitSound("hero.attack.npc_dota_hero_alchemist")
    caster:AddNewModifier(caster, self, "modifier_skeleton_king_one_effect_lua", {duration = 2})
    local vPos = self:GetCursorPosition()
    --技能释放提示圈    
    self.prompt = CreateModifierThinker(
        caster,
        self,
        "modifier_skeleton_king_one_prompt_lua",
        {
            duration = 2,
        }, 
        vPos,
        caster:GetTeamNumber(),
        false
    )
    local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
    direction.z = 0
    local endpos = caster:GetAbsOrigin() + direction * 450
    local axes = 3--self:GetSpecialValueFor("base_axes") + math.floor(caster:GetAgility() / self:GetSpecialValueFor("agility_per_axe"))
    local angles = 60--self:GetSpecialValueFor("spread_angle")
    local angle = angles / axes
    Timers:CreateTimer(2, function ()
        for i = 1, axes do
            local pos = RotatePosition(caster:GetAbsOrigin(), QAngle(0, (i-2) * angle, 0), endpos)
            local info = 
            {
                Ability = self,
                EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_combo.vpcf",
                vSpawnOrigin = caster:GetAbsOrigin(),
                fDistance = 700,--self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
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
function initiative_skeleton_king_one_lua:OnProjectileHit_ExtraData(target, location, keys)
    if target and not target:IsMagicImmune() then
		ApplyDamage({
            attacker = self:GetCaster(), 
            victim = target, 
            damage = 4500,--13000
            damage_type = self:GetAbilityDamageType(), 
            damage_flags = DOTA_DAMAGE_FLAG_NONE, 
            ability = self})
	end
end
modifier_skeleton_king_one_prompt_lua = class({})

function modifier_skeleton_king_one_prompt_lua:OnCreated(kv)
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

function modifier_skeleton_king_one_prompt_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
        ParticleManager:ReleaseParticleIndex(self.nFXIndex)
    end
end


modifier_skeleton_king_one_effect_lua = class({})

function modifier_skeleton_king_one_effect_lua:IsHidden()
    return true
end

function modifier_skeleton_king_one_effect_lua:IsStunDebuff()
        return true
end

function modifier_skeleton_king_one_effect_lua:CheckState()
        local state = {
            [MODIFIER_STATE_STUNNED] = true,
        }
        return state
end

function modifier_skeleton_king_one_effect_lua:DeclareFunctions()
        local funcs = {
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION,--替换动画声明事件
        }
        return funcs
end

--替换动画
function modifier_skeleton_king_one_effect_lua:GetOverrideAnimation(params)
        return ACT_DOTA_DISABLED
end

-- if modifier_skeleton_king_one_effect_lua == nil then
-- 	modifier_skeleton_king_one_effect_lua = class({})
-- end


-- function modifier_skeleton_king_one_effect_lua:IsHidden()
--     return false
-- end

-- function modifier_skeleton_king_one_effect_lua:IsPurgable()
--     return false -- 无法驱散
-- end
 
-- function modifier_skeleton_king_one_effect_lua:RemoveOnDeath()
--     return false -- 死亡不移除
-- end

-- function modifier_skeleton_king_one_effect_lua:GetEffectName()
-- 	return "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff_b.vpcf"
-- end
-- function modifier_skeleton_king_one_effect_lua:StatusEffectPriority()
-- 	return 15
-- end
-- function modifier_skeleton_king_one_effect_lua:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

