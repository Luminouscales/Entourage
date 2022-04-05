util.AddNetworkString( "encounter_cl" )
util.AddNetworkString( "encounter_intro" )
util.AddNetworkString( "player_makeattack" )
util.AddNetworkString( "player_doturn" )
util.AddNetworkString( "encounter_outro" )
util.AddNetworkString( "getmycordsyoufuckingcunt" )
util.AddNetworkString( "enemysend" )
util.AddNetworkString( "player_brace" )
util.AddNetworkString( "player_wait" )
util.AddNetworkString( "player_removestunturns" )
--util.AddNetworkString( "player_biststunned" )
util.AddNetworkString( "descmodel_cl1" ) 
util.AddNetworkString( "descmodel_cl2" )
util.AddNetworkString( "net_enemy_senddata" )
util.AddNetworkString( "up_hudshow" )
util.AddNetworkString( "sendskillnote" )
util.AddNetworkString( "DISPLAY_PAIN" )
util.AddNetworkString( "givemereverie" )
util.AddNetworkString( "fuckmylife" )
util.AddNetworkString( "endgame" )
util.AddNetworkString( "sendplconv" )

-- set variables
lives = 0
deaths = 0
critmp = 1
timer_delay = 0
up_add = 0
up_remove = 0
ss_inbattle = false
global_value = 0
up_int = 0
up_open = true
enemy_choices = 0
players_alive = true
enemy_alive = true
fox_override = 0
-------------------

function SendDialogue( tier, ent, table, override )
	net.Start( "sendplconv" )
		net.WriteInt( tier, 32 )
		net.WriteInt( ent:EntIndex(), 32 )
		if override then
			net.WriteString( table )
		else
			local pog = pl_conv_tbl[ ent:UserID() ][table]
			net.WriteString( pog[ math.random( 1, #pog ) ] )
		end
	net.Broadcast()
end
-- UP stuff -------------------------------------------------------------------------

-- UP function.
function entourage_AddUP( value, max )
	local value = math.Round( math.Clamp( value, -25, max ), 0 )
	-- up_open is false only when this function is ran through a skill, which means you shouldn't gain UP.
	if up_open == false and value > 0  then
		value = 0
	end
	Levitus:SetNWInt( "team_UP", math.Clamp( Levitus:GetNWInt( "team_UP" ) + value, 0, 100 ) )
	local global_value = global_value + value

	if timer.Exists( "up_hudshow_timer" ) == false and global_value ~= 0 then
		timer.Create( "up_hudshow_timer", 0.5, 1, function() 
			net.Start( "up_hudshow" )
				net.WriteInt( global_value, 32 )
			net.Broadcast()
			global_value = 0
			up_open = true
		end)
	else
		up_open = true
	end
end

-- UP hooks.
hook.Add( "EntityTakeDamage", "UP_detect_hook", function( target, dmg )
	-- Make sure it doesn't somehow run when outside of battle.
	if ss_inbattle then 
		local dmg_ov = dmg:GetDamage()
		local dmg_attacker = dmg:GetAttacker()
		-- If a player dealt damage TO NPC
		if dmg_attacker:IsPlayer() and target:IsNPC() then
			local portion = dmg_ov / target:GetMaxHealth()
			entourage_AddUP( math.Clamp( portion * 30, 1, 25 ), 25 )
			-- This function manages damage resistance for enemies like the Guardian. It sucks, I know, but it has to be done.
			if target:GetClass() == "npc_antlionguard" then
				-- MODS
				dmg_ov = math.floor( dmg_ov * 0.75 )
			end
			---------------------------------------------------------
			PrintMessage( HUD_PRINTTALK, dmg_attacker:GetName() .." dealt ".. dmg_ov .." ".. c_type2 .." damage to ".. target:GetName() .."!" )

			if math.random( 0, 100 ) + portion * 150 + fox_override >= 100 and dmg_ov < target:Health() then
				SendDialogue( 0, dmg_attacker, "plconv_dmg" )
			end
			-- If fatal
			if dmg_ov >= target:Health() and target:Health() > 0 then
				-- Ugly, yes, but necessary. 
				if target == enemy1 then
					enemy1 = nil
				elseif target == enemy2 then
					enemy2 = nil
				else
					enemy3 = nil
				end
				-----------------
				-- print( target:GetNWInt( "tbl_deaths" ) )
				table.remove( battle_enemies, target:GetNWInt( "tbl_deaths" ) )
				actions = actions - 1
				PrintMessage( HUD_PRINTTALK, dmg_attacker:GetName() .." defeated ".. target:GetName() .."!" )
				deaths = deaths + 1
				lives = lives - 1

				-- c_type2 = nil

				-- Send EXP
				local timer_delay = 0 -- change if necessary
				timer.Simple( timer_delay, function() -- im pretty sure this is necessary to prevent shit from fucking up
					net.Start( "net_enemy_senddata" )
						net.WriteInt( enemies_table[ target:GetName() ].LVL, 32 )
						net.WriteInt( enemies_table[ target:GetName() ].EXP, 32 )
					net.Broadcast()
				end)
				for k, v in ipairs( battle_enemies ) do
					v:SetNWInt( "tbl_deaths", k )
				end
				if table.IsEmpty( battle_enemies ) then
					enemy_alive = false
					timer.Simple( 2, function()
						EndBattle()
					end)
				end
			elseif enemies_table[ target:GetName() ].PainAnim ~= nil then
				RunString( enemies_table[ target:GetName() ].PainAnim )
			end
			net.Start( "DISPLAY_PAIN" )
				net.WriteEntity( target )
				net.WriteInt( dmg_ov, 32 )
				net.WriteBool( false ) -- heal? true or false
			net.Broadcast()

		-- If damage to player
		elseif target:IsPlayer() then
			-- Endure if possible
			local id = target:UserID()
			local endurevar2 = pl_stats_tbl[ id ].endurevar
			if dmg_ov >= target:Health() and endurevar2 > 0 then
				dmg:SetDamage( math.Clamp( dmg:GetDamage(), 0, target:Health() - 1 ) )
				pl_stats_tbl[ id ].endurevar = math.Clamp( endurevar2 - 1, 0, 100 )
				PrintMessage( HUD_PRINTTALK, target:GetName() .." endured a fatal blow!" )

				SendDialogue( 0, target, "plconv_endure" )
			elseif dmg_ov >= target:GetMaxHealth() * 0.5 then
				SendDialogue( 0, target, "plconv_hit_h" )
			elseif math.random( 1, 4 ) == 1 then
				SendDialogue( 0, target, "plconv_hit_n" )
			end
		end
	end
end)

-- Health add function
function entourage_AddHealth( hptarget, hp )
	local hp2 = math.Round( math.Clamp( hp, 0, hptarget:GetMaxHealth() - hptarget:Health() ), 0 )
	if hp2 > 0 then
		hptarget:SetHealth( hptarget:Health() + hp2 )
		hptarget:EmitSound( "items/smallmedkit1.wav", 150, 100, 1, CHAN_BODY )
	end

	net.Start( "DISPLAY_PAIN" )
		net.WriteEntity( hptarget )
		net.WriteInt( hp2, 32 )
		net.WriteBool( true ) -- heal? true or false
	net.Broadcast()

	PrintMessage( HUD_PRINTTALK, hptarget:GetName() .." was healed for ".. hp2 .." HP!" )
end

hook.Add( "PlayerDeath", "playerdeath_hook", function( victim, inflictor, attacker )
	if attacker:IsNPC() or attacker:IsPlayer() then
		-- Deduct UP for dying.
		entourage_AddUP( -25, 25 )
	end
	-- Set spectate mode
	timer.Simple( 0.01, function()
		victim:Spectate(OBS_MODE_CHASE)
	end)
	
	local hot = 0
	for _, ply in ipairs( player.GetAll() ) do 
		if ply:Alive() then
			hot = hot + 1
		return end
	end
	if hot == 0 then
		players_alive = false
		timer.Simple( 2.5, function()
			EndGame()
		end)	
	end

	SendDialogue( 1, victim, "plconv_die" )
end)

function Calculatum()
	for _, v in ipairs( player.GetAll() ) do 
		local id = v:UserID()
		local defbonus = ( pl_stats_tbl[ id ].AGI_TRUE + pl_stats_tbl[ id ].FCS_TRUE ) * ( 0.5 * pl_stats_tbl[ id ].vint ) -- via precision
		pl_stats_tbl[ id ].FCS_TRUE = pl_stats_tbl[ id ].FCS + v:GetNWInt( "offset_fcs" )
		pl_stats_tbl[ id ].MGT_TRUE = pl_stats_tbl[ id ].MGT + v:GetNWInt( "offset_mgt" )
		pl_stats_tbl[ id ].AGI_TRUE = pl_stats_tbl[ id ].AGI + v:GetNWInt( "offset_cle" )
		pl_stats_tbl[ id ].VIT_TRUE = pl_stats_tbl[ id ].VIT + v:GetNWInt( "offset_dfe" )
		pl_stats_tbl[ id ].DFX_TRUE = pl_stats_tbl[ id ].DFX + v:GetNWInt( "offset_dfx" )
		pl_stats_tbl[ id ].DEF_TRUE = pl_stats_tbl[ id ].DEF + v:GetNWInt( "offset_def" ) + defbonus
		pl_stats_tbl[ id ].flatdmg_TRUE = pl_stats_tbl[ id ].flatdmg + v:GetNWInt( "offset_flatdmg" )


		pl_stats_tbl[ id ].DDG_TRUE = pl_stats_tbl[ id ].DDG + v:GetNWInt( "offset_ddg" ) + pl_stats_tbl[ id ].AGI_TRUE
		pl_stats_tbl[ id ].ACC_TRUE = items_table[ pl_stats_tbl[id].currentweapon ].BaseAcc + v:GetNWInt( "offset_acc" ) + pl_stats_tbl[ id ].AGI_TRUE + pl_stats_tbl[ id ].FCS_TRUE * 5

		if v:GetNWInt( "stunturns_a" ) > 0 then
			v:SetNWInt( "stunturns_a", v:GetNWInt( "stunturns_a" ) - 1 )
			print( v:GetNWInt( "stunturns_a" ) )
		end
	end
end

-- True Accuracy and True Dodge calculation for players
hook.Add( "EnemyTurnEnd", "accresets", Calculatum )
hook.Add( "PlayerTurnEnd", "accresets2", Calculatum )

--------------------------------------------------------------------------------------

-- This function is used in EVERY battle encounter and so shares functions.
-- However, every function must specify beforeclaw what colours to use (this is the "doom" variable).
function EncounterInit( delay )

	-- Start-up variables
	encounter_rate2 = 0 
	lives = 0
	deaths = 0
	turn = 1
	ss_inbattle = true
	-------------------

	-- Manage player visuals
	Entity(1):AddFlags( 128 )
	Entity(1):SetVelocity( Entity(1):GetVelocity()*-1 )
	Entity(1):ScreenFade( 16, Color( doom.r, doom.g, doom.b, 100), 0.05, 0.05 )

	-- fade in
	timer.Simple( 1, function()
		Entity(1):ScreenFade( 2, doom, 1.5, 0.6 )
	end)
	-- fade out
	timer.Simple( 3, function()
		Entity(1):ScreenFade( 1, doom, 1.5, 0.6 )
		Entity(1):SetPos( Vector( -80, 116, -982 ) )
		Entity(1):SetEyeAngles( Angle( 0, -90, 0 ))
		Entity(1):SetViewEntity( ent_cam_override1 )
		
		PrintMessage( HUD_PRINTTALK, "_____________________" )
		PrintMessage( HUD_PRINTTALK, "Turn ".. turn )

		-- This helps shit work. Without this, the battle sequence will 
		-- break if an enemy is insta-killed on the first turn. Fun.
		timer.Simple( 4, function()
			for k, v in ipairs( battle_enemies ) do
				v:SetNWInt( "tbl_deaths", k )
			end
		end)
	end)

	net.Start( "encounter_intro" ) -- Send the go-ahead to the clients
		net.WriteInt( stakes, 32 ) -- 1 for generic 2 for boss
		net.WriteInt( delay, 32 )
		local table = {}
		for k, v in ipairs( player.GetAll() ) do
			table[k] = v
		end
		net.WriteTable( table )
	net.Broadcast()

	hook.Remove( "Tick", "encounter_hook" )
end
-------------------------------------------------------------------------------------------------------------------------------

-- Reset encounter
function EncounterReset2()
	hook.Add( "Tick", "encounter_hook", function()
		if tostring( Entity(1):GetVelocity() ) > tostring( Vector(0, 0, 0) ) then
			encounter_rate2 = encounter_rate2 + 1
		end
	
		if encounter_rate2 >= encounter_rate then -- ENCOUNTER!
			EncounterRun1()
		end
	end)

	net.Start( "encounter_cl" )
	net.Broadcast()
end

function EncounterRun1()
	doom = color_white
	stakes = 1
	-- this is where everything ubiquitous happens
	EncounterInit( 0 )
	-----------------------

	timer.Simple( 3, function()
		EncounterAntlion( zone1_1 )
		BattleSetup() 
	end)
end

function BattleSetup() -- BATTLE STARTS HERE
	buffs_tbl_enemy = {}
	players_alive = true
	timer.Simple( 1, function()
		for k, v in pairs( battle_enemies ) do 
			buffs_tbl_enemy[v:EntIndex()] = {}
		end
		sexy_int = 0
		for k, v in pairs( battle_enemies ) do 
			sexy_int = sexy_int + enemies_table[ v:GetName() ].actionvar
		end
		actions = sexy_int
		Calculatum()
	end)
end

net.Receive( "getmycordsyoufuckingcunt", function( len, ply ) -- reset cords setup
	posNW = net.ReadVector()
	angleNW = net.ReadAngle()
	hpNW = net.ReadDouble()
	ply:SetNWVector( "vectornw", posNW )
	ply:SetNWAngle( "anglenw", angleNW)
	ply:SetHealth( hpNW )
end)

net.Receive( "player_makeattack", function( len, ply ) -- player input
	turntargets = net.ReadTable()
	wpndmg1 = net.ReadDouble()
	wpndmg2 = net.ReadDouble()
	pltype2 = net.ReadString()
	c_type2 = pltype2
	allplayers = net.ReadTable()
	wpn = net.ReadString()
    slash_dmg = net.ReadInt( 32 ) * 0.05 
    slash_dfx = net.ReadInt( 32 )
    slash_acc = net.ReadInt( 32 ) * 0.05 
	mgbplayer = ply
	vis_int = 0
	local proceed = net.ReadBool()

	-- basic attack multi-target damage management and calculation
	timer.Simple( 0.5, function()
		local i = 0
		for k, v in pairs( turntargets ) do
			i = i + 1
		end
		for k, v in pairs( turntargets ) do 
			vis_int = vis_int + 0.25
			timer.Simple( vis_int, function()
				if IsValid(v) and v:Health() > 0 then
					turntarget = v
					turntargetsave = v:GetName()
					dmg_modifier = dmg_modifier / i

					RunString( items_table[ wpn ].func )
					dmg_modifier = 1
				end
				if k == #turntargets and proceed then
					hook.Call( "PlayerTurnEnd" )
					dmg_modifier = 1
					timer.Simple( 1, function() 
						EnemyAttack()
					end)
				end
			end)
		end
	end)

	local note = c_type2 .." Attack"
	SendSkillNote( note )
end)

function SetOffset( ply, stat, amount )
	local stat2 = "offset_".. stat
	ply:SetNWInt( stat2, ply:GetNWInt( stat2 ) + amount )
	Calculatum()
end

net.Receive( "player_brace", function( len, ply )
	allplayers = net.ReadTable()
	mgbplayer = ply
	local braceidentifier = "bracerhook_".. ply:AccountID()
	SetOffset( ply, "def", 3 + pl_stats_tbl[ ply:UserID() ].LVL3 ) 
	SetOffset( ply, "dfx", 25 )

	ply:SetNWBool( "guarding", true )

	hook.Add( "EnemyTurnEnd", braceidentifier, function()
		SetOffset( ply, "def", ( 3 + pl_stats_tbl[ ply:UserID() ].LVL3 ) * -1 ) 
		SetOffset( ply, "dfx", -25 )

		ply:SetNWBool( "guarding", false )

		hook.Remove( "EnemyTurnEnd", braceidentifier )
	end)
	timer.Simple( 2, function() 
		EnemyAttack()
	end)
	PrintMessage( HUD_PRINTTALK, mgbplayer:GetName() .." are bracing themselves for the attack..." )

	hook.Call( "PlayerTurnEnd" )
end)

net.Receive( "player_wait", function( len, ply )
	allplayers = net.ReadTable()
	mgbplayer = ply
	EnemyAttack()

	hook.Call( "PlayerTurnEnd" )
end)

function EndBattle()
	PrintMessage( HUD_PRINTTALK, "_____________________" )
	PrintMessage( HUD_PRINTTALK, "Battle over." )
	Entity(1):RemoveFlags( 128 )
	timer.Simple(2, function()
		for k, v in ipairs( ents.GetAll() ) do -- clean ragdolls
			if v:IsRagdoll() then
				v:Remove()
			end
		end
		net.Start( "encounter_outro" ) -- goodbye!
		net.Broadcast()
		Entity(1):SetViewEntity( Entity(1) )
		Entity(1):ScreenFade( 2, color_white, 1.5, 0.6 )
		lives = 0
		deaths = 0
		ss_inbattle = false
		EncounterReset()
		EncounterReset2() -- reset encounter mechanic

		timer.Simple(2, function() -- put people back in their places
			for i, v in ipairs( allplayers ) do
				v:ScreenFade( 1, color_white, 1.5, 0.6 )
				v:SetPos( v:GetNWVector( "vectornw" ) )
				v:SetAngles( v:GetNWAngle( "anglenw" ) )
			end
		end)

		-- Reset resistances
		-- for k, v in ipairs( player.GetAll() ) do
		-- 	v:SetNWInt( "dmgresistance", 0 )
		-- end
	end)
end

function EnemyAttack()
	print( "actions at start: ".. actions)
	if actions > 0 then 
		
		if IsValid( current_enemy ) then
			if enemies_table[ current_enemy:GetName() ].actionvar > enemy_choices then
				print( "1; the enemy still gets to attack")
				enemy_choices = enemy_choices + 1
				print( "actions: ".. actions .."; enemy_choices: ".. enemy_choices .."; previous_enemya: ".. previous_enemya)
				EnemyAttack1()
				print( "actions: ".. actions )
			else
				previous_enemya = previous_enemya + 1
				print( "2; another enemy gets to attack" )
				current_enemy = battle_enemies[next( battle_enemies, previous_enemya)]
				print( previous_enemya )
				print( current_enemy )
				--previous_enemy = current_enemy
				enemy_choices = 1
				print( "actions: ".. actions .."; enemy_choices: ".. enemy_choices .."; previous_enemya: ".. previous_enemya)
				EnemyAttack1()
			end
		else
			print( "3; current_enemy isn't valid; resorting to first enemy, resetting structure")
			--enemy_choices = enemy_choices + 1
			current_enemy = battle_enemies[1]
			previous_enemya = 0
			print( "actions: ".. actions .."; enemy_choices: ".. enemy_choices .."; previous_enemya: ".. previous_enemya)
			EnemyAttack()
		end
	else
		print( "4; return")
		print( "actions: ".. actions .."; enemy_choices: ".. enemy_choices .."; previous_enemya: ".. previous_enemya)
		previous_enemya = 0
		current_enemy = nil
		enemy_choices = 0
		playerturn()
	end
end

function EnemyAttack1()
	timer.Simple( 0.15, function()
		-- Check if all players are dead
		local hot = 0
		for _, ply in ipairs( player.GetAll() ) do 
			if ply:Alive()  then
				hot = hot + 1
				actions = actions - 1
				if IsValid(current_enemy) and current_enemy:Health() > 0 then -- if alive
					if current_enemy:GetNWInt( "stunturns" ) == 0 then -- if not stunned
						RunString( enemies_table[ current_enemy:GetName() ].AI )
					else -- stunned lol
						PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." was stunned and could not attack!" )
						current_enemy:SetNWInt( "stunturns", current_enemy:GetNWInt( "stunturns" ) - 1 )
						current_enemy:SetNWInt( "stunturns_a", current_enemy:GetNWInt( "stunturns_a" ) - 1 )
						EnemyAttack()
					end
				else -- peter was here
					EnemyAttack()
				end
			return end
		end
	end)
end

function playerturn() -- let the player attack
	if players_alive and enemy_alive then
		enemy_alive = true
		net.Start( "player_doturn" )
		net.Broadcast()
		turn = turn + 1
		PrintMessage( HUD_PRINTTALK, "_____________________" )
		PrintMessage( HUD_PRINTTALK, "Turn ".. turn )
		-- Levitus:TakeDamage( 1 ) -- turnholder. I shall present what I am capable of. The chains are great, but my fortitude is beyond anything. Now suffer!
		hook.Call( "EnemyTurnEnd" )
		sexy_int = 0
		print( "---" )
		print( "Counting actions...:" )
		for k, v in pairs( battle_enemies ) do 
			sexy_int = sexy_int + enemies_table[ v:GetName() ].actionvar
			print( v:GetName() .." / + ".. enemies_table[ v:GetName() ].actionvar )
		end
		actions = sexy_int
		print( "Enemy actions: ".. actions )
		print( "---" )

		entourage_AddUP( 5, 25 )

		for k, v in ipairs( battle_enemies ) do
			v:SetNWInt( "tbl_deaths", k )
		end
	end
end

function EndGame()
	-- Death is not a hunter unbeknownst to its prey
	players_alive = false
	if math.random( 1, 5 ) == 1 then
		feher = table.Random( {
			"Eradicated",
			"Obliterated",
			"Don't give up!",
			"Not yet!",
			"Fin",
			"Stand up!",
			"The world needs you!",
			"This can't be it",
			"There is always another dawn",
			"Kto wie, stary kolego Katz, czy nie najmądrzej postąpiłeś?",
			"In honour of your will"
		} )
	elseif math.random( 1, 100 ) == 1 then
		feher = "ggwp rep jgl"
	else
		feher = "The party has been wiped"
	end
	PrintMessage( HUD_PRINTTALK, feher .."..." )
	net.Start( "endgame" )
	net.Broadcast()
end

function EncounterReset()
	encounter_rate = math.random( 150, 150 )
	net.Start( "encounter_var" )
		net.WriteInt( encounter_rate, 32)
	net.Broadcast()
end

net.Receive( "player_removestunturns", function( len, ply )
	ply:SetNWInt( "stunturns", ply:GetNWInt( "stunturns" ) - 1 )
	PrintMessage( HUD_PRINTTALK, ply:GetName() .." was stunned and could not attack!" )
	timer.Simple( 2, function() 
		EnemyAttack()
	end)
end)

-- This manages attack names that you see on the screen
function SendSkillNote( skillnote, color )
	print( color )
	print( IsColor( color ) )
	net.Start( "sendskillnote" )
		net.WriteString( skillnote )
		if IsColor( color ) == false then
			color = Color( 255, 255, 255 )
		end
		net.WriteColor( color, false )
	net.Broadcast()
end

net.Receive( "givemereverie", function( len, ply )
	ply:SetNWVector( "sexyheadpos", ply:HeadTarget( ply:GetPos() ) )

	local a = net.ReadInt( 32 )

	if a ~= 0 then
		ply:SetViewEntity( ents.GetMapCreatedEntity( a ) )
	else
		ply:SetViewEntity( ply )
	end
end)