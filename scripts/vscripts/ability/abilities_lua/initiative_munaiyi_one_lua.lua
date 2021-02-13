initiative_munaiyi_one_lua = class({})

LinkLuaModifier("modifier_initiative_munaiyi_one_prompt_lua","ability/abilities_lua/initiative_munaiyi_one_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_initiative_munaiyi_one_lua","ability/abilities_lua/initiative_munaiyi_one_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_munaiyi_one_lua:OnSpellStart()
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
--技能释放提示圈    
    self.prompt = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_initiative_munaiyi_one_prompt_lua",
        {
            duration = 2,
		}, 
		vPos,
		self:GetCaster():GetTeamNumber(),
		false
    )
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_initiative_munaiyi_one_lua", { duration = 2 })
--延迟1.6秒释放技能效果
    Timers:CreateTimer(1.6, function()
        if self:GetCaster():IsAlive() then
            local center_positon = RotatePosition(vPos,QAngle(90, 180, 0),cPos) 
                    local knockbackModifierTable =
                    {
                    should_stun = 1,
                    knockback_duration = 0.3,
                    duration = 0.3,
                    knockback_distance = math.sqrt((cPos.x-vPos.x)*(cPos.x-vPos.x)+(cPos.y-vPos.y)*(cPos.y-vPos.y))*-1,
                    knockback_height = 300,
                    center_x = center_positon.x,
                    center_y = center_positon.y,
                    center_z = center_positon.z
                    }
            -- 敌人击飞   系统自带的击飞 modifier 
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackModifierTable )
            --跳跃动作播放完后给与伤害
            Timers:CreateTimer(0.3, function()
                local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), vPos, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)            
                local damage = {
                    victim = nil,
                    attacker = self:GetCaster(),
                    damage = 1600,	
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    ability = self
                }
                for i=1,#enemies do
                    enemies[i]:AddNewModifier(enemies[i], self, "modifier_initiative_munaiyi_one_lua", { duration = 3 })
                    damage.victim = enemies[i]
                    ApplyDamage( damage )
                end 
                self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_initiative_munaiyi_one_lua", { duration = 3 })
                ParticleManager:CreateParticle( "particles/diy_particles/ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
                self:GetCaster():EmitSound("skill.bom2")
            end)
        end
    end)
end

modifier_initiative_munaiyi_one_prompt_lua = class({})

function modifier_initiative_munaiyi_one_prompt_lua:OnCreated(kv)
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

function modifier_initiative_munaiyi_one_prompt_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end

modifier_initiative_munaiyi_one_lua = class({})

function modifier_initiative_munaiyi_one_lua:IsDebuff()
	return true 
end
function modifier_initiative_munaiyi_one_lua:IsHidden()
	return false
end
function modifier_initiative_munaiyi_one_lua:IsPurgable()
	return false
end
function modifier_initiative_munaiyi_one_lua:IsPurgeException()
	return false
end
function modifier_initiative_munaiyi_one_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		}
	return state
end