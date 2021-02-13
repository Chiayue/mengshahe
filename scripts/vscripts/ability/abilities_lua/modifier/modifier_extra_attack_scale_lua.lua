

modifier_extra_attack_scale_lua = class({})
--------------------------------------------------------------------------------

function modifier_extra_attack_scale_lua:DeclareFunctions()
    local funcs = {
        
    }
    return funcs
end

function modifier_extra_attack_scale_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_extra_attack_scale_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_extra_attack_scale_lua:OnCreated( kv )
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0
    if not IsServer() then
        return
    end
    -- print(" >>>>>>>>>>>>>>>>>>>>>>>> kv.hero_level: "..kv.hero_level)
    if kv.hero_level > 0 then
        self:SetStackCount(kv.hero_level)
    end
    
    -- if IsServer() then
	-- 	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- 	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
	-- 	self:AddParticle( self.nFXIndex, false, false, -1, false, false )
    -- end
    
end

function modifier_extra_attack_scale_lua:GetTexture()
    return "wanderer_arcane_aura"
end

