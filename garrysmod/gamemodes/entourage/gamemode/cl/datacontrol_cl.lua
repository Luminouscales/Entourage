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
	LocalPlayer():SetNWInt( "playerdef", playerstats[ "DEF" ] )
	LocalPlayer():SetNWInt( "playerdfx", playerstats[ "DFX" ] )
	LocalPlayer():SetNWFloat( "playerdef2", playerstats[ "DEF" ] )
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
        ["arov_pagi"] = 0.0,
        ["FCS"] = 0.0,
        ["VIT"] = 0,
        ["MGT"] = 0,
        ["FA"] = 0.0,
        ["arov_dfx"] = 0.0,
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
        ["arov_def"] = 5,
        ["DFX"] = 0.0,
        ["arov_def2"] = 5,
        ["arov_sdl2"] = 0,
        ["arov_pagi2"] = 0,
        ["arov_ddg"] = 0,
        ["LVL_POINTS"] = 0,
        ["SLASH_POINTS"] = 20,
        ["BLUNT_POINTS"] = 0,
        ["PIERCE_POINTS"] = 0
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
        }
    }

end

function weaponlistTBL()
    weaponlist = {
        ["OldCrowbar"] = {
            ["Name"] = "Old Crowbar",
            ["Desc"] = "Standard-issue. Dull, but has withstood the test of time.",
            ["Desc2"] = "No bonus effects.",
            ["Desc3"] = "+25% MGT, +25% DFE, +25% CEL",
            ["dmgtype"] = "Slash",
            ["BaseAcc"] = 75,
            ["DMG1"] = 13,
            ["DMG2"] = 17,
            ["SCS1"] = 15,
            ["SCS2"] = 15,
            ["SCS3"] = 15,
            ["Icon"] = "items/entourage_oldcrowbar.png",
            ["Type"] = "Weapon",
            ["PDEF"] = "0",
            ["PSDL"] = 0,
            ["PAGI"] = 0,
            ["func"] = "OldCrowbar()",
            ["targets"] = 1
        },
        ["RustyKnife"] = {
            ["Name"] = "Rusty Knife",
            ["Desc"] = "Only good for thrusting; half-digested.",
            ["Desc2"] = "+2 Celerity",
            ["Desc3"] = "+25% CEL, +10% damage per 1 FCS, 25% armour penetration",
            ["dmgtype"] = "Pierce",
            ["BaseAcc"] = 95,
            ["DMG3"] = 8,
            ["Icon"] = "items/entourage_rustyknife.png",
            ["Type"] = "Weapon",
            ["PDEF"] = "0",
           ["PSDL"] = 0,
            ["PAGI"] = 2,
            ["func"] = "RustyKnife()",
            ["targets"] = 1
        },
        ["WoodenClub"] = {
            ["Name"] = "Wooden Club",
            ["Desc"] = "Desperate attempt at a bash weapon. Heavy, unwieldy.",
            ["Desc2"] = "No bonus effects.",
            ["Desc3"] = "+15% MGT, +10% damage per 1 CST",
            ["dmgtype"] = "Blunt",
            ["BaseAcc"] = 40,
            ["DMG4"] = 22,
            ["DMG5"] = 28,
            ["Icon"] = "items/entourage_woodenclub.png",
            ["Type"] = "Weapon",
            ["PDEF"] = "0",
            ["PSDL"] = 0,
            ["PAGI"] = 0,
            ["func"] = "WoodenClub()",
            ["targets"] = 1
        },
        ["EmptySlot"] = {
            ["Name"] = "Fists",
            ["Type"] = "Weapon",
            ["Icon"] = "items/entourage_emptyslot.png",
            ["DMG4"] = 1,
           ["DMG5"] = 3,
            ["dmgtype"] = "Blunt",
            ["BaseAcc"] = 95,
            ["Desc"] = "Conquer the world as nature intended.",
            ["Desc2"] = "-5 Defence, +2 Celerity",
            ["Desc3"] = "+100% DFE, +25% damage per 1 MGT",
            ["PDEF"] = "-5",
            ["PSDL"] = 0,
            ["PAGI"] = 2,
            ["func"] = "Fists()",
            ["targets"] = 1
        },
        ["RopeSpear"] = {
            ["Name"] = "Rope Spear",
            ["Type"] = "Weapon",
            ["Icon"] = "items/entourage_ropespear.png",
            ["DMG1"] = 12,
            ["DMG2"] = 16,
            ["DMG3"] = 9,
            ["DMG4"] = 4,
           ["DMG5"] = 25,
            ["dmgtype"] = "Multiple",
            ["BaseAcc"] = 95,
            ["Desc"] = "Knife on a long stick, reinforced with rope. Multi-purpose.",
           ["Desc2"] = "-1 Celerity, +1 Defence",
            ["Desc3"] = "+20% MGT / +20% FCS, 50% armour pen. / +20% CST",
            ["PDEF"] = "1",
            ["PSDL"] = 0,
            ["PAGI"] = -1,
            ["func"] = "RopeSpear()",
            ["targets"] = 1
        },
        ["ClothArmour"] = {
            ["Name"] = "Cloth Armour",
            ["Type"] = "Armour",
            ["Icon"] = "items/entourage_clotharmour.png",
            ["Desc"] = "Standard-issue clothes for scouts.",
           ["Desc2"] = "+5 Dodge",
            ["PDEF"] = 5,
            ["PDFX"] = 0,
            ["PDG"] = 5,
            ["PAGI"] = 0
        },
        ["SlimArmour"] = {
            ["Name"] = "Slim Armour",
            ["Type"] = "Armour",
            ["Icon"] = "items/entourage_slimarmour.png",
            ["Desc"] = "Slim clothes with a premise on light weight.",
           ["Desc2"] = "+12 Dodge, +1 Celerity",
            ["PDEF"] = 2,
            ["PDFX"] = 0,
            ["PDG"] = 12,
            ["PAGI"] = 1
        },
        ["PaddedArmour"] = {
            ["Name"] = "Padded Armour",
            ["Type"] = "Armour",
            ["Icon"] = "items/entourage_paddedarmour.png",
            ["Desc"] = "Reinforced standard armour. Heavier, sturdier.",
           ["Desc2"] = "No bonus effects.",
            ["PDEF"] = 10,
            ["PDFX"] = 0,
            ["PDG"] = 0,
            ["PAGI"] = 0
        },
        ["PrecisionArmour"] = {
            ["Name"] = "Precision Armour",
            ["Type"] = "Armour",
            ["Icon"] = "items/entourage_precisionarmour.png",
            ["Desc"] = "Unique set of protection that covers only vital body parts.",
           ["Desc2"] = "+7 Dodge",
            ["PDEF"] = 2,
            ["PDFX"] = 8,
            ["PDG"] = 7,
            ["PAGI"] = 0
        },
        ["ImpracticalArmour"] = {
            ["Name"] = "Impractical Armour",
            ["Type"] = "Armour",
            ["Icon"] = "items/entourage_impracticalarmour.png",
            ["Desc"] = "A shoddy attempt at plate armour.",
           ["Desc2"] = "-50 Dodge, -3 Celerity",
            ["PDEF"] = 1,
            ["PDFX"] = 35,
            ["PDG"] = -50,
            ["PAGI"] = -3
        },
        ["EmptySlot2"] = {
            ["Name"] = "None",
            ["Type"] = "Empty",
            ["Icon"] = "items/entourage_emptyslot.png",
            ["Desc"] = "Light as a feather - as feeble as one.",
           ["Desc2"] = "+30 Dodge, +3 Celerity.",
            ["PDEF"] = -35,
            ["PDFX"] = 0,
            ["PDG"] = 30,
            ["PAGI"] = 3
        },
        ["KillerSword"] = {
            ["Name"] = "Lynxsie's Greatsword",
            ["Desc"] = "Used by the legendary Lynxsie to conquer Calradia.",
           ["Desc2"] = "Where'd my rapier go?",
            ["Desc3"] = "No scaling",
            ["dmgtype"] = "Slash",
            ["BaseAcc"] = 200,
            ["DMG1"] = 30,
            ["DMG2"] = 40,
            ["Icon"] = "items/entourage_killersword.png",
            ["Type"] = "Weapon",
            ["PDEF"] = "0",
            ["PSDL"] = 0,
            ["PAGI"] = 0,
            ["func"] = "KillerSword()",
            ["targets"] = 4
        }
            
    }
    skillsbase = {
        ["s_precstrike"] = {
            ["Name"] = "Precision Strike",
            ["Description"] = "Deal damage to one target equal to bonus slash weapon strength with bonus accuracy. Gain Focus for 3 turns.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 10,
            ["cost"] = 10,
            ["targets"] = 1
        },
        ["s_defmano"] = {
            ["Name"] = "Defensive Manoeuvre",
            ["Description"] = "Deal damage to one target, gain defensive stats for one turn.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 10,
            ["cost"] = 15,
            ["targets"] = 1
        },
        ["s_firstaid"] = {
            ["Name"] = "First Aid",
            ["Description"] = "Heal target for a value plus a % of its max HP. Grants MGT for 3 turns.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 10,
            ["cost"] = 15,
            ["targets"] = 1
        },
        ["s_slasher"] = {
            ["Name"] = "Slasher",
            ["Description"] = "Levi, my beloved.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 20,
            ["cost"] = -1
        },
        ["s_slicer"] = {
            ["Name"] = "Slicer",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 20,
            ["cost"] = -1
        },
        ["s_dicer"] = {
            ["Name"] = "Dicer",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 20,
            ["cost"] = -1
        },
        ["s_broadswing"] = {
            ["Name"] = "Broad Swing",
            ["Description"] = "Slash all targets for a part of your damage and accuracy.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 10,
            ["cost"] = 10,
            ["targets"] = 10
        },
        ["s_fragmentation"] = {
            ["Name"] = "Fragmentation",
            ["Description"] = "Slash two targets for a part of your damage.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 10,
            ["cost"] = 20,
            ["targets"] = 2
        },
        ["s_medicsupplies"] = {
            ["Name"] = "Medical Supplies",
            ["Description"] = "Heal party - healing decreases for amount healed.",
            ["tier"] = 1,
            ["min"] = 1,
            ["max"] = 10,
            ["cost"] = 25,
            ["targets"] = 11
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

    weaponlistTBL()
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

