-----------------------------------------------------------------------------
--  内容:游戏内部设置 & 方法工具  by.泽里艾伦
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
---游戏

--人物额外基础状态抗性
SR=10
--人物额外基础魔法抗性
MR=10
--人物额外基础护甲
AR=3
--人物额外基础血量
--HP=600

---自定义预加载
function TG_Precache()
  --状态抗性
  LinkLuaModifier("modifier_tg_ab_sr", "tg/tg_modifier/modifier_status_resistance.lua", LUA_MODIFIER_MOTION_NONE)

   --神秘据点恢复
  LinkLuaModifier("modifier_heal", "tg/tg_trigger/TG_HEAL.lua", LUA_MODIFIER_MOTION_NONE)

  --神秘据点怪物属性
  LinkLuaModifier("modifier_tg_monster", "tg/tg_modifier/modifier_monster.lua", LUA_MODIFIER_MOTION_NONE)

    --中立金钱巨魔
    LinkLuaModifier("modifier_tg_troll", "tg/tg_modifier/modifier_troll.lua", LUA_MODIFIER_MOTION_NONE)

  --战争老将英雄特效 (英雄特效暂未完工)
  LinkLuaModifier("modifier_tg_hero_hell", "tg/tg_modifier/modifier_tg_hero_hell.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_tg_hero_night", "tg/tg_modifier/modifier_tg_hero_night.lua", LUA_MODIFIER_MOTION_NONE)

--独占特效惹
  LinkLuaModifier("modifier_tg_sun_aura", "tg/tg_modifier/modifier_tg_sun_aura.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_tg_mystical_aura", "tg/tg_modifier/modifier_tg_mystical_aura.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_imba_attack_modifier", "tg/tg_modifier/modifier_imba_attack_modifier.lua", LUA_MODIFIER_MOTION_NONE)
end

illusion_BUFF = {
	"modifier_medusa_stone_gaze",
	"modifier_gyrocopter_flak_cannon_scepter",
 -- "modifier_pangolier_gyroshell",
  "modifier_tg_jugg_inv",
	}

-----------------------------------------------------------------------------
---英雄天赋模板
-----------------------------------------------------------------------------
function IsAddTalent(tg)
local DONT_HERO_TALENT=
{
  ["npc_dota_hero_axe"] = true,
  ["npc_dota_hero_chen"] = true,
  ["npc_dota_hero_enchantress"] = true,
  ["npc_dota_hero_leshrac"] = true,
  ["npc_dota_hero_zuus"] = true,
  ["npc_dota_hero_shadow_shaman"] = true,
  ["npc_dota_hero_juggernaut"] = true,
  ["npc_dota_hero_ancient_apparition"] = true,
  ["npc_dota_hero_windrunner"] = true,
  ["npc_dota_hero_mars"] = true,
}
return DONT_HERO_TALENT[tg]
end

--获取英雄天赋值
function CDOTA_BaseNPC:TG_GetTalentValue(name,v)
  local kv = v or "value"
  local t = self:FindAbilityByName(name)
  if t and t:GetLevel() >= 1 then
      return t:GetSpecialValueFor(kv) 
  end
  return 0 
end

--判断是否拥有此天赋
function CDOTA_BaseNPC:TG_HasTalent(name)
  if self:HasAbility(name) then
      local t = self:FindAbilityByName(name)
      if t and t:GetLevel() > 0 then 
          return true 
      end     
  end
  return false
end
-----------------------------------------------------------------------------
---信使设置
-----------------------------------------------------------------------------

--信使表
if CDOTA_PlayerResource.TG_COURIER == nil then
	CDOTA_PlayerResource.TG_COURIER = {}
end
--信使在泉水反回时间
COURIER_RETURN_TIME=10

function TG_Courier_Set(courier)
  courier:FindAbilityByName("courier_transfer_items"):SetLevel(1)
  courier:FindAbilityByName("tg_courier_ab"):SetLevel(1)
  courier:FindAbilityByName("courier_shield"):SetLevel(1)
  courier:FindAbilityByName("courier_burst"):SetLevel(1)
  table.insert(CDOTA_PlayerResource.TG_COURIER, courier)
  end


---防御塔死亡
--防御塔被击杀，击杀者额外金钱
HERO_TOWER_GOLD=800

--防御塔被击杀，落后方补偿
LOSE_TOWER_GOLD=700
LOSE_TOWER_XP=1000

--防御塔爆炸范围
TOWER_BOOM_RFD=1000

function TG_TowerKill(t)
  local gold = t.gold
	local killerPlayer = PlayerResource:GetPlayer(t.killer_userid)
  local tower_team = t.teamnumber
  
  --击杀者额外金钱
  if killerPlayer ~= nil then
    game_playerinfo:set_player_gold(killerPlayer:GetPlayerID(),HERO_TOWER_GOLD)
		SendOverheadEventMessage(PlayerResource:GetPlayer(killerPlayer:GetPlayerID()), OVERHEAD_ALERT_GOLD,killerPlayer, HERO_TOWER_GOLD, nil)
	end	

  --落后补偿
	for i=1, 24 do
		if CDOTA_PlayerResource.IMBA_PLAYER_HERO[i] then
			
			local hero = CDOTA_PlayerResource.IMBA_PLAYER_HERO[i]
			if hero:GetTeamNumber() == tower_team then
				if hero~= nil then
          game_playerinfo:set_player_gold(hero:GetPlayerID(),LOSE_TOWER_GOLD)
           hero:AddExperience(LOSE_TOWER_XP, DOTA_ModifyXP_Unspecified, false, false)
           SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD,hero, LOSE_TOWER_GOLD, hero)
           SendOverheadEventMessage(hero, OVERHEAD_ALERT_MAGICAL_BLOCK, hero, LOSE_TOWER_XP, hero)
			  end
		  end
		end
  end


  if tower_team == 3 then
    TG_Monster("DOTA_TEAM_BADGUYS",tower_team,MONSTER_BAD)
    else
    TG_Monster("DOTA_TEAM_GOODGUYS",tower_team,MONSTER_GOOD)
    end
end

--神秘据点怪物
--天辉怪物
MONSTER_GOOD="npc_dota_goodguys_monster_s"

--夜魇怪物
MONSTER_BAD="npc_dota_badguys_monster_s"

function TG_Monster(team,num,monster)
  local pos=Entities:FindByName(nil,team)
  local monster=CreateUnitByName(monster, pos:GetAbsOrigin(),false,nil,nil,num)
  monster:AddNewModifier(monster, nil, "modifier_tg_monster", {})
  monster:SetMustReachEachGoalEntity( true )
  monster:SetInitialGoalEntity( pos )
  monster:FindAbilityByName("tg_monster"):SetLevel(1)
  Notifications:TopToAll({text="--神秘据点诞生了怪物--", duration=3.0})
  --EmitGlobalSound("stinger_radiant_hallow")
  EmitAnnouncerSound( "announcer_ann_custom_adventure_alerts_48" )
  end


  --刷新时间
  TIME_CREE=60

  --刷新延迟
  TIME_DELAY=300
  --加强小兵
  function TG_Creep()
    Timers:CreateTimer(TIME_DELAY, function()
      local badguyspos=Entities:FindByName(nil,"lane_mid_pathcorner_badguys_7")
      local goodguyspos=Entities:FindByName(nil,"lane_mid_pathcorner_goodguys_7")
      local monster1=CreateUnitByName("npc_dota_creep_goodguys_monster", badguyspos:GetAbsOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
      local monster2=CreateUnitByName("npc_dota_creep_badguys_monster", goodguyspos:GetAbsOrigin(),false,nil,nil,DOTA_TEAM_BADGUYS)
      monster1:SetMustReachEachGoalEntity( true )
      monster1:SetInitialGoalEntity( goodguyspos )
      monster1:AddNewModifier(monster1, nil, "modifier_imba_fly", {})
      monster1:FindAbilityByName("luna_lunar_blessing"):SetLevel(4)
      monster2:SetMustReachEachGoalEntity( true )
      monster2:SetInitialGoalEntity( badguyspos )
      monster2:AddNewModifier(monster2, nil, "modifier_imba_fly", {})  
      monster2:FindAbilityByName("luna_lunar_blessing"):SetLevel(4)
			return TIME_CREE
		end
	)
     end


    --刷新延迟
    TIME_TROLL_DELAY=300
    --刷新间隔
    TIME_TROLL_INTERVAL=0

     --中立金钱
     function TG_Troll()
      Timers:CreateTimer(TIME_TROLL_DELAY, function()
        local badguyspos=Entities:FindByName(nil,"lane_mid_pathcorner_badguys_7")
        local troll=CreateUnitByName("npc_dota_troll",Vector(-500,-400,0),false,nil,nil,DOTA_TEAM_NEUTRALS)
        troll:AddNewModifier(troll, nil, "modifier_tg_troll", {}) 
        Notifications:TopToAll({text="--中路河道出现了金钱巨魔快去击杀它--", duration=3.0})
        EmitAnnouncerSound( "announcer_ann_custom_generic_alert_72" )
        return nil
      end
    )
     end

---英雄连续死亡3次
--金钱补偿基础
HERO_Kill_GOLD=50
function TG_HERO_Kill(h)
  if h ~= nil then
    local G=h:GetLevel()*HERO_Kill_GOLD
    game_playerinfo:set_player_gold(h:GetPlayerID(),G)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD,h, G, nil)
  end
end

---抽奖包
function TG_LUCK(tg)
	tg:AddItemByName("item_tg_luck_s")
end


--陈随机技能
Random_Abilities={
  "imba_puck_dream_coil",
  "tiny_grow",
  "windrunner_focusfire",
  "zuus_thundergods_wrath",
  "imba_kunkka_ghostship",
  "imba_faceless_void_chronosphere",
  "chen_hand_of_god",
  "lycan_shapeshift",
  "imba_antimage_blink",
  "imba_juggernaut_blade_fury",
  "imba_sven_storm_bolt",
  "imba_lion_hex",
  "slardar_bash",
  "imba_tinker_laser",
  "imba_faceless_void_time_lock",
  "life_stealer_imba_feast",
  "imba_omniknight_degen_aura",
  "windrunner_shackleshot",
  "shadow_shaman_voodoo",
  "enchantress_untouchable",
  "jakiro_ice_path",
  "templar_assassin_refraction",
}




--特效
STEAMID=
{
  76561198097609945,
  76561198100269546,
  76561198361355161,
  76561198319625131,
  76561198078081944,
}
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
---工具

--释放内存
function TG_GC()
	--local time=5
	--	PauseGame( true )
	--	local a = collectgarbage("count")
  --	print("a ", a, "kb")
  Timers:CreateTimer(0, function()
    collectgarbage("collect")
    --Notifications:TopToAll({text="--释放内存中，请等待"..time.."秒--", duration=1})
    return 300
  end)
	--	local b = collectgarbage("count")
	--	print("b ", b, "kb")
	--[[	Timers:CreateTimer("gc", {
			useGameTime = false,
			endTime = 0,
			callback = function()
				time=time-1
				if time<1 then
					--PauseGame( false )
					return nil
				else
					Notifications:TopToAll({text="--释放内存中，请等待"..time.."秒--", duration=1})
					return 1
				end

			end
		})]]
end

--求表中最大或最小值
--[ 0:最大值,1:最小值 ]
function TG_table_value(table,num)
    if table~=nil then
        local value=nil;
        if num==0 then
            for k, v in pairs(t) do
              if value==nil then
                value=v
              elseif value < v then
                value = v
              end
            end
        elseif num==1 then
            for k, v in pairs(t) do
                if value==nil then
                  value=v
                elseif value > v then
                  value = v
                end
              end
        end
        return value
    end
end


function value_nil(var)
    if var==nil then
        return true
    end
    return false
end



--获取向量距离
function TG_distance(fpos,spos)
  return ( fpos - spos):Length2D()
end

--获取向量方向
function TG_direction(fpos,spos)
  local DIR=( fpos - spos):Normalized()
  DIR.z=0
  return DIR
end

--查询背包物品
function TG_ItemSlot_GET(gameobjct,itemname)
  if gameobjct:HasInventory() then
    for i=0,9 do
      for j=1, #(itemname) do
     local item= gameobjct:GetItemInSlot(i)
			if item~=nil then 
        if item:GetName()==itemname[j] then
          return true
        end	
      end	
    end
		end
end
return false
end

--判断是敌人还是友军
function TG_Enemy_GET(target,caster) 
  if target:GetTeamNumber()~=caster:GetTeamNumber() then
    return true
  end
  return false
end

--获取状态抗性
function TG_StatusResistance_GET(target,duration) 
  local sr=target:GetStatusResistance()
    if sr and sr>0 then
      local sr_dur = duration-duration*(sr)
       return sr_dur
    else
      return duration
    end
end

--添加修饰器层数
function TG_Modifier_Num_ADD(tar,name,num1,num2) 
  local var=0
  if tar:HasModifier(name) then
    local modifier= tar:FindModifierByName( name )
    var=modifier:GetStackCount()+num1
   tar:RemoveModifierByName( name)
else
  var=num2  
end
tar:AddNewModifier(tar, nil, name, {num=var})
end