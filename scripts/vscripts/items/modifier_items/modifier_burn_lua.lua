modifier_burn_lua = class({})
function modifier_burn_lua:IsHidden() 			return true end
function modifier_burn_lua:IsDebuff() return true end
function modifier_burn_lua:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end

function modifier_burn_lua:StatusEffectPriority()
	return 15
end
function modifier_burn_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_burn_lua:OnCreated()
  if not IsServer() then
    return
  end

  --设置计时器
  self:StartIntervalThink(1)
  --启动计时器
  self:OnIntervalThink()
end

function modifier_burn_lua:OnIntervalThink()

    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(), 
        self:GetParent():GetOrigin(), --hTarget:GetOrigin()
        nil, 
        500, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
        FIND_CLOSEST, 
        false
      )
    if(#enemies > 0) then
        for a,enemy in pairs(enemies) do
            if enemy ~= nil and ( not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                local damageTable = {
                victim  =  enemy,--
                attacker = self:GetParent(),
                damage = 600,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
                }
                ApplyDamage(damageTable)
            end
        end
    end
end