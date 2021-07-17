include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "ss/weaponfunctions.lua" )
include( "ss/enemyai.lua" )
include( "ss/battlesystem.lua" )
include( "ss/encountertypes.lua" )
include( "ss/skillfunctions.lua" )
include( "ss/tablicas.lua" )
--include( "ss/hitsounds.lua" ) -- it's broken. Stick to the base addon for now.
-- ai
include( "ss/ai/guardian.lua")
include( "ss/ai/miner.lua")
include( "ss/ai/scout.lua")
include( "ss/ai/skinner.lua")
include( "ss/ai/prince.lua")

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

pl_stats_tbl = {}

-- Receivers

net.Receive( "savetable", function( len, ply )
	local tableph = net.ReadTable()
	local id = ply:UserID()

	if pl_stats_tbl[id] ~= nil then
		table.remove( pls_stats_tbl, id)
	end
	pl_stats_tbl[ id ] = tableph
	-- calculate some stats prematurely
	pl_stats_tbl[ id ].DDG_TRUE = pl_stats_tbl[ id ].DDG + pl_stats_tbl[ id ].AGI * 3 + pl_stats_tbl[ id ].FCS * 2
	pl_stats_tbl[ id ].ACC_TRUE = items_table[ pl_stats_tbl[id].currentweapon ].BaseAcc + pl_stats_tbl[ id ].AGI * 2 + pl_stats_tbl[ id ].FCS * 5
	pl_stats_tbl[ id ].DDG_OV = 0
	pl_stats_tbl[ id ].ACC_OV = 0
end)

net.Receive( "maxhealth", function( len, ply )
	-- player = net.ReadEntity()
	playerhealth = net.ReadDouble()
	playerhealth2 = net.ReadDouble()
	--timer.Simple(2, function()
		ply:SetHealth( playerhealth2 )
		ply:SetMaxHealth( playerhealth2 )
	--end)
end)

hook.Add( "PlayerInitialSpawn", "startvar", function() 

	encounter_rate = math.random( 100, 100 )
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

	battle_enemies = {}

	timer.Simple( 2, function()
		ent_cam_override1 = ents.GetMapCreatedEntity( 1726 )
			ent_cam_override1:SetPos( Vector( -360, -60, -850 ) )
			ent_cam_override1:SetAngles( Angle( 25, 0, 0 ) )
		ent_cam_override2 = ents.GetMapCreatedEntity( 1724 )
			ent_cam_override2:SetPos( Vector( -75, -350, -800 ) )
			ent_cam_override2:SetAngles( Angle( 40, 90, 0 ) )
		ent_cam_override3 = ents.GetMapCreatedEntity( 1723 )
			ent_cam_override3:SetPos( Vector( -85, 260, -820 ) )
			ent_cam_override3:SetAngles( Angle( 25, -90, 0 ) )
		ent_cam_override4 = ents.GetMapCreatedEntity( 1722 )
			ent_cam_override4:SetPos( Vector( 225, -60, -850 ) )
			ent_cam_override4:SetAngles( Angle( 25, 180, 0 ) )
		ent_cam_override5 = ents.GetMapCreatedEntity( 1725 )
			ent_cam_override5:SetPos( Vector( -75, -80, -700 ) )
			ent_cam_override5:SetAngles( Angle( 90, 0, 0 ) )
	end)

end)