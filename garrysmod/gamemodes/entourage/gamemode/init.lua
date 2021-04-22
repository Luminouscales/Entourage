include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "ss/weaponfunctions.lua" )
include( "ss/enemyai.lua" )
include( "ss/battlesystem.lua" )
include( "ss/encountertypes.lua" )
include( "ss/skillfunctions.lua" )
include( "ss/tablicas.lua" )
include( "ss/ai/guardian.lua")

AddCSLuaFile( "cl/datacontrol_cl.lua" )

AddCSLuaFile( "cl/menu/cl_menu_overview.lua" )
AddCSLuaFile( "cl/menu/cl_menu_skillsscreen.lua" )
	AddCSLuaFile( "cl/menu/skills/cl_menu_skillsscreen_slash.lua" )
	AddCSLuaFile( "cl/menu/skills/cl_menu_skillsscreen_pierce.lua" )
	AddCSLuaFile( "cl/menu/skills/cl_menu_skillsscreen_blunt.lua" )	
AddCSLuaFile( "cl/menu/cl_menu_statsscreen.lua" )
AddCSLuaFile( "cl/menu/cl_menu_weaponsframe.lua" )

AddCSLuaFile( "cl/encountersystem_cl.lua" )
AddCSLuaFile( "cl/hud_cl.lua" )
AddCSLuaFile( "cl/battlesystem_cl.lua" )

------------------------------
util.AddNetworkString( "encounter_var" )
util.AddNetworkString( "idrequest" )
util.AddNetworkString( "maxhealth" )
util.AddNetworkString( "savetable" )
util.AddNetworkString( "sharetable" )
util.AddNetworkString( "playersave" )
------------------------------

RunConsoleCommand( "ai_ignoreplayers", "1" )
RunConsoleCommand( "ai_serverragdolls", "1" )
RunConsoleCommand( "ai_disabled", "1" ) -- needs to be true to run animations properly. otherwise shit fucks up like it tends to


function PlaceholderFunctionSS()
	print( "Debug serverside message. Report this to the developer." )
end

function PlayerSave()
	net.Start( "playersave" )
	net.Broadcast()
end

-- Receivers

net.Receive( "savetable", function( len, ply )
	tableph = net.ReadTable()
	-- tableph2 = util.TableToJSON( tableph, true )
	ply:SetNWInt( "defNW", tableph[ "DEF" ] + tableph[ "VIT" ] + tableph[ "SDL" ] )
	ply:SetNWInt( "dfxNW", tableph[ "DFX" ] + tableph[ "SDL" ] * 4 )
	ply:SetNWInt( "mgtNW", tableph[ "MGT" ] )
	ply:SetNWInt( "agiNW", tableph[ "AGI" ] )
	ply:SetNWInt( "fcsNW", tableph[ "FCS" ] )
	ply:SetNWInt( "dfeNW", tableph[ "VIT" ] )
	ply:SetNWInt( "sdlNW", tableph[ "SDL" ] )
	ply:SetNWInt( "trueddgNW", tableph[ "DDG" ] + tableph[ "AGI"] * 2 + tableph[ "FCS" ] )
	ply:SetNWString( "trueaccNW", items_table[ tableph[ "currentweapon" ] ].BaseAcc + tableph["BAC"] + tableph["AGI"] * 2 + tableph["FCS"] * 5 )
	ply:SetNWString( "lvlNW", tableph[ "LVL3" ] )
	-- file.CreateDir( "entourage/game/".. GetConVar( "rpgmod_gameid" ):GetString() .."/".. ply:AccountID() )
	-- file.Write( "entourage/game/".. GetConVar( "rpgmod_gameid" ):GetString() .."/".. ply:AccountID() .."/stats.txt", tableph2 )
end)

net.Receive( "maxhealth", function( len, ply )
	player = net.ReadEntity()
	playerhealth = net.ReadDouble()
	playerhealth2 = net.ReadDouble()
	timer.Simple(2, function()
		ply:SetMaxHealth( playerhealth )
		ply:SetHealth( playerhealth2 )
	end)
end)

hook.Add( "PlayerInitialSpawn", "startvar", function() 

	encounter_rate = math.random( 250, 250 )
	encounter_rate2 = 0

	net.Start( "encounter_var" )
		net.WriteInt( encounter_rate, 32)
	net.Broadcast()

	EncounterReset2()

	Levitus = ents.GetMapCreatedEntity( 1263 )
	
	net.Start( "sharetable" )
		net.WriteTable( enemies_table )
		-- convenience
		net.WriteInt( ents.GetMapCreatedEntity( 1263 ):EntIndex(), 32 )
	net.Broadcast()

	-- Manages player team's Utility Points. Convenience.
	Levitus:SetNWInt( "team_UP", 0 )

	timer.Simple( 10, function()
		cam_override = ents.Create( "info_target" )
		cam_override:SetPos( Vector( -333, 84.5, -815 ) )
		cam_override:SetAngles( Angle( 30, -36, 0 ) )
		cam_override:Spawn()
	end)

	battle_enemies = {}

end)

hook.Add( "InitPostEntity", "sex", function()
	timer.Simple( 2, function()
	-- cum
	-- cam_override = ents.Create( "info_target" )
	-- 	cam_override:SetPos( Vector( -333, 84.5, -815 ) )
	-- 	cam_override:SetAngles( Angle( 30, -36, 0 ) )
	-- cam_override:Spawn()
	end)
end)
