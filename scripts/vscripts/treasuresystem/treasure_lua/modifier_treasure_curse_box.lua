-- 宝物: 诅咒宝箱

LinkLuaModifier( "modifier_treasure_feebleness","treasuresystem/treasure_lua/modifier_treasure_curse_box", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_curse_box == nil then 
    modifier_treasure_curse_box = class({})
end

function modifier_treasure_curse_box:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_curse_box"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_curse_box:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_curse_box:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_curse_box:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_treasure_curse_box:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self:SetStackCount(0)
    self.killnumber = 0
    self.listenindex = ListenToGameEvent("entity_killed",Dynamic_Wrap(modifier_treasure_curse_box,'killed_monster'),self)
    self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_feebleness", {duration = 90})
end

function modifier_treasure_curse_box:killed_monster(evt)
    -- DeepPrintTable(evt)
    local monster = EntIndexToHScript(evt.entindex_killed)
    -- 怪的击杀者
    local hero = EntIndexToHScript(evt.entindex_attacker)
    
    if self.caster~=hero then
        -- 怪必须是自己击杀的
        return
    end
    self.killnumber = self.killnumber + 1
    -- print(">>>>>>>killnumber: "..self.killnumber)
    if self.killnumber >= 10 then
        -- 发放奖励
        game_playerinfo:set_player_gold(self.caster:GetPlayerID(),(5000+global_var_func.current_round*1000))
        local delmodifier = self.caster:FindModifierByName("modifier_treasure_feebleness")
        if delmodifier then
            delmodifier:Destroy()
        end
        self:SetStackCount(0)
        StopListeningToGameEvent(self.listenindex)
    end
    -- end
end

function modifier_treasure_curse_box:OnDestroy()
    if not IsServer() then
        return
    end
    StopListeningToGameEvent(self.listenindex)
end

---------------------------------------------------------------------------------
if modifier_treasure_feebleness == nil then 
    modifier_treasure_feebleness = class({})
end

function modifier_treasure_feebleness:IsHidden()
    return true
end

function modifier_treasure_feebleness:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_feebleness:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
    return funcs
end

function modifier_treasure_feebleness:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self:SetStackCount(15)
    self.delmodifier = self.caster:FindModifierByName("modifier_treasure_curse_box")
    self.delmodifier:SetStackCount(15)
end

function modifier_treasure_feebleness:GetModifierAvoidDamage(params)
    if not IsServer() then
        return 0
    end
    if self:GetStackCount() > 0 then
        self:DecrementStackCount()
        self.delmodifier:SetStackCount(self:GetStackCount())
        local nFXIndex = ParticleManager:CreateParticle( "particles/diy_particles/mofadun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        return params.damage
    end
    self.caster:Kill(nil, params.attacker)
    return 0
end

function modifier_treasure_feebleness:OnDestroy()
    if not IsServer() then
        return
    end
    if self.delmodifier.killnumber < 10 then
        DeleteTreasureForHero(self.caster, "modifier_treasure_curse_box")
    end
end