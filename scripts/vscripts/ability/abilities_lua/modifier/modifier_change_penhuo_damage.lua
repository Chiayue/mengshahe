modifier_change_penhuo_damage = class({})


function modifier_change_penhuo_damage:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
    self.damage_info = {
        victim = nil,
        attacker = self:GetParent(),
        damage = 0,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }
end

function modifier_change_penhuo_damage:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    for i = 1,4 do 
        if ability["point_"..i] then
            local units = FindUnitsInLine(caster:GetTeamNumber(), caster:GetOrigin(), ability["point_"..i], nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
            for _,v in pairs(units) do
                if v and v:IsAlive() then
                    local damage_amount = v:GetMaxHealth() * 0.15
                    -- local damage = {
                    --     victim = v,
                    --     attacker = caster,
                    --     damage = damage_amount,
                    --     damage_type = DAMAGE_TYPE_MAGICAL,
                    --     ability = ability
                    -- }
                    self.damage_info.victim = v
                    self.damage_info.damage = damage_amount
                    ApplyDamage( self.damage_info )
                end
            end
        end
    end
end

