modifier_sanweizhenhuo = class({})


function modifier_sanweizhenhuo:OnCreated(params)
    if not IsServer() then
        return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    self.player_count = global_var_func.all_player_amount
    self.thinkTable = {
        EffectName = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf",
        Ability = ability,
        vSpawnOrigin = caster:GetOrigin(),
        Target = nil,
        Source = caster,
        bHasFrontalCone = false,
        iMoveSpeed =  1000,
        bProvidesVision = false,
        iVisionRadius = 1000,
        iVisionTeamNumber = caster:GetTeamNumber()       
    }
    self:OnIntervalThink()
    self:StartIntervalThink(1.5)
end

function modifier_sanweizhenhuo:CheckState() 
	return 
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true, 
	} 
end

function modifier_sanweizhenhuo:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetParent()
    local player_id = RandomInt(0,self.player_count-1)
    local thinker_point = PlayerResource:GetPlayer(player_id):GetAssignedHero():GetOrigin()
    local thinker = CreateModifierThinker( caster, ability, "modifier_sanweizhenhuo_hit_point", {duration = 5}, thinker_point, caster:GetTeamNumber(), false )
    local target = thinker
    local projectile_info = self.thinkTable
    projectile_info.Target = target
    ProjectileManager:CreateTrackingProjectile(projectile_info)
end

--马甲
if modifier_sanweizhenhuo_hit_point == nil then
    modifier_sanweizhenhuo_hit_point = ({})
end

function modifier_sanweizhenhuo_hit_point:OnCreated(params)

end


--伤害
if modifier_sanweizhenhuo_damage == nil then
    modifier_sanweizhenhuo_damage = ({})
end


function modifier_sanweizhenhuo_damage:IsAura()
    return true
end

function modifier_sanweizhenhuo_damage:GetAuraRadius()
    return 600
end

function modifier_sanweizhenhuo_damage:GetModifierAura()
    return "modifier_common_move_speed"
end

function modifier_sanweizhenhuo_damage:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sanweizhenhuo_damage:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_sanweizhenhuo_damage:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_sanweizhenhuo_damage:OnCreated(params)
    if IsServer() then
        local ability = self:GetAbility()
        self.damage_percent = ability:GetSpecialValueFor("damage_percent")
        self.base_damage = ability:GetSpecialValueFor("base_damage")
        self.hit_postion = Vector(params.px,params.py,params.pz)
        self.particle_index = params.particle_index
        self:StartIntervalThink(0.5)
        
    end
end

function modifier_sanweizhenhuo_damage:OnIntervalThink()
    local ability = self:GetAbility()
    local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS,self.hit_postion,nil,600,DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
    for _,v in pairs(enemies) do
        ability.damage_info.victim = v
        ability.damage_info.damage = self.base_damage + v:GetMaxHealth() * self.damage_percent / 100
        ApplyDamage(ability.damage_info)
    end
end
function modifier_sanweizhenhuo_damage:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle( self.particle_index ,true)
        ParticleManager:ReleaseParticleIndex(self.particle_index )
    end
end

