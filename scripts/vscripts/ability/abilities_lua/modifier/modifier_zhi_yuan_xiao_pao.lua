if modifier_zhi_yuan_xiao_pao == nil then 
    modifier_zhi_yuan_xiao_pao = class({})
end

function modifier_zhi_yuan_xiao_pao:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_zhi_yuan_xiao_pao:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_zhi_yuan_xiao_pao:IsHidden()
    return true 
end


function modifier_zhi_yuan_xiao_pao:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }
    return funcs
end



function modifier_zhi_yuan_xiao_pao:OnCreated( evt )
    if IsServer( ) then
        self.attack_range = evt.attack_range
        self.cast_range = evt.cast_range
        local take_key = "zyxp_"..self:GetParent():GetEntityIndex()
        CustomNetTables:SetTableValue( "random_properties", take_key,{attack_range = self.attack_range,cast_range = self.cast_range} )
        local interval_time = self:GetAbility():GetSpecialValueFor("interval_time")
        if interval_time and interval_time > 0 then
            self:StartIntervalThink(interval_time)
        end
        self.thinkTable = {
            EffectName = "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf",
            Ability = self:GetAbility(),
            vSpawnOrigin = self:GetParent():GetOrigin(),
            Target = nil,
            Source =  self:GetParent(),
            bHasFrontalCone = false,
            iMoveSpeed =  1000,
            bProvidesVision = false,
            iVisionRadius = 1000,
            iVisionTeamNumber =  self:GetParent():GetTeamNumber()       
        }
    end
end

function modifier_zhi_yuan_xiao_pao:OnRefresh( evt )
    if IsServer( ) then
        self.attack_range = self.attack_range + evt.attack_range or 0
        self.cast_range = self.cast_range + evt.cast_range or 0
        local take_key = "zyxp_"..self:GetParent():GetEntityIndex()
        CustomNetTables:SetTableValue( "random_properties", take_key,{attack_range = self.attack_range,cast_range = self.cast_range} )
        local interval_time = self:GetAbility():GetSpecialValueFor("interval_time")
        -- print("refresh")
        if interval_time and interval_time > 0 then
            self:StartIntervalThink(interval_time)
        end
    end
end

function modifier_zhi_yuan_xiao_pao:GetModifierAttackRangeBonus()
    if IsServer() then
        return self.attack_range
    else
        return CustomNetTables:GetTableValue( "random_properties", "zyxp_"..self:GetParent():GetEntityIndex()).attack_range
    end
end

function modifier_zhi_yuan_xiao_pao:GetModifierCastRangeBonus()
    if IsServer() then
        return self.cast_range
    else
        return CustomNetTables:GetTableValue( "random_properties", "zyxp_"..self:GetParent():GetEntityIndex()).cast_range
    end
end

function modifier_zhi_yuan_xiao_pao:OnIntervalThink()
    local hero_list = self:GetAbility().hero_list
    local hit_hero = hero_list[RandomInt(1, #hero_list)]
    if not hit_hero then
        hit_hero = self:GetParent()
    end
    local hit_point = hit_hero:GetOrigin() + RandomVector(500)
    local lightningBolt = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(lightningBolt,0,hit_point)   
    local thinker = CreateModifierThinker( self:GetParent(), self:GetAbility(), "modifier_zhi_yuan_xiao_pao_hit_point", {}, hit_point, self:GetParent():GetTeamNumber(), false )
    local projectile_info = self.thinkTable
    projectile_info.Target = thinker
    ProjectileManager:CreateTrackingProjectile(projectile_info)
    self:GetAbility().release_index = lightningBolt
    --刷新英雄表
    if  GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:GetAbility().hero_list = {}
        for i=1 ,global_var_func.all_player_amount do
            local player = PlayerResource:GetPlayer(i-1)
            if player then
                table.insert(self:GetAbility().hero_list,player:GetAssignedHero())
            end
        end
    end
    
end

--马甲
if modifier_zhi_yuan_xiao_pao_hit_point == nil then
    modifier_zhi_yuan_xiao_pao_hit_point = ({})
end

function modifier_zhi_yuan_xiao_pao_hit_point:OnCreated(params)

end