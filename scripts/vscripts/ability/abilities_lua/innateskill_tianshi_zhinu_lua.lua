require("info/game_playerinfo")
require("global/global_var_func")

tianshi_zhinu_lua = class({})
LinkLuaModifier("modifier_tianshi_zhinu_lua","ability/abilities_lua/innateskill_tianshi_zhinu_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tianshi_zhinu_lua:GetIntrinsicModifierName()
	return "modifier_tianshi_zhinu_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_tianshi_zhinu_lua = class({})
--------------------------------------------------------------------------------

function modifier_tianshi_zhinu_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

function modifier_tianshi_zhinu_lua:IsHidden()
    return true
end

function modifier_tianshi_zhinu_lua:OnCreated( kv )
	-- self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0

	-- if IsServer() then
	-- 	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- 	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
	-- 	self:AddParticle( self.nFXIndex, false, false, -1, false, false )
    -- end
    local localtime = self:GetAbility():GetSpecialValueFor( "space_time" )*1000 - self:GetCaster():GetAgility()
    if localtime <= 1000 then
        localtime = 1000
    end
    self.space_time = localtime * 0.001
    if IsServer() then
        -- print(" >>>>>>>>>>>>>>>> self.space_time: "..self.space_time)
        self:StartIntervalThink( self.space_time )

        self.parent = self:GetParent()
        local index = nil

        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ring_spiral.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_dark_swirl.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_nebula.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_core_glow.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ember.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ember_streak.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_flare.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_flare_b.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_flare_c.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5_ground_scorch.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        index = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_world_chasm_ring_pnt.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
        
    end
end

function modifier_tianshi_zhinu_lua:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()       --获取施法者
        if not caster:IsAlive() then
            return
        end
        local value_caster = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()	-- 获取施法者的力量属性值
        local c_team = self:GetParent():GetTeam() 	--获取施法者所在的队伍
        local vec = self:GetParent():GetOrigin()		--获取施法者的位置，及三围坐标
        local radius = self:GetAbility():GetSpecialValueFor( "radius" )	--获取范围
        local rate = self:GetAbility():GetSpecialValueFor( "rate" )	--伤害倍数
        -- print(">>>>>>>>>>>>>>>>>> radius: "..radius)
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
        local flags = DOTA_UNIT_TARGET_FLAG_NONE

        local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
        ParticleManager:SetParticleControl( nFXIndex, 0, vec )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
            
        --获取范围内的单位，效率不是很高，在计时器里面注意使用
        local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)
        local count = 0
        -- DeepPrintTable(targets)
        --利用Lua的循环迭代，循环遍历每一个单位组内的单位
        for i,unit in pairs(targets) do
            -- count = count + 1
            -- if count > 20 then
            --     break
            -- end
            local damageTable = {victim=unit,    --受到伤害的单位
                attacker=caster,	  --造成伤害的单位
                damage=value_caster*rate+caster:GetHealth(),	--在GetLevelSpecialValueFor里面必须技能等级减1
                damage_type=self:GetAbility():GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
                -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
            ApplyDamage(damageTable)    --造成伤害
        end
        local localtime = self:GetAbility():GetSpecialValueFor( "space_time" )*1000 - self:GetCaster():GetAgility()
        if localtime <= 1000 then
            localtime = 1000
        end
        self.space_time = localtime * 0.001
        -- print(" >>>>>>>>>>>>>>>> self.space_time: "..self.space_time)
        self:StartIntervalThink( self.space_time )
    end
end

--------------------------------升华技能-------------------------------------------------
sublime_tianshi_zhinu_lua = class({})
LinkLuaModifier("modifier_sublime_tianshi_zhinu_lua","ability/abilities_lua/innateskill_tianshi_zhinu_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_fushe_lua","ability/abilities_lua/innateskill_tianshi_zhinu_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sublime_tianshi_zhinu_lua:GetIntrinsicModifierName()
	return "modifier_sublime_tianshi_zhinu_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_sublime_tianshi_zhinu_lua = class({})
--------------------------------------------------------------------------------

function modifier_sublime_tianshi_zhinu_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

function modifier_sublime_tianshi_zhinu_lua:IsHidden()
    return true
end
function modifier_sublime_tianshi_zhinu_lua:OnCreated( kv )
	-- self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0

	-- if IsServer() then
		-- self.nFXIndex = ParticleManager:CreateParticle( "particles/ambient/abilty1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		-- self:AddParticle( self.nFXIndex, false, false, -1, false, false )
    -- end
    local localtime = self:GetAbility():GetSpecialValueFor( "space_time" )*1000 - self:GetCaster():GetAgility()
    if localtime <= 800 then
        localtime = 800
    end
    self.space_time = localtime * 0.001
    if IsServer() then
        self:StartIntervalThink( self.space_time )
    end
end

function modifier_sublime_tianshi_zhinu_lua:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()       --获取施法者
        if not caster:IsAlive() then
            return
        end
        local value_caster = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()	-- 获取施法者的全属性值
        local c_team = self:GetParent():GetTeam() 	--获取施法者所在的队伍
        local vec = self:GetParent():GetOrigin()		--获取施法者的位置，及三围坐标
        local radius = self:GetAbility():GetSpecialValueFor( "radius" )	--获取范围
        local rate = self:GetAbility():GetSpecialValueFor( "rate" )	--伤害倍数
        -- print(">>>>>>>>>>>>>>>>>> radius: "..radius)
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
        local flags = DOTA_UNIT_TARGET_FLAG_NONE

        local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
        ParticleManager:SetParticleControl( nFXIndex, 0, vec )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
            
        --获取范围内的单位，效率不是很高，在计时器里面注意使用
        local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)
        local count = 0
        -- DeepPrintTable(targets)
        --利用Lua的循环迭代，循环遍历每一个单位组内的单位
        for i,unit in pairs(targets) do
            -- count = count + 1
            -- if count > 20 then
            --     break
            -- end
            local damageTable = {victim=unit,    --受到伤害的单位
                attacker=caster,	  --造成伤害的单位
                damage=value_caster*rate + caster:GetHealth(),	--在GetLevelSpecialValueFor里面必须技能等级减1
                damage_type=self:GetAbility():GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
                -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
            ApplyDamage(damageTable)    --造成伤害

            if RollPercentage(50) then
				unit:AddNewModifier( unit, nil, "modifier_fushe_lua", {duration = 4, attackerid = caster:GetPlayerID()} )
			end
        end
        local localtime = self:GetAbility():GetSpecialValueFor( "space_time" )*1000 - self:GetCaster():GetAgility()
        if localtime <= 1000 then
            localtime = 1000
        end
        self.space_time = localtime * 0.001
        -- print(" >>>>>>>>>>>>>>>> self.space_time: "..self.space_time)
        self:StartIntervalThink( self.space_time )
    end
end


modifier_fushe_lua = class({})
--------------------------------------------------------------------------------

function modifier_fushe_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_fushe_lua:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    -- self:StartIntervalThink( 0.5 )
    
    self.attacker = PlayerResource:GetPlayer(kv.attackerid):GetAssignedHero()
    
    local EffectName = "particles/killstreak/killstreak_fire_hpbar_lv2.vpcf" -- 燃烧标志特效
	local nFXIndex = ParticleManager:CreateParticle( EffectName, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(nFXIndex, false, false, -1, false, false)

	local EffectName_1 = "particles/killstreak/killstreak_fire_flames_lv2_hud.vpcf" -- 身体燃烧特效
	local nFXIndex_1 = ParticleManager:CreateParticle( EffectName_1, PATTACH_ROOTBONE_FOLLOW, self:GetParent())
	self:AddParticle(nFXIndex_1, false, false, -1, false, false)
end

-- function modifier_fushe_lua:OnIntervalThink()
    
--     local caster = self:GetParent();

--     local damage = {
--         victim = caster,
--         attacker = self.attacker,
--         damage = caster:GetMaxHealth()*0.02,
--         damage_type = DAMAGE_TYPE_MAGICAL,
--         ability = self:GetAbility()
--     }
--     ApplyDamage( damage )
	
-- end

function modifier_fushe_lua:GetModifierMoveSpeedBonus_Percentage()
    return -50
end