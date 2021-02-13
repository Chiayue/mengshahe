-- 宝物: 天启考验

LinkLuaModifier( "modifier_treasure_sunburst","treasuresystem/treasure_lua/modifier_treasure_oracle_test", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_meteorolite","treasuresystem/treasure_lua/modifier_treasure_oracle_test", LUA_MODIFIER_MOTION_NONE )


if modifier_treasure_oracle_test == nil then 
    modifier_treasure_oracle_test = class({})
end

-- function modifier_treasure_oracle_test:IsHidden()
--     if self:GetStackCount() > 0 then
--         return true
--     end
--     return false
-- end

function modifier_treasure_oracle_test:GetTexture()
    if self:GetDuration() < 0 then
        return "buff/modifier_treasure_oracle_test"
    end
    return "buff/modifier_treasure_keep_changing"
end

function modifier_treasure_oracle_test:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_oracle_test:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_oracle_test:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_treasure_oracle_test:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self.sunburst = self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_sunburst", {duration = 22})
    self.meteorolite = self.caster:AddNewModifier(self.caster, nil, "modifier_treasure_meteorolite", {duration = 21})
    self.isdestory = 1
    self:StartIntervalThink(21)
end

function modifier_treasure_oracle_test:OnIntervalThink()
    self.isdestory = 2
    self.caster:AddItemByName( "item_book_chaos_s" )
    -- print(" >>>>>>>>>>>> item_book_chaos_s")
    self:StartIntervalThink(-1)
end

function modifier_treasure_oracle_test:OnDeath(params)
    if not IsServer( ) then
        return
    end
    if params.unit == self.caster and self.isdestory == 1 then
        -- 判断死亡对象是否是自己
        -- self:SetStackCount(0)
        self:Destroy()
    end
end

function modifier_treasure_oracle_test:OnDestroy()
    if not IsServer() then
        return
    end
    if not self.sunburst:IsNull() then
        self.sunburst:Destroy()
    end
    if not self.meteorolite:IsNull() then
        self.meteorolite:Destroy()
    end
end

-------------------------------------------------------------------------------
-- 阳炎
if modifier_treasure_sunburst == nil then 
    modifier_treasure_sunburst = class({})
end

function modifier_treasure_sunburst:IsHidden()
    return true
end

function modifier_treasure_sunburst:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_sunburst:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_sunburst:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_treasure_sunburst:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    self.state = 1
    
    self:StartIntervalThink(2)
end

function modifier_treasure_sunburst:OnIntervalThink()
    if self.state == 1 then
        -- 预警阶段
        self.state = 2
        local randomx = RandomInt(160, 200)
        if RollPercentage(50) then
            randomx = -randomx
        end
        local randomy = RandomInt(160, 200)
        if RollPercentage(50) then
            randomy = -randomy
        end
        self.randomPos_1 = Vector(self.caster:GetOrigin().x + randomx, self.caster:GetOrigin().y + randomy, self.caster:GetOrigin().z)

        randomx = RandomInt(160, 200)
        if RollPercentage(50) then
            randomx = -randomx
        end
        randomy = RandomInt(160, 200)
        if RollPercentage(50) then
            randomy = -randomy
        end
        self.randomPos_2 = Vector(self.caster:GetOrigin().x + randomx, self.caster:GetOrigin().y + randomy, self.caster:GetOrigin().z)
        local nFXIndex_1 = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex_1, 0, self.randomPos_1 )
        ParticleManager:ReleaseParticleIndex( nFXIndex_1 )

        local nFXIndex_2 = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex_2, 0, self.randomPos_2 )
        ParticleManager:ReleaseParticleIndex( nFXIndex_2 )
        
        self:StartIntervalThink(1.5)
    else
        -- 伤害阶段
        self.state = 1
        local nFXIndex_1 = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex_1, 0, self.randomPos_1 )
        ParticleManager:ReleaseParticleIndex( nFXIndex_1 )

        local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.randomPos_1, self.caster, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				local damage = {
                    victim = enemy,
                    attacker = self.caster,
                    damage = self.caster:GetMaxHealth()*0.2,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = nil
                }
                ApplyDamage( damage )
			end
        end
        
        local nFXIndex_2 = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
		ParticleManager:SetParticleControl( nFXIndex_2, 0, self.randomPos_2 )
        ParticleManager:ReleaseParticleIndex( nFXIndex_2 )
        self:StartIntervalThink(2)

        enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.randomPos_2, self.caster, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				local damage = {
                    victim = enemy,
                    attacker = self.caster,
                    damage = self.caster:GetMaxHealth()*0.2,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = nil
                }
                ApplyDamage( damage )
			end
        end
    end
end


-------------------------------------------------------------------------------
-- 陨石
if modifier_treasure_meteorolite == nil then 
    modifier_treasure_meteorolite = class({})
end

function modifier_treasure_meteorolite:IsHidden()
    return true
end

function modifier_treasure_meteorolite:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_treasure_meteorolite:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_treasure_meteorolite:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_treasure_meteorolite:OnCreated(params)
    if not IsServer() then
        return
    end
    self.caster = self:GetCaster()
    
    self:StartIntervalThink(5)
end

function modifier_treasure_meteorolite:OnIntervalThink()
    local randomx = RandomInt(400, 500)
    if RollPercentage(50) then
        randomx = -randomx
    end
    local randomy = RandomInt(400, 500)
    if RollPercentage(50) then
        randomy = -randomy
    end
    self.randomPos_1 = Vector(self.caster:GetOrigin().x + randomx, self.caster:GetOrigin().y + randomy, self.caster:GetOrigin().z)
    
    self.unit = CreateUnitByName("yunshi_monster", self.randomPos_1, true, self.caster, self.caster:GetOwnerEntity(), DOTA_TEAM_BADGUYS)
    if self.unit then
        self.unit:AddNewModifier(self.unit, nil, "modifier_invulnerable", {})
        local hAbility = self.unit:FindAbilityByName("initiative_aerolite_lua")
        if hAbility then
            -- print(" >>>>>>>>>>>> hAbility")
            hAbility:SetLevel(1)
            -- self.unit:CastAbilityOnPosition(self.caster:GetOrigin(), hAbility, self.unit:GetEntityIndex())
            -- self.unit:CastAbilityOnTarget(self.caster, hAbility, self.unit:GetEntityIndex())
            self.CastAbility = 0
            Timers(function()
                if self.CastAbility == 0 then
                    self.CastAbility = 1
                    return 0.1
                elseif self.CastAbility == 1 then
                    self.unit:CastAbilityOnPosition(self.caster:GetOrigin(), hAbility, self.unit:GetEntityIndex())
                    self.CastAbility = 2
                    return 1
                elseif self.CastAbility == 2 then
                    if self.unit then
                        UTIL_Remove(self.unit)
                    end
                    self.CastAbility = 0
                end
            end)
        end
    else
        -- print(" >>>>>>>>>>>> unit is nil")
    end
end

function modifier_treasure_meteorolite:OnDestroy()
    if not IsServer() then
        return
    end
    if self.unit then
        UTIL_Remove(self.unit)
    end
end

