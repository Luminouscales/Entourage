local integer = 0

function PlayerstatsSave()
    if integer > 0 then
        LocalPlayer():PrintMessage( HUD_PRINTTALK, "Game saved successfully to ID: ".. gameid )
	    playerstats["HP1"] = LocalPlayer():Health()
    else
        integer = integer + 1
    end
    playerstats_a = table.Copy( playerstats )
    playerstats_b = table.Copy( playerstats_a )
	local playerstats2 = util.TableToJSON( playerstats, true )
	file.Write( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", playerstats2)

    plskills_a = table.Copy( plskills )
    local plskills3 = util.TableToJSON( plskills, true )
    file.Write( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", plskills3 )

	net.Start( "savetable" )
		net.WriteTable( playerstats )
	net.SendToServer()
	LocalPlayer():SetNWInt( "playerdef", playerstats[ "DEF" ] )
	LocalPlayer():SetNWInt( "playerdfx", playerstats[ "DFX" ] )
	LocalPlayer():SetNWFloat( "playerdef2", playerstats[ "DEF" ] )
end

hook.Add( "InitPostEntity", "datacontrolinit", function()
   
    gameid = GetConVar( "rpgmod_gameid" ):GetString()
	
	statsbase2 = file.Read( "entourage/main/statsbase.txt", "DATA" )
	    statsbase = util.JSONToTable( statsbase2 )
	weaponsbase2 = file.Read( "entourage/main/weaponsbase.txt", "DATA" )
		weaponsbase = util.JSONToTable( weaponsbase2 )
	armoursbase2 = file.Read( "entourage/main/armoursbase.txt", "DATA" )
		armoursbase = util.JSONToTable( armoursbase2 )
	trinketsbase2 = file.Read( "entourage/main/trinketsbase.txt", "DATA" )
		trinketsbase = util.JSONToTable( trinketsbase2 )
    skillsbase2 = file.Read( "entourage/main/skillsbase.txt", "DATA" )
        skillsbase = util.JSONToTable( skillsbase2 )
    plskillsbase2 = file.Read( "entourage/main/plskillsbase.txt", "DATA" )
        plskillsbase = util.JSONToTable( plskillsbase2 )

    -- Defines all weapons.
    weaponlist2 = file.Read( "entourage/main/items.txt", "DATA" )
        weaponlist = util.JSONToTable( weaponlist2 )

    playerid = LocalPlayer():AccountID()
    
    --------------------------------------------------------------------------------------------------
    -- The function below manages data based on whether the save is new or not.
    -- It WILL break if the player removes a save other than stats.txt, but that's not my problem any more.
    file.CreateDir( "entourage/game/".. gameid .."/".. playerid)

    if file.Exists( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", "DATA" ) == false then -- if the save is fresh
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", statsbase2 )
        playerstats = statsbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/weapons.txt", weaponsbase2 )
        plweapons = weaponsbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/armours.txt", armoursbase2 )
        plarmours = armoursbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", plskillsbase2 )
        plskills = table.Copy( plskillsbase )
    else -- if the save isn't new, compile data to tables
        local playerstats2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", "DATA" ) 
        playerstats = util.JSONToTable( playerstats2 )
        local plweapons2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/weapons.txt", "DATA")
        plweapons = util.JSONToTable( plweapons2 )
        local plarmours2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/armours.txt", "DATA" )
        plarmours = util.JSONToTable( plarmours2 )
        plskills2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", "DATA" )
        plskills = util.JSONToTable( plskills2 )
    end
    --------------------------------------------------------------------------------------------------

    net.Start( "maxhealth" ) -- set max health
        net.WriteEntity( LocalPlayer() )
        net.WriteDouble( 100 + playerstats["VIT"] * 5 + playerstats["MGT"] * 2 )
        net.WriteDouble( playerstats["HP1"] )
    net.SendToServer()

    PlayerstatsSave()
    
    if playerstats[ "MGT" ] > ( playerstats[ "FCS" ] + playerstats[ "VIT" ] + playerstats[ "AGI" ] + playerstats[ "SDL" ] ) / 4 then
        tag = "Gladiator"
    elseif playerstats[ "FCS" ] > ( playerstats[ "MGT" ] + playerstats[ "VIT" ] + playerstats[ "AGI" ] + playerstats[ "SDL" ] ) / 4 then
        tag = "Sightseer"
    elseif playerstats[ "VIT" ] > ( playerstats[ "MGT" ] + playerstats[ "FCS" ] + playerstats[ "AGI" ] + playerstats[ "SDL" ] ) / 4 then
        tag = "Protector"
    elseif playerstats[ "AGI" ] > ( playerstats[ "FCS" ] + playerstats[ "VIT" ] + playerstats[ "MGT" ] + playerstats[ "SDL" ] ) / 4 then
        tag = "Wisp"
    elseif playerstats[ "SDL" ] > ( playerstats[ "FCS" ] + playerstats[ "VIT" ] + playerstats[ "AGI" ] + playerstats[ "MGT" ] ) / 4 then
        tag = "Ethereal"
    else
        tag = "Soldier"
    end

end)