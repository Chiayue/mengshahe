require("global/global_var_func")
require("info/game_playerinfo")

modifier_heath_hp_lua = class({})
--------------------------------------------------------------------------------

function modifier_heath_hp_lua:DeclareFunctions()
    local funcs = {
        -- MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_heath_hp_lua:IsHidden()
    return true
end

function modifier_heath_hp_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_heath_hp_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_heath_hp_lua:OnCreated( kv )
    self.heath_hp = self:GetAbility():GetSpecialValueFor( "heath_hp" )
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

function modifier_heath_hp_lua:OnIntervalThink()
    self.heath_hp = self:GetAbility():GetSpecialValueFor( "heath_hp" )
	-- print(">>>>>>>>>>> speed OnCreated: "..self.attack_speed)
	local steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
	-- print(">>>>>>>>>>> steam_id: "..steam_id)
	game_playerinfo:set_dynamic_properties(steam_id, "attack_heal", self.heath_hp)
    self:StartIntervalThink( -1 )
end

