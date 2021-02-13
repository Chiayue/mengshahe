initiative_shadow_one_lua = class({})

LinkLuaModifier("modifier_initiative_shadow_one_lua_prompt_lua","ability/abilities_lua/initiative_shadow_one_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_shadow_one_lua_debuff_lua","ability/abilities_lua/initiative_shadow_one_lua",LUA_MODIFIER_MOTION_NONE)

function initiative_shadow_one_lua:OnSpellStart()
	if not IsServer() then
        return
	end
	local cPos = self:GetCaster():GetOrigin()
	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end
	
	local damage  = self:GetSpecialValueFor("damage")
	local debuff_damage  = self:GetSpecialValueFor("debuff_damage")
	local debuff_duration  = self:GetSpecialValueFor("debuff_duration")
	local width_initial = 100
	local width_end = 100
	local distance = math.sqrt((cPos.x-vPos.x)*(cPos.x-vPos.x)+(cPos.y-vPos.y)*(cPos.y-vPos.y))
	local speed = distance/1.9

--技能释放提示圈    
    self.prompt = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_shadow_one_lua_prompt_lua",
        {
            duration = 4,
		}, 
		vPos,
		self:GetCaster():GetTeamNumber(),
		false
    )
--释放投掷物
	local vDirection = vPos - self:GetCaster():GetOrigin()	
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()	
	local info = {
		EffectName = "particles/neutral_fx/satyr_hellcaller.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = width_initial,
		fEndRadius = width_end,
		vVelocity = vDirection * speed,
		fDistance = distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile( info )
	self:GetCaster():EmitSound("hero.attack.npc_dota_hero_nevermore")
--1.8秒延迟后给与伤害
	Timers:CreateTimer(1.8, function()
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), vPos, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)            
		local damage = {
			victim = nil,
			attacker = self:GetCaster(),
			damage = damage,	
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		for i=1,#enemies do
			enemies[i]:AddNewModifier(enemies[i], self, "modifier_initiative_shadow_one_lua_debuff_lua", { duration = debuff_duration , debuff_damage = debuff_damage })
			damage.victim = enemies[i]
			ApplyDamage( damage )
		end 
		ParticleManager:CreateParticle( "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.prompt)
		self:GetCaster():EmitSound("hero.attack.npc_dota_hero_zuus")
	end)
end

modifier_initiative_shadow_one_lua_prompt_lua = class({})

function modifier_initiative_shadow_one_lua_prompt_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.nFXIndex = ParticleManager:CreateParticle(
                "particles/diy_particles/playercolor.vpcf", 
                PATTACH_CUSTOMORIGIN, 
                nil
            )
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetAbility():GetCursorPosition())
	self:AddParticle(self.nFXIndex, false, false, 15, false, false)
end

function modifier_initiative_shadow_one_lua_prompt_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end

modifier_initiative_shadow_one_lua_debuff_lua = class({})

function modifier_initiative_shadow_one_lua_debuff_lua:IsDebuff()
	return true 
end
function modifier_initiative_shadow_one_lua_debuff_lua:IsHidden()
	return false
end
function modifier_initiative_shadow_one_lua_debuff_lua:IsPurgable()
	return true
end
function modifier_initiative_shadow_one_lua_debuff_lua:IsPurgeException()
	return true
end
function modifier_initiative_shadow_one_lua_debuff_lua:OnCreated(kv)
    if not IsServer() then
        return
	end
	self.debuff_damage = kv.debuff_damage
   	self:StartIntervalThink(1)
end

function modifier_initiative_shadow_one_lua_debuff_lua:OnIntervalThink() 
	local damagetable = {
        victim = self:GetParent(),
        attacker = self:GetAbility():GetCaster(),
        damage = self.debuff_damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(damagetable)
end