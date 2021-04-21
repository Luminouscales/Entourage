hook.Add( "InitPostEntity", "statsscreeninit", function()
    
    -- This frame is for stats. Ugly.
    stats_frame = vgui.Create( "DFrame", equipframe )
        stats_frame:MakePopup()
        stats_frame:SetSize( 1600, 800 )
        stats_frame:Center()
        stats_frame:SetDraggable( false )
        stats_frame:ShowCloseButton( false )
        stats_frame:SetTitle( "" ) 
        stats_frame:SetPaintShadow( true )
        stats_frame.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
        end
		
		local sf_figure_sdl = vgui.Create( "DImageButton", stats_frame )
			sf_figure_sdl:SetImage( "hud/figure_sdl.png" )
			sf_figure_sdl:SetSize( 138, 210 )
			sf_figure_sdl:Dock( RIGHT )
			sf_figure_sdl:DockMargin( 0, 295, 175, 295 )
			sf_figure_sdl.DoClick = function()
                PlaceholderFunction()
			end

		local sf_figure_dfe = vgui.Create( "DImageButton", stats_frame )
			sf_figure_dfe:SetImage( "hud/figure_dfe.png" )
			sf_figure_dfe:SetSize( 128, 128 )
			sf_figure_dfe:Dock( RIGHT )
			sf_figure_dfe:DockMargin( 0, 197, -128, 475 )
			sf_figure_dfe.DoClick = function()
                PlaceholderFunction()
			end
    ------------
    -- Epilogue
    stats_frame:SetDeleteOnClose( false )
	stats_frame:Close()
    ------------

end)