initiative_shitouren_one_lua = class({})

LinkLuaModifier("modifier_initiative_shitouren_one_lua","ability/abilities_lua/initiative_shitouren_one_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_shitouren_one_stunned_lua","ability/abilities_lua/initiative_shitouren_one_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_shitouren_one_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    --技能释放前动作
    caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
    caster:AddNewModifier(caster, self, "modifier_initiative_shitouren_one_lua", { duration = 1 })
    --延迟1秒释放技能效果
    Timers:CreateTimer(1, function()
        caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)
        if caster:IsAlive() and target:IsAlive() then
            local caster_postion = caster:GetOrigin()
            local target_postion = target:GetOrigin()
            local distance = math.abs(math.sqrt((caster_postion.x-target_postion.x)*(caster_postion.x-target_postion.x)+(caster_postion.y-target_postion.y)*(caster_postion.y-target_postion.y)))
            local center_positon = RotatePosition(target_postion, QAngle(90, 180, 0), target_postion) 
            local knockbackModifierTable =
                            {
                            should_stun = 0,
                            knockback_duration = 0.7,
                            duration = 0.7,
                            knockback_distance = -distance,
                            knockback_height = 500,
                            center_x = center_positon.x,
                            center_y = center_positon.y,
                            center_z = center_positon.z
                            }
            -- 系统自带的击飞 modifier 
            caster:AddNewModifier(caster, self, "modifier_knockback", knockbackModifierTable )

            Timers:CreateTimer(0.7, function()
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                caster:EmitSound("huojiandan.boom")
                target:AddNewModifier(caster, self, "modifier_initiative_shitouren_one_stunned_lua", { duration = 5 })
            end)
        end
    end)
end

modifier_initiative_shitouren_one_lua = class({})

function modifier_initiative_shitouren_one_lua:IsDebuff()
	return true 
end
function modifier_initiative_shitouren_one_lua:IsHidden()
	return false
end
function modifier_initiative_shitouren_one_lua:IsPurgable()
	return false
end
function modifier_initiative_shitouren_one_lua:IsPurgeException()
	return false
end
function modifier_initiative_shitouren_one_lua:CheckState()
	local state = {
        [MODIFIER_STATE_ROOTED] = true,
		}
	return state
end

modifier_initiative_shitouren_one_stunned_lua = class({})

function modifier_initiative_shitouren_one_stunned_lua:IsDebuff()
	return true 
end
function modifier_initiative_shitouren_one_stunned_lua:IsHidden()
	return false
end
function modifier_initiative_shitouren_one_stunned_lua:IsPurgable()
	return false
end
function modifier_initiative_shitouren_one_stunned_lua:IsPurgeException()
	return false
end
function modifier_initiative_shitouren_one_stunned_lua:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
		}
	return state
end
function modifier_initiative_shitouren_one_stunned_lua:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
function modifier_initiative_shitouren_one_stunned_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end