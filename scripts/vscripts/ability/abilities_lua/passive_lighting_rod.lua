LinkLuaModifier("modifier_passive_lighting_rod", "ability/abilities_lua/passive_lighting_rod.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_lighting_rod_buff", "ability/abilities_lua/passive_lighting_rod.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

passive_lighting_rod = class({})

function passive_lighting_rod:GetIntrinsicModifierName()
	return "modifier_passive_lighting_rod"
end

-------------------------------------------------------------

modifier_passive_lighting_rod = class({})

function modifier_passive_lighting_rod:CheckState()
	return {}
end

function modifier_passive_lighting_rod:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_START,
    }
end

function modifier_passive_lighting_rod:OnAbilityStart(params)
    local position = self.parent:GetOrigin()
    local index = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(index, 0, position)
    ParticleManager:ReleaseParticleIndex(index)
    local enemies = FindUnitsInRadius( 
        self.parent:GetTeamNumber(), 
        self.parent:GetOrigin(), 
        nil, 
        600, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_ALL, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, 
        false 
    )
    local num = RandomInt(2, 6)
    local count = 0
    for key, enemy in pairs(enemies) do
        if enemy and enemy:IsAlive() then
            count = count + 1
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_passive_lighting_rod_buff", {entity_index = enemy:GetEntityIndex()})
            if count >= num then
                break
            end 
        end
    end
end

function modifier_passive_lighting_rod:IsHidden()
    return true
end

function modifier_passive_lighting_rod:IsPurgable()
    return false
end
 
function modifier_passive_lighting_rod:RemoveOnDeath()
    return false
end

function modifier_passive_lighting_rod:OnCreated(params)
    if IsServer() then
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
    end
end

-------------------------------------------------------------

modifier_passive_lighting_rod_buff = class({})

function modifier_passive_lighting_rod_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_passive_lighting_rod_buff:IsHidden()
    return true
end

function modifier_passive_lighting_rod_buff:IsPurgable()
    return false
end
 
function modifier_passive_lighting_rod_buff:RemoveOnDeath()
    return true
end

function modifier_passive_lighting_rod_buff:OnCreated(params)
    if IsServer() then
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.current = self.parent
        self.next = EntIndexToHScript(params.entity_index)
        self.enemies = FindUnitsInRadius( 
			self.next:GetTeamNumber(), 
			self.next:GetOrigin(), 
			nil, 
			3000, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_ALL, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_CLOSEST, 
			false 
        )
        table.insert(self.enemies, 1, self.next)
        self.length = #self.enemies
        self.index = 1
        self.count = 0
        self:OnIntervalThink()
        self:StartIntervalThink(0.1)
    end
end

function modifier_passive_lighting_rod_buff:OnIntervalThink()
    if IsServer() then
        if self.index < self.length and self.count < 7 then
            for i = self.index, self.length do
                self.index = i + 1
                local enemy = self.enemies[self.index]
                if enemy and enemy:IsAlive() then
                    if (self.current:GetOrigin() - enemy:GetOrigin()):Length2D() > 500 then
                        self:StartIntervalThink(-1)
                        self:Destroy()
                        return
                    end
                    self.next = enemy
                    self.p_index = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_WORLDORIGIN, nil)
                    ParticleManager:SetParticleControl(self.p_index, 0, self.next:GetOrigin())
                    ParticleManager:SetParticleControl(self.p_index, 1, self.current:GetOrigin())
                    ParticleManager:ReleaseParticleIndex(self.p_index)
                    ApplyDamage({
                        victim = self.next,
                        attacker = self.parent,
                        damage = (self.parent:GetAgility() + self.parent:GetStrength()) * 6,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self.ability
                    })
                    self.current = self.next
                    self.count = self.count + 1
                    break
                end
            end
        else
            self:StartIntervalThink(-1)
            self:Destroy()
        end
    end
end