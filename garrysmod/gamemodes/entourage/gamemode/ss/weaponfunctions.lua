dmg_modifier = 1
acc_modifier = 1

-- This is for running stuff related to crits.
function DoCrit()
	-- Since critting gives you 10 UP if you dealt damage:
	-- On a timer so that it can read wpndmg3
	timer.Simple( 0.2, function()
		if wpndmg3 > 0 then
			entourage_AddUP( 10, 25 )
		end
	end)
end
---------------------------------------------------------------

function Fists()
	thp = turntarget:Health()
	if math.random( 1, 100 ) <= player:GetNWString( "trueaccNW" ) * acc_modifier then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) + player:GetNWInt( "dfeNW" ) + math.random( wpndmg1, wpndmg2 ) * ( player:GetNWInt( "mgtNW" ) * 0.25 ) ) * dmg_modifier
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
		if turntarget:Health() <= 0 then
			PrintMessage( HUD_PRINTTALK, player:Name() .." defeated ".. turntargetsave .."!" )
			deaths = deaths + 1
		else
			if math.random( 1, 100 ) <= wpndmg3 / thp * 70 + player:GetNWInt( "mgtNW" ) then 
				turntarget:SetNWInt( "stunturns", turntarget:GetNWInt( "stunturns" ) + 1 )
				PrintMessage( HUD_PRINTTALK, turntargetsave .." is stunned for ".. turntarget:GetNWInt( "stunturns" ) .." turn(s)..." )
			end
		end
	else
		PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
	end
end

function OldCrowbar()
	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) +  pl_stats_tbl[ player:UserID() ].MGT * 0.25 + pl_stats_tbl[ player:UserID() ].AGI * 0.25 + pl_stats_tbl[ player:UserID() ].VIT * 0.25 ) * dmg_modifier + slash_dmg
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
	else
		PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
	end
end

function RustyKnife()
	wp_pierce = 0.25 + pl_stats_tbl[ player:UserID() ].FCS * 0.02

	if math.random( 1, 100 ) <= player:GetNWString( "trueaccNW" ) * acc_modifier then
		if math.random( 1, 100 ) <= 5 + pl_stats_tbl[ player:UserID() ].FCS * 3 then
			critmp = 2.5
			DoCrit()
			PrintMessage( HUD_PRINTTALK, player:Name() .." dealt critical damage!" )
		end
		wpndmg3 = ( ( wpndmg1 + pl_stats_tbl[ player:UserID() ].FCS + pl_stats_tbl[ player:UserID() ].AGI ) * critmp ) * dmg_modifier
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
		critmp = 1
	else
		PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
	end
end

function WoodenClub()
	thp = turntarget:Health()
	if math.random( 1, 100 ) <= player:GetNWString( "trueaccNW" ) * acc_modifier then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) + player:GetNWInt( "mgtNW" ) * 0.15 + math.random( wpndmg1, wpndmg2 ) * ( player:GetNWInt( "dfeNW" ) * 0.1 ) ) * dmg_modifier
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
		if turntarget:Health() <= 0 then
			PrintMessage( HUD_PRINTTALK, player:Name() .." defeated ".. turntargetsave .."!" )
			deaths = deaths + 1
		else
			if math.random( 1, 100 ) <= wpndmg3 / thp * 65 + player:GetNWInt( "mgtNW" ) - enemies_table[ turntargetsave ].DFX then 
				turntarget:SetNWInt( "stunturns", turntarget:GetNWInt( "stunturns" ) + 1 )
				PrintMessage( HUD_PRINTTALK, turntargetsave .." is stunned for ".. turntarget:GetNWInt( "stunturns" ) .." turn(s)..." )
			end
		end
	else
		PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
	end
end

function RopeSpear() -- use pltype2 to derive proper attack from damage type
	if pltype2 == "Slash" then
		if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) then 
			wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) + pl_stats_tbl[ player:UserID() ].MGT * 0.75 ) * ( dmg_modifier + slash_dmg )
			RunString( enemies_table[ turntargetsave ].AI2 )
			turntarget:TakeDamage( wpndmg3, player )
		else
			PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
		end
	elseif pltype2 == "Pierce" then
		
		if math.random( 1, 100 ) <= 5 + pl_stats_tbl[ player:UserID() ].FCS * 3 then
			critmp = 2.5
			PrintMessage( HUD_PRINTTALK, player:Name() .." dealt critical damage!" )
			DoCrit()
		end
		if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier then 
			wp_pierce = 0.25 + pl_stats_tbl[ player:UserID() ].FCS * 0.02
			wpndmg3 = ( ( wpndmg1 + pl_stats_tbl[ player:UserID() ].AGI * 0.75 ) * critmp ) * dmg_modifier
			RunString( enemies_table[ turntargetsave ].AI2 )
			turntarget:TakeDamage( wpndmg3, player )
			critmp = 1

		else
			PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
		end

	else -- BLUNT
		thp = turntarget:Health()
		if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier then 
			wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) ) * dmg_modifier
			RunString( enemies_table[ turntargetsave ].AI2 )
			turntarget:TakeDamage( wpndmg3, player )
			if turntarget:Health() <= 0 then
				PrintMessage( HUD_PRINTTALK, player:Name() .." defeated ".. turntargetsave .."!" )
				deaths = deaths + 1
			else
				if math.random( 1, 100 ) <= wpndmg3 / thp * 65 + pl_stats_tbl[ player:UserID() ].MGT - enemies_table[ turntargetsave ].DFX then 
					turntarget:SetNWInt( "stunturns", turntarget:GetNWInt( "stunturns" ) + 1 )
					PrintMessage( HUD_PRINTTALK, turntargetsave .." is stunned for ".. turntarget:GetNWInt( "stunturns" ) .." turn(s)..." )
				end
			end
		else
			PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
		end
	end
end

function KillerSword()
	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) then 
		wpndmg3 = math.random( wpndmg1, wpndmg2 ) * ( dmg_modifier + slash_dmg )
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
	else
		PrintMessage( HUD_PRINTTALK, "I never miss... I DON'T MISS! GET BACK HERE." )
	end
end