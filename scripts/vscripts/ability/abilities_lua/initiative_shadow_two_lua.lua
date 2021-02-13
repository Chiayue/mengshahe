initiative_shadow_two_lua = class({})

--开始施法
function initiative_shadow_two_lua:OnSpellStart()
    if not IsServer() then
        return
    end

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local caster_postion = caster:GetOrigin()
    local target_postion = target:GetOrigin()
 
    if caster:IsAlive() and target:IsAlive() then
        local index = ParticleManager:CreateParticle("particles/econ/events/ti4/dagon_ti4.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(index, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_postion, true)
        ParticleManager:SetParticleControlEnt(index, 9, caster, PATTACH_POINT_FOLLOW, "attach_head", caster_postion, true)
        ParticleManager:SetParticleControlForward(index, 1, (target_postion - caster_postion):Normalized())
        local center_positon = RotatePosition(target_postion,QAngle(0, -180, 0), caster_postion) 
        local knockbackModifierTable =
                    {
                    should_stun = 0.5,
                    knockback_duration = 0.5,
                    duration = 0.5,
                    knockback_distance = math.abs(math.sqrt((caster_postion.x-target_postion.x)*(caster_postion.x-target_postion.x)+(caster_postion.y-target_postion.y)*(caster_postion.y-target_postion.y))),
                    knockback_height = 100,
                    center_x = center_positon.x,
                    center_y = center_positon.y,
                    center_z = center_positon.z
                    }

            -- 敌人击飞   系统自带的击飞 modifier 
        target:AddNewModifier(caster, self, "modifier_knockback", knockbackModifierTable )
        caster:EmitSound("game.go_back")
        local damagetable = {
            victim = target,
            attacker = caster,
            damage = self:GetSpecialValueFor("damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
        Timers:CreateTimer(0.5, function()
            ApplyDamage(damagetable)
        end)
    end
end
