util.AddNetworkString("trinketcall")

net.Receive( "trinketcall", function( len, ply )
    trinket = net.ReadString()
    equip = net.ReadBool()

    tr_player = ply
    
    RunString( "tr_ss_".. trinket .."()" )

    tr_player = nil
    trinket = nil
    equip = nil
end)

function tr_ss_IronIngot()
    local tr_bool = equip
    local tr_player2 = tr_player
    local hookname = "tr_ironingot_".. tr_player2:UserID()
    if tr_bool then 
        hook.Add( "battlePreStun", hookname, function( ply )
            if tr_player2 == ply then
                stunbonus = stunbonus - 20
            end
        end)
    else
        hook.Remove( "battlePreStun", hookname )
    end
end