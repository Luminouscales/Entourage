-- This is for running stuff related to enemy crits. and stuns.
function DoCrit2()
	-- Taking crits decreases UP by 10. Also runs on stuns.
	timer.Simple( 0.2, function()
		if attackdmg > 0 then
			entourage_AddUP( -10, 25 )
		end
	end)
end

function DoCrit2a()
	if critbonus_a == nil then
		critbonus_a = 0
	end
	if math.random( 1, 100 ) <= enemies_table[ current_enemy:GetName() ].DMGC + critbonus_a then
		calc_info:SetDamage( calc_info:GetDamage() * 2.5 )
	end
end

function DoStun()
	if enemies_table[ current_enemy:GetName() ].DMGS ~= nil then
		local stunbonus_a = enemies_table[ current_enemy:GetName() ].DMGS
	else
		stunbonus_a = 0
	end
	if math.random( 1, 100 ) <= attackdmg / attacktarget:GetMaxHealth() * 70 + stunbonus_a - pl_stats_tbl[ attacktarget_id ].DFE * 2 - pl_stats_tbl[ attacktarget_id ].DFX * 0.5 - attacktarget:GetNWInt( "stunturns_a" ) * 40 then 
		attacktarget:SetNWInt( "stunturns", attacktarget:GetNWInt( "stunturns" ) + 1 )
		attacktarget:SetNWInt( "stunturns_a", attacktarget:GetNWInt( "stunturns" ) + 1 )
		PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." is stunned for ".. attacktarget:GetNWInt( "stunturns" ) .." turn(s)..." )
		DoCrit2()
	end
end
---------------------------------------------------------------

function FighterAI()  
	-- The most basic AI. Simply rolls a random player, then attacks them. Uses slash.
	-- No skills, no blocking, just attacking.
	attacktarget = table.Random( allplayers )
	attackdmg = ( enemies_table[ current_enemy:GetName() ].DMG - pl_stats_tbl[ attacktarget:UserID() ].DEF ) * ( 1 - pl_stats_tbl[ attacktarget:UserID() ].DFX * 0.005 )
	attackdmg = math.Round( math.Clamp( attackdmg, 1, 9999 ), 0 )
	
	if math.random( 1, 100 ) > pl_stats_tbl[ id ].DDG_TRUE + enemies_table[ current_enemy:GetName() ].MISS then
		attacktarget:TakeDamage( attackdmg, current_enemy )
		PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt ".. attackdmg .." ".. enemies_table[ current_enemy:GetName() ].DMGT .." damage to ".. attacktarget:GetName() )
	else
		PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." dodged ".. current_enemy:GetName() .."'s attack!" )
	end
end

function SniperAI()
	-- Pierce crit damage; priority: lowest health > highest flex defence > highest defence.
	-- Tries to assassinate targets with low health. Unfair and dangerous - actually probably underpowered.

	attacktarget = table.Random( allplayers ) -- This will have to be ported to multiplayer. Someday.
	
	if math.random( 1, 100 ) > pl_stats_tbl[ id ].DDG_TRUE + enemies_table[ current_enemy:GetName() ].MISS then

		if math.random( 1, 100 ) <= enemies_table[ current_enemy:GetName() ].DMGC then
			critmp = 2.5
			PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt critical damage!" )
			DoCrit2()
		end

		attackdmg = ( enemies_table[ current_enemy:GetName() ].DMG ) - ( pl_stats_tbl[ id ].DEF * enemies_table[ current_enemy:GetName() ].DMGP ) * critmp
		attackdmg = math.Round( math.Clamp( attackdmg, 0, 9999 ), 0 )
			attacktarget:TakeDamage( attackdmg, current_enemy )
		PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt ".. attackdmg .." ".. enemies_table[ current_enemy:GetName() ].DMGT .." damage to ".. attacktarget:GetName() )
		critmp = 1
	else
		PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." dodged ".. current_enemy:GetName() .."'s attack!" )
	end

end

function KnockerAI()
	-- Blunt damage; priority: lowest health
	-- Tries to stun the player.
	attacktarget = table.Random( allplayers )
	attackdmg = ( enemies_table[ current_enemy:GetName() ].DMG - pl_stats_tbl[ id ].DEF * 0.8 ) * ( 1 - pl_stats_tbl[ id ].DFX * 0.02 )
	attackdmg = math.Round( math.Clamp( attackdmg, 0, 9999 ), 0 )
	
	if math.random( 1, 100 ) > pl_stats_tbl[ id ].DDG_TRUE + enemies_table[ current_enemy:GetName() ].MISS then
		attacktarget:TakeDamage( attackdmg, current_enemy )
		PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt ".. attackdmg .." ".. enemies_table[ current_enemy:GetName() ].DMGT .." damage to ".. attacktarget:GetName() )

		if math.random( 1, 100 ) <= attackdmg / attacktarget:GetMaxHealth() * 70 + enemies_table[ current_enemy:GetName() ].DMGS - attacktarget:GetNWInt( "dfeNW" ) * 2 - attacktarget:GetNWInt( "dfxNW" ) * 0.5 - attacktarget:GetNWInt( "stunturns_a" ) * 30 then 
			DoStun()
		end
	else
		PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." dodged ".. current_enemy:GetName() .."'s attack!" )
	end
end


-- Calculates damage based on resistances

function SnowtlionMinerDMG()
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.0075 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) * 2.5
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) * 0.85
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function UniversalDMG() -- TEMPLATE
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.005 ) -- slash deals more against flex defence
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) -- pierce is unaffected by DFX
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) -- blunt is affected less by defence and more by DFX
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function SkinnerDMG()
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.005 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) * 0.75
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) * 1.75
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end