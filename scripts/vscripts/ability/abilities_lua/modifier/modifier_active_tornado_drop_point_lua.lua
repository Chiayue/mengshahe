modifier_active_tornado_drop_point_lua = class({})

function modifier_active_tornado_drop_point_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
    local nFXIndex = ParticleManager:CreateParticle(
        "particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_core_ring_butterfly.vpcf",
        PATTACH_WORLDORIGIN, 
        nil
    )
    ParticleManager:SetParticleControl(nFXIndex, 0, Vector(kv.position_x, kv.position_y, kv.position_z))
    self:AddParticle(nFXIndex, false, false, 10, false, false)
end