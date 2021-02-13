
LinkLuaModifier("modifier_passive_zhenwu_zhenfa_lua","ability/abilities_lua/passive_zhenwu_zhenfa_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_active_point_magical_lua","ability/abilities_lua/modifier/modifier_active_point_magical_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
passive_zhenwu_zhenfa_lua_d = class({})
function passive_zhenwu_zhenfa_lua_d:GetIntrinsicModifierName()
	return "modifier_passive_zhenwu_zhenfa_lua"
end

passive_zhenwu_zhenfa_lua_c = class({})
function passive_zhenwu_zhenfa_lua_c:GetIntrinsicModifierName()
	return "modifier_passive_zhenwu_zhenfa_lua"
end

passive_zhenwu_zhenfa_lua_b = class({})
function passive_zhenwu_zhenfa_lua_b:GetIntrinsicModifierName()
	return "modifier_passive_zhenwu_zhenfa_lua"
end

passive_zhenwu_zhenfa_lua_a = class({})
function passive_zhenwu_zhenfa_lua_a:GetIntrinsicModifierName()
	return "modifier_passive_zhenwu_zhenfa_lua"
end

passive_zhenwu_zhenfa_lua_s = class({})
function passive_zhenwu_zhenfa_lua_s:GetIntrinsicModifierName()
	return "modifier_passive_zhenwu_zhenfa_lua"
end

if modifier_passive_zhenwu_zhenfa_lua == nil then
	modifier_passive_zhenwu_zhenfa_lua = class({})
end

function modifier_passive_zhenwu_zhenfa_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_passive_zhenwu_zhenfa_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_passive_zhenwu_zhenfa_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end
function modifier_passive_zhenwu_zhenfa_lua:OnCreated(params)
    if not IsServer( ) then
        return
    end
    -- local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
    -- if not global_var_func.extra_ability_crit[steam_id] then
    --     global_var_func.extra_ability_crit[steam_id] = 0
    -- end
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", -global_var_func.extra_ability_crit[steam_id])
    -- game_playerinfo:set_dynamic_properties(steam_id, "attack_critical", self:GetAbility():GetSpecialValueFor( "crit" ))
    -- global_var_func.extra_ability_crit[steam_id] = self:GetAbility():GetSpecialValueFor( "crit" )
end

function modifier_passive_zhenwu_zhenfa_lua:OnAttacked(params)
    local caster = self:GetAbility():GetCaster()

    if caster ~= params.target then
        return 0
    end
    self:IncrementStackCount()
    local need_stack = math.modf(50 - caster:GetStrength()/100)
    if need_stack <= 3 then
        need_stack = 3
    end
    if self:GetStackCount() >= need_stack then
        if RollPercentage(self:GetAbility():GetSpecialValueFor( "chance" )) then
            self:CreateDamage_1()
        else
            self:CreateDamage()
        end
        self:SetStackCount(0)
    end 
end

function modifier_passive_zhenwu_zhenfa_lua:OnAttackLanded(params)
    local caster = self:GetAbility():GetCaster()
    
    if params.attacker ~= caster then
		return 0
	end
    self:IncrementStackCount()
    local need_stack = math.modf(50 - caster:GetStrength()/100)
    if need_stack <= 3 then
        need_stack = 3
    end
    if self:GetStackCount() >= need_stack then
        if RollPercentage(self:GetAbility():GetSpecialValueFor( "chance" )) then
            self:CreateDamage_1()
        else
            self:CreateDamage()
        end
        self:SetStackCount(0)
    end
end

function modifier_passive_zhenwu_zhenfa_lua:OnTooltip()
    local caster = self:GetAbility():GetCaster()
    local need_stack = math.modf(50 - caster:GetStrength()/100)
    if need_stack <= 3 then
        need_stack = 3
    end
    -- print(" >>>>>>>>>>>> need_stack: "..need_stack) 
	return need_stack
end

function modifier_passive_zhenwu_zhenfa_lua:CreateDamage()
    
    local caster = self:GetAbility():GetCaster()
    local Origin = caster:GetOrigin()
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
    ParticleManager:SetParticleControl( nFXIndex, 0, Origin )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    
    -- local EffectName_1 = "particles/vr_env/killbanners/vr_killbanner_triplekill_e.vpcf" -- 
	-- local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
	-- self:AddParticle(nFXIndex_1, false, false, -1, false, false)

    local targets = FindUnitsInRadius(caster:GetTeamNumber(), Origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)
        
    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    for i,unit in pairs(targets) do

        local damage = {
            victim = unit,
            attacker = caster,
            damage = self:GetAbility():GetSpecialValueFor("basedamage") + (caster:GetIntellect()*self:GetAbility():GetSpecialValueFor("scale")),
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility()
        }
        -- print(">>>>>>>>>>> damage: "..damage.damage);
        ApplyDamage( damage )
    end
end

function modifier_passive_zhenwu_zhenfa_lua:CreateDamage_1()
    
    local caster = self:GetAbility():GetCaster()
    local Origin = caster:GetOrigin()
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_cast_arcana_water.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
    ParticleManager:SetParticleControl( nFXIndex, 0, Origin )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    
    -- local EffectName_1 = "particles/vr_env/killbanners/vr_killbanner_triplekill_e.vpcf" -- 
	-- local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
	-- self:AddParticle(nFXIndex_1, false, false, -1, false, false)

    local targets = FindUnitsInRadius(caster:GetTeamNumber(), Origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)
        
    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    for i,unit in pairs(targets) do

        local damage = {
            victim = unit,
            attacker = caster,
            damage = self:GetAbility():GetSpecialValueFor("basedamage") + (caster:GetIntellect()*self:GetAbility():GetSpecialValueFor("scale")),
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        }
        -- print(">>>>>>>>>>> damage: "..damage.damage);
        unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_active_point_magical_lua", { duration = 1.5 } )
        ApplyDamage( damage )
    end
end