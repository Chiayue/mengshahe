--寒霜新星
initiative_frost_nova_lua = class({})

LinkLuaModifier("modifier_frost_nova_slow","ability/abilities_lua/initiative_frost_nova_lua.lua",LUA_MODIFIER_MOTION_NONE)
--施法开始
function initiative_frost_nova_lua:OnSpellStart()
	local caster = self:GetCaster()
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetOrigin(),
        self,
        600,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES ,
        1,
        false
    )
    local hClosestTarget = nil
    local flClosestDist = 0.0
    -- 选取范围最近的1个单位
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            if enemy ~= nil then
                local vToTarget = enemy:GetOrigin() - caster:GetOrigin()
                local flDistToTarget = vToTarget:Length()

                if hClosestTarget == nil or flDistToTarget < flClosestDist then
                    hClosestTarget = enemy
                    flClosestDist = flDistToTarget
                end		
            end
        end
    end
    local target = hClosestTarget
    if hClosestTarget ~= nil  then
        -- target:EmitSound("Ability.FrostNova")
        target:EmitSound("bh3")
        target.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        --设置粒子附着位置
        ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(target.ShieldParticle)
        local damageTable = {
            victim  =  target,--
            attacker = self:GetCaster(),
            damage = caster:GetDamageMax()*0.5+(GameRules:GetCustomGameDifficulty()-1)*(caster:GetDamageMax()*0.1),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        }
        if(damageTable.damage_type ~= nil) then
            ApplyDamage(damageTable)
        end
        --添加修饰器
        target:AddNewModifier(caster,self, "modifier_frost_nova_slow", {duration =  self:GetSpecialValueFor("duration")})
    end
end



--修饰器
modifier_frost_nova_slow = class({})

function modifier_frost_nova_slow:IsDebuff()				return true end
function modifier_frost_nova_slow:IsHidden() 			return false end
function modifier_frost_nova_slow:IsPurgable() 			return true end
function modifier_frost_nova_slow:IsPurgeException() 	return true end

function modifier_frost_nova_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_frost_nova_slow:StatusEffectPriority() return 10 end

function modifier_frost_nova_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end
function modifier_frost_nova_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slow")-(GameRules:GetCustomGameDifficulty()-1)*5 end