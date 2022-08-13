local integer = 0

net.Receive( "playersave", function()
	PlayerstatsSave()
end)

function PlayerstatsSave()
    local datapath = "entourage/game/".. gameid .."/".. playerid .."/"

    if integer > 0 then
        LocalPlayer():PrintMessage( HUD_PRINTTALK, "Game saved successfully to ID: ".. gameid )
	    playerstats["HP1"] = LocalPlayer():Health()
    else
        integer = integer + 1
    end
    playerstats_a = table.Copy( playerstats )
    playerstats_b = table.Copy( playerstats_a )
	local playerstats2 = util.TableToJSON( playerstats, true )
	file.Write( datapath .."stats.txt", playerstats2)

    plskills_a = table.Copy( plskills )
    local plskills3 = util.TableToJSON( plskills, true )
    file.Write( datapath .."skills.txt", plskills3 )

    -- Items
    local plweapons3 = util.TableToJSON( plweapons, true )
    file.Write( datapath .."weapons.txt", plweapons3 )

    local plarmours3 = util.TableToJSON( plarmours, true )
    file.Write( datapath .."armours.txt", plarmours3 )

    local pltrinkets3 = util.TableToJSON( pltrinkets, true )
    file.Write( datapath .."trinkets.txt", pltrinkets3 )
end

function SendStats()
	net.Start( "savetable" )
		net.WriteTable( playerstats_a )
        net.WriteInt( plskills_a["s_vprecision"].equipped, 32 )
        -- Dialogue tables
        net.WriteTable( plconv2 )
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
        ["DDG"] = 10,
        ["currentweapon"] = "OldCrowbar",
        ["DEF"] = 5,
        ["HP2"] = 100.0,
        ["HP1"] = 100.0,
        ["IA"] = 0.0,
        ["TA"] = 0.0,
        ["AGI"] = 0,
        ["currentarmour"] = "ClothArmour",
        ["currenttrinket"] = "EmptySlot3",
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
        ["actionvar"] = 2,
        ["flatdmg"] = 0
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

    trinketsbase = {
    }
    for i = 1, 18, 1 do
        trinketsbase[i] = { ["Item"] = "EmptySlot3" }
    end

    trinketsbase2 = util.TableToJSON( trinketsbase, true )
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
        },
        ["s_sharpcare"] = {
            ["Level"] = 0,
            ["equipped"] = 2
        },
        ["s_immaculate"] = {
            ["Level"] = 0,
            ["equipped"] = 2
        },
        ["s_scrutiny"] = {
            ["Level"] = 0,
            ["equipped"] = 2
        },
        ["s_vprecision"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_dedications"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_moderato"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_zillionedge"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_tknives"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_qethics"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_heartcut"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        },
        ["s_gouge"] = {
            ["Level"] = 0,
            ["equipped"] = 0
        }
    }

    plconvbase = 
    {   ["plconv_dmg"] = {
            "Begone!",
            "Out of my sight!",
            "Fall before me!",
            "Out of my way!",
            "You're nothing!",
            "Is that all you've got!?"
        },
        ["plconv_hit_n"] = {
            "Tch.",
            "Heh.",
            "Try harder.",
            "Is that all you've got?",
            "Barely."
        },
        ["plconv_hit_h"] = {
            "Try harder!",
            "This is nothing!",
            "Ahaha!",
            "Ha! Good one!",
            "I've had worse!"
        },
        ["plconv_endure"] = {
            "I shall stand!",
            "I won't falter!",
            "For glory!",
            "No!",
            "You can't break me!",
            "Not yet!",
            "I never die!"
        },
        ["plconv_die"] = {
            "With... honour...",
            "I never... die...",
            "I... never...",
            "Tell them I...",
            "Only I get to..."
        },
        ["plconv_dodge"] = {
            "Ha.",
            "There.",
            "Easy.",
            "I read you.",
            "Ha, focus!"
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
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/trinkets.txt", trinketsbase2 )
        pltrinkets = trinketsbase
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", plskillsbase )
        plskills = table.Copy( plskillsbase )
        plskills_a = table.Copy( plskills )
        local plconvbase2 = util.TableToJSON( plconvbase, true )
        file.Write( "entourage/game/".. gameid .."/".. playerid .."/dialogue.txt", plconvbase2 )
        plconv2 = plconvbase
    else -- if the save isn't new, compile data to tables
        local playerstats2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/stats.txt", "DATA" ) 
        playerstats = util.JSONToTable( playerstats2 )
        local plweapons2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/weapons.txt", "DATA")
        plweapons = util.JSONToTable( plweapons2 )
        local plarmours2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/armours.txt", "DATA" )
        plarmours = util.JSONToTable( plarmours2 )
        local pltrinkets2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/trinkets.txt", "DATA" )
        pltrinkets = util.JSONToTable( pltrinkets2 )

        plskills2 = file.Read( "entourage/game/".. gameid .."/".. playerid .."/skills.txt", "DATA" )
        plskills = util.JSONToTable( plskills2 )
        plskills_a = table.Copy( plskills )
        local plconv = file.Read( "entourage/game/".. gameid .."/".. playerid .."/dialogue.txt", "DATA" )
        plconv2 = util.JSONToTable( plconv )
    end
    --------------------------------------------------------------------------------------------------

    net.Start( "maxhealth" ) -- set max health
        net.WriteDouble( playerstats["HP1"] )
        net.WriteDouble( playerstats["HP2"] )
    net.SendToServer()

    
    PlayerstatsSave()

    -- Some trinkets have to be re-activated on save load.
    if items_table[ playerstats_a["currenttrinket"] ]["early"] then
        RunString( "eph_".. playerstats_a["currenttrinket"] .."(true)" )
    end

    if items_table[ playerstats_a["currentweapon"] ].early == 1 then
        net.Start( "weapon_effect" )
            net.WriteString( playerstats_a["currentweapon"] )
            net.WriteBool( true )
        net.SendToServer()
    end
    
    
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
