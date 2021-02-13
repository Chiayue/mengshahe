if modifier_kill_self == nil then 
    modifier_kill_self = class({})
end

function modifier_kill_self:DeclareFunctions()
    local funcs = {
 
    }
    return funcs
end

function modifier_kill_self:IsHidden()
    return true
end

function modifier_kill_self:OnCreated( evt )
    if IsServer( ) then
        local unit = self:GetParent()
        local hero = unit:GetOwner()
        if hero ~= nil and hero:IsHero() then
            hero.call_unit["u"..unit:GetEntityIndex()] = unit
        end
        self.noParticle = evt.noParticle
        if evt.count_index then
            self.count_entity = EntIndexToHScript(evt.count_index) 
        end
    end 
end

function modifier_kill_self:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsNull()then
            return
        end
        parent:AddNewModifier(nil, self, "modifier_kill_self_rooted", {})
        local hero = parent:GetOwner()
        if hero and hero:IsHero() then
            hero.call_unit["u"..parent:GetEntityIndex()] = nil
        end
        parent:Stop()
        --计数
        if self.count_entity then
            local count_modifier = self.count_entity:FindModifierByName("modifier_kill_self_count")
            count_modifier:SetStackCount(count_modifier:GetStackCount()-1)
        end
        if self.noParticle then
            UTIL_Remove(parent)
            return
        end
        if self:GetRemainingTime() > 0 then
            return
        end
        local pindex = ParticleManager:CreateParticle( "particles/econ/events/fall_major_2016/teleport_end_fm06_lvl2.vpcf", PATTACH_POINT	, parent );
        ParticleManager:SetParticleControlEnt( pindex, 0, nil, PATTACH_POINT, "", parent:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( pindex, 1, nil, PATTACH_POINT, "", parent:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( pindex, 2, nil, PATTACH_POINT, "", parent:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( pindex, 3, nil, PATTACH_POINT, "", parent:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( pindex, 4, nil, PATTACH_POINT, "", parent:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( pindex, 5, nil, PATTACH_POINT, "", parent:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(pindex)
        -- ParticleManager:SetParticleControlEnt( pindex, 3, nil, PATTACH_WORLDORIGIN, "", unit:GetOrigin(), true );
        Timers:CreateTimer({
            endTime = 1, 
            callback = function()
                if parent then
                    UTIL_Remove(parent)
                end
            end
        })
        
        -- self:GetParent():ForceKill(false)
    end
end

-- function modifier_kill_self:CheckState()
-- 	return {[MODIFIER_STATE_FROZEN] = true,}
-- end


--计数器
if modifier_kill_self_count == nil then 
    modifier_kill_self_count = class({})
end

function modifier_kill_self_count:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)
    end
end

function modifier_kill_self_count:OnRefresh(params)
    if IsServer() then
        self:IncrementStackCount()
    end
end

function modifier_kill_self_count:RemoveOnDeath()
    return false
end

function modifier_kill_self_count:IsHidden()
    return true
end


if modifier_kill_self_rooted == nil then 
    modifier_kill_self_rooted = class({})
end

function modifier_kill_self_rooted:IsHidden()
	return true
end

function modifier_kill_self_rooted:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true,}
end