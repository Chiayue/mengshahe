


--蝎子王技能1
LinkLuaModifier("modifier_scorpion_king_one_poison_damage","ability/abilities_lua/initiative_scorpion_king_one_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scorpion_king_one_poison","ability/abilities_lua/initiative_scorpion_king_one_lua",LUA_MODIFIER_MOTION_NONE)
initiative_scorpion_king_one_lua = class({})

function initiative_scorpion_king_one_lua:OnSpellStart()

    local caster = self:GetCaster()
    local ability = self

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), 
        caster:GetOrigin(), 
        nil, 
        800, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST, 
        false
    )
    if #enemies > 0 then
           local enemy = enemies[RandomInt(1, #enemies)]
          if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
            caster:EmitSound("hero.attack.npc_dota_hero_sand_king")
            caster:StartGesture(ACT_DOTA_SAND_KING_BURROW_IN)
            local nFXIndex1 = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike_eruption.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl( nFXIndex1, 0, caster:GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex1, 1, caster:GetOrigin())

            local to_postion = enemy:GetOrigin() 
            caster:StartGesture(ACT_DOTA_SAND_KING_BURROW_OUT)
            local nFXIndex2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike_eruption.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl( nFXIndex2, 0, to_postion)
            ParticleManager:SetParticleControl( nFXIndex2, 1, to_postion)
            FindClearSpaceForUnit(caster, to_postion, true)
            local damageTable = {
                victim  =  enemy,--
                attacker = caster,
                damage = caster:GetBaseDamageMax()*2,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability,
              }
            ApplyDamage(damageTable)
            if enemy:HasModifier("modifier_scorpion_king_one_poison") then
                enemy:RemoveModifierByName("modifier_scorpion_king_one_poison")          
            end
            enemy:AddNewModifier(caster,self, "modifier_scorpion_king_one_poison", nil)
          end 
      end
end
if modifier_scorpion_king_one_poison == nil then
    modifier_scorpion_king_one_poison = class({})
end

function modifier_scorpion_king_one_poison:IsHidden()
    return true -- 隐藏
end

function modifier_scorpion_king_one_poison:RemoveOnDeath()
    return true -- 死亡移除
end
function modifier_scorpion_king_one_poison:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function modifier_scorpion_king_one_poison:OnAttackLanded(params)
    if not IsServer() then
		return
    end
    if params.attacker ~= self:GetCaster() then
		return 0
    end
    if params.target.count == nil  then
        params.target.count = 0
    end
    if params.target.count < 8 then
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_scorpion_king_one_poison_damage", { duration = 8})
    end
end
modifier_scorpion_king_one_poison_damage = class({})
function modifier_scorpion_king_one_poison_damage:IsDebuff()
    return true
end
function modifier_scorpion_king_one_poison_damage:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end
function modifier_scorpion_king_one_poison_damage:IsHidden()
    return false
end
function modifier_scorpion_king_one_poison_damage:OnCreated(kv)
    if not IsServer() then
		return
    end
    self:GetParent().count = self:GetParent().count + 1
      	--设置计时器时间
    self:StartIntervalThink(1)

end
function modifier_scorpion_king_one_poison_damage:OnIntervalThink()
    local damage = {
        victim =  self:GetParent(),
        attacker = self:GetCaster(),
        damage = 500,--500
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }

    ApplyDamage(damage) 
end
function modifier_scorpion_king_one_poison_damage:GetEffectName()
	return "particles/diy_particles/shui_skill1_2.vpcf"
end


function modifier_scorpion_king_one_poison_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_scorpion_king_one_poison_damage:OnDestroy()
    if not IsServer( ) then
        return
    end
    if  self:GetParent().count ~= nil  then
        if self:GetParent().count > 0 then
            self:GetParent().count = self:GetParent().count - 1
        else
            self:GetParent().count = 0
        end
    end
end