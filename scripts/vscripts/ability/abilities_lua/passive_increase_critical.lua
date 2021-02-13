LinkLuaModifier("modifier_increase_critical","ability/abilities_lua/passive_increase_critical",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
increase_critical = class({})
function increase_critical:GetIntrinsicModifierName()
	return "modifier_increase_critical"
end


if modifier_increase_critical == nil then
    modifier_increase_critical = ({})
end

function modifier_increase_critical:IsHidden() return false end
function modifier_increase_critical:IsPurgable() return false end
function modifier_increase_critical:RemoveOnDeath() return false end

function modifier_increase_critical:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local wearTable = {
            "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
            "models/items/rubick/puppet_master_head/puppet_master_head.vmdl",
            "models/items/rubick/force_staff/force_staff.vmdl",
            "models/items/rubick/rubick_ti8_immortal_shoulders/rubick_ti8_immortal_shoulders.vmdl",
        }
        WearForHero(wearTable,hero)
        hero.wear_table[3]:SetSkin(1)
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_force_gold_ambient/rubick_force_ambient_gold.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[3] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_staff_ambient", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[3], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_default.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[1] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 10, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_arcana/rubick_arc_shoulders_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[4] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[4], PATTACH_POINT_FOLLOW, "attach_necktie_base", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)


        self.criticla = 0
        self.criticla_damage = 0
        self.hero_steam_id = PlayerResource:GetSteamAccountID(self:GetParent():GetPlayerID())
        self.added_amount = 0

        self.time_wheel = {0,0,0,0,0,0,0,0,0,0}
        self.current_time_wheel = 1
        self.end_time_wheel = 1
        self:StartIntervalThink(1)
    end
end

function modifier_increase_critical:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
    return funcs
end



function modifier_increase_critical:OnAttackStart(params)
    if params.attacker == self:GetParent() then
        if RollPercentage(10) then
            if self.current_time_wheel == 1 then 
                self.end_time_wheel = 10
            else
                self.end_time_wheel = self.current_time_wheel - 1
            end
            self.time_wheel[self.end_time_wheel] = self.time_wheel[self.end_time_wheel] + 1
            self:IncrementStackCount()
        end
    end
end

function modifier_increase_critical:OnStackCountChanged(oldStack)
    if IsServer() then
        self.criticla = oldStack
        self.criticla_damage = 0.05 * oldStack
        game_playerinfo:set_dynamic_properties(self.hero_steam_id,"attack_critical",-self.criticla)
        game_playerinfo:set_dynamic_properties(self.hero_steam_id,"attack_critical_damage",-self.criticla_damage)
        self.added_amount = self:GetStackCount()
        self.criticla = self.added_amount
        self.criticla_damage = 0.05 * self.added_amount
        game_playerinfo:set_dynamic_properties(self.hero_steam_id,"attack_critical",self.criticla)
        game_playerinfo:set_dynamic_properties(self.hero_steam_id,"attack_critical_damage",self.criticla_damage)
    end
end

function modifier_increase_critical:OnIntervalThink()
    if self.time_wheel[self.current_time_wheel] > 0 then
        if self:GetStackCount() > 0 then
            self:SetStackCount(self:GetStackCount() - self.time_wheel[self.current_time_wheel])
            self.time_wheel[self.current_time_wheel] = 0
        end
    end
    if self.current_time_wheel >= 10 then
        self.current_time_wheel = 1
    else
        self.current_time_wheel = self.current_time_wheel + 1
    end
    
   
end