local editing = GetConVar( "entourage_editmode" ):GetBool()

function GM:AddDeathNotice() end
function GM:DrawDeathNotice() end
function GM:SpawnMenuEnabled() return editing end
timer.Simple( 1, function()
	CreateContextMenu()	
end)

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

			function pleqic.Entity:GetPlayerColor() return LocalPlayer():GetPlayerColor() end

		pleqic.DoClick = function()
			equipframe:ToggleVisible()
			pleqic:ToggleVisible()
			CrossCheck1()
		end
	-----------------------------

	-- DangerHUD()
	function DangerHUD()
		local int = 0
		encounter_rate3 = 0
		
		hook.Add( "HUDPaint", "dangerbar", function()
			surface.SetDrawColor( color_white )
			surface.DrawRect( ScrW()/1.134, ScrH()/1.0, ScrW()/9, 20 )
	
			int = encounter_rate3 / encounter_rate4
			int = math.Clamp( int, 0, 1 )
	
			if equipframe and equipframe:IsActive() == false then
				draw.RoundedBox( 4, ScrW()/1.129, ScrH()/1.023, ScrW()/9.6, ScrH()/100, Color(185, 255 - 255 * int, 0) )
	
				draw.SimpleText( "Danger", "danger_font", 1800, 1040, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end)
	end
	DangerHUD()
	-----------------------------

	-- Hiders
	local hide = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true,
		["CHudWeaponSelection"] = editing == false
	}

	hook.Add( "HUDShouldDraw", "HideHUD", function( name )
		if ( hide[ name ] ) then return false end
	end)
	-----------------------------

	-- Singleplayer alert
	if game.SinglePlayer() then
		timer.Simple( 0.5, function()
			reprimand_box = vgui.Create( "DFrame" )
			reprimand_box:SetSize( 800, 300 )
			reprimand_box:Center()
			reprimand_box:ShowCloseButton( true )
				reprimand_box.btnMaxim:SetVisible( false )
				reprimand_box.btnMinim:SetVisible( false )
			reprimand_box:SetTitle( "" )
			reprimand_box:SetDraggable( false )
			reprimand_box.Paint = function( self, w, h )
				surface.SetDrawColor( Color( 110, 110, 115, 240 ) )
				surface.DrawRect( 0, 0, w, h )
				surface.SetDrawColor( plcol.r, plcol.g, plcol.b)
				surface.DrawRect( 0, h - 5, w, 5 )
			end

			reprimand_text = vgui.Create( "DLabel", reprimand_box )
			reprimand_text:SetColor( color_white )
			reprimand_text:SetFont( "equipment_plname" )
			reprimand_text:SetText( "The current game is running in Singleplayer.")
			reprimand_text:SizeToContents()
			reprimand_text:SetPos( 0, 12 + reprimand_box:GetTall() / 4 )
			reprimand_text:CenterHorizontal( 0.5 )

			reprimand_text1 = vgui.Create( "DLabel", reprimand_box )
			reprimand_text1:SetColor( color_white )
			reprimand_text1:SetFont( "equipment_plname2" )
			reprimand_text1:SetText( "This might cause some game functions to run incorrectly.")
			reprimand_text1:SizeToContents()
			reprimand_text1:SetPos( 0, reprimand_text:GetY() + reprimand_text:GetTall() - 5 )
			reprimand_text1:CenterHorizontal( 0.5 )

			reprimand_text2 = vgui.Create( "DLabel", reprimand_box )
			reprimand_text2:SetColor( color_white )
			reprimand_text2:SetFont( "equipment_plname2" )
			reprimand_text2:SetText( "Please host a local game for at least two players to avoid issues.")
			reprimand_text2:SizeToContents()
			reprimand_text2:SetPos( 0, reprimand_text1:GetY() + reprimand_text1:GetTall() - 5 )
			reprimand_text2:CenterHorizontal( 0.5 )
		end)
	end
end)