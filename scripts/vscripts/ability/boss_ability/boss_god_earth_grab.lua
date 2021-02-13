LinkLuaModifier("modifier_boss_god_earth_grab_throw", "ability/boss_ability/boss_god_earth_grab", LUA_MODIFIER_MOTION_BOTH)

-----------------------------------------------------------------------------

boss_god_earth_grab = class({})

function boss_god_earth_grab:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        self.target = self:GetCursorTarget()
        self.target:AddNewModifier(self.caster, self, "modifier_boss_god_earth_grab_throw", nil)
    end
end

--------------------------------------------------------------------------

modifier_boss_god_earth_grab_throw = class({})

function modifier_boss_god_earth_grab_throw:CheckState() 
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end

function modifier_boss_god_earth_grab_throw:IsHidden()
    return true
end

function modifier_boss_god_earth_grab_throw:IsPurgable()
    return false
end

function modifier_boss_god_earth_grab_throw:RemoveOnDeath()
    return true
end

function modifier_boss_god_earth_grab_throw:OnCreated(table)
    if IsServer() then
        self.ability = self:GetAbility()
        self.caster = self.ability.caster
        self.parent = self:GetParent()
        self.hand = self.ability.target
        self:ApplyHorizontalMotionController()
        self:ApplyVerticalMotionController()
        self:StartIntervalThink(5)
    end
end

function modifier_boss_god_earth_grab_throw:OnDestroy()
    if IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
        self.parent:RemoveVerticalMotionController(self)
    end
end

function modifier_boss_god_earth_grab_throw:OnIntervalThink()
    if IsServer() then
        if not self.caster:IsChanneling() then
            self:StartIntervalThink(-1)
            self.target = self:GetFarthestHero()
            if self.target then
                self.t_position = self.target:GetOrigin()
            else
                self.t_position = self:RandomPosition()
            end
            self.caster:FaceTowards(self.t_position)
            self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)
            local index = ParticleManager:CreateParticle(
                "particles/creatures/elemental_tiny_ping.vpcf", 
                PATTACH_WORLDORIGIN, 
                nil
            )
            ParticleManager:SetParticleControl(index, 0, self.t_position)
            ParticleManager:ReleaseParticleIndex(index)
            self.caster:SetContextThink(DoUniqueString("throw"), function ()
                self.s_position = self.caster:GetAttachmentOrigin(self.caster:ScriptLookupAttachment("attach_attack2"))
                self.throw = true
                return nil
            end, 0.3)
        end
    end
end

function modifier_boss_god_earth_grab_throw:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        self:SetNextPosition(me, dt)
    end
end

function modifier_boss_god_earth_grab_throw:UpdateVerticalMotion(me, dt)
    if IsServer() then
        self:SetNextPosition(me, dt)
        -- local height = GetGroundHeight(self.n_position, self.parent)
        if self.n_position.z < 128 then
            self.n_position.z = 128
            me:SetOrigin(self.n_position)
            self.parent:RemoveHorizontalMotionController(self)
            self.parent:RemoveVerticalMotionController(self)
            self.parent:RemoveModifierByName(self:GetClass())
        end
    end
end

function modifier_boss_god_earth_grab_throw:GetFarthestHero()
    for _, hero in pairs(HeroList:GetAllHeroes()) do
        if hero ~= self.hand and hero:IsRealHero() and hero:IsAlive() then
            return hero
        end
    end
    return nil
end

function modifier_boss_god_earth_grab_throw:RandomPosition()
    local position = self.caster:GetOrigin()
    local t_position = position + self.caster:GetForwardVector() * 1500
    while true do
        t_position = RotatePosition(position, QAngle(0, RandomInt(0, 360), 0), t_position)
        if GridNav:CanFindPath(position, t_position) then
            return t_position
        end
    end
end

function modifier_boss_god_earth_grab_throw:SetNextPosition(me, dt)
    if self.count == nil then
        self.count = 0
    end
    self.count = self.count + 1
    if self.count % 2 ~= 0 then
        if self.throw then
            self.n_position = me:GetOrigin() + (self.t_position - self.s_position):Normalized() * 2000 * dt
        else
            self.n_position = self.caster:GetAttachmentOrigin(self.caster:ScriptLookupAttachment("attach_attack2"))
        end
    end
    me:SetOrigin(self.n_position)
end
