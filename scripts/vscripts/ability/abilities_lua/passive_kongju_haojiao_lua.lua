
LinkLuaModifier("modifier_passive_kongju_haojiao_lua","ability/abilities_lua/passive_kongju_haojiao_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_kongju_haojiao_lua_d = class({})
function passive_kongju_haojiao_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_kongju_haojiao_lua"
end

passive_kongju_haojiao_lua_c = class({})
function passive_kongju_haojiao_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_kongju_haojiao_lua"
end

passive_kongju_haojiao_lua_b = class({})
function passive_kongju_haojiao_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_kongju_haojiao_lua"
end

passive_kongju_haojiao_lua_a = class({})
function passive_kongju_haojiao_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_kongju_haojiao_lua"
end

if modifier_passive_kongju_haojiao_lua == nil then
	modifier_passive_kongju_haojiao_lua = class({})
end


function modifier_passive_kongju_haojiao_lua:IsHidden()
    return true
end

function modifier_passive_kongju_haojiao_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_kongju_haojiao_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_kongju_haojiao_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end
function modifier_passive_kongju_haojiao_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end

end

function modifier_passive_kongju_haojiao_lua:OnAttacked(params)
    -- DeepPrintTable(params)
    local caster = self:GetAbility():GetCaster()
    local attacker = params.attacker
    if caster ~= params.target then
        return
    end
    
    if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
        return
    end
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/vr_env/killbanners/vr_killbanner_triplekill_e.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
    ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin() )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    
    -- local EffectName_1 = "particles/vr_env/killbanners/vr_killbanner_triplekill_e.vpcf" -- 
	-- local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
	-- self:AddParticle(nFXIndex_1, false, false, -1, false, false)

    local targets = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)
        
    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    for i,unit in pairs(targets) do

        local damage = {
            victim = unit,
            attacker = self:GetAbility():GetCaster(),
            damage = self:GetAbility():GetSpecialValueFor("basedamage") + (self:GetAbility():GetCaster():GetAgility()*self:GetAbility():GetSpecialValueFor("scale")),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }
        -- print(">>>>>>>>>>> damage: "..damage.damage);
        ApplyDamage( damage )
    end
    
    return 
end