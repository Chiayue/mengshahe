---------------------------------------------------------------------------
-- 宝物：启示录
---------------------------------------------------------------------------

if modifier_treasure_apocalypse == nil then 
    modifier_treasure_apocalypse = class({})
end

function modifier_treasure_apocalypse:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_treasure_apocalypse:GetModifierBonusStats_Strength()
    return 300
end
 
function modifier_treasure_apocalypse:GetModifierBonusStats_Agility()
    return 300
end

function modifier_treasure_apocalypse:GetModifierBonusStats_Intellect()
    return 300
end

function modifier_treasure_apocalypse:GetTexture()
    return "buff/modifier_treasure_apocalypse"
end

function modifier_treasure_apocalypse:IsHidden()
    return false
end

function modifier_treasure_apocalypse:IsPurgable()
    return false
end

function modifier_treasure_apocalypse:RemoveOnDeath()
    return false
end

function modifier_treasure_apocalypse:OnCreated(params)
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_treasure_apocalypse_a")
        parent:RemoveModifierByName("modifier_treasure_apocalypse_b")
        parent:RemoveModifierByName("modifier_treasure_apocalypse_c")
        ListenToGameEvent("player_chat", Dynamic_Wrap(modifier_treasure_apocalypse, "on_player_chated"), self)
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_apocalypse:OnIntervalThink()
    if IsServer() then
        if self:GetStackCount() > 0 then
            self:DecrementStackCount()
        end
    end
end

function modifier_treasure_apocalypse:on_player_chated(event)
    local parent = self:GetParent()
    if self:GetStackCount() <= 0 and (event.text == "末日降临" or event.text == "mrjl") and event.playerid == parent:GetPlayerID() then
        for i = 1, 3 do
            local pa = CreateUnitByName("apocalypse_pa", parent:GetOrigin(), true, parent, parent:GetPlayerOwner(), parent:GetTeamNumber())
            pa:SetOwner(parent)
            pa:AddNewModifier(nil, nil, "modifier_treasure_apocalypse_pa", nil)
        end
        self:SetStackCount(90)
		return
	end
end

-------------------------------------------------------------------------

LinkLuaModifier( "modifier_treasure_apocalypse_pa","treasuresystem/treasure_lua/modifier_treasure_apocalypse", LUA_MODIFIER_MOTION_NONE )

if modifier_treasure_apocalypse_pa == nil then 
    modifier_treasure_apocalypse_pa = class({})
end

function modifier_treasure_apocalypse_pa:CheckState()
	return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end

function modifier_treasure_apocalypse_pa:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        self.time = 0
        self.enemies = {}
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end
end

function modifier_treasure_apocalypse_pa:OnIntervalThink()
    if IsServer() then
        if #self.enemies <= 0 then
            for _, unit in pairs(global_var_func.unit_table) do
                table.insert(self.enemies, unit)
            end
            for _, hero in pairs(HeroList:GetAllHeroes()) do
                table.insert(self.enemies, hero)
            end
        end
        local enemy = nil
        while #self.enemies > 0 do
            enemy = table.remove(self.enemies, RandomInt(1, #self.enemies))
            if not enemy:IsNull() and enemy and enemy:IsAlive() and not ContainUnitTypeFlag(enemy, DOTA_UNIT_TYPE_FLAG_BOSS) and not enemy:IsInvulnerable() then
                self.parent:SetOrigin(enemy:GetOrigin() - enemy:GetForwardVector() * 100)
                self.parent:FaceTowards(enemy:GetOrigin())
                local position = enemy:GetOrigin()
                local index = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_WORLDORIGIN, enemy)
                ParticleManager:SetParticleControl(index, 0, position)
                ParticleManager:SetParticleControl(index, 1, position + enemy:GetForwardVector() * 50)
                ParticleManager:SetParticleControlForward(index, 1, enemy:GetForwardVector() * -1)
                ParticleManager:ReleaseParticleIndex(index)
                enemy:Kill(nil, self.parent)
                break
            end
        end 
        self.time = self.time + 1
        if self.time >= 5 then
            UTIL_Remove(self.parent)
        end
    end
end