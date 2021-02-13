initiative_meidusha_three_lua = class({})

LinkLuaModifier("modifier_initiative_meidusha_three_lua","ability/abilities_lua/initiative_meidusha_three_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_meidusha_three_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    -- caster:StartGesture(ACT_DOTA_DISABLED)
    -- caster:EmitSound("hero.attack.npc_dota_hero_clinkz")
    ProjectileManager:CreateTrackingProjectile(
				{
					Target			= target,
					Source			= caster,
					Ability			= self,
                    EffectName      = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf",
					iMoveSpeed		= 1500,
                })
end

--技能命中
function initiative_meidusha_three_lua:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		local damagetable = {
			victim = hTarget,                                 
			attacker = self:GetCaster(),								 
			damage = self:GetSpecialValueFor("damage"),								 
			damage_type = DAMAGE_TYPE_MAGICAL,				 
        }
        hTarget:AddNewModifier(hTarget, self, "modifier_initiative_meidusha_three_lua", { duration = 5 })
		ApplyDamage(damagetable)
	end
end

modifier_initiative_meidusha_three_lua = class({})

function modifier_initiative_meidusha_three_lua:IsDebuff()
	return true 
end
function modifier_initiative_meidusha_three_lua:IsHidden()
	return false
end
function modifier_initiative_meidusha_three_lua:IsPurgable()
	return true
end
function modifier_initiative_meidusha_three_lua:IsPurgeException()
	return true
end
function modifier_initiative_meidusha_three_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end
function modifier_initiative_meidusha_three_lua:OnCreated(kv)
    if not IsServer() then
        return
    end
end

function modifier_initiative_meidusha_three_lua:GetModifierPhysicalArmorBonus(kv)
    return self:GetAbility():GetSpecialValueFor("armor_reduce")*-1
end