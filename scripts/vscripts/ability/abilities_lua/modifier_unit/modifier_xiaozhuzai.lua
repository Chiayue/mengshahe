if modifier_xiaozhuzai == nil then
    modifier_xiaozhuzai = ({})
end

function modifier_xiaozhuzai:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_xiaozhuzai:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1)
        self.time_acount = 0
        self.grow_time = params.grow_time * 60
        self.remove_time = self.grow_time + 1
        self.pig_gain = params.pig_gain
        self.grow_time_1 = math.ceil(self.grow_time / 3)
        self.grow_time_2 = math.ceil(self.grow_time * 2 / 3)
    end
end

function modifier_xiaozhuzai:OnIntervalThink()
    local unit = self:GetParent()
    if not unit:IsMoving() and self.time_acount % 3 ==0 then
        local local_positon = unit:GetOrigin()
        local to_postion = local_positon + Vector(RandomInt(-500,500),RandomInt(-500,500),0)
        unit:MoveToPosition(to_postion)
    end
    
    if self.time_acount == self.grow_time_1  then 
        unit:SetModelScale(1.5)
    elseif self.time_acount == self.grow_time_2 then
        unit:SetModelScale(2.5)
    elseif self.time_acount == self.grow_time then
        local hero = unit:GetOwner()
        game_playerinfo:set_player_gold(hero:GetPlayerID(),self.pig_gain)
        local pindex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinada.vpcf", PATTACH_OVERHEAD_FOLLOW	, unit );
        ParticleManager:SetParticleControlEnt( pindex, 0, nil, PATTACH_OVERHEAD_FOLLOW, "",unit:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( pindex, 1, nil, PATTACH_OVERHEAD_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(pindex)
    elseif self.time_acount >= self.remove_time then
        UTIL_Remove(unit)
    end
    self.time_acount = self.time_acount + 1
end

function modifier_xiaozhuzai:OnAttackLanded(params)
    if params.target == self:GetParent() then
        StopSoundOn("pig.sound_1",self:GetParent())
        self:GetParent():EmitSound("pig.sound_1")
    end
end


function modifier_xiaozhuzai:IsHidden()
    return true
end


-- function modifier_xiaozhuzai:OnDeath(params)
--     local unit_postion = self:GetParent():GetOrigin()
--     local attacker_postion = params.attacker:GetOrigin()
--     local postion =  ( attacker_postion - unit_postion):Normalized()
--     local info = {
--         EffectName = "particles/heroes/drow_ranger/mirana_spell_arrow.vpcf",
-- 		Ability = self:GetAbility(),
-- 		vSpawnOrigin = unit_postion, 
-- 		fStartRadius = 20,
-- 		fEndRadius = 20,
-- 		vVelocity =postion * 500,
-- 		fDistance = 5000,
-- 		Source = self:GetParent(),
-- 		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
-- 		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
-- 	}
-- 	ProjectileManager:CreateLinearProjectile( info )
-- end

