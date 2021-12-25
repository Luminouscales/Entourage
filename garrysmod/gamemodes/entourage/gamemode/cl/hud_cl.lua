hook.Add("Think", "clicka1", function() -- clicka
    gui.EnableScreenClicker( input.IsKeyDown( KEY_N ) )
end)

hook.Add( "InitPostEntity", "initglobal", function()
	
	-- pleqic
	pleqic = vgui.Create( "DModelPanel" )
		
		pleqic:SetSize( 100, 100 )
			pleqic:SetPos( 0, 975 )
			pleqic:SetModel( LocalPlayer():GetModel() )

			function pleqic:LayoutEntity( ent ) return end

			local headpos = pleqic.Entity:GetBonePosition(pleqic.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			pleqic:SetLookAt(headpos)

			pleqic:SetCamPos(headpos-Vector( -5, 13, 0 ) )

			function pleqic.Entity:GetPlayerColor() return Entity(1):GetPlayerColor() end

		pleqic.DoClick = function()
			equipframe:ToggleVisible()
			pleqic:ToggleVisible()
			CrossCheck1()
		end
	-----------------------------

	-- DangerHUD()
	function DangerHUD()
		int = 0
		encounter_rate3 = 0
		
		hook.Add( "HUDPaint", "dangerbar", function()
			surface.SetDrawColor( color_white )
			surface.DrawRect( ScrW()/1.134, ScrH()/1.0, ScrW()/9, 20 )
	
			int = encounter_rate3 / encounter_rate4
			int = math.Clamp( int, 0, 1 )
	
			if equipframe:IsActive() == false then
				draw.RoundedBox( 4, ScrW()/1.129, ScrH()/1.023, ScrW()/9.6, ScrH()/100, Color(185, 255 - 255 * int, 0) )
	
				draw.SimpleText( "Danger", "danger_font", 1800, 1040, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end)
	end
	DangerHUD()
	-----------------------------

	-- Hiders. Handy!
	local hide = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true
	}

	hook.Add( "HUDShouldDraw", "HideHUD", function( name )
		if ( hide[ name ] ) then return false end
	end)
	-----------------------------
	-- Dialogue box
	lx_conv_frame = vgui.Create( "DFrame" )
        lx_conv_frame:Hide()
        lx_conv_frame:SetSize( 800, 800 )
        lx_conv_frame:SetPos( 0, 0 )
        lx_conv_frame:ShowCloseButton( false )
        lx_conv_frame:SetTitle( "" )

        lx_conv_frame.Paint = function( self, w, h )
            if convboxshow then
                graybox = Lerp( ( SysTime() - sus ) * 0.1, graybox, 800 )
            else
                graybox = Lerp( ( SysTime() - sus ) * 0.1, graybox, 0 )
            end
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