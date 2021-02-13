modifier_active_thunder_storm_lua = class({})

function modifier_active_thunder_storm_lua:OnCreated(kv)
	self.ability = self:GetAbility()
	self.caster = self.ability:GetCaster()
	self.scale = self:GetAbility():GetSpecialValueFor("scale")
	self.caster = self:GetAbility():GetCaster()
	self.strength = self.caster:GetIntellect()
	if IsServer() then
		local cursor_position = self:GetAbility():GetCursorPosition()
		self.cursor_pos = cursor_position
		for i = 1, 5 do
			for j = 1, 5 do
				local position = cursor_position + RandomVector(i * 100)
				local nFXIndex = ParticleManager:CreateParticle(
					"particles/units/heroes/hero_razor/razor_rain_storm.vpcf", 
					PATTACH_CUSTOMORIGIN, 
					nil
				)
				ParticleManager:SetParticleControl(nFXIndex, 0, position)
				self:AddParticle( nFXIndex, false, false, 15, false, false )
			end
		end
		self:StartIntervalThink(3)
	end
end

function modifier_active_thunder_storm_lua: OnIntervalThink()
	local unit_table = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		self.cursor_pos,
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	for key, value in pairs(unit_table) do
		local nFXIndex = ParticleManager:CreateParticle(
			"particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", 
			PATTACH_OVERHEAD_FOLLOW,
			value
		)
		self:AddParticle( nFXIndex, false, false, 10, false, false )
		local damage = {
			victim = value,
			attacker = self.caster,
			damage = 500 + self.strength * self.scale,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage(damage)
		value:AddNewModifier(self.caster, self.ability, "modifier_stun_lua", {duration = 1})
	end
end