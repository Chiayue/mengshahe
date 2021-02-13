if modifier_wood_tuji == nil then
    modifier_wood_tuji = ({})
end

function modifier_wood_tuji:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_wood_tuji:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_wood_tuji:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_wood_tuji:OnCreated(params)
    if IsServer() then
        local caster= self:GetParent()
        self.vDirection = caster:GetForwardVector()
        self.endPoint = Vector(params.px,params.py,params.pz)
        self.distance =(caster:GetOrigin() - self.endPoint):Length2D()
        if self.distance <1500 then
            self.distance = 1500
        end
        self.moveSpeed = self.distance/self:GetRemainingTime()
        self:ApplyHorizontalMotionController()
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_wood_tuji_damage", {duration = self:GetRemainingTime()})
    end
end


function modifier_wood_tuji:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.moveSpeed * dt
        me:SetOrigin(vNewPos)
    end
end

function modifier_wood_tuji:OnDestroy()
    if IsServer() then
        -- 移除运动控制器
        self:GetParent():RemoveHorizontalMotionController(self)
    end
end

if modifier_wood_tuji_damage == nil then
    modifier_wood_tuji_damage = ({})
end

function modifier_wood_tuji_damage:OnCreated(params)
    if IsServer() then
        local ability = self:GetAbility()
        self.damage_info = {
            victim = nil,
            attacker = self:GetParent(),
            damage = 0,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = ability
        }
        self.damage_percent = ability:GetSpecialValueFor("damage_percent") / 100
        -- print(self.damage_percent )
        self.destroy_particle = {}
        self:StartIntervalThink(0.05)
        Timers:CreateTimer({
            endTime = 3, 
            callback = function()
                for k,v in ipairs(self.destroy_particle) do
                    ParticleManager:DestroyParticle(v,true)
                    ParticleManager:ReleaseParticleIndex(v)
                end
            end
        })
    end
end

function modifier_wood_tuji_damage:OnIntervalThink()
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local units = FindUnitsInRadius( caster:GetTeamNumber(),caster:GetOrigin(),nil,140,DOTA_UNIT_TARGET_TEAM_ENEMY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
    for _,v in ipairs(units) do
        if not v:HasModifier("modifier_wood_tuji_damage_mark") then
            v:AddNewModifier(caster, ability, "modifier_common_stun" , {duration = 2})
            self.damage_info.victim = v
            self.damage_info.damage = v:GetMaxHealth() * self.damage_percent
            ApplyDamage( self.damage_info )
            v:AddNewModifier(caster, ability, "modifier_wood_tuji_damage_mark" , {duration = 2})
        end
    end
    local jsIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(jsIndex, 0,caster:GetOrigin())
    ParticleManager:SetParticleControl(jsIndex, 1, caster:GetOrigin())
    table.insert(self.destroy_particle,jsIndex)
end

function modifier_wood_tuji_damage:IsHidden()
    return true
end

if modifier_wood_tuji_damage_mark == nil then
    modifier_wood_tuji_damage_mark = ({})
end

function modifier_wood_tuji_damage_mark:IsHidden()
    return true
end