-- Music function
function test()
    sound.PlayFile( "sound/cer2.mp3", "noblock noplay mono", function( a, b, c )
        a:EnableLooping( true )
        a:SetVolume( 2 )
        a:Play()
        local channel = a
    end)
end

function entourage_FadeOut( chan )
    local a = SysTime()
    local c = chan:GetFileName().."fadeout"
    local d = chan:GetVolume()
    hook.Add( "Think", c, function()
        local b = Lerp( ( SysTime() - a ) / 3, d, 0 )
        chan:SetVolume( b )
        if b == 0 then
            hook.Remove( "Think", c )
        end
    end)
end