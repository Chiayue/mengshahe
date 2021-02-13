if modifier_huojiandan == nil then 
	modifier_huojiandan = ({})
end

function modifier_huojiandan:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    }
    return funcs
end

function modifier_huojiandan:OnCreated( param )
	if IsServer() then
		self.damage_info = {
			victim = nil,
			attacker = self:GetParent(),
			damage = 0,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self:GetAbility(),
		}
	end
end

function modifier_huojiandan:OnDestroy()
	if IsServer() then
		if self:GetParent() then 
			-- self:GetParent():ForceKill(false)
			StopSoundOn("huojiandan.fashe",self:GetParent())
			UTIL_Remove(self:GetParent())
		end
	end
end

-- function modifier_huojiandan:IsHidden()
-- 	return true
-- end


function modifier_huojiandan:OnAttackStart(params)
	local attacker = params.attacker
	if attacker ~= self:GetParent() then
		return
	end
	-- local particle = "particles/heroes/ogre_magi/gensmoke.vpcf"
	local particle = "particles/base_destruction_fx/gensmoke.vpcf"
	ParticleManager:CreateParticle( particle, PATTACH_RENDERORIGIN_FOLLOW	, attacker );
	attacker:EmitSound("huojiandan.fashe")
end
	

function modifier_huojiandan:OnAttackLanded(params)
	local attacker = params.attacker
	if attacker ~= self:GetParent() then
		return
	end
	local attack_damage = params.damage
	local hTarget = params.target
	local particle = "particles/heroes/ogre_magi/gensmoke.vpcf"
	local ability = self:GetAbility()
	ParticleManager:CreateParticle( particle, PATTACH_RENDERORIGIN_FOLLOW	, hTarget );
	StopSoundOn("huojiandan.fashe",attacker)
	hTarget:EmitSound("huojiandan.boom")
	local unit_entitis = FindUnitsInRadius( attacker:GetTeamNumber(),hTarget:GetOrigin(),nil,500,DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
	for i=1 ,#unit_entitis do
		if unit_entitis[i]:GetTeam() == DOTA_TEAM_BADGUYS and unit_entitis[i]:IsAlive() and unit_entitis[i]~=hTarget then
			self.damage_info.victim = unit_entitis[i]
			self.damage_info.damage = attack_damage
			ApplyDamage( self.damage_info )
		end
	end
	-- CreateModifierThinker(attacker, ability, "modifier_huojiandan_qianghuang", {duration = 10,c_position=hTarget:GetOrigin()}, hTarget:GetOrigin(), attacker:GetTeamNumber(), false)
end

function modifier_huojiandan:OnAttack(params)
    local target = params.target
    local owner = self:GetParent()
    if target == owner then
        local pre_spell_ability = owner:FindAbilityByName("unit_jinjichetui")
        if pre_spell_ability then
            if pre_spell_ability:IsFullyCastable() then
                owner:CastAbilityImmediately(pre_spell_ability,owner:GetEntityIndex())
            end
        end
    end
end


function modifier_huojiandan:GetModifierTurnRate_Percentage() 
	return -90
end

if modifier_huojiandan_qianghuang == nil then 
	modifier_huojiandan_qianghuang = ({})
end

function modifier_huojiandan_qianghuang:OnCreated( param )
	-- ParticleManager:CreateParticle( "particles/dark_smoke_test.vpcf", PATTACH_POINT	, self:GetParent() );
	local inx = ParticleManager:CreateParticle( "particles/neutral_fx/black_dragon_fireball.vpcf", PATTACH_POINT	, self:GetParent());
end