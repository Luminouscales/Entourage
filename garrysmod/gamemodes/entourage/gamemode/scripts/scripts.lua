util.AddNetworkString( "dropitem" )

-- RNG item drop system
function droptableRNG( table )
    for k, v in ipairs( table ) do
        if math.random( 1, 100 ) <= v[2] then
            net.Start( "dropitem" )
                net.WriteString( v[1] )
                net.WriteUInt( v[3], 3 )
            net.Send( player.GetAll()[ math.random( 1, #player.GetAll()) ] )
        end
    end
end