if modifier_wood_overgrowth == nil then
    modifier_wood_overgrowth = ({})
end

function modifier_wood_overgrowth:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifier_wood_overgrowth:OnCreated(params)
    if IsServer() then
        self.particle_index = {}
        self:StartIntervalThink(1)
    end
end

function modifier_wood_overgrowth:OnIntervalThink()
    for i=0,global_var_func.all_player_amount -1 do
        local player = PlayerResource:GetPlayer(i)
        if player then
            local hero_positon = player:GetAssignedHero():GetOrigin()
            local cast_position = hero_positon + RandomVector(50)
            local tipIndex = ParticleManager:CreateParticle("particles/heroes/treant/dazzle_ti6_shallow_grave_ground_ray.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(tipIndex, 0,cast_position)
            table.insert(self.particle_index,tipIndex)
            Timers:CreateTimer({
                endTime = 1.8, 
                callback = function()
                    local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), cast_position, nil, 70, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
                    if heros then
                        for _,v in ipairs(heros) do
                            v:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wood_overgrowth_damage", {duration = 5})
                        end
                    end
                end
            })
        end
    end
end

function modifier_wood_overgrowth:OnDestroy()
    if IsServer() then 
        for _,v in ipairs(self.particle_index) do
            ParticleManager:DestroyParticle(v,true)
            ParticleManager:ReleaseParticleIndex(v)
        end
    end
end

if modifier_wood_overgrowth_damage == nil then
    modifier_wood_overgrowth_damage = ({})
end

function modifier_wood_overgrowth_damage:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        self.damage_percent = self:GetAbility():GetSpecialValueFor("damage_percent") / 100
        self.damage_table = self:GetAbility().damage_info
        self.damage_table.victim = hero
        self.damage_table.damage = hero:GetMaxHealth()* self.damage_percent
        local tipIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", PATTACH_ROOTBONE_FOLLOW, hero)
        ParticleManager:SetParticleControlEnt( tipIndex, 0, hero, PATTACH_ROOTBONE_FOLLOW, "", hero:GetOrigin(), true );
        hero.overgrowth_pidx = tipIndex
        -- ParticleManager:ReleaseParticleIndex(tipIndex)
        -- ParticleManager:SetParticleControlEnt( pindex, 1, hero, PATTACH_ROOTBONE_FOLLOW, "", hero:GetOrigin(), true );
    end
    
end

function modifier_wood_overgrowth_damage:OnRefresh(params)
    if IsServer() then
        local hero = self:GetParent()
        ParticleManager:DestroyParticle(hero.overgrowth_pidx, true)
        ParticleManager:ReleaseParticleIndex(hero.overgrowth_pidx)
        local tipIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", PATTACH_ROOTBONE_FOLLOW, hero)
        ParticleManager:SetParticleControlEnt( tipIndex, 0, hero, PATTACH_ROOTBONE_FOLLOW, "", hero:GetOrigin(), true );
        hero.overgrowth_pidx = tipIndex
        self.damage_table = self:GetAbility().damage_info
        self.damage_table.victim = hero
        self.damage_table.damage = hero:GetMaxHealth()* self.damage_percent
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end
end

function modifier_wood_overgrowth_damage:CheckState()
    local states = {
        [MODIFIER_STATE_ROOTED] = true,
    }
    return states
end

function modifier_wood_overgrowth_damage:OnIntervalThink()
    local caster = self:GetCaster()
    caster:Heal(caster:GetMaxHealth() * self.damage_percent, caster)
    ApplyDamage(self.damage_table)
end


function modifier_wood_overgrowth_damage:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self:GetParent().overgrowth_pidx, true)
        ParticleManager:ReleaseParticleIndex(self:GetParent().overgrowth_pidx)
    end
end
