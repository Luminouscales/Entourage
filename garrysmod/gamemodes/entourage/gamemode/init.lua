include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "ss/weaponfunctions.lua" )
include( "ss/enemyai.lua" )
include( "ss/battlesystem.lua" )
include( "ss/encountertypes.lua" )
include( "ss/skillfunctions.lua" )

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
RunConsoleCommand( "ai_disabled", "0" )

enemies_table1 = file.Read( "entourage/main/enemies.txt", "DATA" )
enemies_table = util.JSONToTable( enemies_table1 )

items_table1 = file.Read( "entourage/main/items.txt", "DATA" )
items_table = util.JSONToTable( items_table1 )

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

	encounter_rate = math.random( 150, 150 )
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
	
end)