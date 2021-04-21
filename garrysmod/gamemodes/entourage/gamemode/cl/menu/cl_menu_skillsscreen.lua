hook.Add( "InitPostEntity", "skillscreeninit", function()
    
    -- This skill frame lets you choose the damage type skillset.
    skills_frame = vgui.Create( "DFrame", equipframe )
        skills_frame:MakePopup()
        skills_frame:SetSize( 1740, 920 )
        skills_frame:Center()
        skills_frame:SetDraggable( false )
        skills_frame:ShowCloseButton( false )
        skills_frame:SetTitle( "" ) 
        skills_frame:SetPaintShadow( true )
        skills_frame.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
            draw.SimpleText( "Skills", "equipment_plname4", w/2, 11, color_white, a, a )
            draw.SimpleText( playerstats_a["SLASH_POINTS"], "equipment_plname5", 330, 610, color_white, b, a )
            draw.SimpleText( playerstats_a["BLUNT_POINTS"], "equipment_plname5", 889, 610, color_white, b, a )
            draw.SimpleText( playerstats_a["PIERCE_POINTS"], "equipment_plname5", 1448, 610, color_white, b, a )
        end

        -- Return button.
        local sk_closebutton = vgui.Create( "DImageButton", skills_frame )
            sk_closebutton:SetImage( "hud/arrow_left.png" )
            sk_closebutton:SetSize( 20, 20 )
            sk_closebutton:SetPos( 5, 4 )
            sk_closebutton.DoClick = function()
                mainframe:ToggleVisible()
                skills_frame:Close()
                CrossCheck1()
            end

        -- Damage type button...
        local sk_slashbutton_1 = vgui.Create( "DImageButton", skills_frame )
            sk_slashbutton_1:SetImage( "hud/sk_slashb.png" )
            sk_slashbutton_1:SetSize( skills_frame:GetWide()/4.09, skills_frame:GetTall()/16.73 )
            sk_slashbutton_1:SetPos( skills_frame:GetWide()/17.4, skills_frame:GetTall()/2.17 )
            sk_slashbutton_1.Paint = function( self, w, h )
                draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, true, true, true, true)
            end
            sk_slashbutton_1.DoClick = function()
                skills_frame:Close()
                skills_frame_slash:Show()
            end
            -- ...and its respective description.
            local sk_slashbutton_1_desc = vgui.Create( "DImage", skills_frame )
                sk_slashbutton_1_desc:SetSize( skills_frame:GetWide()/4.09, skills_frame:GetTall()/9.2 )
                sk_slashbutton_1_desc:SetPos( skills_frame:GetWide()/17.4, skills_frame:GetTall()/1.94 )
                sk_slashbutton_1_desc:SetImage( "hud/sk_slashb_dsc.png" )
            -- and also skill points.
            local sk_s_lvlp = vgui.Create( "DImage", skills_frame )
                sk_s_lvlp:SetImage( "menu/entourage_lvlpoint.png")
                sk_s_lvlp:SetPos( 265, 585 )
                sk_s_lvlp:SetSize( 50, 50 )

        local sk_bluntbutton_1 = vgui.Create( "DImageButton", skills_frame )
            sk_bluntbutton_1:SetImage( "hud/sk_bluntb.png" )
            sk_bluntbutton_1:SetSize( skills_frame:GetWide()/4.09, skills_frame:GetTall()/16.73 )
            sk_bluntbutton_1:SetPos( skills_frame:GetWide()/2.64 , skills_frame:GetTall()/2.17 )
            sk_bluntbutton_1.Paint = function( self, w, h )
                draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, true, true, true, true)
            end
            sk_bluntbutton_1.DoClick = function()
                skills_frame:Close()
                skills_frame_blunt:Show()
            end
            local sk_bluntbutton_1_desc = vgui.Create( "DImage", skills_frame )
                sk_bluntbutton_1_desc:SetSize( skills_frame:GetWide()/4.09, skills_frame:GetTall()/9.2 )
                sk_bluntbutton_1_desc:SetPos( skills_frame:GetWide()/2.64, skills_frame:GetTall()/1.94 )
                sk_bluntbutton_1_desc:SetImage( "hud/sk_bluntb_dsc.png" )
            local sk_b_lvlp = vgui.Create( "DImage", skills_frame )
                sk_b_lvlp:SetImage( "menu/entourage_lvlpoint.png")
                sk_b_lvlp:SetPos( 824, 585 )
                sk_b_lvlp:SetSize( 50, 50 )

        local sk_piercebutton_1 = vgui.Create( "DImageButton", skills_frame )
            sk_piercebutton_1:SetImage( "hud/sk_pierceb.png" )
            sk_piercebutton_1:SetSize( skills_frame:GetWide()/4.09, skills_frame:GetTall()/16.73 )
            sk_piercebutton_1:SetPos( skills_frame:GetWide()/1.43 , skills_frame:GetTall()/2.17 )
            sk_piercebutton_1.Paint = function( self, w, h )
                draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, true, true, true, true)
            end
            sk_piercebutton_1.DoClick = function()
                skills_frame:Close()
                skills_frame_pierce:Show()
            end
            local sk_piercebutton_1_desc = vgui.Create( "DImage", skills_frame )
                sk_piercebutton_1_desc:SetSize( skills_frame:GetWide()/4.09, skills_frame:GetTall()/9.2 )
                sk_piercebutton_1_desc:SetPos( skills_frame:GetWide()/1.43, skills_frame:GetTall()/1.9 )
                sk_piercebutton_1_desc:SetImage( "hud/sk_pierceb_dsc.png" )
            local sk_p_lvlp = vgui.Create( "DImage", skills_frame )
                sk_p_lvlp:SetImage( "menu/entourage_lvlpoint.png")
                sk_p_lvlp:SetPos( 1383, 585 )
                sk_p_lvlp:SetSize( 50, 50 )
    -----------------------
    -- Base for each skill frame.
    skills_frame_slash = vgui.Create( "DFrame", equipframe )
        skills_frame_slash:MakePopup()
        skills_frame_slash:SetSize( 1740, 920 )
        skills_frame_slash:Center()
        skills_frame_slash:SetDraggable( false )
        skills_frame_slash:ShowCloseButton( false )
        skills_frame_slash:SetTitle( "" ) 
        skills_frame_slash:SetPaintShadow( true )
        skills_frame_slash.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
            draw.RoundedBoxEx( 0, 1350, 25, 6, h, Color( 90, 90, 95 ), false, false, false, false)
            draw.SimpleText( "Skills", "equipment_plname4", ( w - 380 ) /2, 11, color_white, a, a )
            draw.SimpleText( playerstats_a["SLASH_POINTS"], "equipment_plname3", 1430, h - 35, color_white, b, a )
            draw.SimpleText( "LVL: ".. playerstats_a["LVL3"], "equipment_plname3", 1610, h - 35, color_white, b, a )
        end

        -- Base frame close button.
        local skbs_closebutton = vgui.Create( "DImageButton", skills_frame_slash )
        skbs_closebutton:SetImage( "hud/arrow_left.png" )
        skbs_closebutton:SetSize( 20, 20 )
        skbs_closebutton:SetPos( 5, 4 )
        skbs_closebutton.DoClick = function()
            skills_frame_slash:Close()
            skills_frame:Show()
        end

    skills_frame_pierce = vgui.Create( "DFrame", equipframe )
        skills_frame_pierce:MakePopup()
        skills_frame_pierce:SetSize( 1740, 920 )
        skills_frame_pierce:Center()
        skills_frame_pierce:SetDraggable( false )
        skills_frame_pierce:ShowCloseButton( false )
        skills_frame_pierce:SetTitle( "" ) 
        skills_frame_pierce:SetPaintShadow( true )
        skills_frame_pierce.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
            draw.RoundedBoxEx( 0, 1350, 25, 6, h, Color( 90, 90, 95 ), false, false, false, false)
            draw.SimpleText( "Skills", "equipment_plname4", ( w - 380 ) /2, 11, color_white, a, a )
        end

        -- Base frame close button.
        local skbp_closebutton = vgui.Create( "DImageButton", skills_frame_pierce )
        skbp_closebutton:SetImage( "hud/arrow_left.png" )
        skbp_closebutton:SetSize( 20, 20 )
        skbp_closebutton:SetPos( 5, 4 )
        skbp_closebutton.DoClick = function()
            skills_frame_pierce:Close()
            skills_frame:Show()
        end

    skills_frame_blunt = vgui.Create( "DFrame", equipframe )
        skills_frame_blunt:MakePopup()
        skills_frame_blunt:SetSize( 1740, 920 )
        skills_frame_blunt:Center()
        skills_frame_blunt:SetDraggable( false )
        skills_frame_blunt:ShowCloseButton( false )
        skills_frame_blunt:SetTitle( "" ) 
        skills_frame_blunt:SetPaintShadow( true )
        skills_frame_blunt.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
            draw.RoundedBoxEx( 0, 1350, 25, 6, h, Color( 90, 90, 95 ), false, false, false, false)

            draw.SimpleText( "Skills", "equipment_plname4", ( w - 380 ) /2, 11, color_white, a, a )
        end

        -- Base frame close button.
        local skb_closebutton = vgui.Create( "DImageButton", skills_frame_blunt )
        skb_closebutton:SetImage( "hud/arrow_left.png" )
        skb_closebutton:SetSize( 20, 20 )
        skb_closebutton:SetPos( 5, 4 )
        skb_closebutton.DoClick = function()
            skills_frame_blunt:Close()
            skills_frame:Show()
        end

    -----------------------
    -- Epilogue
    skills_frame:SetDeleteOnClose( false )
    
    skills_frame_slash:SetDeleteOnClose( false )
    skills_frame_pierce:SetDeleteOnClose( false )
    skills_frame_blunt:SetDeleteOnClose( false )
    
    -----------------------
    
end)