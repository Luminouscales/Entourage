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

end)