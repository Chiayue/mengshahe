passive_mines_explosion_lua = class({})

LinkLuaModifier("modifier_passive_mines_explosion_lua","ability/abilities_lua/passive_mines_explosion_lua",LUA_MODIFIER_MOTION_NONE )

function passive_mines_explosion_lua:GetIntrinsicModifierName()
	return "modifier_passive_mines_explosion_lua"
end

if modifier_passive_mines_explosion_lua == nil then
    modifier_passive_mines_explosion_lua = class({})
end

function modifier_passive_mines_explosion_lua:IsHidden()
    return true -- 隐藏
end

function modifier_passive_mines_explosion_lua:IsPurgable()
    return false -- 无法驱散
end

function modifier_passive_mines_explosion_lua:IsPurgeException()
	return false -- 无法强力驱散
end

function modifier_passive_mines_explosion_lua:RemoveOnDeath()
    return true -- 死亡移除
end

function modifier_passive_mines_explosion_lua:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_passive_mines_explosion_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    self.caster = self:GetCaster() 
    self:StartIntervalThink( 0.5 )
end

function modifier_passive_mines_explosion_lua:OnIntervalThink()
    local scope = self:GetAbility():GetSpecialValueFor("scope")
    local base_damage = self:GetAbility():GetSpecialValueFor("base_damage") + GameRules:GetCustomGameDifficulty()*100
    local round_damage = (self:GetAbility():GetSpecialValueFor("round_damage") + GameRules:GetCustomGameDifficulty()*50) * global_var_func.current_round
    local results_damage = base_damage + round_damage
--每0.5秒寻找自身周围是否有目标    
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, scope, target_team, target_types, target_flags, FIND_CLOSEST, false)
    if #units > 0 then
--找到目标后启动计时器，2秒后再次寻找范围内是否依然存在目标
        Timers:CreateTimer(2, function()
            local units1 = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, scope, target_team, target_types, target_flags, FIND_CLOSEST, false)
            if #units1 > 0 then
--引爆自身对周围目标造成伤害
                if self.caster:IsAlive() then                 
                    for i=1, #units1 do 
                        local damage = {
                            victim = units1[i],
                            attacker = units1[i],
                            damage = results_damage,	
                            damage_type = DAMAGE_TYPE_PHYSICAL,
                            ability = self
                        }
                        ApplyDamage( damage )
                    end
                    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
                    ParticleManager:SetParticleControlForward( nFXIndex, 1, self.caster:GetOrigin())
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                    self.caster:ForceKill(true) 
                    self.caster:EmitSound("skill.bom2")
                end
            end
		end)
	end
end

