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

    -- THIS HAS TO BE OPTIMIZED. in the future
    -- SendStats()
    -------------------------------------------
	-- LocalPlayer():SetNWInt( "playerdef", playerstats[ "DEF" ] )
	-- LocalPlayer():SetNWInt( "playerdfx", playerstats[ "DFX" ] )
	-- LocalPlayer():SetNWFloat( "playerdef2", playerstats[ "DEF" ] )
end

function SendStats()
	net.Start( "savetable" )
		net.WriteTable( playerstats_a )
	net.SendToServer()
end

-- Tables rework
function DoTBLFirstInit()
    statsbase = { -- base stats
        ["LVL1"] = 0.0,
        ["FCS"] = 0.0,
        ["VIT"] = 0,
        ["MGT"] = 0,
        ["FA"] = 0.0,
        ["DDG"] = 15,
        ["currentweapon"] = "OldCrowbar",
        ["DEF"] = 5,
        ["HP2"] = 100.0,
        ["HP1"] = 100.0,
        ["IA"] = 0.0,
        ["TA"] = 0.0,
        ["AGI"] = 0,
        ["currentarmour"] = "ClothArmour",
        ["SDL"] = 0.0,
        ["LVL2"] = 100.0,
        ["LVL3"] = 1.0,
        ["WA"] = 0.0,
        ["DFX"] = 0.0,
        ["LVL_POINTS"] = 0,
        ["SLASH_POINTS"] = 20,
        ["BLUNT_POINTS"] = 20,
        ["PIERCE_POINTS"] = 20,
        ["endurevar"] = 1,
        ["actionvar"] = 2
    }

    -- Equipment tables
    weaponsbase = {
        [1] = {
            ["Item"] = "OldCrowbar"
        }
    }
    for i = 2, 18, 1 do
        weaponsbase[i] = { ["Item"] = "EmptySlot" }
    end

    weaponsbase2 = util.TableToJSON( weaponsbase, true )

    armoursbase = {
        [1] = {
            ["Item"] = "ClothArmour"
        }
    }
    for i = 2, 18, 1 do
        armoursbase[i] = { ["Item"] = "EmptySlot2" }
    end

    armoursbase2 = util.TableToJSON( armoursbase, true )
    ----------------------------------------------------

    

    plskillsbase = {
        ["s_precstrike"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_defmano"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_firstaid"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_slasher"] = {
            ["Level"] = 0,
            ["equipped"] = 2
        },
        ["s_slicer"] = {
            ["Level"] = 0,
            ["equipped"] = 2
        },
        ["s_dicer"] = {
            ["Level"] = 0,
            ["equipped"] = 2
        },
        ["s_broadswing"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_fragmentation"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_medicsupplies"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_moraleslash"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_distraction"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_acrobatics"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_performance"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        }
    }

end

hook.Add( "InitPostEntity", "datacontrolinit", function()
   
    gameid = GetConVar( "rpgmod_gameid" ):GetString()
    playerid = LocalPlayer():AccountID()
    
    --------------------------------------------------------------------------------------------------
    -- The function below manages data based on whether the save is new or not.
    -- It WILL break if the player removes a save other than stats.txt, but that's not my problem any more.
    file.CreateDir( "entourage/game/".. gameid .."/".. playerid)

    if file.Exists( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", "DATA" ) == false then -- if the save is fresh
        DoTBLFirstInit()
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", statsbase )
        playerstats = statsbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/weapons.txt", weaponsbase2 )
        plweapons = weaponsbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/armours.txt", armoursbase2 )
        plarmours = armoursbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", plskillsbase )
        plskills = table.Copy( plskillsbase )
        plskills_a = table.Copy( plskills )
    else -- if the save isn't new, compile data to tables
        local playerstats2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", "DATA" ) 
        playerstats = util.JSONToTable( playerstats2 )
        local plweapons2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/weapons.txt", "DATA")
        plweapons = util.JSONToTable( plweapons2 )
        local plarmours2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/armours.txt", "DATA" )
        plarmours = util.JSONToTable( plarmours2 )
        plskills2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", "DATA" )
        plskills = util.JSONToTable( plskills2 )
        plskills_a = table.Copy( plskills )
    end
    --------------------------------------------------------------------------------------------------

    net.Start( "maxhealth" ) -- set max health
        --net.WriteEntity( LocalPlayer() )
        net.WriteDouble( playerstats["HP1"] )
        net.WriteDouble( playerstats["HP2"] )
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

net.Receive( "sharetable", function()
	-- levi; UP purposes
	levi = net.ReadInt( 32 )

    cl_Levitus = Entity( levi )
end)
