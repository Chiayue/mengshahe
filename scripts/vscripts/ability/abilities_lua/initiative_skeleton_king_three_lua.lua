
--骷髅王技能3
initiative_skeleton_king_three_lua = class({})
LinkLuaModifier( "modifier_skeleton_king_three_lua","ability/abilities_lua/initiative_skeleton_king_three_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_remove_speed_poison_lua","ability/abilities_lua/initiative_skeleton_king_three_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_three_damage","ability/abilities_lua/initiative_skeleton_king_three_lua", LUA_MODIFIER_MOTION_NONE )
--开始施法
function initiative_skeleton_king_three_lua:GetAOERadius()
	return 450
end
function initiative_skeleton_king_three_lua:OnSpellStart()


    local caster = self:GetCaster()
    self.vPos = nil
	if self:GetCursorTarget() then
		self.vPos = self:GetCursorTarget():GetOrigin()
	else
		self.vPos = self:GetCursorPosition()
    end
    -- ACT_DOTA_GENERIC_CHANNEL_1/cast1_hellfire_blast_injured_frostivus
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
    -- Timers:CreateTimer(10, function()
        CreateModifierThinker(
            caster, 
            self, 
            "modifier_skeleton_king_three_lua", 
            {
                duration = 5
            }, 
            self.vPos, 
            self:GetCaster():GetTeamNumber(), 
            false
        )

    -- end)
end
    

modifier_skeleton_king_three_lua = class({})

function modifier_skeleton_king_three_lua:IsHidden()
    return true
end

function modifier_skeleton_king_three_lua:OnCreated(kv)
    if not IsServer() then
		return
    end
    self.count = 5
    local caster = self:GetAbility():GetCaster()
    self.index = ParticleManager:CreateParticle("particles/diy_particles/ambient14.vpcf", PATTACH_WORLDORIGIN,  caster)
    ParticleManager:SetParticleControl(self.index, 0, self:GetAbility():GetCursorPosition())

   	--设置计时器时间
    self:StartIntervalThink(1)
    
end
function modifier_skeleton_king_three_lua:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()

    if self.count  <= 1 then
        self:Destroy()
        return
    end
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        self:GetAbility().vPos,
        self:GetAbility(),
        450,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
        1,
        false
    )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() )  then
                enemy:AddNewModifier(caster,self:GetAbility(), "modifier_skeleton_king_three_damage", { duration = 3})
                enemy:AddNewModifier(caster,self:GetAbility(), "modifier_remove_speed_poison_lua", { duration = 1})
            end
        end
    end 
    self.count = self.count - 1
end

function modifier_skeleton_king_three_lua:OnDestroy()
	if not IsServer() then
		return
    end
	ParticleManager:DestroyParticle(self.index, false)
    ParticleManager:ReleaseParticleIndex( self.index)
    self:GetParent():RemoveModifierByName("modifier_skeleton_king_three_lua")
    UTIL_Remove(self:GetParent())
end

modifier_remove_speed_poison_lua = class({})

function modifier_remove_speed_poison_lua:IsHidden()
    return true
end
function modifier_remove_speed_poison_lua:OnCreated(kv)
    if not IsServer() then
		return
    end
end
function modifier_remove_speed_poison_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_remove_speed_poison_lua:GetModifierMoveSpeedBonus_Percentage() return -20 end


--持续伤害
modifier_skeleton_king_three_damage = class({})

function modifier_skeleton_king_three_damage:IsHidden()
    return true
end
function modifier_skeleton_king_three_damage:OnCreated(kv)
    if not IsServer() then
		return
    end
  	--设置计时器时间
      self:StartIntervalThink(1)

end
function modifier_skeleton_king_three_damage:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    local damage = {
        victim =  self:GetParent(),
        attacker = caster,
        damage = 500,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }
    ApplyDamage(damage) 
end
function modifier_skeleton_king_three_damage:GetEffectName()
	return "particles/diy_particles/shui_skill1_2.vpcf"
end


function modifier_skeleton_king_three_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end