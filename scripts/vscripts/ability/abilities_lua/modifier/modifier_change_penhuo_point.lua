modifier_change_penhuo_point = class({})


function modifier_change_penhuo_point:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.025)
end

function modifier_change_penhuo_point:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    for i = 1,4 do 
        local changePoint = RotatePosition(caster:GetOrigin(),QAngle(0, -0.5, 0),ability["point_"..i]) 
        ParticleManager:SetParticleControl( ability["penhuo_"..i], 1, changePoint )
        ability["point_"..i] = changePoint
    end
end

function modifier_change_penhuo_point:CheckState() 
	return 
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true, 
	} 
end