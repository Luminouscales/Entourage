function eph_EmptySlot3(equip)
    -- Did you know? Programming while high is a little difficult. The afterglow suits it fine, though, I think.
end

function eph_Skrunkly( equip )
    if equip then
        playerstats_a["currenttrinket"] = "Skrunkly"
        playerstats["currenttrinket"] = "Skrunkly"

        playerstats_a["HP1"] = playerstats_a["HP1"] + 30
        playerstats["HP1"] = playerstats_a["HP1"]
        playerstats_a["HP2"] = playerstats_a["HP2"] + 30
        playerstats["HP2"] = playerstats_a["HP2"]
    else
        playerstats_a["HP1"] = math.Clamp( playerstats_a["HP1"] - 30, 1, 9999 )
        playerstats["HP1"] = playerstats_a["HP1"]
        playerstats_a["HP2"] = playerstats_a["HP2"] - 30
        playerstats["HP2"] = playerstats_a["HP2"]

    end
    net.Start( "maxhealth" )
        net.WriteDouble( playerstats["HP1"] )
        net.WriteDouble( playerstats["HP2"] )
    net.SendToServer()
end

function eph_IronIngot( equip )
    net.Start( "trinketcall" )
        net.WriteString( "IronIngot" )
        net.WriteBool( equip )
    net.SendToServer()
end

function eph_MonsterFang( equip )
    if equip then
        playerstats_a["currenttrinket"] = "MonsterFang"
        playerstats["currenttrinket"] = "MonsterFang"

        playerstats_a["flatdmg"] = playerstats_a["flatdmg"] + 3
        playerstats["flatdmg"] = playerstats_a["flatdmg"]
    else
        playerstats_a["flatdmg"] = playerstats_a["flatdmg"] - 3
        playerstats["flatdmg"] = playerstats_a["flatdmg"]
    end
end