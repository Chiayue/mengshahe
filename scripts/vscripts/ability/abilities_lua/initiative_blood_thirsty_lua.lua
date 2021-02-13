--嗜血--bloodseeker_thirst
initiative_blood_thirsty_lua = class({})


LinkLuaModifier("modifier_blood_thirsty_attack_speed","ability/abilities_lua/initiative_blood_thirsty_lua.lua",LUA_MODIFIER_MOTION_NONE)
--施法开始
function initiative_blood_thirsty_lua:OnSpellStart()

    local caster = self:GetCaster()
    EmitSoundOn( "TG.zeusdg", self:GetCaster() )
    local creeps = {}
    local friendlys = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetOrigin(),
        self,
        1000,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
        1,
        false
    )
    local unit
    if(#friendlys > 0) then    
        for a,friendly in pairs(friendlys) do   
            if ContainUnitTypeFlag(friendly, DOTA_UNIT_TYPE_FLAG_CREEP) then
                creeps[#creeps + 1] = friendly
            end
        end
        if(#creeps > 0)then
            unit = creeps[math.floor(math.random(#creeps - 1))]
            unit:AddNewModifier(caster,self, "modifier_blood_thirsty_attack_speed", {duration =  self:GetSpecialValueFor("duration")})
        else
            unit = friendlys[math.floor(math.random(#friendlys - 1))]
            unit:AddNewModifier(caster,self, "modifier_blood_thirsty_attack_speed", {duration =  self:GetSpecialValueFor("duration")})
        end
    end
end

--修饰器
modifier_blood_thirsty_attack_speed = class({})


function modifier_blood_thirsty_attack_speed:IsBuff()			return true end
function modifier_blood_thirsty_attack_speed:IsDebuff()				return true end
function modifier_blood_thirsty_attack_speed:IsHidden() 			return false end
function modifier_blood_thirsty_attack_speed:IsPurgable() 			return true end
function modifier_blood_thirsty_attack_speed:IsPurgeException() 	return true end

function modifier_blood_thirsty_attack_speed:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" end

function modifier_blood_thirsty_attack_speed:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function modifier_blood_thirsty_attack_speed:GetModifierAttackSpeedBonus_Constant() return (0 + self:GetAbility():GetSpecialValueFor("bonus_attack_speed")+(GameRules:GetCustomGameDifficulty()-1)*20) end
