function zheng_zhong_ba_xin(params)
    local attacker = params.attacker
    local caster = params.caster
    attacker:AddNewModifier( caster, params.ability, "modifier_zheng_zhong_ba_xin", {} )
end

function fangyu_jihuo(params)
    local attacker = params.attacker
    local victim = params.target
    local attackCapability = attacker:GetAttackCapability(  )
    if attackCapability == DOTA_UNIT_CAP_RANGED_ATTACK then 
        if RollPercentage(50) then
            local damage = {
                victim = attacker,
                attacker = victim,
                damage = params.Damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = params.ability
            }
            ApplyDamage( damage )
        end
    end
end

function chougou(params)
    local caster = params.caster
    local ability = params.ability
    local buff_time = ability:GetSpecialValueFor( "buff_time" )
    caster:AddNewModifier(caster,ability,"modifier_chougou",{duration=buff_time})
end

function onekillmonster(params)
    -- print(" >>>>>>>>>>>>>>>>>>>>>>>> I KILL U !!!")
    local target = params.target
    if not ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_FINALLY, DOTA_UNIT_TYPE_FLAG_BOSS + DOTA_UNIT_TYPE_FLAG_TALENT) then
        target:Kill(nil, params.attacker)
    end
end

function go_back(params)
    local caster = params.caster
    caster:GetOwnerEntity()
    caster:EmitSound("game.go_back")
    local cast_point = params.target_points[1]
    local teamer = FindUnitsInRadius( caster:GetTeamNumber(),cast_point,nil,500,DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE,  0,false)
    if teamer and teamer[1] then
        for _,v in ipairs(teamer) do
            if v:GetUnitName() ~= "courier_doom" then
                local to_postion = teamer[RandomInt(1, #teamer)]:GetOrigin()
                FindClearSpaceForUnit(caster, to_postion, true)
                caster:SetContextThink(DoUniqueString("get_caster_camera"), function ()
                caster:Stop()
                CustomGameEventManager:Send_ServerToPlayer(caster:GetOwnerEntity(), "go_back_camera",{position = to_postion})
                    return nil
                end, 1/144)

                break
            end
        end
    else
        params.ability:EndCooldown()
        send_error_tip(caster:GetPlayerID(),"error_NoTeamer")
    end
    -- local entityName = global_var_func.corner[caster:GetPlayerID()+1]["hero_corner"]
    -- local position = Entities:FindByName(nil,entityName):GetAbsOrigin()
    -- caster:SetAbsOrigin(position)
    -- caster:SetContextThink(DoUniqueString("get_caster_camera"), function ()
    --     CustomGameEventManager:Send_ServerToPlayer(caster:GetOwnerEntity(), "go_back_camera",{position = position})
    --     return nil
    -- end, 1/144)

    
end

--闪电链-小兵
function do_lightning_chain_unit(evt)
    local caster = evt.caster
    local owner = caster:GetOwner() 
    local base_damage = 1000
    local ability = evt.ability
    local damge_mult = ability:GetSpecialValueFor("damge_mult")
    local damage_amount = ability:GetSpecialValueFor("damge_amount")
    if owner and owner:IsHero() then
        base_damage = base_damage + damge_mult * (owner:GetStrength() + owner:GetAgility() + owner:GetIntellect())
    end
    local sParticle = "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf"
    local lightningBolt = ParticleManager:CreateParticle(sParticle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(evt.target:GetAbsOrigin().x,evt.target:GetAbsOrigin().y,evt.target:GetAbsOrigin().z + evt.target:GetBoundingMaxs().z ))
    ParticleManager:ReleaseParticleIndex(lightningBolt)
    evt.target:AddNewModifier(evt.caster,ability,"modifier_passive_lightning_chain_unit_thinker",{basedamage = base_damage,damage_amount = damage_amount}) 
    ability.hited_unit = {}
    table.insert(ability.hited_unit,evt.target)
end

--召唤蛇棒
function call_shebang(params)
    local caster = params.caster
    local player = caster:GetOwner(  )
    local ability = params.ability
    local position = params.target_points[1]
    local duration = ability:GetSpecialValueFor("duration")
    local ext_duration = duration * caster.dynamic_properties.call_unit_durationtime_percent / 100
    duration = duration + ext_duration
    local damage =(caster:GetStrength(  ) + caster:GetAgility(  ) + caster:GetIntellect()) * ability:GetSpecialValueFor("multiple_damage")
    local num = ability:GetSpecialValueFor("num")
    for i= 1 ,num do
        local unit = CreateUnitByName("shebang", position, true, caster,player, DOTA_TEAM_GOODGUYS)
        unit:SetOwner( caster )
        unit:SetBaseMaxHealth(200)
        unit:SetBaseDamageMax(100 + damage)
        unit:SetBaseDamageMin(90 + damage)
        unit:AddNewModifier(caster,ability,"modifier_shebang",{})
        unit:AddNewModifier(caster,ability,"modifier_kill_self",{duration = duration})
    end
end

--召唤地狱火
function call_diyuhuo(params)
    local caster = params.caster
    local player = caster:GetOwner(  )
    local ability = params.ability
    local position = params.target_points[1]
    local quality = ability:GetSpecialValueFor("quality")
    local duration = ability:GetSpecialValueFor("alive_time")
    local ext_duration = duration * caster.dynamic_properties.call_unit_durationtime_percent / 100
    duration = duration + ext_duration
    local unit = CreateUnitByName("diyuhuo", position, true, caster,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner( caster )
    unit: SetControllableByPlayer(player:GetPlayerID(), false)
    caster:EmitSound("warlock.spell.diyuhuo")
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_WORLDORIGIN	, nil );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, nil, PATTACH_WORLDORIGIN	, "", position, true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)

    if quality > 2 then
        local guanghuan = unit:AddAbility("daniu_guanghuan")
        guanghuan:SetLevel(1)
        local uPIndex = ParticleManager:CreateParticle( "particles/ambient/ambient4.vpcf", PATTACH_ROOTBONE_FOLLOW	, unit );
        ParticleManager:ReleaseParticleIndex(uPIndex)
        local uPIndex1 = ParticleManager:CreateParticle( "particles/ambient/ambient4.vpcf", PATTACH_ROOTBONE_FOLLOW	, unit );
        ParticleManager:ReleaseParticleIndex(uPIndex1)
        local uPIndex1 = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf", PATTACH_ROOTBONE_FOLLOW	, unit );
        ParticleManager:ReleaseParticleIndex(uPIndex1)
    end
    -- print(5000 + caster:GetMaxHealth() * ability:GetSpecialValueFor("health_mult"))
    unit:SetBaseMaxHealth(5000 + caster:GetMaxHealth() * ability:GetSpecialValueFor("health_mult"))
    unit:SetBaseDamageMax(caster:GetAverageTrueAttackDamage(caster))
    unit:SetBaseDamageMin(caster:GetAverageTrueAttackDamage(caster))
    unit:SetPhysicalArmorBaseValue(ability:GetSpecialValueFor("armor"))
    unit:SetBaseMagicalResistanceValue(ability:GetSpecialValueFor("magic_resistance"))
    unit:SetBaseHealthRegen(ability:GetSpecialValueFor("health_regen"))
    unit:SetBaseManaRegen(ability:GetSpecialValueFor("mana_regen"))
    unit:AddNewModifier(caster,ability,"modifier_diyuhuo",{})
    unit:AddNewModifier(caster,ability,"modifier_kill_self",{duration = duration})
    unit:AddNewModifier(caster,ability,"modifier_burn_lua",{duration = duration})
    -- ParticleManager:SetParticleControlEnt( nFXIndex, 1, nil, PATTACH_WORLDORIGIN, "", position, true );
    -- ParticleManager:ReleaseParticleIndex( nFXIndex );
end


--召唤大炮
function call_huojian(params)
    local caster = params.caster
    local player = caster:GetOwner(  )
    local ability = params.ability
    local position = params.target_points[1]
    local quality = ability:GetSpecialValueFor("quality")
    local base_damage = ability:GetSpecialValueFor("base_damage") + (quality * caster:GetIntellect() * 2 )
    local duration = ability:GetSpecialValueFor("alive_time")
    local ext_duration = duration * caster.dynamic_properties.call_unit_durationtime_percent / 100
    duration = duration + ext_duration
    local unit = CreateUnitByName("huojiandan", position, true, caster,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner( caster )
    unit:SetControllableByPlayer(player:GetPlayerID(), false)
    unit:SetBaseDamageMax(base_damage)
    unit:SetBaseDamageMin(base_damage)
    unit:SetBaseMaxHealth(ability:GetSpecialValueFor("base_heal"))
    unit:SetBaseHealthRegen(quality)
    if quality > 2 then
        local cheli = unit:AddAbility("unit_jinjichetui")
        cheli:SetLevel(1)
    end
    unit:AddNewModifier(caster,ability,"modifier_huojiandan",{})
    unit:AddNewModifier(caster,ability,"modifier_kill_self",{duration = duration})
end

--召唤大牛
function call_daniu(params)
    local caster = params.caster
    local player = caster:GetOwner(  )
    local ability = params.ability
    local position = params.target_points[1]
    local duration = ability:GetSpecialValueFor("alive_time")
    local ext_duration = duration * caster.dynamic_properties.call_unit_durationtime_percent / 100
    duration = duration + ext_duration
    local unit = CreateUnitByName("daniu", position, true, caster,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner(caster)
    local unit_ability = unit:AddAbility("stun_unit")
    unit_ability:SetLevel(1)
    local interval_time = ability:GetSpecialValueFor("interval_time")
    if params.ability:GetAbilityName() == "call_daniu_b" then
        local guanghuan = unit:AddAbility("daniu_guanghuan_b")
        guanghuan:SetLevel(1)
    elseif params.ability:GetAbilityName() == "call_daniu_a" then
        local guanghuan = unit:AddAbility("daniu_guanghuan_a")
        guanghuan:SetLevel(1)
    end

    unit:AddNewModifier(unit,ability,"modifier_custom_wudi",{})
    unit:AddNewModifier(unit,ability,"modifier_kill_self",{duration = duration})
    unit:AddNewModifier(unit,ability,"modifier_cast_ability",{cast_ability_0 = "stun_unit"})
    unit:SetContextThink(DoUniqueString("daniu_cai"..unit:GetEntityIndex()), function ()
        if unit:IsAlive() then
            unit:CastAbilityImmediately(unit_ability,unit:GetEntityIndex())
            return interval_time
        else
            return nil
        end
    end, 0)
        local pindex = ParticleManager:CreateParticle( "particles/econ/courier/courier_cluckles/patchouli_sorcererstone.vpcf", PATTACH_WORLDORIGIN	, unit );
end

--大牛踩
function stun_unit_script(params)
    local caster = params.caster
    local ability = params.ability
    local stun_time = ability:GetSpecialValueFor("stun_time")
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    local pindex = ParticleManager:CreateParticle( "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_cast_combined_detail_ti7.vpcf", PATTACH_WORLDORIGIN	, nil );
    ParticleManager:SetParticleControlEnt( pindex, 0, nil, PATTACH_OVERHEAD_FOLLOW, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( pindex, 6, nil, PATTACH_WORLDORIGIN, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(pindex)
    local stun_range = ability:GetSpecialValueFor("stun_range")
    caster:EmitSound("daniu.cai_2")
    Timers:CreateTimer({
        endTime = 1.6, 
        callback = function()
            StopSoundOn("daniu.cai_2",caster)
            caster:EmitSound("daniu.cai_1")
            local rIndex = ParticleManager:CreateParticle( "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_physical.vpcf", PATTACH_WORLDORIGIN	, caster );
            ParticleManager:SetParticleControlEnt( rIndex, 0, nil, PATTACH_WORLDORIGIN, "", caster:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex(rIndex)
            local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS,params.caster:GetOrigin(),nil,stun_range,DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
            for i=1 ,#enemies do 
                if enemies[i] and enemies[i]:IsAlive() then
                    enemies[i]:AddNewModifier(caster,params.ability,"modifier_custom_xuanyun",{duration = stun_time })
                end
            end
        end
    })
end
--大牛光环
function daniu_guanghuan_damage(params)
    local caster = params.caster
    if caster and caster:GetOwner() then
        local damage_amount = 1000 + caster:GetOwner():GetIntellect()*2
        local ability = params.ability
        local damage = {
            victim = params.target,
            attacker = caster,
            damage = damage_amount,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }
        ApplyDamage( damage )
    end
end


--召唤天使
function call_tianshi(params)
    local hero = params.caster
    local ability = params.ability
    local position = params.target_points[1]
    local unit = CreateUnitByName("tianshi", position, true, hero,nil, DOTA_TEAM_GOODGUYS)
    unit:SetOwner(hero)
    local alive_time = ability:GetSpecialValueFor("alive_time")
    local ext_duration = alive_time * hero.dynamic_properties.call_unit_durationtime_percent / 100
    alive_time = alive_time + ext_duration
    local quality = ability:GetSpecialValueFor("quality")
    unit:AddNewModifier(unit,ability,"modifier_kill_self",{duration = alive_time})
    unit:AddNewModifier(unit,ability,"modifier_custom_wudi",{})
    local ability_heal = unit:AddAbility("tianshi_heal")
    ability_heal:SetLevel(1)
    local ability_fuhuo = nil
    if quality > 2 then
        ability_fuhuo = unit:AddAbility("tianshi_fuhuo")
        ability_fuhuo:SetLevel(1)
    end
    -- unit:SetContextThink(DoUniqueString("tianshi_heal"), function ()
    --     if unit:IsAlive() then
    --         if hero:IsAlive() then
    --             unit:MoveToNPC(hero)
    --             if ability_heal:IsFullyCastable() then
    --                 unit:CastAbilityImmediately(ability_heal,unit:GetEntityIndex())
    --             end
    --         end
    --         if not hero:IsAlive() and ability_fuhuo and ability_fuhuo:IsFullyCastable() then
    --             unit:CastAbilityImmediately(ability_fuhuo,unit:GetEntityIndex())
    --         end
    --         return 1
    --     else
    --         return nil
    --     end
    -- end, 0)
end

function tianshi_heal_hero(params)
    local caster = params.caster
    local hero = caster:GetOwner()
    local ability = params.ability
    local heal_amount = ability:GetSpecialValueFor("heal_amount")
    local heal_amount = hero:GetMaxHealth() * heal_amount /100
    hero:Heal(heal_amount, ability)
    local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_RENDERORIGIN_FOLLOW, hero)
    ParticleManager:SetParticleControlEnt(pfx3, 0, hero, PATTACH_RENDERORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(pfx3)
end


function fuhuo_hero(params)
    local caster = params.caster
    local hero = caster:GetOwner()
    if hero:UnitCanRespawn() then
        hero:RespawnHero(false, false)
    end
end

--紧急撤离
function jinjiceli(params)
    local caster = params.caster
    local hero = caster:GetOwner()
    local ability = params.ability
    local damage_radius = ability:GetSpecialValueFor("damage_radius")
    local catapult_distance = ability:GetSpecialValueFor("catapult_distance")
    local damge_multe = ability:GetSpecialValueFor("damge_multe")
    caster:AddNewModifier(caster,ability,"modifier_active_jinjicheli",{catapult_distance = catapult_distance})
    local vims = FindUnitsInRadius( caster:GetTeam(), caster:GetOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
    local damage_amount = 1000 + hero:GetIntellect() * damge_multe
    for i=1 ,#vims do 
        if vims[i]:IsAlive() then
            local damage = {
                victim = vims[i],
                attacker = caster,
                damage = damage_amount,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability
            }
            ApplyDamage( damage )
        end
    end
end

function call_xiaozhuzai(params)
    local caster = params.caster
    local target = params.target
    local ability = params.ability
    local player_id = caster:GetPlayerID()
    if target ~= nil  then
        if target:GetUnitName() == "xiaozhuzai" then 
            local unit_postion  = target:GetOrigin()
            local to_postion   = unit_postion + target:GetForwardVector():Normalized() * 100
            to_postion = RotatePosition(unit_postion,QAngle(0, -180, 0),to_postion) 
            to_postion = unit_postion + (to_postion - unit_postion) :Normalized() * 1500
            target:MoveToPosition(to_postion)
            target:EmitSound("pig.sound_2")
        end
        ability:EndCooldown()
    else
        local gold = game_playerinfo:get_player_gold(player_id)
        local pig_gain = ability:GetSpecialValueFor("pig_gain")
        local grow_time = ability:GetSpecialValueFor("grow_time")
        local pig_sell = ability:GetSpecialValueFor("pig_sell")
        if gold < pig_sell then
            send_error_tip(player_id,"error_nomoney")
            ability:EndCooldown()
            return
        end
        game_playerinfo:set_player_gold(caster:GetPlayerID(),-pig_sell)
        local cast_point = params.target_points[1]
        local unit = CreateUnitByName("xiaozhuzai", cast_point, true, caster,nil, DOTA_TEAM_GOODGUYS)
        unit:AddNewModifier(caster,params.ability,"modifier_xiaozhuzai",{pig_gain = pig_gain,grow_time = grow_time})
        local ability = unit:AddAbility("xiaozhuchongzhuang")
        ability:SetLevel(1)
        unit:SetOwner(caster)
        unit:EmitSound("pig.sound_2")
    end
end

function xiaozhu_start(params)
    local caster = params.caster
    local ability = params.ability
    local attacker = params.attacker
    local unit_postion = caster:GetOrigin()
    local attacker_postion = attacker:GetOrigin()
    local postion =  ( attacker_postion - unit_postion):Normalized()
    local info = {
        EffectName = "particles/heroes/drow_ranger/tusk_ice_shards_projectile_stout.vpcf",
        -- EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
		Ability = ability,
		vSpawnOrigin = unit_postion, 
		fStartRadius = 100,
		fEndRadius = 100,
		vVelocity =postion * 500,
		fDistance = 1000,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile( info )
end

function xiaozhua_mingzhong(params)
    local target = params.target
    local caster = params.caster
    local ability = params.ability
    -- local ve = caster:GetOrigin() - target:GetOrigin()
    local center_positon = RotatePosition(caster:GetOrigin(),QAngle(0, -180, 0), target:GetOrigin()) 
    local knockbackModifierTable =
				{
				should_stun = 0,
				knockback_duration =3,
				duration = 2,
				knockback_distance = 1000,
				knockback_height = 0,
				center_x = center_positon.x,
				center_y = center_positon.y,
				center_z = center_positon.z
				}

        -- 敌人击飞   系统自带的击飞 modifier 
    target:AddNewModifier( caster, ability, "modifier_knockback", knockbackModifierTable )
    local damage_amount
    if ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_BOSS) then
        local hero = caster:GetOwner()
        damage_amount = 10000 + 20 * (hero:GetAgility() + hero:GetStrength() + hero:GetIntellect())
    else
        damage_amount = target:GetHealth() * ability:GetSpecialValueFor("damage_amount") / 100
    end
    local damage = {
        victim = target,
        attacker = caster,
        damage = damage_amount,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    }
    ApplyDamage( damage )
end

function do_jiguang(params)
    local caster= params.caster
    local ability = params.ability
    local hero_amount = global_var_func.all_player_amount
    local isPlayer = false
    for i= 0,hero_amount do
        local player = PlayerResource:GetPlayer(i)
        if not player then
            return
        end
        local hero = player:GetAssignedHero()
        if hero and hero:IsAlive() and caster:IsAlive() then
            local cast_point = hero:GetOrigin()
            -- local pfx4 = ParticleManager:CreateParticle("particles/heroes/tinker/wisp_ambient.vpcf", PATTACH_POINT, caster)
            local pfx4 = ParticleManager:CreateParticle("particles/units/unit/kunkka_immortal_ghost_ship_splash_rings.vpcf", PATTACH_WORLDORIGIN, nil)
            -- ParticleManager:SetParticleControlEnt(pfx4, 0, nil, PATTACH_POINT, "", cast_point, true)
            ParticleManager:SetParticleControl(pfx4,  3,  cast_point)
            ParticleManager:ReleaseParticleIndex(pfx4)
            Timers:CreateTimer({
                endTime = 1.5, 
                callback = function()
                    if not isPlayer then 
                        caster:EmitSound( "tinker.cast.laser")
                        isPlayer = true
                    end
                    if not caster:IsAlive() then
                        return
                    end
                    local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_laser_aghs.vpcf", PATTACH_POINT_FOLLOW, caster)
                    ParticleManager:SetParticleControlEnt(pfx3, 1, nil, PATTACH_POINT_FOLLOW, "attach_hitloc", cast_point, true)
                    ParticleManager:SetParticleControlEnt(pfx3, 9, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
                    ParticleManager:ReleaseParticleIndex(pfx3)
                    local enemy = FindUnitsInLine(caster:GetTeamNumber(), caster:GetOrigin(), cast_point, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
                    for _,v in pairs(enemy) do
                        v:Kill(ability,caster)
                    end
                end
            })
        end
    end
end

function do_penhuo_line(params)
    local caster= params.caster
    local ability = params.ability
    local start_point = caster:GetOrigin()
    local vdrict = caster:GetForwardVector()
    local end_point = start_point + vdrict:Normalized() * 2000
    
    for i = 1,4 do 
        ability["point_"..i] = end_point
        local pfx3 = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(pfx3, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
        ParticleManager:SetParticleControl( pfx3, 1, end_point )
        end_point = RotatePosition(start_point,QAngle(0, 90, 0),end_point) 
        ability["penhuo_"..i] = pfx3
    end
    caster:AddNewModifier(caster,ability,"modifier_change_penhuo_point",{})
    caster:AddNewModifier(caster,ability,"modifier_change_penhuo_damage",{})
end

function end_penhuo_line(params)
    local caster= params.caster
    local ability = params.ability
    for i = 1,4 do 
        ParticleManager:DestroyParticle( ability["penhuo_"..i],true)
        ParticleManager:ReleaseParticleIndex( ability["penhuo_"..i])
        caster:RemoveModifierByName("modifier_change_penhuo_point")
        caster:RemoveModifierByName("modifier_change_penhuo_damage")
        ability["point_"..i] = nil
    end
end

function do_sanweizhenhuo(params)
    local caster= params.caster
    local ability = params.ability
    ability.movespeed_reduce = ability:GetSpecialValueFor("movespeed_reduce") * -1
    caster:AddNewModifier(caster,ability,"modifier_sanweizhenhuo",{})
    ability.damage_info = {
        victim = nil,
        attacker = caster,
        damage = 0,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    }
    -- local pfx3 = ParticleManager:CreateParticle("", PATTACH_POINT_FOLLOW, caster)
    -- ParticleManager:SetParticleControlEnt(pfx3, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
    -- ParticleManager:SetParticleControl(pfx3, 1, end_point)
    -- ParticleManager:ReleaseParticleIndex(pfx3)
end

function end_sanweizhenhuo(params)
    local caster= params.caster
    caster:RemoveModifierByName("modifier_sanweizhenhuo")
end

function projectile_hit(params)
    local point = params.target_points[1]
    local attacker = params.caster
    local ability = params.ability
    local damge_time = ability:GetSpecialValueFor("damge_time")
    local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_snapfire/hero_snapfire_ult_2imate_linger.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx3, 0, point)
    CreateModifierThinker( attacker, ability, "modifier_sanweizhenhuo_damage", {duration = damge_time,px =point.x,py = point.y,pz=point.z ,
                    particle_index = pfx3}, point, attacker:GetTeamNumber(), false )
end

function do_huo_dun(params)
    local caster = params.caster
    local ability = params.ability
    caster:AddNewModifier(caster,ability,"modifier_huodun",{})
end

function do_fengkuangshengzhang(params)
    local caster = params.caster
    local ability = params.ability
    local szIndex = ParticleManager:CreateParticle("particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf", PATTACH_ROOTBONE_FOLLOW, caster)
    ParticleManager:SetParticleControl(szIndex, 0,caster:GetOrigin())
    ParticleManager:SetParticleControl(szIndex, 1, caster:GetOrigin())
    ability.damage_info = {
        victim = nil,
        attacker = caster,
        damage = 0,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    }
    caster:AddNewModifier(caster, ability, "modifier_wood_overgrowth", {duration = 15})
end

function do_jishengzhongzi(params)
    local caster = params.caster
    local ability = params.ability
    caster.call_unit = {}
    local jsIndex = ParticleManager:CreateParticle("particles/heroes/treant/taunt_cat_dancer_dust_impact_bits.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt( jsIndex, 0, caster, PATTACH_OVERHEAD_FOLLOW, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(jsIndex)
    caster:AddNewModifier(caster, ability, "modifier_wood_call_settlement", {duration=10})
    local unitHeal = caster:GetMaxHealth() /100
    for i=1 ,global_var_func.all_player_amount * 3 do
        local create_position = caster:GetOrigin() + RandomVector(1000)
        local unit = CreateUnitByName("unit_shujing", create_position, true, nil,nil, caster:GetTeam())
        unit:SetBaseMaxHealth(unitHeal)
        unit:SetMaxHealth(unitHeal)
        unit:SetHealth(unitHeal)
        unit:SetBaseDamageMax(100)
        unit:SetBaseDamageMin(90)
        AppendUnitTypeFlag(unit, DOTA_UNIT_TYPE_FLAG_CREEP)
        table.insert(caster.call_unit,unit)
    end
end

function do_shujingtuji(params)
    local caster = params.caster
    local ability = params.ability
    local randomHeros ={}
    for i=0,global_var_func.all_player_amount-1 do
        if PlayerResource:GetPlayer(i) then
            local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
            if hero:IsAlive() then
                table.insert(randomHeros,hero)
            end
        end
    end
    if #randomHeros > 0 then 
        local endPoint = randomHeros[RandomInt(1, #randomHeros)]:GetOrigin()
        local facedirect = caster:GetOrigin() + (endPoint - caster:GetOrigin()):Normalized() *150
        facedirect.z = caster:GetOrigin().z
        local jsIndex = ParticleManager:CreateParticle("particles/units/direct/range_finder_directional.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(jsIndex, 0,caster:GetOrigin())
        ParticleManager:SetParticleControl(jsIndex, 2, facedirect)
        Timers:CreateTimer({
            endTime = 2, 
            callback = function()
                ParticleManager:DestroyParticle(jsIndex,true)
                ParticleManager:ReleaseParticleIndex(jsIndex)
                caster:AddNewModifier(caster, ability, "modifier_wood_tuji", {duration=1,px=endPoint.x,py=endPoint.y,pz=endPoint.z})
            end
        })
    end
end

function do_shenwaihuashen(params)
    local caster = params.caster
    local ability = params.ability
    local new_unit = CopyUnit(caster)
    new_unit:SetHealth(new_unit:GetMaxHealth() * 0.25)
    local spawn_position = caster:GetOrigin() + caster:GetForwardVector() * 300
    FindClearSpaceForUnit(new_unit,spawn_position, true)
    new_unit:RemoveAbility("shenwaihuashen")
    caster:AddNewModifier(caster, ability, "modifier_wood_fenshen", {other_index=new_unit:GetEntityIndex()})
    new_unit:AddNewModifier(caster, ability, "modifier_wood_fenshen", {other_index=caster:GetEntityIndex()})
end

function do_barracks(params)
    local caster = params.caster
    local ability = params.ability
    if not caster:IsAlive() then
        return
    end
    local unit
    if RandomInt(1, 2) == 1 then
        unit = CreateUnitByName("goodguys_melee", caster:GetOrigin(), true, caster,caster:GetOwnerEntity(), caster:GetTeamNumber())
    else 
        unit = CreateUnitByName("goodguys_ranged", caster:GetOrigin(), true, caster,caster:GetOwnerEntity(), caster:GetTeamNumber())
    end
    local create_commando = ability:GetSpecialValueFor("create_commando")
    if create_commando and RandomChance(create_commando/100) then
        local witch_buff = RandomInt(1, 4)
        if witch_buff== 1 then
            unit:AddNewModifier(caster, ability, "modifier_state_aura_damage_up", {})
        elseif witch_buff == 2 then
            unit:AddNewModifier(caster, ability, "modifier_state_aura_attackspeed", {})
        elseif witch_buff == 3 then
            unit:AddNewModifier(caster, ability, "modifier_state_aura_armor", {})
        elseif witch_buff == 4 then
            unit:AddNewModifier(caster, ability, "modifier_state_aura_ability", {})
        end
    end
    local health = caster:GetStrength() * 100
    local attack_amount = (caster:GetAgility() + caster:GetIntellect()) * 25
    unit:SetOwner(caster)
    unit:SetBaseMaxHealth(health)
    unit:SetMaxHealth(health)
    unit:SetHealth(health)
    unit:SetBaseDamageMax(attack_amount)
    unit:SetBaseDamageMin(attack_amount)
    unit:AddNewModifier(caster, ability, "modifier_kill_self", {duration = 60})
end

function do_jindan(params)
    game_playerinfo:set_player_gold(params.caster:GetPlayerID(),3 * global_var_func.current_round)
end

function jindan_apply_modifier(params)
    local caster = params.caster 
    local ability = params.ability
    local wait_add = {}
    for i=0,global_var_func.all_player_amount -1 do
        local player = PlayerResource:GetPlayer(i)
        if player then
            local hero = player:GetAssignedHero()
            if hero ~= caster  then
                if hero:GetUnitName()~="npc_dota_hero_crystal_maiden" then
                    ability:ApplyDataDrivenModifier(caster, hero, "modifier_jindan", {})
                else
                    table.insert(wait_add,player)
                end
            end
        end
    end
    if #wait_add > 0 then
        Timers:CreateTimer({
            endTime = 3, 
            callback = function()
                addModifierForAll(wait_add,ability,caster)
            end
        })
    end
end

function addModifierForAll(player_table,ability,caster)
    local wait_add = {}
    if #player_table > 0 then 
        for _,player in ipairs(player_table)  do
            local hero = player:GetAssignedHero()
            if hero and hero:GetUnitName()~="npc_dota_hero_crystal_maiden" then
                ability:ApplyDataDrivenModifier(caster, hero, "modifier_jindan", {})
            else
                table.insert(wait_add,player)
            end
        end
    end
    if #wait_add>0 then
        Timers:CreateTimer({
            endTime = 3, 
            callback = function()
                addModifierForAll(wait_add,ability,caster)
            end
        })
    end
end

function delay_add(params)
    local caster = params.caster
    game_playerinfo:set_player_gold(caster:GetPlayerID(),300 * global_var_func.current_round)
    for i=0,global_var_func.all_player_amount -1 do
        local player = PlayerResource:GetPlayer(i)
        if player then
            local hero = player:GetAssignedHero()
            if hero ~= caster and hero:GetUnitName()~="npc_dota_hero_crystal_maiden" then
                params.ability:ApplyDataDrivenModifier(caster, hero, "modifier_jindan", {})
            end
        end
    end
end

function create_jindan(params)
    local caster = params.caster
    local player_id = caster:GetPlayerID()
    if game_playerinfo:get_player_gold(player_id) >10000 then
        game_playerinfo:set_player_gold(player_id,-10000)
        local item = CreateItem("item_consum_jindan", nil, nil)
        CreateItemOnPositionForLaunch(caster:GetOrigin()+RandomVector(300),item)
    else
        send_error_tip(player_id,"error_nomoney")
        params.ability:EndCooldown()
    end
end

function do_zhiyuanxiaopao(params)
    local target = params.unit
    if ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_BOSS) then
        local ability = params.ability
        local attack_range = ability:GetSpecialValueFor("attack_range")
        local cast_range = ability:GetSpecialValueFor("cast_range")
        params.attacker:AddNewModifier(params.attacker, ability, "modifier_zhi_yuan_xiao_pao", {attack_range = attack_range,cast_range = cast_range})
    end
end

function do_refresh_zyxp(params)
    params.caster:AddNewModifier(params.caster, params.ability, "modifier_zhi_yuan_xiao_pao", {})
    params.caster:RemoveModifierByName("modifier_zhiyuanxiaopao")
    params.ability.damage_info = {
        victim = nil,
        attacker = params.caster,
        damage = 0,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = params.ability
    }
    params.ability.hero_list = {}
    for i=1 ,global_var_func.all_player_amount do
        local player = PlayerResource:GetPlayer(i-1)
        if player then
            table.insert(params.ability.hero_list,player:GetAssignedHero())
        end
    end
end

function zyxp_hit(params)
    local point = params.target_points[1]
    local attacker = params.caster
    local ability = params.ability
    local damge_time = ability:GetSpecialValueFor("damge_time")
    local pfx3 = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_call_down_explosion_impact_h.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx3, 3, point)
    params.ability.damage_info.damage = attacker:GetStrength() * 32
    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(),point,nil,300,DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
    for i=1 ,#enemies do 
        params.ability.damage_info.victim = enemies[i]
        ApplyDamage(params.ability.damage_info)
    end
    Timers:CreateTimer({
        endTime = 1, 
        callback = function()
            ParticleManager:DestroyParticle(ability.release_index, false)
            ParticleManager:ReleaseParticleIndex(pfx3)
            ParticleManager:DestroyParticle(ability.release_index, true)
            ParticleManager:ReleaseParticleIndex(ability.release_index)
        end
    })
end

function do_yinhangshengzhuanggouzi(params)
    local ability = params.ability
    local chance = ability:GetSpecialValueFor("add_mult") 
    if RollPercentage(chance) then
        local witch_add = RandomInt(1, 3)
        local attacker = params.attacker
        local buff = attacker:FindModifierByName("modifier_yinhangshengzhuanggouzi")
        buff:IncrementStackCount()
        if witch_add == 1 then
            attacker:AddNewModifier(attacker, ability, "modifier_yinhangshengzhuanggouzi_intell", {})
        elseif witch_add == 2 then
            attacker:AddNewModifier(attacker, ability, "modifier_yinhangshengzhuanggouzi_strength", {})
        elseif witch_add == 3 then
            attacker:AddNewModifier(attacker, ability, "modifier_yinhangshengzhuanggouzi_agility", {})
        end
    end
end

function do_call_bear(params)
    local caster = params.caster 
    local unit = CreateUnitByName("bear_xss", caster:GetOrigin() + RandomVector(200), true, caster,caster:GetOwnerEntity(), caster:GetTeamNumber())
    local attack_amount = caster:GetAgility() * 15
    local health = caster:GetStrength() * 32
    unit:SetOwner( caster )
    unit:SetControllableByPlayer(caster:GetPlayerID(), false)
    unit:SetBaseMaxHealth(health)
    unit:SetMaxHealth(health)
    unit:SetHealth(health)
    unit:SetBaseDamageMax(attack_amount)
    unit:SetBaseDamageMin(attack_amount)
    unit:AddNewModifier(caster, params.ability, "modifier_kill_self",{duration = 60})
end

function do_mechanical_modification(params)
    if RollPercentage(10) then
        local unit = params.unit
        local item = CreateItem("item_consum_parts", nil, nil)
        CreateItemOnPositionSync( unit:GetOrigin(), item )
        item:LaunchLoot(false, 200, 0.75, unit:GetOrigin()+RandomVector(50))
    end
end

function do_mechanical_modification_add(params)
    local hero = params.caster
    local weartable = {
            "models/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vmdl",
            "models/items/tinker/artillery_of_the_fortified_fabricator_head/artillery_of_the_fortified_fabricator_head.vmdl",
            "models/items/tinker/deep_sea_robot_off_hand/deep_sea_robot_off_hand.vmdl",
            "models/items/tinker/deep_sea_robot_shoulder/deep_sea_robot_shoulder.vmdl",
            "models/items/tinker/artillery_of_the_fortified_fabricator_head/artillery_of_the_fortified_fabricator_head.vmdl",
        }
    WearForHero(weartable,hero)
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[1] );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    
    local buff = params.caster:AddNewModifier(params.caster,params.ability , "modifier_mechanical_modification_add", {})
    params.caster.strength_add_buff = buff
end

function do_yuezhanyueyong_add(params)
    params.caster:AddNewModifier(params.caster,params.ability , "modifier_yu_zhan_yu_yong", {})
end

function do_start_didong(params)
    local hero = params.caster
    hero.unit_position = params.caster:GetOrigin()+RandomVector(100)
    local building = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(building,0,hero.unit_position )   
    hero.building_index = building
end
function do_success_didong(params)
    local hero = params.caster
    if hero.created_unit then
        for _,v in pairs(hero.call_unit) do
            if v == hero.created_unit then
                v = nil
            end
        end
        UTIL_Remove(hero.created_unit)
    end
    local unit = CreateUnitByName("shouren_didong", hero.unit_position, true, hero, hero, hero:GetTeamNumber())
    local health = hero:GetMaxHealth() * 10
    local damage = hero:GetBaseDamageMax() * 12
    unit:SetBaseMaxHealth(health)
    unit:SetMaxHealth(health)
    unit:SetHealth(health)
    unit:SetBaseDamageMax(damage)
    unit:SetBaseDamageMin(damage)
    unit:SetControllableByPlayer(hero:GetPlayerID(), false)
    unit:AddNewModifier(hero, params.ability, "modifier_shouren_didong", {})
    unit:AddNewModifier(hero, params.ability, "modifier_jiaoxie", {})
    hero.created_unit = unit
    table.insert(hero.call_unit,unit)
    ParticleManager:DestroyParticle(hero.building_index,true)
    ParticleManager:ReleaseParticleIndex( hero.building_index)
    
end
 
function do_out_didong(params)
    local hero = params.caster:GetOwner()
    local unit = params.caster
    if unit then
        unit:AddNewModifier(hero, params.ability, "modifier_jiaoxie", {})
    end
    local buff = hero:FindModifierByName("modifier_shouren_didong_no_see")
    if buff then
        buff:Destroy()
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()), "set_selected_unit", {index = hero:GetEntityIndex()})
end
function do_interrupted_didong(params)
    local hero = params.caster
    ParticleManager:DestroyParticle(hero.building_index,true)
    ParticleManager:ReleaseParticleIndex( hero.building_index)
end

function xingzailehuo(params)
    local caster = params.caster 
    local item = nil
    item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/rattletrap/the_neuromaniac_armor/the_neuromaniac_armor.vmdl"})
    item:FollowEntity(caster, true)
    ParticleManager:CreateParticle("particles/econ/items/clockwerk/rt_fall_the_neuromaniac_armor/rt_fall_the_neuromaniac_armor_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
    item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/rattletrap/the_neuromaniac_head/the_neuromaniac_head.vmdl"})
    item:FollowEntity(caster, true)
    ParticleManager:CreateParticle("particles/econ/items/clockwerk/rt_fall_the_neuromaniac_head/rt_fall_the_neuromaniac_head_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
    item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/rattletrap/the_neuromaniac_misc/the_neuromaniac_misc.vmdl"})
    item:FollowEntity(caster, true)
    ParticleManager:CreateParticle("particles/econ/items/clockwerk/rt_fall_the_neuromaniac_misc/rt_fall_the_neuromaniac_misc_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
    item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/rattletrap/the_neuromaniac_weapon/the_neuromaniac_weapon.vmdl"})
    item:FollowEntity(caster, true)
end

function fangyu_jihuo_add(params)
    if params.ability.rebound_damage ==nil then
        params.ability.rebound_damage = {
            victim = nil,
            attacker = params.caster,
            damage = 0,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = params.ability
        }
    end
    params.caster:AddNewModifier(params.caster, params.ability, "modifier_fangyu_jihuo_add", {})
end

function one_punch(params)
    local caster = params.caster 
    local item = nil

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/tuskarr/icelord_arms/icelord_arms.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/tuskarr/icelord_back/icelord_back.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/tuskarr/icelord_head/icelord_head.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/tuskarr/icelord_neck/icelord_neck.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/tuskarr/icelord_shoulder/icelord_shoulder.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/tuskarr/icelord_weapon/icelord_weapon.vmdl"
    })
    item:FollowEntity(caster, true)
    
    game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(caster:GetPlayerID()), "extra_attack_speed", 200)
end

function tiejiafanshang(params)
    local caster = params.caster 
    if "npc_dota_hero_centaur" ~= caster:GetUnitName() then
        return
    end
    local item = nil
    local index = nil

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/frostivus2018_cent_icehhoof_arms/frostivus2018_cent_icehhoof_arms.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/frostivus2018_cent_icehhoof_back/frostivus2018_cent_icehhoof_back.vmdl"
    })
    item:FollowEntity(caster, true)
    index = ParticleManager:CreateParticle("particles/econ/items/centaur/cent_icehoof/cent_icehoof_back_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
    ParticleManager:SetParticleControlEnt(index, 0, item, PATTACH_POINT_FOLLOW, "attach_horn", item:GetOrigin(), true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/frostivus2018_cent_icehhoof_belt/frostivus2018_cent_icehhoof_belt.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/frostivus2018_cent_icehhoof_head/frostivus2018_cent_icehhoof_head.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/frostivus2018_cent_icehhoof_shoulder/frostivus2018_cent_icehhoof_shoulder.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/frostivus2018_cent_icehhoof_tail/frostivus2018_cent_icehhoof_tail.vmdl"
    })
    item:FollowEntity(caster, true)

    item = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/centaur/centaur_ti9_immortal_weapon/centaur_ti9_immortal_weapon.vmdl"
    })
    item:FollowEntity(caster, true)
    ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti9/centaur_ti9_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
    
end

function shansuo(params)
    local caster = params.caster 
    if caster:GetUnitName() == "npc_dota_hero_phantom_assassin" then
        local item = nil
        local index = nil
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_head.vmdl"
        })
        item:FollowEntity(caster, true)
        ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_head_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/phantom_assassin/toll_of_the_fearful_aria_back/toll_of_the_fearful_aria_back.vmdl"
        })
        item:FollowEntity(caster, true)
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/phantom_assassin/toll_of_the_fearful_aria_belt/toll_of_the_fearful_aria_belt.vmdl"
        })
        item:FollowEntity(caster, true)
    
    
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_immortal_shoulders.vmdl"
        })
        item:FollowEntity(caster, true)
        ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_immortal_shoulder_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/heroes/phantom_assassin/pa_arcana_weapons.vmdl"
        })
        item:FollowEntity(caster, true)
    
        index = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_ambient_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true)
        ParticleManager:SetParticleControl(index, 26, Vector(100, 0, 0))
    
        index = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_ambient_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetOrigin(), true)
        ParticleManager:SetParticleControl(index, 26, Vector(100, 0, 0))
    
        index = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_ambient.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "attach_leg_r", caster:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 1, caster, PATTACH_POINT_FOLLOW, "attach_leg_l", caster:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 2, caster, PATTACH_POINT_FOLLOW, "attach_hand_r", caster:GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(index, 3, caster, PATTACH_POINT_FOLLOW, "attach_hand_l", caster:GetOrigin(), true)
    
        index = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_eyes_l.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "attach_eye_l", caster:GetOrigin(), true)
    
        index = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_eyes_r.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "attach_eye_r", caster:GetOrigin(), true)
    
        caster:AddActivityModifier("arcana")
    end
end

function quanshui(params)
    local caster = params.caster
    local index = ParticleManager:CreateParticle("particles/world_shrine/radiant_shrine_ambient.vpcf", 
    PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(index, 0, caster, PATTACH_POINT_FOLLOW, "", caster:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(index, 1, caster, PATTACH_POINT_FOLLOW, "", caster:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(index, 4, caster, PATTACH_POINT_FOLLOW, "", caster:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(index, 16, caster, PATTACH_POINT_FOLLOW, "", caster:GetOrigin(), true)
end