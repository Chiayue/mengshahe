
function ability_unit( keys )
	local caster = keys.caster
	local target = keys.target

	local damageTable = {victim=target,
						attacker=caster,
						damage=100,
						damage_type=DAMAGE_TYPE_MAGICAL
						}
	ApplyDamage(damageTable)
end

-- function ability_null_continue_str( keys )
-- 	local ability = keys.ability	-- 技能对应句柄
-- 	local caster = keys.caster             --获取施法者
-- 	local targets = keys.target_entities   --获取传递进来的单位组
-- 	local al = ability:GetLevel() - 1   --获取技能等级，并且减1

-- 	local time = 0
-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_null_1_time"), 
-- 		function( )
-- 			if time < 10 then
-- 				--利用Lua的循环迭代，循环遍历每一个单位组内的单位
				
-- 				-- local damage_table = {}		-- 创建伤害传递表

-- 				-- damage_table.attacker = caster		-- 填写施法者
-- 				-- damage_table.damage_type = ability:GetAbilityDamageType()		-- 伤害类型
-- 				-- damage_table.ability = ability			-- 技能对应句柄
-- 				-- damage_table.victim = target			-- 承受伤害目标

-- 				-- damage_table.damage = int_caster * int_damage / 100		-- 计算出最终伤害值

-- 				-- ApplyDamage(damage_table)		-- 提交对单位造成伤害
-- 				for i,unit in pairs(targets) do
-- 					if IsValidEntity(unit) and unit:IsAlive() then    --这里判断单位是否为空，且单位是否存活
-- 						local value_caster = caster:GetStrength()	-- 获取施法者的力量属性值
-- 						-- local int_damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1)) 	-- 获取对应技能KV表里面的AbilitySpecial项下面的intellect_damage_pct参数的值
				
-- 						local damageTable = {
-- 							victim = unit,    --受到伤害的单位
-- 							attacker = caster,	  --造成伤害的单位
-- 							damage = value_caster * 6 + ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
-- 							damage_type = ability:GetAbilityDamageType()
-- 						}    --获取技能伤害类型，就是AbilityUnitDamageType的值
-- 						ApplyDamage(damageTable)    --造成伤害
-- 					else
-- 						unit = nil
-- 					end
-- 				end
-- 				time=time+1
-- 				return 1
-- 			else
-- 				return nil
-- 			end
-- 		end, 0)
-- end

function ability_sector_immediately_str( keys )	-- 立刻扇形造成范围伤害
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> sector")
	local caster = keys.caster       --获取施法者
	local target = keys.target		-- 目标
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1

	local value_caster = caster:GetStrength()	-- 获取施法者的力量属性值
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local vec = caster:GetOrigin()		--获取施法者的位置，及三围坐标
	local tvec = target:GetOrigin()		--获取目标的位置，及三围坐标
	local radius = keys.ability:GetLevelSpecialValueFor("radius", al)	--获取范围
	-- local targets = keys.target_entities   --获取传递进来的单位组

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, tvec, nil, radius, teams, types, flags, FIND_CLOSEST, true)

	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		-- print(">>>>>>>>>>> i: "..i)
		if IsValidEntity(unit) and unit:IsAlive() then    --这里判断单位是否为空，且单位是否存活
			local damageTable = {victim=unit,    --受到伤害的单位
				attacker=caster,	  --造成伤害的单位
				damage=value_caster*60+keys.ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
				damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
				-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
			ApplyDamage(damageTable)    --造成伤害
		end
	end
end


function ability_null_immediately_str( keys )	-- 立刻造成范围伤害
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> str")
	local caster = keys.caster       --获取施法者
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1

	local value_caster = caster:GetStrength()	-- 获取施法者的力量属性值
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local vec = caster:GetOrigin()		--获取施法者的位置，及三围坐标
	local radius = keys.ability:GetLevelSpecialValueFor("radius", al)	--获取范围

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)

	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		local damageTable = {victim=unit,    --受到伤害的单位
			attacker=caster,	  --造成伤害的单位
			damage=value_caster*60+keys.ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
			damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
		ApplyDamage(damageTable)    --造成伤害
	end
end

-- function ability_null_continue_int( keys )
-- 	local ability = keys.ability	-- 技能对应句柄
-- 	local caster = keys.caster             --获取施法者
-- 	local targets = keys.target_entities   --获取传递进来的单位组
-- 	local al = ability:GetLevel() - 1   --获取技能等级，并且减1

-- 	local time = 0
-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_null_1_time"), 
-- 		function( )
-- 			if time < 10 then
-- 				--利用Lua的循环迭代，循环遍历每一个单位组内的单位
				
-- 				-- local damage_table = {}		-- 创建伤害传递表

-- 				-- damage_table.attacker = caster		-- 填写施法者
-- 				-- damage_table.damage_type = ability:GetAbilityDamageType()		-- 伤害类型
-- 				-- damage_table.ability = ability			-- 技能对应句柄
-- 				-- damage_table.victim = target			-- 承受伤害目标

-- 				-- damage_table.damage = int_caster * int_damage / 100		-- 计算出最终伤害值

-- 				-- ApplyDamage(damage_table)		-- 提交对单位造成伤害
-- 				for i,unit in pairs(targets) do
-- 					if IsValidEntity(unit) and unit:IsAlive() then    --这里判断单位是否为空，且单位是否存活
-- 						local value_caster = caster:GetIntellect()	-- 获取施法者的智力属性值
-- 						-- local int_damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1)) 	-- 获取对应技能KV表里面的AbilitySpecial项下面的intellect_damage_pct参数的值
				
-- 						local damageTable = {
-- 							victim = unit,    --受到伤害的单位
-- 							attacker = caster,	  --造成伤害的单位
-- 							damage = value_caster * 6 + ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
-- 							damage_type = ability:GetAbilityDamageType()
-- 						}    --获取技能伤害类型，就是AbilityUnitDamageType的值
-- 						ApplyDamage(damageTable)    --造成伤害
-- 					else
-- 						unit = nil
-- 					end
-- 				end
-- 				time=time+1
-- 				return 1
-- 			else
-- 				return nil
-- 			end
-- 		end, 0)
-- end

function ability_null_immediately_int( keys )	-- 立刻造成范围伤害
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> int")
	local caster = keys.caster       --获取施法者
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1

	local value_caster = caster:GetIntellect()	-- 获取施法者的智力属性值
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local vec = caster:GetOrigin()		--获取施法者的位置，及三围坐标
	local radius = keys.ability:GetLevelSpecialValueFor("radius", al)	--获取范围

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)

	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		local damageTable = {victim=unit,    --受到伤害的单位
			attacker=caster,	  --造成伤害的单位
			damage=value_caster*60+keys.ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
			damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
		ApplyDamage(damageTable)    --造成伤害
	end
end

-- function ability_null_continue_agi( keys )
-- 	local ability = keys.ability	-- 技能对应句柄
-- 	local caster = keys.caster             --获取施法者
-- 	local targets = keys.target_entities   --获取传递进来的单位组
-- 	local al = ability:GetLevel() - 1   --获取技能等级，并且减1

-- 	local time = 0
-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_null_1_time"), 
-- 		function( )
-- 			if time < 10 then
-- 				--利用Lua的循环迭代，循环遍历每一个单位组内的单位
				
-- 				-- local damage_table = {}		-- 创建伤害传递表

-- 				-- damage_table.attacker = caster		-- 填写施法者
-- 				-- damage_table.damage_type = ability:GetAbilityDamageType()		-- 伤害类型
-- 				-- damage_table.ability = ability			-- 技能对应句柄
-- 				-- damage_table.victim = target			-- 承受伤害目标

-- 				-- damage_table.damage = int_caster * int_damage / 100		-- 计算出最终伤害值

-- 				-- ApplyDamage(damage_table)		-- 提交对单位造成伤害
-- 				for i,unit in pairs(targets) do
-- 					if IsValidEntity(unit) and unit:IsAlive() then    --这里判断单位是否为空，且单位是否存活
-- 						local value_caster = caster:GetAgility()	-- 获取施法者的敏捷属性值
-- 						-- local int_damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1)) 	-- 获取对应技能KV表里面的AbilitySpecial项下面的intellect_damage_pct参数的值
				
-- 						local damageTable = {
-- 							victim = unit,    --受到伤害的单位
-- 							attacker = caster,	  --造成伤害的单位
-- 							damage = value_caster * 6 + ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
-- 							damage_type = ability:GetAbilityDamageType()
-- 						}    --获取技能伤害类型，就是AbilityUnitDamageType的值
-- 						ApplyDamage(damageTable)    --造成伤害
-- 					else
-- 						unit = nil
-- 					end
-- 				end
-- 				time=time+1
-- 				return 1
-- 			else
-- 				return nil
-- 			end
-- 		end, 0)
-- end

function ability_null_immediately_agi( keys )	-- 立刻造成范围伤害
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> agi")
	local caster = keys.caster       --获取施法者
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1

	local value_caster = caster:GetAgility()	-- 获取施法者的敏捷属性值
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local vec = caster:GetOrigin()		--获取施法者的位置，及三围坐标
	local radius = keys.ability:GetLevelSpecialValueFor("radius", al)	--获取范围

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)

	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		local damageTable = {victim=unit,    --受到伤害的单位
			attacker=caster,	  --造成伤害的单位
			damage=value_caster*60+keys.ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
			damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
		ApplyDamage(damageTable)    --造成伤害
	end
end

-- function ability_null_continue_allattr( keys )
-- 	local ability = keys.ability	-- 技能对应句柄
-- 	local caster = keys.caster             --获取施法者
-- 	local targets = keys.target_entities   --获取传递进来的单位组
-- 	local al = ability:GetLevel() - 1   --获取技能等级，并且减1

-- 	local time = 0
-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_null_1_time"), 
-- 		function( )
-- 			if time < 10 then
-- 				--利用Lua的循环迭代，循环遍历每一个单位组内的单位
				
-- 				-- local damage_table = {}		-- 创建伤害传递表

-- 				-- damage_table.attacker = caster		-- 填写施法者
-- 				-- damage_table.damage_type = ability:GetAbilityDamageType()		-- 伤害类型
-- 				-- damage_table.ability = ability			-- 技能对应句柄
-- 				-- damage_table.victim = target			-- 承受伤害目标

-- 				-- damage_table.damage = int_caster * int_damage / 100		-- 计算出最终伤害值

-- 				-- ApplyDamage(damage_table)		-- 提交对单位造成伤害
-- 				for i,unit in pairs(targets) do
-- 					if IsValidEntity(unit) and unit:IsAlive() then    --这里判断单位是否为空，且单位是否存活
-- 						local value_caster = caster:GetAgility() + caster:GetStrength() + caster:GetIntellect()	-- 获取施法者的全属性值
-- 						-- local int_damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1)) 	-- 获取对应技能KV表里面的AbilitySpecial项下面的intellect_damage_pct参数的值
				
-- 						local damageTable = {
-- 							victim = unit,    --受到伤害的单位
-- 							attacker = caster,	  --造成伤害的单位
-- 							damage = value_caster * 6 + ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
-- 							damage_type = ability:GetAbilityDamageType()
-- 						}    --获取技能伤害类型，就是AbilityUnitDamageType的值
-- 						ApplyDamage(damageTable)    --造成伤害
-- 					else
-- 						unit = nil
-- 					end
-- 				end
-- 				time=time+1
-- 				return 1
-- 			else
-- 				return nil
-- 			end
-- 		end, 0)
-- end

function ability_null_immediately_allattr( keys )	-- 立刻造成范围伤害
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> all")
	local caster = keys.caster       --获取施法者
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1

	local value_caster = caster:GetStrength() + caster:GetIntellect() + caster:GetAgility()	-- 获取施法者的全属性值
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local vec = caster:GetOrigin()		--获取施法者的位置，及三围坐标
	local radius = keys.ability:GetLevelSpecialValueFor("radius", al)	--获取范围

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)

	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		local damageTable = {victim=unit,    --受到伤害的单位
			attacker=caster,	  --造成伤害的单位
			damage=value_caster*60+keys.ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
			damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
		ApplyDamage(damageTable)    --造成伤害
	end
end

function ability_null_immediately_strandagi( keys )	-- 立刻造成范围伤害
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> all")
	local caster = keys.caster       --获取施法者
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1

	local value_caster = caster:GetStrength() + caster:GetAgility()	-- 获取施法者的力量+敏捷属性值
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local vec = caster:GetOrigin()		--获取施法者的位置，及三围坐标
	local radius = keys.ability:GetLevelSpecialValueFor("radius", al)	--获取范围

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--获取范围内的单位，效率不是很高，在计时器里面注意使用
	local targets = FindUnitsInRadius(c_team, vec, nil, radius, teams, types, flags, FIND_CLOSEST, true)

	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		local damageTable = {victim=unit,    --受到伤害的单位
			attacker=caster,	  --造成伤害的单位
			damage=value_caster*60+keys.ability:GetLevelSpecialValueFor("damage", al),	--在GetLevelSpecialValueFor里面必须技能等级减1
			damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> damage: "..damageTable.damage);
		ApplyDamage(damageTable)    --造成伤害
	end
end


function ability_single_immediately_strandagi( keys )
	local caster = keys.caster
	local point = keys.target_points[1]

	local value_caster = caster:GetStrength() + caster:GetAgility()	-- 获取施法者的力量+敏捷属性值
	local radius = 400		--设置范围
	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE

	--设置施法者的面向角度
	caster:SetForwardVector( ((point - caster:GetOrigin()):Normalized()) )

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MyAbility_point_time"), 
		function( )

			--判断单位是否死亡，是否存在，是否被击晕
			if caster:IsAlive() and IsValidEntity(caster) and not(caster:IsStunned()) then
				
				--不是死亡，存在这个单位，没被击晕，就运行这里面的内容
				local caster_vec = caster:GetOrigin()		--获取施法者的位置

				if (point - caster_vec):Length()>50 then	--当单位移动到距离指定地点小于50时不在进行移动

					local caster_abs = caster:GetAbsOrigin()
					local face = (point - caster_abs):Normalized()
					local vec = face * 75.0
					caster:SetAbsOrigin(caster_abs + vec)

					return 0.01
				else
					--获取范围内的单位，效率不是很高，在计时器里面注意使用
					local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, radius, teams, types, flags, FIND_CLOSEST, true)

					--利用Lua的循环迭代，循环遍历每一个单位组内的单位
					for i,unit in pairs(targets) do
						local damageTable = {victim=unit,    --受到伤害的单位
							attacker=caster,	  --造成伤害的单位
							damage=value_caster*60,
							damage_type=DAMAGE_TYPE_PURE}
						ApplyDamage(damageTable)    --造成伤害
					end

					caster:RemoveModifierByName("modifier_phased")
					-- print("MyAbility_point Over")
					return nil
				end

			else
				caster:RemoveModifierByName("modifier_phased")
				-- print("Caster is death or stunned")
				return nil
			end
		end, 0)

	-- print("Run MyAbility_point Succeed")
end


function MyAbility_passive( keys )
end