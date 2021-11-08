GM.Name = "Entourage"
GM.Author = "Luminouscales"
GM.Email = "blank"
GM.Website = "blank"

DeriveGamemode( "sandbox" )

-- buff table for properties
buffs_id_tbl = {
    ["precstrike"] = {
        ["id"] = 1,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Focus is increased.\nSource: Precision Strike" 
    },
    ["defmano"] = {
        ["id"] = 2,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Defensive stats are increased.\nSource: Defensive Manoeuvre" 
    },
    ["firstaid"] = {
        ["id"] = 3,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Might is increased.\nSource: First Aid" 
    },
    ["acrobatics"] = {
        ["id"] = 4,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Dodge is greatly increased.\nSource: Acrobatics" 
    },
    ["dedications"] = {
        ["id"] = 5,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Flat damage and Defence is increased.\nSource: Dedications" 
    },
    ["moderato"] = {
        ["id"] = 6,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Accuracy and dodge chance is increased.\nSource: Moderato" 
    },
    ["tknives"] = {
        ["id"] = 7,
        ["icon"] = "hud/lyx_buff_PH.png",
        ["desc"] = "Dodge is increased.\nSource: Throwing Knives" 
    }
}

-- Enemies table
enemies_table = {
	["Frostlion Scout"] = {
		["Name"] = "Frostlion Scout",
		["Description"] = "An average unit of the snow insect forces. Only powerful in numbers.",
		["DMG"] = 11,
		["DMGT"] = "Slash",
		["DEF"] = 5,
		["DFX"] = 0,
		["DDG"] = 20,
		["MISS"] = 15,
		["AI"] = "FrostlionScoutAI()",
		["AI2"] = "UniversalDMG()",
		["LVL"] = 1,
		["EXP"] = 10,
        ["idletbl"] = antlion_idle,
        ["StunAnim"] = "AntlionStun()",
        ["actionvar"] = 1
	},
	["Frostlion Skinner"] = {
		["Name"] = "Frostlion Skinner",
		["Description"] = "Its sharp talons pierce armour with a predator’s instinct. Frail.",
		["DMG"] = 7,
		["DMGT"] = "Pierce",
		["DMGP"] = 0,
		["DMGC"] = 20,
		["DEF"] = 0,
		["DFX"] = 15,
		["DDG"] = 40,
		["MISS"] = -10,
		["AI"] = "FrostlionSkinnerAI()",
		["AI2"] = "SkinnerDMG()",
		["LVL"] = 3,
		["EXP"] = 20,
        ["idletbl"] = antlion_idle,
        ["StunAnim"] = "AntlionStun()",
        ["actionvar"] = 1
	},
	["Frostlion Miner"] = {
		["Name"]= "Frostlion Miner",
		["Description"] = "Its heavy and durable limbs carve tunnels in the mountain and concuss your brains.",
		["DMG"] = 25,
		["DMGT"] = "Blunt",
		["DMGS"] = 25,
		["DEF"] = 5,
		["DFX"] = 15,
		["DDG"] = -10,
		["MISS"] = 50,
		["AI"] = "FrostlionMinerAI()",
		["AI2"] = "SnowtlionMinerDMG()",
		["LVL"] = 4,
		["EXP"] = 30,
        ["idletbl"] = antlion_idle,
        ["sound_att"] = "npc/antlion/attack_double3.wav",
        ["StunAnim"] = "AntlionStun()",
        ["actionvar"] = 1
	},

    -- FROSTLION GUARDIAN
    ["Frostlion Guardian"] = {
		["Name"]= "Frostlion Guardian",
		["Description"] = "This ground-quaking beast roams the lands with a crazed thirst for vengeance.",
		["DMG"] = 70,
		["DMGT"] = "Blunt",
		["DMGS"] = 40,
		["DEF"] = 0,
		["DFX"] = 20,
		["DDG"] = -20,
		["MISS"] = 15,
		["AI"] = "GuardianAI()",
		["AI2"] = "DefaultDMG()",
		["LVL"] = 10,
		["EXP"] = 500,
        ["idletbl"] = guardian_idle,
        ["sound_att"] = "npc/antlion/attack_double3.wav",
        ["StunAnim"] = "GuardianStun()",
        ["PainAnim"] = "GuardianPain()",
        ["actionvar"] = 1
	},
    ["Frostlion Prince"] = {
		["Name"] = "Frostlion Prince",
		["Description"] = "Swift and of sharp senses, the Prince seeks out dazed targets to eviscerate.",
		["DMG"] = 10,
		["DMGT"] = "Pierce",
		["DMGP"] = 0,
		["DMGC"] = 35,
		["DEF"] = 0,
		["DFX"] = -10,
		["DDG"] = 25,
		["MISS"] = -30,
		["AI"] = "PrinceAI()",
		["AI2"] = "SkinnerDMG()",
		["LVL"] = 6,
		["EXP"] = 250,
        ["idletbl"] = antlion_idle,
        ["StunAnim"] = "AntlionStun()",
        ["actionvar"] = 1
	}
}

items_table = {
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
        ["Desc2"] = "+1 Celerity",
        ["Desc3"] = "+75% CLE, +75% FCS, 25% armour penetration",
        ["dmgtype"] = "Pierce",
        ["BaseAcc"] = 95,
        ["DMG3"] = 4,
        ["Icon"] = "items/entourage_rustyknife.png",
        ["Type"] = "Weapon",
        ["PDEF"] = "0",
       ["PSDL"] = 0,
        ["PAGI"] = 1,
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
        ["Desc3"] = "+100% DFE, +75% damage per 1 MGT",
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
        ["DMG1"] = 10,
        ["DMG2"] = 14,
        ["DMG3"] = 7,
        ["DMG4"] = 4,
       ["DMG5"] = 20,
        ["dmgtype"] = "Multiple",
        ["BaseAcc"] = 95,
        ["Desc"] = "Knife on a long stick, reinforced with rope. Multi-purpose.",
       ["Desc2"] = "-1 Celerity",
        ["Desc3"] = "+75% MGT / 75% CLE, 50% armour pen. / No scaling",
        ["PDEF"] = 0,
        ["PSDL"] = 0,
        ["PAGI"] = -1,
        ["func"] = "RopeSpear()",
        ["targets"] = 1
    },
    ["SalvagedBlade"] = {
        ["Name"] = "Salvaged Blade",
        ["Type"] = "Weapon",
        ["Icon"] = "items/entourage_salvagedblade.png",
        ["DMG1"] = 15,
        ["DMG2"] = 18,
        ["dmgtype"] = "Slash",
        ["BaseAcc"] = 65,
        ["Desc"] = "Crude metal marks this weapon's sharp edge.",
       ["Desc2"] = "None",
        ["Desc3"] = "+100% MGT, +75% FCS",
        ["PDEF"] = 0,
        ["PSDL"] = 0,
        ["PAGI"] = -1,
        ["func"] = "SalvagedBlade()",
        ["targets"] = 1
    },
    ["ClothArmour"] = {
        ["Name"] = "Cloth Armour",
        ["Type"] = "Armour",
        ["Icon"] = "items/entourage_clotharmour.png",
        ["Desc"] = "Standard-issue clothes for scouts.",
       ["Desc2"] = "",
        ["PDEF"] = 5,
        ["PDFX"] = 0,
        ["PDG"] = 0,
        ["PAGI"] = 0
    },
    ["SlimArmour"] = {
        ["Name"] = "Slim Armour",
        ["Type"] = "Armour",
        ["Icon"] = "items/entourage_slimarmour.png",
        ["Desc"] = "Slim clothes with a premise on light weight.",
       ["Desc2"] = "+12 Dodge, +3 Celerity",
        ["PDEF"] = 2,
        ["PDFX"] = 0,
        ["PDG"] = 12,
        ["PAGI"] = 3
    },
    ["PaddedArmour"] = {
        ["Name"] = "Padded Armour",
        ["Type"] = "Armour",
        ["Icon"] = "items/entourage_paddedarmour.png",
        ["Desc"] = "Reinforced standard armour. Heavier, sturdier.",
       ["Desc2"] = "No bonus effects.",
        ["PDEF"] = 15,
        ["PDFX"] = 0,
        ["PDG"] = 0,
        ["PAGI"] = 0
    },
    ["PrecisionArmour"] = {
        ["Name"] = "Precision Armour",
        ["Type"] = "Armour",
        ["Icon"] = "items/entourage_precisionarmour.png",
        ["Desc"] = "An unique set of protection that covers only vital body parts.",
       ["Desc2"] = "+8 Dodge, +1 CLE",
        ["PDEF"] = 3,
        ["PDFX"] = 14,
        ["PDG"] = 8,
        ["PAGI"] = 1
    },
    ["ImpracticalArmour"] = {
        ["Name"] = "Impractical Armour",
        ["Type"] = "Armour",
        ["Icon"] = "items/entourage_impracticalarmour.png",
        ["Desc"] = "A shoddy attempt at plate armour.",
       ["Desc2"] = "-50 Dodge, -3 Celerity",
        ["PDEF"] = 0,
        ["PDFX"] = 60,
        ["PDG"] = -50,
        ["PAGI"] = -5
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
        ["DMG1"] = 100,
        ["DMG2"] = 100,
        ["Icon"] = "items/entourage_killersword.png",
        ["Type"] = "Weapon",
        ["PDEF"] = 0,
        ["PSDL"] = 0,
        ["PAGI"] = 0,
        ["func"] = "KillerSword()",
        ["targets"] = 1
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
        ["targets"] = 1,
        ["cd"] = 3
    },
    ["s_defmano"] = {
        ["Name"] = "Defensive Manoeuvre",
        ["Description"] = "Deal damage to one target, gain defensive stats for one turn.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 20,
        ["targets"] = 1,
        ["cd"] = 3
    },
    ["s_firstaid"] = {
        ["Name"] = "First Aid",
        ["Description"] = "Heal target for a value plus a % of its max HP. Grants MGT for 3 turns.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 15,
        ["targets"] = 1,
        ["cd"] = 3
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
        ["targets"] = 10,
        ["cd"] = 2
    },
    ["s_fragmentation"] = {
        ["Name"] = "Fragmentation",
        ["Description"] = "Slash two targets for a part of your damage.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 20,
        ["targets"] = 2,
        ["cd"] = 4
    },
    ["s_medicsupplies"] = {
        ["Name"] = "Medical Supplies",
        ["Description"] = "Heal party - healing decreases for amount healed.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 25,
        ["targets"] = 11,
        ["cd"] = 3
    },
    ["s_moraleslash"] = {
        ["Name"] = "Morale Slash",
        ["Description"] = "Strike a target; gain Celerity and recover HP on hit.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 15,
        ["targets"] = 1,
        ["cd"] = 3
    },
    ["s_acrobatics"] = {
        ["Name"] = "Acrobatics",
        ["Description"] = "Strike all targets, gaining a very high dodge chance for 1 turn.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 10,
        ["targets"] = 10,
        ["cd"] = 5
    },
    ["s_distraction"] = {
        ["Name"] = "Distraction",
        ["Description"] = "Choose two targets; the first becomes stunned, the other takes damage.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 25,
        ["targets"] = 2,
        ["cd"] = 4
    },
    ["s_performance"] = {
        ["Name"] = "Performance",
        ["Description"] = "Strike all targets for low damage, heal allies.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 15,
        ["targets"] = 10,
        ["cd"] = 2
    },
    ["s_sharpcare"] = {
        ["Name"] = "Sharp Care",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 20,
        ["cost"] = -1
    },
    ["s_immaculate"] = {
        ["Name"] = "Immaculate Blades",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 20,
        ["cost"] = -1
    },
    ["s_scrutiny"] = {
        ["Name"] = "Vile Scrutiny",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 20,
        ["cost"] = -1
    },
    ["s_vprecision"] = {
        ["Name"] = "Via Precision",
        ["Description"] = "Deal a portion of your CLE and FCS as bonus damage.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 25,
        ["targets"] = 1,
        ["cd"] = 3
    },
    ["s_dedications"] = {
        ["Name"] = "Dedications",
        ["Description"] = "Increase party flat damage and defence, plus a permanent bonus.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 15,
        ["targets"] = 11,
        ["cd"] = 3
    },
    ["s_moderato"] = {
        ["Name"] = "Moderato",
        ["Description"] = "Increase party hit chance and evasion.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 25,
        ["targets"] = 11,
        ["cd"] = 2
    },
    ["s_zillionedge"] = {
        ["Name"] = "Zillion Edge",
        ["Description"] = "Deal very little to very high damage to one target.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 15,
        ["targets"] = 1,
        ["cd"] = 2
    },
    ["s_tknives"] = {
        ["Name"] = "Throwing Knives",
        ["Description"] = "Hit a random target 1-6 times, gain dodge chance for each hit.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 10,
        ["targets"] = 10,
        ["cd"] = 2
    },
    ["s_qethics"] = {
        ["Name"] = "Questionable Ethics",
        ["Description"] = "Heal yourself for a random amount of max HP.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 20,
        ["targets"] = 11,
        ["cd"] = 3
    },
    ["s_heartcut"] = {
        ["Name"] = "Heartful Cut",
        ["Description"] = "Strike a target for less damage but more crit efficiency.",
        ["tier"] = 1,
        ["min"] = 1,
        ["max"] = 10,
        ["cost"] = 15,
        ["targets"] = 1,
        ["cd"] = 3
    }
}