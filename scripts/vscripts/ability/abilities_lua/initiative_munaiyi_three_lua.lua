initiative_munaiyi_three_lua = class({})

LinkLuaModifier("modifier_initiative_munaiyi_three_lua","ability/abilities_lua/initiative_munaiyi_three_lua",LUA_MODIFIER_MOTION_NONE)

--开始施法
function initiative_munaiyi_three_lua:OnSpellStart()
    if not IsServer() then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_initiative_munaiyi_three_lua", {duration = 10})
end

modifier_initiative_munaiyi_three_lua = class({})

function modifier_initiative_munaiyi_three_lua:IsDebuff()
	return false 
end
function modifier_initiative_munaiyi_three_lua:IsHidden()
	return false
end
function modifier_initiative_munaiyi_three_lua:IsPurgable()
	return true
end
function modifier_initiative_munaiyi_three_lua:IsPurgeException()
	return true
end
function modifier_initiative_munaiyi_three_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end

function modifier_initiative_munaiyi_three_lua:OnCreated(params)
    if not IsServer() then
        return
    end
    self.nFXIndex = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true)
end

function modifier_initiative_munaiyi_three_lua:OnAttacked(params)
    if IsServer( ) then
        if params.attacker == self:GetCaster() and self:GetCaster():FindModifierByNameAndCaster("modifier_initiative_munaiyi_three_lua",self:GetCaster()) and self.nFXIndex then
            ParticleManager:DestroyParticle(self.nFXIndex,true)
            local damagetable = {
                victim = params.target,                                 
                attacker = params.attacker,								 
                damage = params.original_damage,								 
                damage_type = DAMAGE_TYPE_PHYSICAL,
            }
            ApplyDamage(damagetable)
            self:GetCaster():RemoveModifierByName("modifier_initiative_munaiyi_three_lua")
        end
    end
end

function modifier_initiative_munaiyi_three_lua:OnDestroy()
    if not IsServer() then
		return
    end
    if self.nFXIndex then
        ParticleManager:DestroyParticle(self.nFXIndex,true)
    end
end