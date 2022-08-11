local lol = 0
clicka2 = false
local madechanges = false




function CrossCheck1()
	local convenience = { 
		overview_cross_mgt,
		overview_cross_dfe,
		overview_cross_cle,
		overview_cross_sdl,
		overview_cross_fcs
	}

	if playerstats_a["LVL_POINTS"] > 0 then
		for _, v in pairs( convenience ) do
			v:Show()
		end
	else
		for _, v in pairs( convenience ) do
			v:Hide()
		end
	end
end

hook.Add( "InitPostEntity", "clmenuinit", function()
	
	timer.Simple( 0.25, function()

		menuwepalt = playerstats["currentweapon"]
		menuwep = items_table[ playerstats[ "currentweapon" ] ].Name
		menuwep2 = items_table[ playerstats[ "currentweapon" ] ].Desc
		menuwep4 = items_table[ playerstats[ "currentweapon" ] ].Desc2
		menuwep5 = items_table[ playerstats[ "currentweapon" ] ].Desc3

		menuarm = items_table[ playerstats[ "currentarmour" ] ].Name
		menuarm2 = items_table[ playerstats[ "currentarmour" ] ].Desc
		menuarm3 = items_table[ playerstats[ "currentarmour" ] ].PDEF
		menuarm4 = items_table[ playerstats[ "currentarmour" ] ].PDFX
		menuarm5 = items_table[ playerstats[ "currentarmour" ] ].Desc2

		-- Everything here presets variables to be used in the overview screen and elsewhere.
		if items_table[ menuwepalt ].dmgtype == "Slash" then
			menuwep3 = items_table[ menuwepalt ].DMG1.. "-".. items_table[ menuwepalt ].DMG2.. " Slash damage"
		elseif items_table[ menuwepalt ].dmgtype == "Pierce" then
			menuwep3 = items_table[ menuwepalt ].DMG3 .." Pierce damage"
		elseif items_table[ menuwepalt ].dmgtype == "Blunt" then
			menuwep3 = items_table[ menuwepalt ].DMG4.. "-".. items_table[ menuwepalt ].DMG5.. " Blunt damage"
		else
			menuwep3 = items_table[ menuwepalt ].DMG1.. "-".. items_table[ menuwepalt ].DMG2.. " Slash damage, ".. items_table[ menuwepalt ].DMG3 .." Pierce damage, ".. items_table[ menuwepalt ].DMG4.. "-".. items_table[ menuwepalt ].DMG5 .." Blunt damage"
		end

	end)

    -- plcol isn't used in pleqic and so is defined here instead.
    plcol = LocalPlayer():GetPlayerColor() * Vector( 255, 255, 255 )
    ----------------------------

    -- This frame is the foundation for all the other menus.
    equipframe = vgui.Create( "DFrame" )
        equipframe:SetDraggable( false )
        equipframe:SetSize( ScrW(), ScrH() ) 
        equipframe:SetPos( 0, 0 )
        equipframe:SetTitle( "" ) 
        equipframe:ShowCloseButton( false )
        equipframe:SetPaintShadow( false )
        equipframe.Paint = function( self, w, h )
        end
	---------------------------

	-- This is the actual overview screen.
	mainframe = vgui.Create( "DFrame", equipframe )
		mainframe:MakePopup()
		mainframe:SetDraggable( false )
		mainframe:SetSize( 800, 800 )
		mainframe:Center()
		mainframe:SetTitle( "" )
		mainframe:ShowCloseButton( false )
		local sh = "equipment_plname4"
		local sh2 = "equipment_plname2"
		mainframe.Paint = function( self, w, h )
			draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
			draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
			draw.SimpleText( "Overview", sh, w/2, 10, color_white, a, a )
			draw.SimpleText( LocalPlayer():Name(), "encounter_font", w/2, 75, plcol, a, a )
			draw.SimpleText( "Level ".. playerstats_a["LVL3"] .." ".. tag, sh, w/2, 130, color_white, a, a )
			draw.SimpleText( playerstats_a["LVL1"] .."/".. playerstats_a["LVL2"], sh, w/2, 165, color_white, a, a )
			draw.SimpleText( playerstats_a["HP1"] .."/".. playerstats_a["HP2"], sh2, w/2 - 32, 690, color_white, b, a )
			draw.SimpleText( items_table[ playerstats_a["currentweapon"] ].Name, sh2, w/2 - 35, 730, color_white, b, a )
			draw.SimpleText( items_table[ playerstats_a["currentarmour"] ].Name, sh2, w/2 - 35, 770, color_white, b, a )
			draw.SimpleText( playerstats_a["MGT"], sh2, 545, 275, color_white, b, a )
			draw.SimpleText( playerstats_a["VIT"], sh2, 545, 328, color_white, b, a )
			draw.SimpleText( playerstats_a["AGI"], sh2, 545, 380, color_white, b, a )
			draw.SimpleText( playerstats_a["SDL"], sh2, 545, 435, color_white, b, a )
			draw.SimpleText( playerstats_a["FCS"], sh2, 545, 490, color_white, b, a )
			draw.SimpleText( playerstats_a["DEF"] + ( playerstats_a["FCS"] + playerstats_a["AGI"] ) * ( 0.5 * plskills_a["s_vprecision"].equipped ), sh2, 545, 545, color_white, b, a )
			draw.SimpleText( playerstats_a["DFX"], sh2, 545, 600, color_white, b, a )
			draw.SimpleText( playerstats_a["LVL_POINTS"], sh2, 545, 670, color_white, b, a )
		end

		local convenience = {
			"might",
			"defiance",
			"celerity",
			"sidle",
			"focus",
			"defence",
			"flexdefence"
		}

		for k, v in pairs( convenience ) do
			local a = vgui.Create( "DImage", mainframe )
			a:SetImage("hud/entourage_".. v ..".png")
			a:SetPos( 490, 255 + k * 55 - 55 )
			a:SetSize( 35, 35 )
		end
			
		local mf_hpic = vgui.Create( "DImage", mainframe )
			mf_hpic:SetImage( "hud/entourage_hpicon.png")
			mf_hpic:SetPos( 325, 675)
			mf_hpic:SetSize( 30, 30 )

		local mf_wpic = vgui.Create( "DImage", mainframe )
			mf_wpic:SetImage( "hud/entourage_wpicon.png")
			mf_wpic:SetPos( 325, 708)
			mf_wpic:SetSize( 30, 30 )

		local mf_amic = vgui.Create( "DImage", mainframe )
			mf_amic:SetImage( "hud/entourage_armouricon.png")
			mf_amic:SetPos( 325, 750)
			mf_amic:SetSize( 30, 30 )

		local mf_lvlp = vgui.Create( "DImage", mainframe )
			mf_lvlp:SetImage( "menu/entourage_lvlpoint.png")
			mf_lvlp:SetPos( 490, 655 )
			mf_lvlp:SetSize( 35, 35 )
		
		-- The player's model.
		local plmic = vgui.Create( "DModelPanel", mainframe )
			plmic:SetSize( 700, 700 )
			plmic:SetModel( LocalPlayer():GetModel() )
			plmic:Center()
			plmic:SetCamPos( Vector( 75, 0, 50 ) )
			plmic:SetMouseInputEnabled( false )
			function plmic.Entity:GetPlayerColor() 
				return LocalPlayer():GetPlayerColor() 
			end
			function plmic:LayoutEntity( ent ) 
				return 
			end
			
		-- These buttons send you elsewhere.
		local weapon_button = vgui.Create( "DImageButton", mainframe )
			weapon_button:SetSize( 200, 35 )
			weapon_button:SetPos( 0, mainframe:GetTall()/2 )
			weapon_button:SetImage( "hud/entourage_arsenal3.png" )
			weapon_button.Paint = function( self, w, h )
				draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, false, true, false, true)
			end
			weapon_button.DoClick = function()
				mainframe:ToggleVisible()
				weapons_frame:Show()
				rt_armour()
				image_check1:SetPos( ScrW()+100, ScrH()+100 )
				image_check2:SetPos( ScrW()+100, ScrH()+100 )
			end

		local stats_button = vgui.Create( "DImageButton", mainframe )
			stats_button:SetSize( 200, 35 )
			stats_button:SetPos( 0, mainframe:GetTall()/2 - 60 )
			stats_button:SetImage( "hud/entourage_stats.png" )
			stats_button.Paint = function( self, w, h )
				draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, false, true, false, true)
			end
			stats_button.DoClick = function()
				mainframe:ToggleVisible()
				stats_frame:Show()
			end

		local skills_button = vgui.Create( "DImageButton", mainframe )
			skills_button:SetSize( 200, 35 )
			skills_button:SetPos( 0, mainframe:GetTall()/2 + 60 )
			skills_button:SetImage( "hud/entourage_skills.png" )
			skills_button.Paint = function( self, w, h )
				draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, false, true, false, true)
			end
			skills_button.DoClick = function()
				mainframe:ToggleVisible()
				skills_frame:Show()
			end
	---------------------------
	-- This one is omnipresent; close button for everything.
	local closebutton = vgui.Create( "DImageButton", equipframe )
		closebutton:SetImage( "icon16/cross.png" )
		closebutton:SetSize( 20, 20 )
		closebutton:SetPos( ScrW() - 25, 5 )
		closebutton.DoClick = function()
			equipframe:ToggleVisible()
			pleqic:Show()
		end
	---------------------------
	-- This belongs in weaponsframe but is parented here so I'll just leave it with its father.
	image_check1 = vgui.Create( "DImage", equipframe)
		image_check1:SetSize( 100, 100 )
		image_check1:SetPos( ScrW()+100, ScrH()+100 )
		image_check1:SetImage( "entourage_checkedslot.png" )

	image_check2 = vgui.Create( "DImage", equipframe)
		image_check2:SetSize( 100, 100 )
		image_check2:SetPos( ScrW()+100, ScrH()+100 )
		image_check2:SetImage( "entourage_checkedslot.png" )

	image_check3 = vgui.Create( "DImage", equipframe)
		image_check3:SetSize( 100, 100 )
		image_check3:SetPos( ScrW()+100, ScrH()+100 )
		image_check3:SetImage( "entourage_checkedslot.png" )
	---------------------------
	-- This creates stat upgrade buttons.
	overview_cross_mgt = vgui.Create( "DImageButton", mainframe )
		overview_cross_mgt:SetImage( "menu/entourage_cross.png" )
		overview_cross_mgt:SetSize( 35, 35 )
		overview_cross_mgt:SetPos( 580, 255 ) 
		overview_cross_mgt.DoClick = function()
			playerstats_a["MGT"] = playerstats_a["MGT"] + 1

			-- Increase health and max health by 1 :)
			playerstats_a["HP1"] = playerstats_a["HP1"] + 1
			playerstats_a["HP2"] = playerstats_a["HP2"] + 1

			playerstats_a["LVL_POINTS"] = playerstats_a["LVL_POINTS"] - 1

			if playerstats_a["MGT"] % 2 == 0 then
				playerstats_a["SLASH_POINTS"] = playerstats_a["SLASH_POINTS"] + 1
			end
			if playerstats_a["MGT"] % 3 == 0 then
				playerstats_a["BLUNT_POINTS"] = playerstats_a["BLUNT_POINTS"] + 1
			end

			madechanges = true
			CrossCheck1()
		end
	overview_cross_dfe = vgui.Create( "DImageButton", mainframe )
		overview_cross_dfe:SetImage( "menu/entourage_cross.png" )
		overview_cross_dfe:SetSize( 35, 35 )
		overview_cross_dfe:SetPos( 580, 310 )
		overview_cross_dfe.DoClick = function()
			playerstats_a["VIT"] = playerstats_a["VIT"] + 1
			playerstats_a["LVL_POINTS"] = playerstats_a["LVL_POINTS"] - 1

			playerstats_a["HP1"] = playerstats_a["HP1"] + 5
			playerstats_a["HP2"] = playerstats_a["HP2"] + 5
			playerstats_a["DEF"] = playerstats_a["DEF"] + 2

			if playerstats_a["VIT"] % 2 == 0 then
				playerstats_a["BLUNT_POINTS"] = playerstats_a["BLUNT_POINTS"] + 1
			end

			madechanges = true
			CrossCheck1()
		end
	overview_cross_cle = vgui.Create( "DImageButton", mainframe )
		overview_cross_cle:SetImage( "menu/entourage_cross.png" )
		overview_cross_cle:SetSize( 35, 35 )
		overview_cross_cle:SetPos( 580, 365 )
		overview_cross_cle.DoClick = function()
			playerstats_a["AGI"] = playerstats_a["AGI"] + 1
			playerstats_a["LVL_POINTS"] = playerstats_a["LVL_POINTS"] - 1

			if playerstats_a["AGI"] % 2 == 0 then
				playerstats_a["PIERCE_POINTS"] = playerstats_a["PIERCE_POINTS"] + 1
			end

			madechanges = true
			CrossCheck1()
		end
	overview_cross_sdl = vgui.Create( "DImageButton", mainframe )
		overview_cross_sdl:SetImage( "menu/entourage_cross.png" )
		overview_cross_sdl:SetSize( 35, 35 )
		overview_cross_sdl:SetPos( 580, 420 )
		overview_cross_sdl.DoClick = function()
			playerstats_a["SDL"] = playerstats_a["SDL"] + 1
			playerstats_a["LVL_POINTS"] = playerstats_a["LVL_POINTS"] - 1

			playerstats_a["DEF"] = playerstats_a["DEF"] + 1
			playerstats_a["DFX"] = playerstats_a["DFX"] + 3

			if playerstats_a["SDL"] % 3 == 0 then
				playerstats_a["SLASH_POINTS"] = playerstats_a["SLASH_POINTS"] + 1
				playerstats_a["BLUNT_POINTS"] = playerstats_a["BLUNT_POINTS"] + 1
				playerstats_a["PIERCE_POINTS"] = playerstats_a["PIERCE_POINTS"] + 1
			end

			madechanges = true
			CrossCheck1()
		end
	overview_cross_fcs = vgui.Create( "DImageButton", mainframe )
		overview_cross_fcs:SetImage( "menu/entourage_cross.png" )
		overview_cross_fcs:SetSize( 35, 35 )
		overview_cross_fcs:SetPos( 580, 475 )
		overview_cross_fcs.DoClick = function()
			playerstats_a["FCS"] = playerstats_a["FCS"] + 1
			playerstats_a["LVL_POINTS"] = playerstats_a["LVL_POINTS"] - 1

			if playerstats_a["FCS"] % 3 == 0 then
				playerstats_a["SLASH_POINTS"] = playerstats_a["SLASH_POINTS"] + 1
				playerstats_a["PIERCE_POINTS"] = playerstats_a["PIERCE_POINTS"] + 1
			end

			madechanges = true
			CrossCheck1()
		end
	overview_save = vgui.Create( "DImageButton", mainframe )
		overview_save:SetImage( "menu/entourage_save.png" )
		overview_save:SetSize( 35, 35 )
		overview_save:SetPos( mainframe:GetWide() - 45, mainframe:GetTall() - 45 )
		overview_save.DoClick = function()
			playerstats = table.Copy( playerstats_a )

			net.Start( "maxhealth" )
				net.WriteDouble( playerstats["HP1"] )
				net.WriteDouble( playerstats["HP2"] )
			net.SendToServer()
			
			madechanges = false
		end
	overview_revert = vgui.Create( "DImageButton", mainframe )
		overview_revert:SetImage( "menu/entourage_revert.png" )
		overview_revert:SetSize( 35, 35 )
		overview_revert:SetPos( mainframe:GetWide() - 45, mainframe:GetTall() - 95 )
		overview_revert.DoClick = function()
			playerstats_a = table.Copy( playerstats )
			madechanges = false
			CrossCheck1()
		end
	CrossCheck1()
	function equipframe:Think()
		if madechanges then
			overview_save:Show()
			overview_revert:Show()
		else
			overview_save:Hide()
			overview_revert:Hide()
		end
	end

end)