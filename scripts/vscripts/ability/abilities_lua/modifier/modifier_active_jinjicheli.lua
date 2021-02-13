if modifier_active_jinjicheli == nil then 
    modifier_active_jinjicheli = class({})
end

function modifier_active_jinjicheli:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_active_jinjicheli:RemoveOnDeath()
    return false -- 死亡不移除
end

-- function modifier_active_jinjicheli:IsHidden()
--     return true    
-- end



--碎片modifier
function modifier_active_jinjicheli:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end


function modifier_active_jinjicheli:OnCreated( evt )
    if IsServer( ) then
            self:ApplyHorizontalMotionController()
            self:ApplyVerticalMotionController()
            local owner                            = self:GetParent()
            self.flHeight          = 600
            self.flDuration        = 1.7
            self.vStartPosition    = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
            self.vTargetPosition   = self.vStartPosition + owner:GetForwardVector():Normalized() * 100
            self.vTargetPosition = RotatePosition(self.vStartPosition,QAngle(0, -180, 0),self.vTargetPosition) 
            self.vDirection        = (self.vTargetPosition - self.vStartPosition):Normalized()
            self.flDistance        = evt.catapult_distance
            self.flHorizontalSpeed = self.flDistance / self.flDuration
            local pindex = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_orange_smoke.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControlEnt( pindex, 0, nil, PATTACH_CUSTOMORIGIN, "", self.vTargetPosition , true );
            ParticleManager:ReleaseParticleIndex(pindex)
    end
end

function modifier_active_jinjicheli:OnDestroy()
    if IsServer() then
        -- 移除运动控制器
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
    end
end

function modifier_active_jinjicheli:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
        -- vNewPos.z          = 0
        me:SetOrigin(vNewPos)
    end
end

function modifier_active_jinjicheli:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local pos = self:GetParent():GetOrigin()
        local vDistance  = (pos - self.vStartPosition):Length2D()
        local vZ = - 4 * self.flHeight / (self.flDistance * self.flDistance) * (vDistance * vDistance) + 4 * self.flHeight / self.flDistance * vDistance
        pos.z  = vZ
        local isEnd = false
        local flGroundHeight = GetGroundHeight( pos, self:GetParent() )
        if pos.z < flGroundHeight and vDistance > self.flDistance/2 then
            pos.z = flGroundHeight
            isEnd = true
        end
        me:SetOrigin(pos)
        if isEnd then
            self:Destroy()
        end
    end
end

