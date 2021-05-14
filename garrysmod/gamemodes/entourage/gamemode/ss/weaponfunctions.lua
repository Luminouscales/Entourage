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
	PrintMessage( HUD_PRINTTALK, player:Name() .." dealt critical damage!" )
	turntarget:EmitSound( "mgb_crit1.mp3", 150, 100, 1, CHAN_BODY )
end

-- Stun for player
function DoStun2( bonus )
	if math.random( 1, 100 ) <= wpndmg3 / thp * ( 65 + bonus ) + pl_stats_tbl[ player:UserID() ].MGT then 
		turntarget:SetNWInt( "stunturns", turntarget:GetNWInt( "stunturns" ) + 1 )
		PrintMessage( HUD_PRINTTALK, turntargetsave .." is stunned for ".. turntarget:GetNWInt( "stunturns" ) .." turn(s)..." )
		if enemies_table[ turntargetsave ].StunAnim ~= nil then
			RunString( enemies_table[ turntargetsave ].StunAnim )
		end
	end
end

function DoDodge()
	PrintMessage( HUD_PRINTTALK, turntargetsave .." dodged ".. player:GetName() .."'s attack!" )
	if c_type2 == "Slash" then
		turntarget:EmitSound( "mgb_miss1.mp3", 150, 100, 1, CHAN_BODY )
	elseif c_type2 == "Pierce" then
		turntarget:EmitSound( "mgb_miss2.mp3", 150, 100, 1, CHAN_BODY )
	else
		turntarget:EmitSound( "mgb_miss3.mp3", 150, 100, 1, CHAN_BODY )
	end
end
---------------------------------------------------------------

function Fists()
	thp = turntarget:Health()
	if math.random( 1, 100 ) <= ( pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier ) - enemies_table[ turntargetsave ].DDG then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) + pl_stats_tbl[ player:UserID() ].VIT + math.random( wpndmg1, wpndmg2 ) * ( pl_stats_tbl[ player:UserID() ].MGT * 3 ) ) * dmg_modifier
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
		if turntarget:Health() <= 0 then
			PrintMessage( HUD_PRINTTALK, player:Name() .." defeated ".. turntargetsave .."!" )
			deaths = deaths + 1
		else
			DoStun2( 5 )
		end
	else
		DoDodge()
	end
end

function OldCrowbar()
	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) - enemies_table[ turntargetsave ].DDG then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) +  pl_stats_tbl[ player:UserID() ].MGT * 0.25 + pl_stats_tbl[ player:UserID() ].AGI * 0.25 + pl_stats_tbl[ player:UserID() ].VIT * 0.25 ) * ( dmg_modifier + slash_dmg )
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
	else
		DoDodge()
	end
end

function RustyKnife()
	wp_pierce = 0.25 + pl_stats_tbl[ player:UserID() ].FCS * 0.02

	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier - enemies_table[ turntargetsave ].DDG then
		if math.random( 1, 100 ) <= 5 + pl_stats_tbl[ player:UserID() ].FCS * 3 then
			critmp = 2.5
			DoCrit()
			
		end
		wpndmg3 = ( ( wpndmg1 + pl_stats_tbl[ player:UserID() ].FCS + pl_stats_tbl[ player:UserID() ].AGI ) * critmp ) * dmg_modifier
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
		critmp = 1
	else
		DoDodge()
	end
end

function WoodenClub()
	thp = turntarget:Health()
	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier - enemies_table[ turntargetsave ].DDG then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) + pl_stats_tbl[ player:UserID() ].MGT * 0.15 + math.random( wpndmg1, wpndmg2 ) * ( pl_stats_tbl[ player:UserID() ].VIT * 0.1 ) ) * dmg_modifier
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
		if turntarget:Health() <= 0 then
			PrintMessage( HUD_PRINTTALK, player:Name() .." defeated ".. turntargetsave .."!" )
			deaths = deaths + 1
		else
			DoStun2( 0 )
		end
	else
		DoDodge()
	end
end

function RopeSpear() -- use pltype2 to derive proper attack from damage type
	if pltype2 == "Slash" then
		if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) - enemies_table[ turntargetsave ].DDG then 
			wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) + pl_stats_tbl[ player:UserID() ].MGT * 0.75 ) * ( dmg_modifier + slash_dmg )
			RunString( enemies_table[ turntargetsave ].AI2 )
			turntarget:TakeDamage( wpndmg3, player )
		else
			DoDodge()
		end
	elseif pltype2 == "Pierce" then
		
		if math.random( 1, 100 ) <= 5 + pl_stats_tbl[ player:UserID() ].FCS * 3 then
			critmp = 2.5
			DoCrit()
		end
		if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier - enemies_table[ turntargetsave ].DDG then 
			wp_pierce = 0.25 + pl_stats_tbl[ player:UserID() ].FCS * 0.02
			wpndmg3 = ( ( wpndmg1 + pl_stats_tbl[ player:UserID() ].AGI * 0.75 ) * critmp ) * dmg_modifier
			RunString( enemies_table[ turntargetsave ].AI2 )
			turntarget:TakeDamage( wpndmg3, player )
			critmp = 1

		else
			DoDodge()
		end

	else -- BLUNT
		thp = turntarget:Health()
		if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * acc_modifier - enemies_table[ turntargetsave ].DDG then 
			wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) ) * dmg_modifier
			RunString( enemies_table[ turntargetsave ].AI2 )
			turntarget:TakeDamage( wpndmg3, player )
			if turntarget:Health() <= 0 then
				PrintMessage( HUD_PRINTTALK, player:Name() .." defeated ".. turntargetsave .."!" )
				deaths = deaths + 1
			else
				DoStun2( 0 )
			end
		else
			DoDodge()
		end
	end
end

function KillerSword()
	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) - enemies_table[ turntargetsave ].DDG then 
		wpndmg3 = math.random( wpndmg1, wpndmg2 ) * ( dmg_modifier + slash_dmg )
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
	else
		PrintMessage( HUD_PRINTTALK, "I never miss... I DON'T MISS! GET BACK HERE." )
	end
end

function SalvagedBlade()
	if math.random( 1, 100 ) <= pl_stats_tbl[ player:UserID() ].ACC_TRUE * ( acc_modifier + slash_acc ) - enemies_table[ turntargetsave ].DDG then 
		wpndmg3 = ( math.random( wpndmg1, wpndmg2 ) +  pl_stats_tbl[ player:UserID() ].MGT + pl_stats_tbl[ player:UserID() ].FCS * 0.75 ) * ( dmg_modifier + slash_dmg )
		RunString( enemies_table[ turntargetsave ].AI2 )
		turntarget:TakeDamage( wpndmg3, player )
	else
		DoDodge()
	end
end