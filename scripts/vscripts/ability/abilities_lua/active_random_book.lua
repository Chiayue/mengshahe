LinkLuaModifier("modifier_active_random_book", "ability/abilities_lua/active_random_book.lua", LUA_MODIFIER_MOTION_NONE)

active_random_book = class({})

function active_random_book:OnSpellStart()
    if IsServer() then
        self.caster = self:GetCaster()
        local books = {
            "item_book_passive_",
            "item_book_initiative_",
        }
        local book_name = books[RandomInt(1, 2)]
        if global_var_func.last_time <= 1800 and global_var_func.last_time > 1500 then
            book_name = book_name.."d"
        elseif global_var_func.last_time <= 1500 and global_var_func.last_time > 1200 then
            book_name = book_name.."c"
        elseif global_var_func.last_time <= 1200 and global_var_func.last_time > 900 then
            book_name = book_name.."b"
        elseif global_var_func.last_time <= 900 and global_var_func.last_time > 600 then
            book_name = book_name.."a"
        elseif global_var_func.last_time <= 600 and global_var_func.last_time >= 0 then
            book_name = book_name.."s"
        end
        local item = self.caster:AddItemByName(book_name)
        if not item then
            item = CreateItem(book_name,nil,nil)
            CreateItemOnPositionForLaunch(self.caster:GetOrigin()+RandomVector(150),item)
        end
    end
end

function active_random_book:GetIntrinsicModifierName()
    return "modifier_active_random_book"
end

-------------------------------------------------------------

modifier_active_random_book = class({})

function modifier_active_random_book:CheckState()
	return {}
end

function modifier_active_random_book:DeclareFunctions()
	return {
    }
end

function modifier_active_random_book:IsHidden()
    return true
end

function modifier_active_random_book:IsPurgable()
    return false
end
 
function modifier_active_random_book:RemoveOnDeath()
    return false
end

function modifier_active_random_book:OnCreated(params)
    if IsServer() then
        self.parent = self:GetParent()
        local position = self.parent:GetOrigin()
        local index = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ambient_hands_backup.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(index, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", position, true)
        ParticleManager:SetParticleControlEnt(index, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", position, true)
        local item = nil 
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/dark_seer/ds_manipulator_of_warsituation_arms/ds_manipulator_of_warsituation_arms.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/dark_seer/ds_manipulator_of_warsituation_back/ds_manipulator_of_warsituation_back.vmdl"})
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/dark_seer/dark_seer_warsituation_back/dark_seer_warsituation_back_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/dark_seer/ds_manipulator_of_warsituation_belt/ds_manipulator_of_warsituation_belt.vmdl"})
        item:FollowEntity(self.parent, true)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/dark_seer/ds_manipulator_of_warsituation_head/ds_manipulator_of_warsituation_head.vmdl"})
        item:FollowEntity(self.parent, true)
        ParticleManager:CreateParticle("particles/econ/items/dark_seer/dark_seer_warsituation_head/dark_seer_warsituation_ambient.vpcf", PATTACH_POINT_FOLLOW, item)
        item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/dark_seer/ds_manipulator_of_warsituation_shoulder/ds_manipulator_of_warsituation_shoulder.vmdl"})
        item:FollowEntity(self.parent, true)
    end
end