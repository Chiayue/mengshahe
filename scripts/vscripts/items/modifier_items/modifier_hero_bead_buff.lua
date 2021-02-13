require("items/lua_items_ability/item_ability")
require("info/game_playerinfo")
require("config/config_item")

if modifier_hero_bead_buff == nil then 
    modifier_hero_bead_buff = class({})
end

function modifier_hero_bead_buff:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_hero_bead_buff:RemoveOnDeath()
    return false -- 死亡不移除
end


--碎片modifier
function modifier_hero_bead_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        --百分比减伤
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        --增伤
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        --伤害抵消
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
        --技能增伤
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        --物理攻击力百分比增加
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        -- MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE ,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        -- 额外魔法值上限
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
        -- 额外攻击力
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        -- 额外血量百分比
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        -- MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end


function modifier_hero_bead_buff:OnCreated( evt )
    if not IsServer( ) then
        return
    end 
    self:StartIntervalThink( 1 )
    self.damage_info = {
        victim = nil,
        attacker = self:GetParent(),
        damage = 0,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }
    self.creat_ame_time = 0
end

function modifier_hero_bead_buff:OnAttackLanded(evt)
    if not IsServer( ) then
        return
    end
    local attacker = evt.attacker 
    local target = evt.target
    if attacker == self:GetParent() then 
        if attacker.dynamic_properties then 
            --吸血
            if evt.damage_type == DAMAGE_TYPE_PHYSICAL then 
                local heal_amount = 0
                local heal_percent = 0
                if attacker.dynamic_properties.attack_heal then
                    heal_amount =  attacker.dynamic_properties.attack_heal
                end
                if attacker.dynamic_properties.attack_heal_percent then
                    heal_percent  = evt.damage * attacker.dynamic_properties.attack_heal_percent / 100
                end
                local total_heal = heal_amount + heal_percent
                attacker:Heal( total_heal, attacker )
                if heal_amount > 0 then 
                    self.attack_heal_index =  ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker )
                    ParticleManager:ReleaseParticleIndex(self.attack_heal_index)
                end
            end

            -- 附加物理伤害
            if attacker.dynamic_properties.extra_attack_physics > 0 then
                -- body
                self.damage_info.victim = target
                self.damage_info.damage = attacker.dynamic_properties.extra_attack_physics
                self.damage_info.damage_type = DAMAGE_TYPE_PHYSICAL
                ApplyDamage( self.damage_info )
            end

            -- 附加真实伤害
            if attacker.dynamic_properties.extra_attack_pure > 0 then
                -- body
                self.damage_info.victim = target
                self.damage_info.damage = attacker.dynamic_properties.extra_attack_pure
                self.damage_info.damage_type = DAMAGE_TYPE_PURE
                ApplyDamage( self.damage_info )
            end
        end
        -- 召唤影子
        if attacker.dynamic_properties.call_shadow and attacker.dynamic_properties.call_shadow > 0 then
            if attacker:IsAlive() and RandomChance(0.15) then
                local illusions = CreateIllusions(attacker, attacker, {
                    outgoing_damage = 100,	-- 造成50%的伤害
                    incoming_damage = 300,	-- 受到300%的伤害
                    bounty_base = 15,	-- 击杀获得15金钱
                    outgoing_damage_structure = 10,	-- 对建筑造成10%伤害
                    outgoing_damage_roshan = 60	-- 对肉山造成60%伤害
                }, attacker.dynamic_properties.call_shadow, 50, true, true)
                for k,v in pairs(illusions) do
                    -- v:SetControllableByPlayer(attacker:GetEntityIndex(), false)
                    v:SetOwner(attacker)
                    v:AddNewModifier(nil, nil, "modifier_item_rune_illusions", { duration = 3 })
                    v:AddNewModifier(nil, nil, "modifier_custom_wudi", {})
                end
            end
        end
        --召唤陨石
        if attacker.dynamic_properties.call_rolling_stone and attacker.dynamic_properties.call_rolling_stone > 0 then
            if attacker:IsAlive() and RandomChance(0.15) then
                local distance = 300
                local vDirection = -attacker:GetForwardVector()
                -- local vLandPosition = target:GetAbsOrigin() - vDirection:Normalized() * fOffsetDistance
                local vStartPosition = attacker:GetAbsOrigin() + Vector(0, 0, 1500) - vDirection:Normalized() * (distance + 100)
                for i=1 , attacker.dynamic_properties.call_rolling_stone do
                    -- local fOffsetDistance = RandomInt(30,400)
                    local fOffsetDistance 
                    if i==1 then
                        fOffsetDistance = vDirection:Normalized()
                    else
                        fOffsetDistance = RandomVector(300)
                    end
                    local vLandPosition = target:GetAbsOrigin() - fOffsetDistance --vDirection:Normalized() * fOffsetDistance
                    local iParticleID = ParticleManager:CreateParticle("particles/units/towers/combination_t28_rolling_stone_fly.vpcf", PATTACH_CUSTOMORIGIN, nil)
                    ParticleManager:SetParticleControl(iParticleID, 0, vStartPosition)
                    ParticleManager:SetParticleControl(iParticleID, 1, vLandPosition)
                    ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 0, 0))
                    ParticleManager:ReleaseParticleIndex(iParticleID)
                    Timers:CreateTimer({
                        endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                            local vims = FindUnitsInRadius( attacker:GetTeam(), vLandPosition, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
                            local damage_amount = attacker:GetAgility() * 20
                            for i=1 ,#vims do 
                                if vims[i]:IsAlive() then
                                    self.damage_info.victim = vims[i]
                                    self.damage_info.damage = damage_amount
                                    self.damage_info.damage_type = DAMAGE_TYPE_MAGICAL
                                    ApplyDamage( self.damage_info )
                                end
                            end
                            
                        end
                    })
                end
            end
        end
        --秒杀小怪（boss百分比伤害）
        if attacker.dynamic_properties.kill_immediately and attacker.dynamic_properties.kill_immediately > 0 then 
            if RollPercentage(attacker.dynamic_properties.kill_immediately) then
                if ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_BOSS) then
                    self.damage_info.victim = target
                    self.damage_info.damage = target:GetMaxHealth() * attacker.dynamic_properties.kill_immediately/100
                    self.damage_info.damage_type = DAMAGE_TYPE_MAGICAL
                    ApplyDamage( self.damage_info )
                else
                    target:Kill(nil,attacker)
                end
            end
        end
    end
        --经验(击杀监听)
        --爆率(击杀监听)
end

function modifier_hero_bead_buff:OnAttackStart(evt)
    if not IsServer( ) then
        return
    end
    local attacker = evt.attacker 
    --暴击
    if attacker == self:GetParent() then 
        if attacker.dynamic_properties then 
            if attacker.dynamic_properties.attack_critical then
                local critical_percent = attacker.dynamic_properties.attack_critical 
                if RollPercentage(critical_percent) then
                    local critical_damage = attacker.dynamic_properties.attack_critical_damage or 2
                    attacker:AddNewModifier(attacker,nil,"modifier_critical_strike", {critical_damage= critical_damage})
                end
            end
        end
    end
end

function modifier_hero_bead_buff:OnAttack(evt)
    if not IsServer() then
        return
    end
    local target = evt.target 
    if target == self:GetParent() then 
        if target.dynamic_properties.strength_up_temporary and target.dynamic_properties.strength_up_temporary > 0  then
            if RandomChance(0.1) then 
                local strength = 30 * target.dynamic_properties.strength_up_temporary 
                target:AddNewModifier(target,nil,"modifier_temporary_property",{Duration=3, strength= strength,stack_limit = 20})
                target:CalculateStatBonus(true)
            end
        end
    end
end

-- 护甲
function modifier_hero_bead_buff:GetModifierPhysicalArmorBonus(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.add_armor
    else
        local get_key = "bead"..self:GetParent():GetEntityIndex()
        local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
        if get_bead_data then 
            return get_bead_data.add_armor or 0
        else
            return 0
        end
    end
end

--伤害减免 上限80
function modifier_hero_bead_buff:GetModifierIncomingDamage_Percentage(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.reduce_attack_scale
    -- else
    --     local get_key = "bead"..self:GetParent():GetEntityIndex()
    --     local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
    --     if get_bead_data then 
    --         return get_bead_data.reduce_attack_scale or 0
    --     else
    --         return 0
    --     end
    end
end

--伤害抵消
function modifier_hero_bead_buff:GetModifierTotal_ConstantBlock(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.reduce_attack_point
    end
end

--额外基础攻击
function modifier_hero_bead_buff:GetModifierBaseAttack_BonusDamage()
	if IsServer() then 
        return self:GetParent().dynamic_properties.add_baseattack
    else
        local get_key = "bead"..self:GetParent():GetEntityIndex()
        local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
        if get_bead_data then 
            return get_bead_data.add_baseattack or 0
        else
            return 0
        end
    end
end

--增伤 
function modifier_hero_bead_buff:GetModifierTotalDamageOutgoing_Percentage(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.extra_attack_scale
    end
end

--技能增伤
function modifier_hero_bead_buff:GetModifierSpellAmplify_Percentage(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.magic_attack_scale
    -- else
    --     local get_key = "bead"..self:GetParent():GetEntityIndex()
    --     local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
    --     if get_bead_data then 
    --         return get_bead_data.attack_scale or 0
    --     else
    --         return 0
    --     end
    end
end

--物理攻击百分比增加
function modifier_hero_bead_buff:GetModifierDamageOutgoing_Percentage(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.physics_attack_scale
    else
        local get_key = "bead"..self:GetParent():GetEntityIndex()
        local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
        if get_bead_data then 
            return get_bead_data.physics_attack_scale or 0
        else
            return 0
        end
    end
end

function modifier_hero_bead_buff:GetModifierExtraManaBonus()
    if not IsServer( ) then
        return
    end
    return self:GetParent().dynamic_properties.max_mana
end

function modifier_hero_bead_buff:GetModifierExtraHealthPercentage()
    if not IsServer( ) then
        return
    end
    return self:GetParent().dynamic_properties.extra_health_percent
end

--魔抗
function modifier_hero_bead_buff:GetModifierMagicalResistanceBonus(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.add_resistance or 0
    else
        local get_key = "bead"..self:GetParent():GetEntityIndex()
        local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
        if get_bead_data then 
            return get_bead_data.add_resistance or 0
        else
            return 0
        end
        
    end
end

--移速
function modifier_hero_bead_buff:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then 
        return self:GetParent().dynamic_properties.move_speed or 0
    else
        local get_key = "bead"..self:GetParent():GetEntityIndex()
        local get_bead_data = CustomNetTables:GetTableValue("dynamic_properties",get_key)
        if get_bead_data then 
            return get_bead_data.move_speed or 0
        else
            return 0
        end
        
    end
end

function modifier_hero_bead_buff:IsHidden()
    return true    
end
 
function modifier_hero_bead_buff:OnIntervalThink()
    local hero = self:GetParent()
    if not hero:HasModifier("modifier_bloodseeker_thirst") then 
        hero:AddNewModifier(self:GetParent(),self,"modifier_bloodseeker_thirst",nil)
    end
    local regen_heal = hero.dynamic_properties.percent_regen_heal
    if regen_heal then 
        hero:Heal(hero:GetMaxHealth() * regen_heal / 100,nil)
    end
    local regen_mana = hero.dynamic_properties.percent_regen_mana
    if regen_mana then
        hero:GiveMana(hero:GetMaxMana() * regen_mana / 100)
    end
    --召唤人族部队
    if hero.dynamic_properties.call_human_army and hero.dynamic_properties.call_human_army>0 then
        if self.creat_ame_time == 0 or self.creat_ame_time%40 == 0 then
            local player = PlayerResource:GetPlayer(hero:GetPlayerID())
            local base_damage = hero:GetAgility() + 1000
            local base_health = hero:GetIntellect() * 5 + 2000 
            local base_armor = hero:GetPhysicalArmorBaseValue() < 5 and 5 or hero:GetPhysicalArmorBaseValue()
            local base_magic_r = hero:GetBaseMagicalResistanceValue()
            for i=1 ,hero.dynamic_properties.call_human_army do 
                for i=0 ,5 do 
                    local unit = CreateUnitByName("xiaobing_j", hero:GetOrigin(), true, hero,player, DOTA_TEAM_GOODGUYS)
                    unit:SetBaseMaxHealth(base_health)
                    unit:SetMaxHealth(base_health)
                    unit:SetHealth(base_health)
                    unit:SetBaseDamageMax(base_damage)
                    unit:SetBaseDamageMin(base_damage)
                    unit:SetPhysicalArmorBaseValue(base_armor)
                    unit:SetBaseMagicalResistanceValue(base_magic_r)
                    unit:SetOwner( hero )
                    unit:AddNewModifier(hero,nil,"modifier_kill_self",{duration = 20})
                end
                local unit_y = CreateUnitByName("xiaobing_y", hero:GetOrigin(), true, hero,player, DOTA_TEAM_GOODGUYS)
                local base_health_y = base_health -  hero:GetIntellect() * 2
                unit_y:SetBaseMaxHealth(base_health_y)
                unit_y:SetMaxHealth(base_health_y)
                unit_y:SetHealth(base_health_y)
                unit_y:SetBaseDamageMax(base_damage)
                unit_y:SetBaseDamageMin(base_damage)
                local base_armor_y = base_armor - 10 < 0 and 1 or  base_armor - 10
                unit_y:SetPhysicalArmorBaseValue(base_armor_y)
                unit_y:SetBaseMagicalResistanceValue(base_magic_r)
                unit_y:SetMaxMana(300)
                unit_y:SetMana(300)
                unit_y:SetBaseManaRegen(1)
                unit_y:SetOwner( hero )
                unit_y:AddNewModifier(hero,nil,"modifier_kill_self",{duration = 20 })
                local ability_y = unit_y:AddAbility("lightning_chain_unit")
                ability_y:SetLevel(1)
                unit_y:SetContextThink(DoUniqueString("unit_do_ligth"), function ()
                    if unit_y:IsAlive() then
                        if ability_y:IsFullyCastable() then
                            local cast_range = ability_y:GetCastRange(nil,nil)
                            local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,unit_y:GetOrigin(),nil,cast_range,DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
                            unit_y:CastAbilityOnTarget(enemies[1], ability_y, hero:GetPlayerID())
                        end
                        return 1
                    else
                        return nil
                    end
                end, 1)
            end
        end
        self.creat_ame_time = self.creat_ame_time + 1
    end
    CustomNetTables:SetTableValue("dynamic_properties","bead"..hero:GetEntityIndex(),hero.dynamic_properties)
end

-- function modifier_hero_bead_buff:GetModifierMoveSpeed_Absolute(params)
--     return 1000
-- end
--降低技能冷却
function modifier_hero_bead_buff:GetModifierPercentageCooldown()
    if IsServer() then
        return self:GetParent().dynamic_properties.ability_cd_percent
    end
end

function modifier_hero_bead_buff:GetModifierBonusStats_Agility()
    if IsServer() then
        return (self:GetParent().dynamic_properties.add_agility + ((self:GetParent().dynamic_properties.add_agility_scale*0.01)*self:GetParent():GetBaseAgility()))
    end
end

function modifier_hero_bead_buff:GetModifierBonusStats_Intellect()
    if IsServer() then
        return (self:GetParent().dynamic_properties.add_intellect + ((self:GetParent().dynamic_properties.add_intellect_scale*0.01)*self:GetParent():GetBaseIntellect()))
    end
end

function modifier_hero_bead_buff:GetModifierBonusStats_Strength()
    if IsServer() then
        return (self:GetParent().dynamic_properties.add_strength + ((self:GetParent().dynamic_properties.add_strength_scale*0.01)*self:GetParent():GetBaseStrength()))
    end
end

function modifier_hero_bead_buff:OnTakeDamage(params)
    if params.attacker ~= self:GetParent() then
        return
    end
    print(self:GetParent().dynamic_properties.extra_attack_scale)
    print("------------------------------------")
    print("damage "..params.damage)
    print("damage_o "..params.original_damage)
end

