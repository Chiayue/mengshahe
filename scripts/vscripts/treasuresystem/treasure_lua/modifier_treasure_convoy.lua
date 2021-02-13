-- 宝物: 护航任务

LinkLuaModifier( "modifier_treasure_convoy_destination","treasuresystem/treasure_lua/modifier_treasure_convoy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_convoy_endtask","treasuresystem/treasure_lua/modifier_treasure_convoy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unit_move_to_point","treasuresystem/treasure_lua/modifier_treasure_convoy", LUA_MODIFIER_MOTION_NONE )

local endpoint = {
    {-4160,1856,128,},
    {1728,1856,128,},
    {1728,-4032,128,},
    {-4160,-4032,128,},
}

if modifier_treasure_convoy == nil then 
    modifier_treasure_convoy = class({})
end

function modifier_treasure_convoy:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_convoy"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_convoy:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_convoy:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_convoy:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_treasure_convoy:OnCreated(params)
    if not IsServer() then
        return
    end
    local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/mission_begins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 红鱼转圈加强版
    self:AddParticle( nFXIndex, false, false, -1, false, true )
    
    local randnum = RandomInt(1,4)
    self.caster = self:GetCaster()
    self.modifi = CreateModifierThinker( self.caster, nil, "modifier_treasure_convoy_destination", {duration = 300, px = endpoint[randnum][1], py = endpoint[randnum][2], pz = endpoint[randnum][3],}, Vector(endpoint[randnum][1], endpoint[randnum][2], endpoint[randnum][3]), self.caster:GetTeamNumber(), false )
    
    self.unit = CreateTaskNpc(self.caster:GetPlayerID(), "task_works", Vector(-1184, -1024, 320), Vector(endpoint[randnum][1], endpoint[randnum][2], endpoint[randnum][3]))
    
    self:StartIntervalThink(300)
end

function modifier_treasure_convoy:OnIntervalThink()
    UTIL_Remove(self.unit)
    send_error_tip(self.caster:GetPlayerID(), "error_taskfalse")
    DeleteTreasureForHero(self.caster, "modifier_treasure_convoy")
end
----------------------------------------------------------------------------------

modifier_treasure_convoy_destination = class({})

function modifier_treasure_convoy_destination:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_treasure_convoy_destination:IsHidden()
    return true
end

function modifier_treasure_convoy_destination:IsAura()
    return true
end

function modifier_treasure_convoy_destination:IsAuraActiveOnDeath()
    return true
end

function modifier_treasure_convoy_destination:GetAuraRadius()
    return 100
end

function modifier_treasure_convoy_destination:GetModifierAura()
    return "modifier_treasure_convoy_endtask"
end

function modifier_treasure_convoy_destination:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_treasure_convoy_destination:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_treasure_convoy_destination:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_treasure_convoy_destination:OnCreated( kv )
    if not IsServer() then
        return
    end
    self.point = Vector(kv.px, kv.py, kv.pz)
    -- 创建一个目标点的特效
	self.index = ParticleManager:CreateParticle(
        "particles/diy_particles/clicked_basemove.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(self.index, 0, self.point)
    -- ParticleManager:SetParticleControl(self.index, 1, Vector(kv.radius-300, 0, 0))
    self:StartIntervalThink(1)
end

function modifier_treasure_convoy_destination:OnIntervalThink()
    -- 创建一个目标点的特效
	self.index = ParticleManager:CreateParticle(
        "particles/diy_particles/clicked_basemove.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(self.index, 0, self.point)
end

--------------------------------------------------------------------------------
modifier_treasure_convoy_endtask = class({})

function modifier_treasure_convoy_endtask:IsHidden()
    return true
end

function modifier_treasure_convoy_endtask:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_treasure_convoy_endtask:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent();
    self.attack = self:GetCaster();
    if self.caster:GetUnitName() == "task_works" then
        -- 任务完成,发放奖励
        local gold = global_var_func.current_round*2000
        game_playerinfo:set_player_gold(self.attack:GetPlayerID(), gold)
        send_tips_message(self.attack:GetPlayerID(), "成功完成任务,获得奖励!")
        UTIL_Remove(self.caster)

        local modifiname = self.attack:FindModifierByName("modifier_treasure_convoy")
        if modifiname then
            modifiname.modifi:Destroy()
            modifiname:StartIntervalThink(-1)
        end
    end
end


--------------------------------------------------------------------------------
modifier_unit_move_to_point = class({})

function modifier_unit_move_to_point:IsHidden()
    return true
end

function modifier_unit_move_to_point:DeclareFunctions()
    local funcs = {
    }
    return funcs
end


function modifier_unit_move_to_point:OnCreated( kv )
    if not IsServer( ) then
        return
    end
    self.caster = self:GetParent();
    self.end_position = Vector(kv.endx, kv.endy, kv.endz)
    self:OnIntervalThink()
    self:StartIntervalThink(1)
end

function modifier_unit_move_to_point:OnIntervalThink()
    -- if self.caster:GetOrigin() == self.end_position then
    --     self:StartIntervalThink(-1)
    --     self:Destroy()
    --     return
    -- end
    -- print(">>>>>>>>> "..self.caster:GetUnitName())
    self.caster: MoveToPosition(self.end_position)
end