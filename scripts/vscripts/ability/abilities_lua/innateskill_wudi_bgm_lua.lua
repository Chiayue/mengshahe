wudi_bgm_lua = class({})
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_wudi_bgm_lua","ability/abilities_lua/innateskill_wudi_bgm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wear_zj","ability/abilities_lua/innateskill_wudi_bgm_lua", LUA_MODIFIER_MOTION_NONE )

function wudi_bgm_lua:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_wudi_bgm_lua", { duration = 30 } )
end

function wudi_bgm_lua:GetIntrinsicModifierName()
    return "modifier_wear_zj"
end

if modifier_wudi_bgm_lua == nil then
	modifier_wudi_bgm_lua = class({})
end

-- function modifier_wudi_bgm_lua:IsHidden()
--     return true
-- end

function modifier_wudi_bgm_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_wudi_bgm_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_wudi_bgm_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

function modifier_wudi_bgm_lua:OnCreated(params)
    if IsServer() then
        self.steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
        local randint = RandomInt(1,3)
        if randint == 1 then
            -- self:GetAbility():GetCaster():EmitSound("hero.wudi_bgm")
            self.bgmname = "hero.wudi_bgm"
        elseif randint == 2 then
            -- self:GetAbility():GetCaster():EmitSound("hero.wudi_bgm_2")
            self.bgmname = "hero.wudi_bgm_2"
        else
            -- self:GetAbility():GetCaster():EmitSound("hero.wudi_bgm_3")
            self.bgmname = "hero.wudi_bgm_3"
        end
    end
end

function modifier_wudi_bgm_lua:OnDestroy()
    if IsServer() then
		self:GetParent():StopSound(self.bgmname)
	end
end

function modifier_wudi_bgm_lua:GetModifierDamageOutgoing_Percentage()
	return 100
end

function modifier_wudi_bgm_lua:GetModifierPhysicalArmorBonus()
	return 1000
end

function modifier_wudi_bgm_lua:GetModifierMagicalResistanceBonus()
	return 100
end



if modifier_wear_zj == nil then
    modifier_wear_zj = ({})
end

function modifier_wear_zj:IsHidden() return true end
function modifier_wear_zj:IsPurgable() return false end
function modifier_wear_zj:RemoveOnDeath() return false end

function modifier_wear_zj:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        hero:AddActivityModifier('chase')
        local weartable = {
            "models/items/juggernaut/jugg_ti8/jugg_ti8_sword.vmdl",
            "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl",
            "models/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms.vmdl",
            "models/items/juggernaut/jugg_flag/jugg_flag.vmdl",
            "models/items/juggernaut/armor_for_the_favorite_legs/armor_for_the_favorite_legs.vmdl",
        }
        WearForHero(weartable,hero)
        hero.wear_table[1]:SetSkin(2)
        hero.wear_table[2]:SetSkin(1)
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_ti8_sword/jugg_ti8_sword_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[1] );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        -- nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,   hero);
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0,  hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[2] );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_body_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[5] );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end
--------------------------------------------------------------------------------
---------------------------------升华技能-----------------------------------------------

sublime_wudi_bgm_lua = class({})
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_sublime_wudi_bgm_lua","ability/abilities_lua/innateskill_wudi_bgm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_show_lua","ability/abilities_lua/innateskill_wudi_bgm_lua", LUA_MODIFIER_MOTION_NONE )

function sublime_wudi_bgm_lua:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sublime_wudi_bgm_lua", { duration = 30 } )
end

function sublime_wudi_bgm_lua:GetIntrinsicModifierName()
	return "modifier_show_lua"
end

modifier_show_lua = class({})
--------------------------------------------------------------------------------

function modifier_show_lua:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifier_show_lua:IsHidden()
    return true
end

function modifier_show_lua:OnCreated( kv )
    if IsServer() then
        -- print(" >>>>>>>>>>>>>>>> self.space_time: "..self.space_time)
        
    end
end

if modifier_sublime_wudi_bgm_lua == nil then
	modifier_sublime_wudi_bgm_lua = class({})
end

-- function modifier_sublime_wudi_bgm_lua:IsHidden()
--     return true
-- end

function modifier_sublime_wudi_bgm_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_sublime_wudi_bgm_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_sublime_wudi_bgm_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_sublime_wudi_bgm_lua:OnCreated(params)
    if IsServer() then
        -- self:GetCaster():SetModelScale(self:GetCaster():GetModelScale() + 0.5)
        -- self.nFXIndex = ParticleManager:CreateParticle( "particles/ambient/abilty1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
        -- self:AddParticle( self.nFXIndex, false, false, -1, false, false )
        
        self.steam_id = PlayerResource:GetSteamAccountID(self:GetAbility():GetCaster():GetPlayerID())
        local randint = RandomInt(1,3)
        if randint == 1 then
            self:GetAbility():GetCaster():EmitSound("hero.wudi_bgm")
            self.bgmname = "hero.wudi_bgm"
        elseif randint == 2 then
            self:GetAbility():GetCaster():EmitSound("hero.wudi_bgm_2")
            self.bgmname = "hero.wudi_bgm_2"
        else
            self:GetAbility():GetCaster():EmitSound("hero.wudi_bgm_3")
            self.bgmname = "hero.wudi_bgm_3"
        end
    end
end

function modifier_sublime_wudi_bgm_lua:OnDestroy()
    if IsServer() then
		self:GetParent():StopSound(self.bgmname)
	end
end

function modifier_sublime_wudi_bgm_lua:GetModifierDamageOutgoing_Percentage()
	return 200
end

function modifier_sublime_wudi_bgm_lua:GetModifierPhysicalArmorBonus()
	return 1000
end

function modifier_sublime_wudi_bgm_lua:GetModifierMagicalResistanceBonus()
	return 100
end

-- function modifier_sublime_wudi_bgm_lua:GetModifierPercentageCooldown()
--     return 50
-- end
