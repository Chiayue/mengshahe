


function Blink(keys)
    --PrintTable(keys)
    local point = keys.target_points[1]
    local caster = keys.caster
    local casterPos = caster:GetAbsOrigin()
    local pid = caster:GetPlayerID()
    local difference = point - casterPos
    local ability = keys.ability
    local range = ability:GetLevelSpecialValueFor("blink_range", 0)
    local radius = ability:GetSpecialValueFor("radius")
    local attribute_type = ability:GetSpecialValueFor("attribute_type")
    local scale = ability:GetSpecialValueFor("scale")
    local base_atk = ability:GetSpecialValueFor("base_atk")

    ProjectileManager:ProjectileDodge(caster)

    if difference:Length2D() > range then
        point = casterPos + (point - casterPos):Normalized() * range
    end

    FindClearSpaceForUnit(caster, point, false)	

    local caster = keys.caster       --获取施法者
	
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	
	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, point, nil, radius, teams, types, flags, FIND_CLOSEST, true)

    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    local att_value = caster:GetIntellect()+caster:GetAgility()+caster:GetStrength();
    if attribute_type == 0 then
        att_value = caster:GetStrength();
    elseif attribute_type == 1 then
        att_value = caster:GetAgility();
    elseif attribute_type == 2 then
        att_value = caster:GetIntellect();
    end
    -- DeepPrintTable(targets)
    for i,unit in pairs(targets) do
        
		local damageTable = {victim=unit,    --受到伤害的单位
			attacker=caster,	  --造成伤害的单位
			damage=att_value * scale + base_atk,	--
            damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
		ApplyDamage(damageTable)    --造成伤害
	end
    if ability:GetAbilityName() == "sublime_blueflash_blink_datadriven" then
        caster:AddNewModifier(caster, ability, "modifier_sublime_blueflash_blink_datadriven", {duration=5})
    end
end

LinkLuaModifier( "modifier_sublime_blueflash_blink_datadriven","ability/abilities_lua/blueflash_blink.lua", LUA_MODIFIER_MOTION_NONE )

if modifier_sublime_blueflash_blink_datadriven == nil then 
    modifier_sublime_blueflash_blink_datadriven = class({})
end

function modifier_sublime_blueflash_blink_datadriven:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_sublime_blueflash_blink_datadriven:IsHidden()
    return true
end

function modifier_sublime_blueflash_blink_datadriven:OnDeath(params)
   if IsServer() then
        if params.unit == self:GetParent() then
            SetBaseStrength(self:GetParent(), 15)
            SetBaseAgility(self:GetParent(), 15)
            SetBaseIntellect(self:GetParent(), 15)
        end
   end
end
