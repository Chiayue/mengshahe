
modifier_physical_armor_lua = class({})
--------------------------------------------------------------------------------

function modifier_physical_armor_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS ,
    }
    return funcs
end

function modifier_physical_armor_lua:IsHidden()
    return true
end

function modifier_physical_armor_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_physical_armor_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_physical_armor_lua:OnCreated( kv )
    self.physical_armor = self:GetAbility():GetSpecialValueFor( "physical_armor" )
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
    -- print(">>>>>>>>>>> self.physical_armor: "..self.physical_armor)
end

function modifier_physical_armor_lua:OnIntervalThink()
    self.physical_armor = self:GetAbility():GetSpecialValueFor( "physical_armor" )
    self:StartIntervalThink( -1 )
end

function modifier_physical_armor_lua:GetModifierPhysicalArmorBonus()
    -- return self.physical_armor
    if self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        return -5
    else 
        return -20
    end
end

