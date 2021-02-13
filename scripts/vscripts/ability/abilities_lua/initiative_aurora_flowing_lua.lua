--极光流彩
initiative_aurora_flowing_lua = class({})
initiative_aurora_flowing_lua_d = initiative_aurora_flowing_lua
initiative_aurora_flowing_lua_c = initiative_aurora_flowing_lua
initiative_aurora_flowing_lua_b = initiative_aurora_flowing_lua
initiative_aurora_flowing_lua_a = initiative_aurora_flowing_lua
initiative_aurora_flowing_lua_s = initiative_aurora_flowing_lua


LinkLuaModifier( "modifier_aurora_flowing_lua","ability/abilities_lua/initiative_aurora_flowing_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aurora_flowing_slow_lua","ability/abilities_lua/initiative_aurora_flowing_lua", LUA_MODIFIER_MOTION_NONE )
function initiative_aurora_flowing_lua:GetAOERadius()
	return 400
end
function initiative_aurora_flowing_lua:OnSpellStart()
	EmitSoundOn( "bh", self:GetCaster() )
    CreateModifierThinker(
		self:GetCaster(), 
		self, 
		"modifier_aurora_flowing_lua", 
		{
			duration = 5
		}, 
		self:GetCursorPosition(), 
		self:GetCaster():GetTeamNumber(), 
		false
	)
end


modifier_aurora_flowing_lua = class({})

function modifier_aurora_flowing_lua:OnCreated(kv)
	self.ability = self:GetAbility()
    self.caster = self.ability:GetCaster()
    local scale = self:GetAbility():GetSpecialValueFor("int_scale")
    self.damage = self:GetAbility():GetSpecialValueFor("base_damage")+self.caster:GetIntellect()*scale
	self.caster = self:GetAbility():GetCaster()
	self.strength = self.caster:GetIntellect()
	if IsServer() then
		local cursor_position = self:GetAbility():GetCursorPosition()
		self.cursor_pos = cursor_position
		for i = 1, 5 do
			for j = 1, 5 do
				local position = cursor_position + RandomVector(i * 100)
                local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death_skybeam.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, nil, PATTACH_WORLDORIGIN, "",position, true)
                ParticleManager:SetParticleControl(nFXIndex, 1, position)
			end
		end
		self:StartIntervalThink(1)
	end
end

function modifier_aurora_flowing_lua: OnIntervalThink()
	local unit_table = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		self.cursor_pos,
		nil,
		400,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
    for key, value in pairs(unit_table) do
        local nFXIndex

        local random = RandomInt(1, 100)
        if random >= 1 and random <= 50 then
            nFXIndex = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout_ribbon_b.vpcf", PATTACH_OVERHEAD_FOLLOW, value)
            ParticleManager:SetParticleControl(nFXIndex, 0, value:GetOrigin())
        end
        if random >= 51 and random <= 100 then
            nFXIndex= ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_flash_hit_ribbon_c.vpcf", PATTACH_OVERHEAD_FOLLOW, value)

            ParticleManager:SetParticleControl(nFXIndex, 0, value:GetOrigin())
        end
		local damage = {
			victim = value,
			attacker = self.caster,
			damage =  self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage(damage)
		value:AddNewModifier(self.caster, self:GetAbility(), "modifier_aurora_flowing_slow_lua", {duration = 5})

	end
end

modifier_aurora_flowing_slow_lua = class({})

--------------------------------------------------------------------------------

function modifier_aurora_flowing_slow_lua:IsDebuff() return true end
function modifier_aurora_flowing_slow_lua:IsPurgable() return true end
function modifier_aurora_flowing_slow_lua:IsPurgeException() return true end
function modifier_aurora_flowing_slow_lua:IsHidden() return true end

function modifier_aurora_flowing_slow_lua:GetEffectName()
	return "particles/econ/courier/courier_nian/courier_nian_ribbon_rays.vpcf"
end


function modifier_aurora_flowing_slow_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_aurora_flowing_slow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_aurora_flowing_slow_lua:GetModifierMoveSpeedBonus_Percentage() return -50 end