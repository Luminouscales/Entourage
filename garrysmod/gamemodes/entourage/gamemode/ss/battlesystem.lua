util.AddNetworkString( "encounter_cl" )
util.AddNetworkString( "encounter_intro" )
util.AddNetworkString( "player_makeattack" )
util.AddNetworkString( "player_doturn" )
util.AddNetworkString( "encounter_outro" )
util.AddNetworkString( "getmycordsyoufuckingcunt" )
util.AddNetworkString( "enemysend" )
util.AddNetworkString( "player_brace" )
util.AddNetworkString( "player_removestunturns" )
util.AddNetworkString( "player_biststunned" )
util.AddNetworkString( "descmodel_cl1" )
util.AddNetworkString( "descmodel_cl2" )
util.AddNetworkString( "net_enemy_senddata" )
util.AddNetworkString( "up_hudshow" )

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
		if dmg:GetAttacker():IsPlayer() and target:IsPlayer() == false and target:IsNPC() then
			entourage_AddUP( dmg:GetDamage() / target:GetMaxHealth() * 30, 25 )
			if dmg:GetDamage() >= target:Health() and target:Health() > 0 then
				PrintMessage( HUD_PRINTTALK, dmg:GetAttacker():GetName() .." defeated ".. target:GetName() .."!" )
				deaths = deaths + 1
				print( deaths )
			end
		end
	end
end)

hook.Add( "PlayerDeath", "playerdeath_hook", function( victim, inflictor, attacker )
	if attacker:IsNPC() or attacker:IsPlayer() then
		-- Deduct UP for dying.
		entourage_AddUP( -25, 25 )
	end
end)
--------------------------------------------------------------------------------------

function EncounterReset2() -- Setup for detection system. This is where the battle system starts.
	hook.Add( "Tick", "encounter_hook", function()
		if tostring( Entity(1):GetVelocity() ) > tostring( Vector(0, 0, 0) ) then
			encounter_rate2 = encounter_rate2 + 1
		end
	
		if encounter_rate2 >= encounter_rate then -- ENCOUNTER!
			-- reset
			encounter_rate2 = 0 
			lives = 0
			deaths = 0
			turn = 1
			ss_inbattle = true
			-----------------------
			Entity(1):AddFlags( 128 )
			Entity(1):SetVelocity( Entity(1):GetVelocity()*-1 )
			Entity(1):ScreenFade( 16, Color(255, 255, 255, 100), 0.05, 0.05 )
			timer.Simple( 1, function()
				Entity(1):ScreenFade( 2, color_white, 1.5, 0.6 )
			end)
	
			timer.Simple( 3, function()
				EncounterAntlion()  
	
				Entity(1):ScreenFade( 1, color_white, 1.5, 0.6 )
	
				cam_override = ents.Create( "info_target" )
					cam_override:SetPos( Vector( -333, 84.5, -815 ) )
					cam_override:SetAngles( Angle( 30, -36, 0 ) )
				Entity(1):SetViewEntity( cam_override )
				
				Entity(1):SetPos( Vector( -80, 116, -982 ) )
				Entity(1):SetEyeAngles( Angle( 0, -90, 0 ))

				PrintMessage( HUD_PRINTTALK, "_____________________" )
				PrintMessage( HUD_PRINTTALK, "Turn ".. turn )
			end)

			net.Start( "encounter_intro" ) -- Send the go-ahead to the clients
			net.Broadcast()

			hook.Remove( "Tick", "encounter_hook" )

			hook.Add( "OnNPCKilled", "enemy_senddata", function( npc )
				timer_delay = 0 -- change if necessary
				timer.Simple( timer_delay, function() -- im pretty sure this is necessary to prevent shit from fucking up
					net.Start( "net_enemy_senddata" )
						net.WriteInt( enemies_table[ npc:GetName() ].LVL, 32 )
						net.WriteInt( enemies_table[ npc:GetName() ].EXP, 32 )
					net.Broadcast()
				end)
			end)
		end
	end)

	net.Start( "encounter_cl" )
	net.Broadcast()
end

net.Receive( "getmycordsyoufuckingcunt", function( len, ply ) -- reset cords setup
	posNW = net.ReadVector()
	angleNW = net.ReadAngle()
	hpNW = net.ReadDouble()
	ply:SetNWVector( "vectornw", posNW )
	ply:SetNWAngle( "anglenw", angleNW)
	ply:SetHealth( hpNW )
end)




net.Receive( "getmycordsyoufuckingcunt", function( len, ply ) -- get reset cords
	posNW = net.ReadVector()
	angleNW = net.ReadAngle()
	hpNW = net.ReadDouble()
	ply:SetNWVector( "vectornw", posNW )
	ply:SetNWAngle( "anglenw", angleNW)
	ply:SetHealth( hpNW ) -- also sets health because convenient?
end)

-- 

net.Receive( "player_makeattack", function( len, ply ) -- player input
	turntargets = net.ReadTable()
	wpndmg1 = net.ReadDouble()
	wpndmg2 = net.ReadDouble()
	pltype2 = net.ReadString()
	allplayers = net.ReadTable()
	wpn = net.ReadString()
    slash_dmg = net.ReadInt( 32 ) * 0.05 
    slash_dfx = net.ReadInt( 32 ) * 0.03
    slash_acc = net.ReadInt( 32 ) * 0.05 
	player = ply
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
		enemy_makeattack()
		dmg_modifier = 1
	end)
end)

net.Receive( "player_brace", function( len, ply )
	allplayers = net.ReadTable()
	player = ply
	local braceidentifier = "bracerhook_".. ply:AccountID()
	ply:SetNWInt( "defNW", ply:GetNWInt( "defNW" ) + 3 + ply:GetNWInt( "lvlNW" ) )
	ply:SetNWInt( "dfxNW", ply:GetNWInt( "dfxNW" ) + 20 )
	hook.Add( "EntityTakeDamage", braceidentifier, function( target, dmginfo )
		if target == Levitus then
			ply:SetNWInt( "defNW", ply:GetNWInt( "defNW" ) - 3 - ply:GetNWInt( "lvlNW" ) )
			ply:SetNWInt( "dfxNW", ply:GetNWInt( "dfxNW" ) - 20  )
			hook.Remove( "EntityTakeDamage", braceidentifier )
		end
	end)
	timer.Simple( 2, function() 
		enemy_makeattack()
	end)
	PrintMessage( HUD_PRINTTALK, player:GetName() .." are bracing themselves for the attack..." )
end)

function enemy_makeattack() -- First enemy attack turn
	if IsValid(enemy1) and enemy1:Health() > 0 then -- if alive
		if enemy1:GetNWInt( "stunturns" ) == 0 then -- if not stunned
			fighter = enemy1
			RunString( enemies_table[ enemy1:GetName() ].AI )
			enemy1:UseNoBehavior()
			enemy1:ResetSequenceInfo()	
			enemy1:SetNPCState( NPC_STATE_SCRIPT )
			enemy1:ResetSequence( "ragdoll" ) -- Reset the animation
			enemy1:ResetSequence( enemy1:GetNWString( "animstart" ) )
			timer.Simple( enemy1:GetNWFloat( "animend" ), function()
				-- Set custom end anim if applicable
				if isstring( enemy1:GetNWString( "animend_a" ) )  then
					enemy1:ResetSequenceInfo()
					enemy1:ResetSequence( "ragdoll" )
					enemy1:ResetSequence( enemy1:GetNWString( "animend_a" ) )
					timer.Simple( enemy1:GetNWFloat( "animend_b" ), function()
						enemy1:SetNPCState( NPC_STATE_IDLE )
					end)
				else
					enemy1:SetNPCState( NPC_STATE_IDLE )
				end
			end)
			timer.Simple(2, function()
				EnemyMakeAttack2()
			end)
		else -- stunned lol
			PrintMessage( HUD_PRINTTALK, enemy1:GetName() .." was stunned and could not attack!" )
			enemy1:SetNWInt( "stunturns", enemy1:GetNWInt( "stunturns" ) - 1 )
			EnemyMakeAttack2()
		end
	else
		EnemyMakeAttack2()
	end
end

function EnemyMakeAttack2() -- Second enemy attack turn
	if IsValid( enemy2 ) and enemy2:Health() > 0 then
		if enemy2:GetNWInt( "stunturns" ) == 0 then
			fighter = enemy2
			RunString( enemies_table[ enemy2:GetName() ].AI )
			enemy2:UseNoBehavior()
			enemy2:ResetSequenceInfo()	
			enemy2:SetNPCState( NPC_STATE_SCRIPT )
			enemy2:ResetSequence( "ragdoll" ) -- Reset the animation
			enemy2:ResetSequence( enemy2:GetNWString( "animstart" ) )
			timer.Simple( enemy2:GetNWFloat( "animend" ), function()
				if isstring( enemy2:GetNWString( "animend_a" ) )  then
					enemy2:ResetSequenceInfo()
					enemy2:ResetSequence( "ragdoll" )
					enemy2:ResetSequence( enemy2:GetNWString( "animend_a" ) )
					timer.Simple( enemy2:GetNWFloat( "animend_b" ), function()
						enemy2:SetNPCState( NPC_STATE_IDLE )
					end)
				else
					enemy2:SetNPCState( NPC_STATE_IDLE )
				end
			end)
			timer.Simple(2, function()
				EnemyMakeAttack3()
			end)
		else
			PrintMessage( HUD_PRINTTALK, enemy2 .." was stunned and could not attack!" )
			enemy2:SetNWInt( "stunturns", enemy2:GetNWInt( "stunturns" ) - 1 )
			EnemyMakeAttack3()
		end
	else
		EnemyMakeAttack3()
	end
end

function playerturn() -- let the player attack
	net.Start( "player_doturn" )
	net.Broadcast()
	turn = turn + 1
	PrintMessage( HUD_PRINTTALK, "_____________________" )
	PrintMessage( HUD_PRINTTALK, "Turn ".. turn )
	Levitus:TakeDamage( 1 ) -- turnholder. I shall present what I am capable of. The chains are great, but my fortitude is beyond anything. Now suffer!
end

function EnemyMakeAttack3() -- Third enemy attack turn, also activates player turns
	if deaths == lives then -- end battle if all are dead
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
		end)
	
	elseif IsValid(enemy3) and enemy3:Health() > 0 then -- it's alive!
		if enemy3:GetNWInt( "stunturns" ) == 0 then
			fighter = enemy3
			aistring = enemies_table[ enemy3:GetName() ].AI
			RunString( aistring )
			enemy3:UseNoBehavior()
			enemy3:ResetSequenceInfo()	
			enemy3:SetNPCState( NPC_STATE_SCRIPT )
			enemy3:ResetSequence( "ragdoll" ) -- Reset the animation
			enemy3:ResetSequence( enemy3:GetNWString( "animstart" ) )
			timer.Simple( enemy3:GetNWString( "animend" ), function()
				if isstring( enemy3:GetNWString( "animend_a" ) )  then
					enemy3:ResetSequenceInfo()
					enemy3:ResetSequence( "ragdoll" )
					enemy3:ResetSequence( enemy3:GetNWString( "animend_a" ) )
					timer.Simple( enemy3:GetNWFloat( "animend_b" ), function()
						enemy3:SetNPCState( NPC_STATE_IDLE )
					end)
				else
					enemy3:SetNPCState( NPC_STATE_IDLE )
				end
			end)
			timer.Simple(1, function() -- let the player attack
				playerturn()
			end)
		else
			PrintMessage( HUD_PRINTTALK, enemy3 .." was stunned and could not attack!" )
			enemy3:SetNWInt( "stunturns", enemy3:GetNWInt( "stunturns" ) - 1 )
			timer.Simple(0.5, function()
				playerturn()
			end)
		end	
	else
		timer.Simple(0.5, function()
			playerturn()
		end)
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
		enemy_makeattack()
	end)
end)