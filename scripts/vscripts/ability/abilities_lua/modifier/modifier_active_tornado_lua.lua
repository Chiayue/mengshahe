modifier_active_tornado_lua = class({})

function modifier_active_tornado_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
	self.ability = self:GetAbility()
    self.cursor_position = self.ability:GetCursorPosition()
    local nFXIndex = ParticleManager:CreateParticle(
        "particles/neutral_fx/tornado_ambient.vpcf", 
        PATTACH_CUSTOMORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(nFXIndex, 0, self.ability:GetCursorPosition())
    self:AddParticle(nFXIndex, false, false, 15, false, false)
    self:StartIntervalThink(0.5)
end

function modifier_active_tornado_lua: OnIntervalThink()
	local unit_table = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		self.cursor_position,
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	for _, unit in pairs(unit_table) do
		local position = self:GetTargetPosition(unit:GetAbsOrigin())
		CreateModifierThinker(
			self.ability:GetCaster(),
			self.ability,
			"modifier_active_tornado_drop_point_lua",
			{
				duration = 10,
				position_x = position.x,
				position_y = position.y,
				position_z = position.z,
			},
			position,
			self.ability:GetCaster():GetTeamNumber(),
			false
		)
		unit:AddNewModifier(self.ability:GetCaster(), self.ability, "modifier_active_tornado_fly_lua", 
		{
			position_x = position.x,
			position_y = position.y,
			position_z = position.z,
		})
	end
end

function modifier_active_tornado_lua:GetTargetPosition(position)
    while true do
        local random_x = RandomInt(-4200, 1800)
        local random_y = RandomInt(-4000, 2000)
        local target_position = Vector(random_x, random_y, 0)
        if GridNav:CanFindPath(position, target_position) and position ~= target_position then
            return target_position
        end
    end
end