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
util.AddNetworkString( "player_biststunned" )
util.AddNetworkString( "descmodel_cl1" ) 
util.AddNetworkString( "descmodel_cl2" )
util.AddNetworkString( "net_enemy_senddata" )
util.AddNetworkString( "up_hudshow" )
util.AddNetworkString( "sendskillnote" )
util.AddNetworkString( "DISPLAY_PAIN" )
util.AddNetworkString( "givemereverie" )
util.AddNetworkString( "fuckmylife" )

-- set variables
lives = 0
deaths = 0
critmp = 1
timer_delay = 0
up_add = 0
up_remove = 0
ss_inbattle = 0
global_value = 0
up_int = 0
up_open = true
-------------------

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
		-- If a player dealt damage TO NPC
		if dmg:GetAttacker():IsPlayer() and target:IsNPC() then
			entourage_AddUP( math.Clamp( dmg:GetDamage() / target:GetMaxHealth() * 30, 1, 25 ), 25 )
			-- This function manages damage resistance for enemies like the Guardian. It sucks, I know, but it has to be done.
			local dmg_ov = dmg:GetDamage()
			if target:GetClass() == "npc_antlionguard" then
				-- MODS
				dmg_ov = math.floor( dmg_ov * 0.75 )
			end
			---------------------------------------------------------
			PrintMessage( HUD_PRINTTALK, dmg:GetAttacker():GetName() .." dealt ".. dmg_ov .." ".. c_type2 .." damage to ".. target:GetName() .."!" )
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
				print( target:GetNWInt( "tbl_deaths" ) )
				table.remove( battle_enemies, target:GetNWInt( "tbl_deaths" ) )
				actions = actions - 1
				PrintMessage( HUD_PRINTTALK, dmg:GetAttacker():GetName() .." defeated ".. target:GetName() .."!" )
				deaths = deaths + 1
				lives = lives - 1

				-- Send EXP
				local timer_delay = 0 -- change if necessary
				timer.Simple( timer_delay, function() -- im pretty sure this is necessary to prevent shit from fucking up
					net.Start( "net_enemy_senddata" )
						net.WriteInt( enemies_table[ target:GetName() ].LVL, 32 )
						net.WriteInt( enemies_table[ target:GetName() ].EXP, 32 )
					net.Broadcast()
				end)
			elseif enemies_table[ target:GetName() ].PainAnim ~= nil then
				RunString( enemies_table[ target:GetName() ].PainAnim )
			end
			net.Start( "DISPLAY_PAIN" )
				net.WriteEntity( target )
				net.WriteInt( dmg_ov, 32 )
				net.WriteBool( false ) -- heal? true or false
			net.Broadcast()
		end
	end
end)

-- Health add function
function entourage_AddHealth( hptarget, hp )
	local hp2 = math.Clamp( hp, 0, hptarget:GetMaxHealth() )
	hptarget:SetHealth( hptarget:Health() + hp2 )

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
end)

function Calculatum()
	local id = Entity(1):UserID()
	pl_stats_tbl[ id ].DDG_TRUE = pl_stats_tbl[ id ].DDG + pl_stats_tbl[ id ].AGI * 3 + pl_stats_tbl[ id ].FCS * 2 + pl_stats_tbl[ id ].DDG_OV
	pl_stats_tbl[ id ].ACC_TRUE = items_table[ pl_stats_tbl[id].currentweapon ].BaseAcc + pl_stats_tbl[ id ].AGI * 2 + pl_stats_tbl[ id ].FCS * 5 + pl_stats_tbl[ id ].ACC_OV
end
-- True Accuracy and True Dodge calculation for players
hook.Add( "EnemyTurnEnd", "accresets", Calculatum )

hook.Add( "PlayerTurnEnd", "accresets2", Calculatum )

--------------------------------------------------------------------------------------

-- This function is used in EVERY battle encounter and so shares functions.
-- However, every function must specify beforeclaw what colours to use. (this is the "doom" variable)
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
		
		-- change viewpoint

		-- i hate my life and i don't get why this is necessary and WHY THIS TAKES HOURS OFF MY LIFE.
		-- if IsValid( ent_cam_override1) == false then
		-- 	ent_cam_override1 = ents.Create( "info_target" )
		-- 		ent_cam_override1:SetPos( Vector( -360, -60, -850 ) )
		-- 		ent_cam_override1:SetAngles( Angle( 25, 0, 0 ) )
		-- 		ent_cam_override1:Spawn()
		-- 	ent_cam_override2 = ents.Create( "info_target" )
		-- 		ent_cam_override2:SetPos( Vector( -75, -350, -800 ) )
		-- 		ent_cam_override2:SetAngles( Angle( 40, 90, 0 ) )
		-- 		ent_cam_override2:Spawn()
		-- 	ent_cam_override3 = ents.Create( "info_target" )
		-- 		ent_cam_override3:SetPos( Vector( -85, 260, -820 ) )
		-- 		ent_cam_override3:SetAngles( Angle( 25, -90, 0 ) )
		-- 		ent_cam_override3:Spawn()
		-- 	ent_cam_override4 = ents.Create( "info_target" )
		-- 		ent_cam_override4:SetPos( Vector( 225, -60, -850 ) )
		-- 		ent_cam_override4:SetAngles( Angle( 25, 180, 0 ) )
		-- 		ent_cam_override4:Spawn()
		-- 	ent_cam_override5 = ents.Create( "info_target" )
		-- 		ent_cam_override5:SetPos( Vector( -75, -80, -700 ) )
		-- 		ent_cam_override5:SetAngles( Angle( 90, 0, 0 ) )
		-- 		ent_cam_override5:Spawn()
		-- 		Entity(1):SetViewEntity( ent_cam_override1 )
		-- end

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
    slash_dfx = net.ReadInt( 32 ) * 0.03
    slash_acc = net.ReadInt( 32 ) * 0.05 
	mgbplayer = ply
	vis_int = 0

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
				end)
		end
	end)
	
	timer.Simple( 2, function() 
		EnemyAttack()
		dmg_modifier = 1
	end)

	local note = c_type2 .." Attack"
	SendSkillNote( note )

	hook.Call( "PlayerTurnEnd" )
end)

net.Receive( "player_brace", function( len, ply )
	allplayers = net.ReadTable()
	mgbplayer = ply
	local braceidentifier = "bracerhook_".. ply:AccountID()
	pl_stats_tbl[ mgbplayer:UserID() ].DEF = pl_stats_tbl[ mgbplayer:UserID() ].DEF + 3 + pl_stats_tbl[ mgbplayer:UserID() ].LVL3
	pl_stats_tbl[ mgbplayer:UserID() ].DFX = pl_stats_tbl[ mgbplayer:UserID() ].DFX + 20
	hook.Add( "EnemyTurnEnd", braceidentifier, function()
		pl_stats_tbl[ mgbplayer:UserID() ].DEF = pl_stats_tbl[ mgbplayer:UserID() ].DEF - 3 - pl_stats_tbl[ mgbplayer:UserID() ].LVL3
		pl_stats_tbl[ mgbplayer:UserID() ].DFX = pl_stats_tbl[ mgbplayer:UserID() ].DFX - 20
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

function EnemyAttack()
	if table.IsEmpty( battle_enemies ) then
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
			for k, v in ipairs( player.GetAll() ) do
				v:SetNWInt( "dmgresistance", 0 )
			end
		end)
	elseif actions > 0 and next( battle_enemies, previous_enemya ) == nil then
		current_enemy = battle_enemies[1]
		previous_enemy = current_enemy
		previous_enemya = 1
		--print( current_enemy )
		EnemyAttack1()
	elseif actions > 0 then 
		current_enemy = battle_enemies[next( battle_enemies, previous_enemya)]
		previous_enemy = current_enemy
		previous_enemya = previous_enemya + 1
		--print( current_enemy )
		EnemyAttack1()
	else
		playerturn()
	end
end

function EnemyAttack1()
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
end

function playerturn() -- let the player attack
	net.Start( "player_doturn" )
	net.Broadcast()
	turn = turn + 1
	PrintMessage( HUD_PRINTTALK, "_____________________" )
	PrintMessage( HUD_PRINTTALK, "Turn ".. turn )
	-- Levitus:TakeDamage( 1 ) -- turnholder. I shall present what I am capable of. The chains are great, but my fortitude is beyond anything. Now suffer!
	hook.Call( "EnemyTurnEnd" )
	sexy_int = 0
	for k, v in pairs( battle_enemies ) do 
		sexy_int = sexy_int + 1
	end
	actions = sexy_int
	-- Doing the action below causes additional spawning enemies to not function but also breaks the attack sequence in spawning battles.
	-- previous_enemya = 0

	entourage_AddUP( 5, 25 )

	for k, v in ipairs( battle_enemies ) do
		v:SetNWInt( "tbl_deaths", k )
	end
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

-- This manages skill tooltips that you see on the battle hud.
function SendSkillNote( skillnote )
	net.Start( "sendskillnote" )
		net.WriteString( skillnote )
	net.Broadcast()
end

net.Receive( "givemereverie", function( len, ply )
	-- Only God can judge me.

	ply:SetNWVector( "sexyheadpos", ply:HeadTarget( ply:GetPos() ) )

	local a = net.ReadInt( 32 )
	local b = nil
	if a == 1 then
		b = ent_cam_override1
	elseif a == 2 then
		b = ent_cam_override2
	elseif a == 3 then
		b = ent_cam_override3
	elseif a == 4 then
		b = ent_cam_override4
	elseif a == 5 then
		b = ent_cam_override5
	else
		b = ply
	end
	ply:SetViewEntity( b )
end)