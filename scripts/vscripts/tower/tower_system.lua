

if tower_system == nil then
    tower_system = class({})
end

local randomaure = {
    "aura_armor_improve_tower",
    "aura_speed_reduce_tower",
    "aura_damage_improve_tower",
    "aura_damage_reduce_tower",
    "aura_magical_resistance_improve_tower",
    "aure_sacrificial_lua",
    "aura_armor_reduce_tower",
    "aura_speed_increase_tower",
    "aura_huihuang_guanghuan_tower",
    "aure_health_lua",
    "initiative_phoenix_fire_tower_lua",
    "initiative_elf_fire_tower_lua",
    "initiative_shixue_tower_lua",
    "initiative_ice_armor_tower_lua",
    "initiative_soul_fire_tower_lua",
}

function getrandomaure()
    local rand = RandomInt(1, #randomaure)
    return randomaure[rand]
end

local tower_origin = {
    {{-3300, 100, 5},{-2300, 1000, 5},},-- 左上
    {{-2300, -3100, 5},{-3300, -2200, 5},},-- 左下
    {{900, -2200, 5},{-100, -3100, 5},},-- 右下
    {{-100, 1000, 5},{900, 100, 5},},-- 右上
}

function tower_system:init_tower()
    for i = 1, global_var_func.all_player_amount do
        local teamnumber = PlayerResource:GetTeam(i-1)
        for j = 1, #tower_origin[i] do
            local origin = Vector(tower_origin[i][j][1], tower_origin[i][j][2], tower_origin[i][j][3])
            if j==1 then
                CreateModifierThinker(nil, nil, "modifier_tower_repair_1", {duration = 310, type = j, teamnumber = teamnumber, playerid = (i-1), posx = tower_origin[i][j][1], posy = tower_origin[i][j][2], posz = tower_origin[i][j][3]}, origin, teamnumber, false )
            else
                CreateModifierThinker(nil, nil, "modifier_tower_repair_1", {duration = 610, type = j, teamnumber = teamnumber, playerid = (i-1), posx = tower_origin[i][j][1], posy = tower_origin[i][j][2], posz = tower_origin[i][j][3]}, origin, teamnumber, false )
            end
        end
        -- DeepPrintTable(tower_origin[i])
        -- local nFXIndex = ParticleManager:CreateParticle( "particles/items5_fx/repair_kit.vpcf", PATTACH_WORLDORIGIN, nil );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 1, nil, PATTACH_WORLDORIGIN, "", origin, true );
    end
end

if modifier_tower_repair_1 == nil then 
    modifier_tower_repair_1 = class({})
end

-- 1阶段
function modifier_tower_repair_1:OnCreated( table )
    if IsServer() then
        self.position = Vector(table.posx, table.posy, table.posz)
        self.playerid = table.playerid
        self.teamnumber = table.teamnumber
        self.type = table.type
        self.nFXIndex = ParticleManager:CreateParticle( "particles/items5_fx/repair_kit.vpcf", PATTACH_CUSTOMORIGIN	, nil );
        ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, nil, PATTACH_CUSTOMORIGIN	, "", self.position, true );
        if self.type == 1 then
            -- body
            self:SetStackCount(610)
        else
            self:SetStackCount(1210)
        end
        self.tower = call_friend_tower_1(self.position)
        self:StartIntervalThink(1)
    end
end

function modifier_tower_repair_1:OnIntervalThink()
    self:DecrementStackCount()
    utils_popups:ShowBuildTime(self.tower, self:GetStackCount())
end

function modifier_tower_repair_1:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.nFXIndex, false)
        ParticleManager:ReleaseParticleIndex(self.nFXIndex)
        if self.type == 1 then
            CreateModifierThinker(nil, nil, "modifier_tower_repair_2", {duration = 300, type = self.type, playerid = self.playerid, posx = self.position[1], posy = self.position[2], posz = self.position[3]}, self.position, self.teamnumber, false )
        else
            CreateModifierThinker(nil, nil, "modifier_tower_repair_2", {duration = 600, type = self.type, playerid = self.playerid, posx = self.position[1], posy = self.position[2], posz = self.position[3]}, self.position, self.teamnumber, false )
        end
        UTIL_Remove(self.tower)
    end
end

function modifier_tower_repair_1:IsHidden()
    return true    
end

-- 2阶段
if modifier_tower_repair_2 == nil then 
    modifier_tower_repair_2 = class({})
end

function modifier_tower_repair_2:OnCreated( table )
    if IsServer() then 
        self.position = Vector(table.posx, table.posy, table.posz)
        self.playerid = table.playerid
        self.type = table.type
        self.nFXIndex = ParticleManager:CreateParticle( "particles/items5_fx/repair_kit2.vpcf", PATTACH_CUSTOMORIGIN	, nil );
        ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, nil, PATTACH_CUSTOMORIGIN	, "", self.position, true );
        local caster = PlayerResource:GetPlayer(self.playerid):GetAssignedHero()
        if self.type == 1 then
            -- body
            self:SetStackCount(300)
        else
            self:SetStackCount(600)
        end
        self.tower = call_friend_tower_2(self.position, caster)
        self:StartIntervalThink(1)
    end
end

function modifier_tower_repair_2:OnIntervalThink()
    self:DecrementStackCount()
    utils_popups:ShowBuildTime(self.tower, self:GetStackCount())
end

function modifier_tower_repair_2:OnDestroy()
    if IsServer() then 
        ParticleManager:DestroyParticle(self.nFXIndex, false)
        ParticleManager:ReleaseParticleIndex(self.nFXIndex)
        local caster = PlayerResource:GetPlayer(self.playerid):GetAssignedHero()
        call_friend_tower(self.position, caster)
        UTIL_Remove(self.tower)
    end
end

function modifier_tower_repair_2:IsHidden()
    return true
end

function call_friend_tower_1(position)
    -- local player = caster:GetOwner(  )
    -- local ability = params.ability
    local unit = CreateUnitByName("friend_tower_1", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    -- unit:SetOwner( caster )
    unit:SetBaseMaxHealth(1)
    unit:SetMaxHealth(1)
    unit:SetHealth(1)
    -- unit:AddAbility("aura_damage_improve"):SetLevel(1)
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
    return unit
end

function call_friend_tower_2(position, caster)
    local player = caster:GetOwner()
    -- local ability = params.ability
    local unit = CreateUnitByName("friend_tower_2", position, true, caster,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner( caster )
    unit:SetBaseMaxHealth(10)
    unit:SetMaxHealth(10)
    unit:SetHealth(10)
    -- unit:AddAbility("aura_damage_improve"):SetLevel(1)
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
    return unit
end

function call_friend_tower(position, caster)
    local player = caster:GetOwner(  )
    -- local ability = params.ability
    local unit = CreateUnitByName("friend_tower", position, true, caster,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner( caster )
    unit:SetBaseMaxHealth(100)
    unit:SetMaxHealth(100)
    unit:SetHealth(100)
    unit:AddAbility(getrandomaure()):SetLevel(1)
    unit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
    return unit
end