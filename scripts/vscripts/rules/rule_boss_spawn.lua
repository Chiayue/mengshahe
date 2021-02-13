rule_boss_spawn = class({})

function rule_boss_spawn: SpawnWorldBoss(bossname)
    self.bossname = bossname
    self:CreateBornParticle()
    self:CreateBoss()
    local health = self.boss:GetHealth()
    CustomGameEventManager:Send_ServerToAllClients("show_boss_health_bar", {
        name = self.boss:GetUnitName(),
        num = self:GetHPNum(health),
        loss = self:GetCurrentLoss(health),
        time = self.boss.alive_time,
    })
    self:SetSounds()
    self:SetThinks()
end

function rule_boss_spawn: CreateBornParticle()
    local born_particle = {
        ["boss_god_metal"] = "particles/diy_particles/ambient13.vpcf",
        ["boss_god_wood"] = "particles/diy_particles/ambient14.vpcf",
        ["boss_god_water"] = "particles/diy_particles/ambient15.vpcf",
        ["boss_god_fire"] = "particles/diy_particles/ambient16.vpcf",
        ["boss_god_earth"] = "particles/diy_particles/ambient17.vpcf",
    }
    self.position = Entities:FindByName(nil, "call_boss_corner"):GetAbsOrigin()
    self.bp_index = ParticleManager:CreateParticle(born_particle[self.bossname], PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.bp_index, 0, self.position)
end

function rule_boss_spawn: CreateBoss()
    local unit = CreateUnitByName(
        self.bossname,
        self.position,
        true,
        nil,
        nil,
        DOTA_TEAM_BADGUYS
    )
    unit.alive_time = 300
    self.boss = unit
    self:BossGrowth()
    local face_position = self.position
    face_position.y = face_position.y - 100
    unit:FaceTowards(face_position)
    unit:SetContext("unit_type", "2", 0)
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", nil)
    unit:AddNewModifier(nil, nil, "modifier_conmon_boss", nil)
    unit:StartGesture(ACT_DOTA_SPAWN)
end

function rule_boss_spawn: BossGrowth()
    local unit = self.boss
    local level = GameRules:GetCustomGameDifficulty()
    if level == 1 then
        -- 攻击力
        unit: SetBaseDamageMin(1500)
        unit: SetBaseDamageMax(1500)
        -- 血量
        unit: SetBaseMaxHealth(900000)
        unit: SetMaxHealth(900000)
        unit: SetHealth(900000)
        return
    end
    if level == 2 then
        -- 攻击力
        unit: SetBaseDamageMin(2250)
        unit: SetBaseDamageMax(2250)
        -- 血量
        unit: SetBaseMaxHealth(1800000)
        unit: SetMaxHealth(1800000)
        unit: SetHealth(1800000)
        return
    end
    if level == 3 then
        -- 攻击力
        unit: SetBaseDamageMin(3000)
        unit: SetBaseDamageMax(3000)
        -- 血量
        unit: SetBaseMaxHealth(2700000)
        unit: SetMaxHealth(2700000)
        unit: SetHealth(2700000)
        return
    end
    if level == 4 then
        -- 攻击力
        unit: SetBaseDamageMin(3750)
        unit: SetBaseDamageMax(3750)
        -- 血量
        unit: SetBaseMaxHealth(3600000)
        unit: SetMaxHealth(3600000)
        unit: SetHealth(3600000)
        return
    end
    if level == 5 then
        -- 攻击力
        unit: SetBaseDamageMin(4500)
        unit: SetBaseDamageMax(4500)
        -- 血量
        unit: SetBaseMaxHealth(4500000)
        unit: SetMaxHealth(4500000)
        unit: SetHealth(4500000)
        return
    end
    if level == 6 then
        -- 攻击力
        unit: SetBaseDamageMin(5250)
        unit: SetBaseDamageMax(5250)
        -- 血量
        unit: SetBaseMaxHealth(5400000)
        unit: SetMaxHealth(5400000)
        unit: SetHealth(5400000)
        return
    end
    if level == 7 then
        -- 攻击力
        unit: SetBaseDamageMin(6000)
        unit: SetBaseDamageMax(6000)
        -- 血量
        unit: SetBaseMaxHealth(6300000)
        unit: SetMaxHealth(6300000)
        unit: SetHealth(6300000)
        return
    end
end

function rule_boss_spawn: SetSounds()
    StopGlobalSound("game.beginbgm")
    EmitGlobalSound("boss.enter1")
end

function rule_boss_spawn: SetThinks()
    local unit = self.boss
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("call_boss_corner_1"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if not unit:IsMoving() and not unit:IsChanneling() and not unit:IsAttacking() then
            return 1
        end
        StopGlobalSound("boss.enter1")
        EmitGlobalSound("boss.fighting")
        ParticleManager:DestroyParticle(self.bp_index, false)
        ParticleManager:ReleaseParticleIndex(self.bp_index)
        self.boss:RemoveModifierByName("modifier_invulnerable")
        return nil
    end, 0)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("call_boss_corner_2"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if not unit.alive_time then
            unit.alive_time = 300
            return 1
        end
        unit.alive_time = unit.alive_time - 1
        if not unit:IsAlive() or unit.alive_time <= 0 then
            CustomGameEventManager:Send_ServerToAllClients("close_boss_health_bar", nil)
            StopGlobalSound("boss.fighting")
            if unit and not unit:IsNull() and unit:IsAlive() then
                unit:AddNewModifier(nil, nil, "modifier_common_tp", nil)
            end
            return nil
        end
        return 1
    end, 0)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("call_boss_corner_3"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if unit and not unit:IsNull() and unit:IsAlive() then
            local health = unit:GetHealth()
            CustomGameEventManager:Send_ServerToAllClients("update_boss_hp", {
                name = unit:GetUnitName(),
                num = self:GetHPNum(health),
                loss = self:GetCurrentLoss(health),
                time = unit.alive_time,
            })
            return 1 / 60
        end
        return nil
    end, 0)
end

function rule_boss_spawn: GetHPNum(health)
    if health < global_var_func.final_boss_hp_each then
        return 0
    end
    if math.fmod(health, global_var_func.final_boss_hp_each) == 0 then
        return math.floor(health / global_var_func.final_boss_hp_each) - 1
    end
    return math.floor(health / global_var_func.final_boss_hp_each)
end

function rule_boss_spawn: GetCurrentLoss(health)
    local loss = math.fmod(health, global_var_func.final_boss_hp_each)
    if health ~= 0 and loss == 0 then
        loss = global_var_func.final_boss_hp_each
    end
    return math.floor(loss * 100 / global_var_func.final_boss_hp_each)
end

function rule_boss_spawn: SpawnFinallyBoss()
    local boss = CreateUnitByName(
        "boss_finally",
        Vector(0, 0, -1000),
        true,
        nil,
        nil,
        DOTA_TEAM_BADGUYS
    )
    AppendUnitTypeFlag(boss, global_var_func.flag_boss_finally)
    SetUnitBaseValue(boss)
    boss:AddNewModifier(nil, nil, "modifier_conmon_boss", nil)
    local health = boss:GetHealth()
    CustomGameEventManager:Send_ServerToAllClients("show_boss_health_bar", {
        name = boss:GetUnitName(),
        num = self:GetHPNum(health),
        loss = self:GetCurrentLoss(health),
        time = global_var_func.final_boss_alive_time,
    })
    boss:SetOrigin(GetGroundPosition(Vector(-1184.66,-1026.62,568.624), boss))
    boss:StartGesture(ACT_DOTA_SPAWN)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("finally_boss"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if not boss.alive_time then
            boss.alive_time = global_var_func.final_boss_alive_time
            return 1
        end
        boss.alive_time = boss.alive_time - 1
        if not boss:IsAlive() or boss.alive_time <= 0 then
            CustomGameEventManager:Send_ServerToAllClients("close_boss_health_bar", nil)
            global_var_func.final_boss = true
            return nil
        end
        return 1
    end, 0)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("update_finally_boss"), function ()
        if GameRules:IsGamePaused() then
            return 1
        end
        if boss and not boss:IsNull() and boss:IsAlive() then
            local health1 = boss:GetHealth()
            CustomGameEventManager:Send_ServerToAllClients("update_boss_hp", {
                name = boss:GetUnitName(),
                num = self:GetHPNum(health1),
                loss = self:GetCurrentLoss(health1),
                time = boss.alive_time,
            })
            return 1 / 60
        end
        return nil
    end, 0)
end