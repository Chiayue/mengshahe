LinkLuaModifier("modifier_bomb_thinker","ability/abilities_lua/initiative_bomb_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bomb_effect","ability/abilities_lua/initiative_bomb_lua",LUA_MODIFIER_MOTION_NONE)
--树爆术
initiative_bomb_lua = class({})
initiative_bomb_lua_d = initiative_bomb_lua
initiative_bomb_lua_c = initiative_bomb_lua
initiative_bomb_lua_b = initiative_bomb_lua
initiative_bomb_lua_a = initiative_bomb_lua
initiative_bomb_lua_s = initiative_bomb_lua
function initiative_bomb_lua:OnSpellStart()
  -- --body
  local caster = self:GetCaster()
  local point = self:GetCursorPosition()
  local team_id = caster:GetTeamNumber()
  local thinker = CreateModifierThinker(caster,self,"modifier_bomb_thinker",{duration = 3},point,team_id,false)
  -- CreateTempTree(point,3)
  EmitSoundOn( "UI.Click1", self:GetCaster() )

  local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/events/new_bloom/new_bloom_tree_cast.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
  ParticleManager:SetParticleControl( nFXIndex, 0, point )
  ParticleManager:ReleaseParticleIndex( nFXIndex )

  CreateTempTreeWithModel(point,3,"models/props_tree/mango_tree.vmdl")



  -- local player = caster:GetOwner(  )
  -- local position = caster:GetAbsOrigin()
  -- for i = 0, 2 do
  --   local unit = CreateUnitByName("task_smith", position, true, caster,player, DOTA_TEAM_BADGUYS )
  --   unit:SetOwner(caster)
  --   -- unit:AddAbility(creep_ability_name):SetLevel(1)
  --   local explosion = unit:AddAbility("passive_poisonous_lua")
  --   explosion:SetLevel(1)

  -- end

end
function initiative_bomb_lua:GetAOERadius()
	return 500
end
modifier_bomb_thinker = class({})

function modifier_bomb_thinker:OnCreated()
  if not IsServer() then
    return 
  end
  --body
  self.count = 3
  self:StartIntervalThink(1)


end

function modifier_bomb_thinker:OnIntervalThink()
  if not IsServer() then
    return
  end
  if self.count  <= 0 then
    UTIL_Remove( self:GetParent() )
    return
  end
  -- local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/shredder/timber_controlled_burn/timber_controlled_burn_tree_kill_hit_fireb.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetTeamNumber() )
  local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/diy_particles/timber_controlled_burn_tree_kill_hit_fireb.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetTeamNumber() )
  ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin()+Vector( 0, 0, 100 ) )
  ParticleManager:ReleaseParticleIndex( nFXIndex )
  local caster = self:GetParent()
  local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
        1,
        false
      )
  if #enemies > 0 then
    for _,enemy in pairs(enemies) do
      if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
        enemy:AddNewModifier(caster,self:GetAbility(), "modifier_bomb_effect", {duration = 3})
      end 
    end
  end
  self.count = self.count - 1
end

--修饰器
modifier_bomb_effect = class({})
function modifier_bomb_effect:IsHidden() 			return true end
function modifier_bomb_effect:IsDebuff() return true end
function modifier_bomb_effect:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end

function modifier_bomb_effect:StatusEffectPriority()
	return 15
end
function modifier_bomb_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_bomb_effect:OnCreated()
  if not IsServer() then
    return
  end
  local scale = self:GetAbility():GetSpecialValueFor("scale")
  local strength = self:GetAbility():GetCaster():GetStrength()
  self.demage = 500 + strength * scale
  --设置计时器
  self:StartIntervalThink(1)
  --启动计时器
  self:OnIntervalThink()
end

function modifier_bomb_effect:OnIntervalThink()
  local damageTable = {
    victim  =  self:GetParent(),--
    attacker = self:GetAbility():GetCaster(),
    damage = self.demage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility(),
  }
  ApplyDamage(damageTable)
end