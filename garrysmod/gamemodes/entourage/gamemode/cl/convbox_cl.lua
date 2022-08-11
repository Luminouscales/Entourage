-- Dialogue box
hook.Add( "InitPostEntity", "ahhhhh", function()
    lx_conv_frame = vgui.Create( "DFrame" )
        lx_conv_frame:Hide()
        lx_conv_frame:SetSize( 800, 800 )
        lx_conv_frame:SetPos( 0, 0 )
        lx_conv_frame:ShowCloseButton( false )
        lx_conv_frame:SetTitle( "" )
        lx_conv_frame.Paint = function( self, w, h )
            local int = 0
            if convboxshow then
                int = 800
            else
                int = 0
            end
            graybox = Lerp( ( SysTime() - sus ) * 0.1, graybox, int )
            surface.SetDrawColor( Color( 50, 50, 50, 200 ) )
            surface.DrawRect( 5, 5, graybox, 135 )
        end

    lx_conv_avic = vgui.Create( "DModelPanel", lx_conv_frame )
        lx_conv_avic:SetPos( 0, 0 )
        lx_conv_avic:SetSize( 130, 130 )
        lx_conv_avic:SetModel( LocalPlayer():GetModel() )

    function lx_conv_avic:LayoutEntity( ent ) return end

    local headpos = lx_conv_avic.Entity:GetBonePosition(lx_conv_avic.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        lx_conv_avic:SetLookAt(headpos)
        lx_conv_avic:SetCamPos(headpos-Vector( -5, 13, 0 ) )
        function lx_conv_avic.Entity:GetPlayerColor() return LocalPlayer():GetPlayerColor() end

    lx_conv_text = vgui.Create( "RichText", lx_conv_frame )
        lx_conv_text:SetPos( 150, 0 )
        lx_conv_text:SetSize( 620, 800 )
        lx_conv_text:InsertColorChange( 255, 255, 255, 255 )
        lx_conv_text:SetVerticalScrollbarEnabled( false )
        function lx_conv_text:PerformLayout()
            self:SetFontInternal( "equipment_plname" )
        end

    lx_conv_name = vgui.Create( "DLabel", lx_conv_frame )
        lx_conv_name:SetPos( 25, 95 )
        lx_conv_name:SetFont( "equipment_plname" )
        lx_conv_name:SetTextColor( color_white )
        lx_conv_name:SetText( LocalPlayer():Name() )
        lx_conv_name:SetExpensiveShadow( 2.5, color_black )
        lx_conv_name:SizeToContents()
end)


function lx_conv_debug( unit, string, delay )

    if convboxshow2 == false then

        -- Model & name management
        lx_conv_avic:SetModel( unit:GetModel() )
        if unit:IsPlayer() then
            function lx_conv_avic.Entity:GetPlayerColor() return LocalPlayer():GetPlayerColor() end
        else
            function lx_conv_avic.Entity:GetColor() return color_white end
        end
        ---

        lx_conv_frame:Show()

        local var = 0 
        if delay == nil then
            local delay = 0.05
        end

        sus = SysTime()
        convboxshow = true
        convboxshow2 = true

        timer.Create( "lx_conv_timer", delay, #string, function()
            if convboxshow then
                var = var + 1

                lx_conv_text:SetText( "" )
                lx_conv_text:InsertColorChange( 255, 255, 255, 255 )
                lx_conv_text:AppendText( string.sub( string, 1, var ) )
                print( lx_conv_text:GetWide() )
                if var > 25 then
                    lx_conv_text:CenterVertical( 0.525 )
                else
                    lx_conv_text:CenterVertical( 0.555 )
                end
                if string.byte( string, var, var ) ~= 32 then
                    surface.PlaySound( "yuumi.wav" )
                end
            end

        end)
        timer.Create( "lx_conv_deleter", delay * #string + 2, 1, function()
            lx_conv_text:SetText( "" )
            sus = SysTime()
            convboxshow = false
            timer.Create( "lx_conv_deleter2", 0.9, 1, function()
                convboxshow2 = false
                conv_tier = -1
                lx_conv_frame:Hide()
            end)
        end)
    end
end