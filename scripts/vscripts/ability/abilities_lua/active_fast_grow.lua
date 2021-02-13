active_fast_grow = class({})

function active_fast_grow:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.time = GameRules:GetGameTime()
    end
end

function active_fast_grow:OnChannelThink(flInterval)
    if IsServer() then
        local now = GameRules:GetGameTime()
        if now - self.time >= 1 then
            self.time = now
            self.caster:StartGesture(ACT_DOTA_SPAWN)
            self.caster:AddExperience(300, DOTA_ModifyXP_TomeOfKnowledge, false, false)
        end 
    end
end

function active_fast_grow:OnChannelFinish(bInterrupted)
    if IsServer() then
        self.caster:AddExperience(300, DOTA_ModifyXP_TomeOfKnowledge, false, false)
    end
end