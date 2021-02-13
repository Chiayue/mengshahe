LinkLuaModifier("modifier_passive_my_brothers","ability/abilities_lua/passive_my_brothers",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_passive_my_brothers_add","ability/abilities_lua/passive_my_brothers",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
my_brothers = class({})
function my_brothers:GetIntrinsicModifierName()
	return "modifier_passive_my_brothers"
end

function my_brothers:OnHeroLevelUp()
    if IsServer() then
        local hero = self:GetCaster()
        local illusions = CreateIllusions(hero, hero, {
                    outgoing_damage = 100,	-- 造成%的伤害
                    incoming_damage = 100,	-- 受到%的伤害
                    bounty_base = 15,	-- 击杀获得15金钱
                    outgoing_damage_structure = 100,	-- 对建筑造成%伤害
                    outgoing_damage_roshan = 100,	-- 对肉山造成%伤害
                    duration = -1
                }, 1, 50, true, true)
        for k,v in pairs(illusions) do
            v:SetOwner(hero)
            v:SetBaseAgility(hero:GetBaseAgility())
            v:SetBaseStrength(hero:GetBaseStrength())
            v:SetBaseIntellect(hero:GetBaseIntellect())
            v:AddNewModifier(hero, self, "modifier_passive_my_brothers_add", {})
            for i=0, 9 do
                local vItem = v:GetItemInSlot(i)
                if vItem ~= nil then
                    vItem:SetSellable(false)
                end
            end
        end
    else
    end
end

if modifier_passive_my_brothers == nil then
    modifier_passive_my_brothers = ({})
end

function modifier_passive_my_brothers:IsHidden() return true end
function modifier_passive_my_brothers:IsPurgable() return false end
function modifier_passive_my_brothers:RemoveOnDeath() return false end

function modifier_passive_my_brothers:OnCreated(params)
    if IsServer() then
        --穿饰品
        local hero = self:GetParent()
        local weartable = {
            "models/items/meepo/sir_meepalot_weapon/sir_meepalot_weapon.vmdl",
            "models/items/meepo/ti8_meepo_pitmouse_fraternity_head/ti8_meepo_pitmouse_fraternity_head.vmdl",
            "models/items/meepo/ti8_meepo_pitmouse_fraternity_shoulder/ti8_meepo_pitmouse_fraternity_shoulder.vmdl",
            "models/items/meepo/colossal_crystal_chorus/colossal_crystal_chorus.vmdl",
            "models/items/meepo/ti8_meepo_pitmouse_fraternity_arms/ti8_meepo_pitmouse_fraternity_arms.vmdl",
            "models/items/meepo/ti8_meepo_pitmouse_fraternity_tail/ti8_meepo_pitmouse_fraternity_tail.vmdl",
        }
        WearForHero(weartable,self:GetParent())
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/meepo/meepo_meepalot/meepo_meepalot_sword_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[1] );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/meepo/meepo_ti8_pitmouse/meepo_ti8_pitmouse_candle_flame.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[2] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[2], PATTACH_POINT_FOLLOW, "candle_front", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[2], PATTACH_POINT_FOLLOW, "candle_back", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/meepo/meepo_ti8_pitmouse/meepo_ti8_pitmouse_candle_flame_shoulder.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[3] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_candle", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero);
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_back", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

if modifier_passive_my_brothers_add == nil then
    modifier_passive_my_brothers_add = ({})
end

function modifier_passive_my_brothers_add:IsHidden() return true end
function modifier_passive_my_brothers_add:IsPurgable() return false end
function modifier_passive_my_brothers_add:RemoveOnDeath() return false end

function modifier_passive_my_brothers_add:OnCreated(params)
    if IsServer() then
        local caster = self:GetCaster()
        self.strength = caster:GetStrength()
        self.agility = caster:GetAgility()
        self.intellect = caster:GetIntellect()
    end
end

function modifier_passive_my_brothers_add:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_passive_my_brothers_add:GetModifierBonusStats_Strength()
    return self.strength
end

function modifier_passive_my_brothers_add:GetModifierBonusStats_Agility()
    return self.agility
end

function modifier_passive_my_brothers_add:GetModifierBonusStats_Intellect()
    return self.intellect
end