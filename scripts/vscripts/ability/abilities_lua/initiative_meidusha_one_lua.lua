initiative_meidusha_one_lua = class({})

LinkLuaModifier("modifier_initiative_meidusha_one_lua","ability/abilities_lua/initiative_meidusha_one_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_meidusha_one_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    --技能释放前动作
    caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
--延迟1秒释放技能效果
    Timers:CreateTimer(1, function()
        if caster:IsAlive() and target:IsAlive() then
            local index = ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControlEnt(index, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
            ParticleManager:SetParticleControlEnt(index, 9, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetOrigin(), true)
            ParticleManager:SetParticleControlForward(index, 1, (target:GetOrigin() - caster:GetOrigin()):Normalized())
            --技能释放动作，1秒后解除
            caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)
            caster:StartGesture(ACT_DOTA_LOADOUT)
            self:GetCaster():EmitSound("hero.attack.npc_dota_hero_zuus")
            Timers:CreateTimer(1, function()
                caster:RemoveGesture(ACT_DOTA_LOADOUT)
            end)

            -- 目标是否面向自己
            local caster_location = caster:GetAbsOrigin()
            local target_location = target:GetAbsOrigin()	
            local direction = (caster_location - target_location):Normalized()
            local forward_vector = target:GetForwardVector()
            local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
            if angle <= 90 then
                target:AddNewModifier(caster, self, "modifier_initiative_meidusha_one_lua", { duration = 2 })
            end
            local damagetable = {
                victim = target,
                attacker = caster,
                damage = self:GetSpecialValueFor("damage"),
                damage_type = DAMAGE_TYPE_MAGICAL,
            }
            ApplyDamage(damagetable)
        end
    end)
end


modifier_initiative_meidusha_one_lua = class({})

function modifier_initiative_meidusha_one_lua:IsDebuff()
	return true 
end
function modifier_initiative_meidusha_one_lua:IsHidden()
	return false
end
function modifier_initiative_meidusha_one_lua:IsPurgable()
	return false
end
function modifier_initiative_meidusha_one_lua:IsPurgeException()
	return false
end
function modifier_initiative_meidusha_one_lua:CheckState()
	local state = {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
		}
	return state
end

function modifier_initiative_meidusha_one_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end