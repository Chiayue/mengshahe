require("global/global_var_func")
require("info/game_playerinfo")

modifier_intellect_gain_lua = class({})
--------------------------------------------------------------------------------

function modifier_intellect_gain_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_intellect_gain_lua:IsHidden()
    return true
end

function modifier_intellect_gain_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_intellect_gain_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_intellect_gain_lua:OnCreated( kv )
    self.intellect_gain = self:GetAbility():GetSpecialValueFor( "intellect_gain" ) or 0
    if not IsServer( ) then
        return
    end
    self:StartIntervalThink( 0.01 )
	-- self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	-- self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	-- self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	-- self.flFierySoulDuration = 0

	-- if IsServer() then
	-- 	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- 	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
	-- 	self:AddParticle( self.nFXIndex, false, false, -1, false, false )
    -- end
    
end

function modifier_intellect_gain_lua:OnIntervalThink()
    ListenToGameEvent("dota_player_gained_level",Dynamic_Wrap(modifier_intellect_gain_lua,'hero_level_up'),self)
	self.intellect_gain = self:GetAbility():GetSpecialValueFor( "intellect_gain" ) or 0
    self:StartIntervalThink( -1 )
end

function modifier_intellect_gain_lua:hero_level_up(evt)
    local caster = self:GetAbility():GetCaster()
    if caster:GetPlayerID() ~= evt.player_id then
        return
    end
    caster:SetBaseIntellect(caster:GetBaseIntellect()+self.intellect_gain)
end

