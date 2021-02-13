if modifier_shouren_didong == nil then 
    modifier_shouren_didong = class({})
end

function modifier_shouren_didong:IsPurgable()
    return false -- 无法驱散
end

function modifier_shouren_didong:IsHidden()
    return true 
end

function modifier_shouren_didong:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_shouren_didong:GetModifierAttackSpeedBonus_Constant()
    return 200
end

function modifier_shouren_didong:OnCreated( evt )
    if IsServer( ) then
        local caster = self:GetCaster()
        caster.attack_units = {}
        self.attack_amount = 9 --攻击人数上限
        self.attack_count = 0 --攻击计数
        self.attack_distance = 0 --与攻击者距离
        self.attack_range = 700 -- 攻击范围
        self.need_find = true --是否需要查找
        self:StartIntervalThink(0.5)
    end
end

function modifier_shouren_didong:OnAttackStart(params)
    
    if IsServer() then
        if params.attacker ~= self:GetParent() then
            return
        end
        if not params.attacker:IsAlive() then
            return
        end
        local didong = self:GetParent()
        if self:GetCaster().attack_units == nil or (#self:GetCaster().attack_units < 9 and self.need_find) then
            self:GetCaster().attack_units = FindUnitsInRadius( didong:GetTeamNumber(),didong:GetOrigin(),nil,self.attack_range,DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
            -- 身边单位小于10个 1秒后再查找
            if #self:GetCaster().attack_units < 9 then
                self.need_find = false
            end
        end
        for index,v in pairs(self:GetCaster().attack_units) do 
            if self.attack_count < self.attack_amount then 
                if (not v:IsNull()) and v:IsAlive() and v ~= params.target then
                    self.attack_distance = (v:GetOrigin() - didong:GetOrigin()):Length2D()
                    if  self.attack_distance < self.attack_range then
                        didong:PerformAttack(
                            v, -- 目标
                            true, -- 是否使用法球
                            true, -- bProcessProcs
                            true, -- 不冷却
                            false, -- 无视隐形
                            true, -- 使用弹道
                            false, -- 假攻击
                            false -- 不丢失
                        );
                        self.attack_count = self.attack_count + 1
                    else
                        self:GetCaster().attack_units[index] = nil
                    end
                else
                    self:GetCaster().attack_units[index] = nil
                end
            else
                self.attack_count = 0
                break
            end
        end
    end
end


function modifier_shouren_didong:OnDeath(params)
    if IsServer() then
        if params.unit == self:GetParent() then
            local hero = self:GetParent():GetOwner()
            local buff = hero:FindModifierByName("modifier_shouren_didong_no_see")
            if buff then
                buff:Destroy()
            end
        end
    end
end


function modifier_shouren_didong:OnIntervalThink()
    self.need_find = true
end

function modifier_shouren_didong:OnOrder( evt )
    if IsServer( ) then
        local target = evt.target
        if not target then
            return
        end
        if target ~= self:GetParent() then
            return
        end
        local hero = evt.unit
        if evt.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or evt.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
            if hero ~= self:GetCaster() then
                return
            end
            if (target:GetOrigin() - hero:GetOrigin()):Length2D() <200 then
                hero:AddNewModifier(target, self:GetAbility(), "modifier_shouren_didong_no_see", {})
                hero:AddEffects((EF_NODRAW))
                hero.attack_units = {}
                target:RemoveModifierByName("modifier_jiaoxie")
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()), "set_selected_unit", {index = target:GetEntityIndex()})
                
            end
        elseif evt.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or evt.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
            self:GetCaster().attack_units = FindUnitsInRadius( target:GetTeamNumber(),target:GetOrigin(),nil,self.attack_range,DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0,  0,false)
        end
    end
end


--设置英雄不可用
if modifier_shouren_didong_no_see == nil then 
    modifier_shouren_didong_no_see = class({})
end

function modifier_shouren_didong_no_see:OnCreated(params)
    if IsServer() then
        self:GetParent():SetOrigin(self:GetCaster():GetOrigin())
    end
end

function modifier_shouren_didong_no_see:IsHidden()
    return true
end

function modifier_shouren_didong_no_see:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    }
    return funcs
end

function modifier_shouren_didong_no_see:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true, --缴械
		[MODIFIER_STATE_INVULNERABLE] = true, --无敌
		[MODIFIER_STATE_NO_HEALTH_BAR] = true, --生命条
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true, -- 不执行命令
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true, -- 无小地图
        [MODIFIER_STATE_UNSELECTABLE] = true, -- 不可选
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, -- 无碰撞
        [MODIFIER_STATE_INVISIBLE] = true, -- 隐身
	}
end

function modifier_shouren_didong_no_see:GetModifierInvisibilityLevel(params)
    return 60
end

function modifier_shouren_didong_no_see:OnDestroy()
    if IsServer() then
        local postion = self:GetCaster():GetOrigin()+ RandomVector(100)
        self:GetParent():RemoveEffects(EF_NODRAW)
        self:GetParent():SetOrigin(postion)
        FindClearSpaceForUnit(self:GetParent(), postion, true)
    end
end

if modifier_jiaoxie == nil then 
    modifier_jiaoxie = class({})
end

function modifier_jiaoxie:IsHidden() return true end

function modifier_jiaoxie:CheckState()
    return {
        [MODIFIER_STATE_DISARMED] = true, --缴械
    }
end