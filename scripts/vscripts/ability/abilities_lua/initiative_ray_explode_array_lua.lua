initiative_ray_explode_array_lua = class({})
initiative_ray_explode_array_lua_d = initiative_ray_explode_array_lua
initiative_ray_explode_array_lua_c = initiative_ray_explode_array_lua
initiative_ray_explode_array_lua_b = initiative_ray_explode_array_lua
initiative_ray_explode_array_lua_a = initiative_ray_explode_array_lua
initiative_ray_explode_array_lua_s = initiative_ray_explode_array_lua

function initiative_ray_explode_array_lua:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()
  local location = self:GetCursorPosition()

  if self.instance == nil then
      self.instance = 0
      self.jump_count = {}
      self.target = {}
  else
      self.instance = self.instance + 1
  end
  self.target[self.instance] = target
  self.jump_count[self.instance] = 15
  local info = {
    EffectName = "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt_arc.vpcf",
    Ability = self,
    iMoveSpeed = 900,
    Source = caster,
    Target = target,
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_HITLOCATION,
  }
    ProjectileManager:CreateTrackingProjectile(info)

end

--------------------------
function initiative_ray_explode_array_lua:OnProjectileHit(hTarget, vLocation)
  if hTarget ~= nil and not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
    local caster = self:GetCaster()
    local target = hTarget
    local scale = self:GetSpecialValueFor("scale")
    --伤害，还是debuff，buff
    local damageTabe = {
        victim = target,
        attacker = caster,
        damage = 300+ caster:GetStrength()*scale,
        damage_type = DAMAGE_TYPE_MAGICAL
    }

    ApplyDamage(damageTabe)

    local current = 0
    --用于判断当前的技能是第几次
    for i = 0,self.instance do
      if self.target[i] ~= nil then
        if self.target[i] == hTarget then
          current = i
        end
      end
    end
    --减少一次技能的计数
    if self.jump_count[current] ~=nil then
      self.jump_count[current] = self.jump_count[current] - 1
    end
    --创建目标的hit记录
    if hTarget.hit == nil then
      hTarget.hit = {}
    end
  --对象已经被第几次技能的命中了hTarget.hit[0] = true,hTarget.hit[1] = true
    hTarget.hit[current] = true
    if self.jump_count[current] > 0 then
      local next_target
      local enemies = FindUnitsInRadius(caster:GetTeamNumber(),vLocation,nil,600,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,1,false)
      --找到满足条件的目标对象
      for _,enemy in pairs(enemies) do
        if enemy ~= hTarget then
        if enemy.hit == nil then
          next_target = enemy
          break
        elseif enemy.hit[current] == nil then
          next_target = enemy
          break  
        end
      end
    end
  --如果存在一个这样满足条件的目标，就发射投射物 next_target
    if next_target ~= nil then
    --将实例技能的目标对象进行修改
      self.target[current] = next_target
      local info = {
        -- EffectName = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf",
        EffectName = "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt_arc.vpcf",
        Ability = self,
        iMoveSpeed = 900,
        Source = hTarget,
        Target = next_target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_HITLOCATION,
      }
      -- caster:EmitSound("sd")
      caster:EmitSound("Hero_Leshrac.Lightning_Storm")  
      ProjectileManager:CreateTrackingProjectile(info)

    --如果没有目标就释放技能对象的内存
    else
      self.target[current] = nil
    end
    --如果没有次数就释放技能对象的内存
    else
      self.target[current] = nil
    end
  end
end

