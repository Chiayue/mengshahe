LinkLuaModifier("modifier_passive_breed_children", "ability/abilities_lua/passive_breed_children.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_breed_children_run_state", "ability/abilities_lua/passive_breed_children.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_breed_children_plant", "ability/abilities_lua/passive_breed_children.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_breed_children_hit", "ability/abilities_lua/passive_breed_children.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------

passive_breed_children = class({})

function passive_breed_children:GetIntrinsicModifierName()
    self.caster = self:GetCaster()
	return "modifier_passive_breed_children"
end

function passive_breed_children:OnProjectileHit(hTarget, vLocation)
    if hTarget and hTarget:IsAlive() then
        local enemies = FindUnitsInRadius(
            hTarget:GetTeamNumber(), 
            hTarget:GetOrigin(), 
            nil, 
            300, 
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false 
        )
        for _, enemy in pairs(enemies) do
            ApplyDamage({
                victim = enemy,
                attacker = self.caster,
                damage = 2 * (self.caster:GetIntellect() + self.caster:GetAgility()),
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = self
            })
        end
    end
    return true
end

-------------------------------------------------------------

modifier_passive_breed_children = class({})

function modifier_passive_breed_children:CheckState()
	return {
    }
end

function modifier_passive_breed_children:DeclareFunctions()
	return {
    }
end

function modifier_passive_breed_children:IsHidden()
    return true
end

function modifier_passive_breed_children:IsPurgable()
    return false
end
 
function modifier_passive_breed_children:RemoveOnDeath()
    return false
end

function modifier_passive_breed_children:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_passive_breed_children_run_state", nil)
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_passive_breed_children_plant", nil)
    end
end

-------------------------------------------------------------

modifier_passive_breed_children_run_state = class({})

function modifier_passive_breed_children_run_state:CheckState()
	return {
    }
end

function modifier_passive_breed_children_run_state:DeclareFunctions()
	return {
    }
end

function modifier_passive_breed_children_run_state:IsHidden()
    return true
end

function modifier_passive_breed_children_run_state:IsPurgable()
    return false
end
 
function modifier_passive_breed_children_run_state:RemoveOnDeath()
    return false
end

function modifier_passive_breed_children_run_state:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self:StartIntervalThink(0.1)
    end
end

function modifier_passive_breed_children_run_state:OnIntervalThink()
    if IsServer() then
        if self.parent:IsAlive() and self.parent:IsMoving() then
            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_eyesintheforest_g.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(index, 0,self.parent:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
        end
    end
end

-------------------------------------------------------------

modifier_passive_breed_children_plant= class({})

function modifier_passive_breed_children_plant:CheckState()
	return {
    }
end

function modifier_passive_breed_children_plant:DeclareFunctions()
	return {
    }
end

function modifier_passive_breed_children_plant:IsHidden()
    return true
end

function modifier_passive_breed_children_plant:IsPurgable()
    return false
end
 
function modifier_passive_breed_children_plant:RemoveOnDeath()
    return false
end

function modifier_passive_breed_children_plant:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        self:StartIntervalThink(10)
    end
end

function modifier_passive_breed_children_plant:OnIntervalThink()
    if IsServer() then
        if self.parent:IsAlive() and self.parent:IsMoving() then
            if RollPercentage(50) then
                -- 攻击树
                local trees = {
                    "models/props_tree/palm_02d_inspector.vmdl",
                    -- "models/props_tree/dire_tree007_inspector.vmdl",
                    -- "models/props_tree/dire_tree007_tintable_inspector.vmdl",
                    -- "models/props_tree/dire_tree008_inspector.vmdl",
                    -- "models/props_tree/dire_tree011.vmdl",
                    -- "models/props_tree/dire_tree009.vmdl",
                    -- "models/props_tree/tree_desert001.vmdl",
                    -- "models/props_tree/tree_cine_02_10k.vmdl",
                    -- "models/props_tree/tree_pine_00.vmdl",
                    -- "models/props_tree/tree_pine_03b_inspector.vmdl",
                }
                local position = self.parent:GetOrigin() - self.parent:GetForwardVector() * 150
                -- local index = ParticleManager:CreateParticle("particles/world_destruction_fx/dire_tree004b.vpcf", PATTACH_WORLDORIGIN, nil)
                -- ParticleManager:SetParticleControl(index, 0, position)
                -- ParticleManager:ReleaseParticleIndex(index)
                local tree = CreateTempTreeWithModel(position, 50, trees[RandomInt(1, #trees)])
                tree:SetModelScale(tree:GetModelScale() * 0.8)
                tree:SetContextThink(DoUniqueString("tree_think"), function ()
                    if not GameRules:IsGamePaused() then
                        local units = FindUnitsInRadius(
                            self.parent:GetTeamNumber(), 
                            tree:GetOrigin(), 
                            nil, 
                            800, 
                            DOTA_UNIT_TARGET_TEAM_ENEMY, 
                            DOTA_UNIT_TARGET_ALL, 
                            DOTA_UNIT_TARGET_FLAG_NONE, 
                            FIND_ANY_ORDER, 
                            false 
                        )
                        for _, unit in pairs(units) do
                            ProjectileManager:CreateTrackingProjectile({
                                EffectName = "particles/units/heroes/hero_tiny/tiny_tree_proj.vpcf",
                                Ability = self.ability,
                                iMoveSpeed = 1000,
                                vSourceLoc = tree:GetOrigin(),
                                Target = unit,
                                bDodgeable = false,
                                bProvidesVision = true,
                                iVisionTeamNumber = self.parent:GetTeamNumber(),
                                iVisionRadius = 0,
                                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
                            })
                            break
                        end
                    end
                    return 1
                end, 0)
            else
                -- 治疗树
                local trees = {
                    -- "models/props_tree/tree_oak_02_inspector.vmdl",
                    "models/props_tree/mango_tree.vmdl",
                    -- "models/props_tree/tree_pinestatic_02.vmdl",
                    -- "models/props_tree/armandpine/armandpine_01.vmdl",
                    -- "models/props_tree/tree_oak_02_inspector.vmdl",
                    -- "models/props_tree/tree_bamboo_01_inspector.vmdl",
                    -- "models/props_tree/frostivus_tree.vmdl",
                    -- "models/props_tree/newbloom_tree.vmdl",
                }
                local position = self.parent:GetOrigin() - self.parent:GetForwardVector() * 150
                -- local index = ParticleManager:CreateParticle("particles/world_destruction_fx/tree_oak_02.vpcf", PATTACH_WORLDORIGIN, nil)
                -- ParticleManager:SetParticleControl(index, 0, position)
                -- ParticleManager:ReleaseParticleIndex(index)
                local tree = CreateTempTreeWithModel(position, 50, trees[RandomInt(1, #trees)])
                tree:SetModelScale(tree:GetModelScale() * 2)
                tree:SetContextThink(DoUniqueString("tree_think"), function ()
                    if not GameRules:IsGamePaused() then
                        local units = FindUnitsInRadius(
                            self.parent:GetTeamNumber(), 
                            tree:GetOrigin(), 
                            nil, 
                            800, 
                            DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
                            DOTA_UNIT_TARGET_HERO, 
                            DOTA_UNIT_TARGET_FLAG_NONE, 
                            FIND_ANY_ORDER, 
                            false 
                        )
                        for _, unit in pairs(units) do
                            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_WORLDORIGIN, nil)
                            ParticleManager:SetParticleControl(index, 0, unit:GetOrigin())
                            ParticleManager:ReleaseParticleIndex(index)
                            unit:Heal(self.parent:GetStrength() * 2, self.parent)
                        end
                    end
                    return 1
                end, 0)
            end
        end
    end
end