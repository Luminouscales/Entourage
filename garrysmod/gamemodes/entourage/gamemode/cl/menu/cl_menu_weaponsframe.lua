-- Functions - can be left outside of Init hooks.
function rt_weapon()
    if IsValid( rt_weapontext ) then -- if exists (button pressed)
        rt_weapontext:Remove()
    end
    rt_weapontext = vgui.Create( "RichText", weapons_frame )
        rt_weapontext:SetSize( 680, 300 )
        rt_weapontext:SetPos( 900, 70 )
        rt_weapontext:SetVerticalScrollbarEnabled( false )
        rt_weapontext:InsertColorChange( 255, 255, 255, 255 )
        rt_weapontext:AppendText( menuwep .."\n" )
        rt_weapontext:AppendText( '"'.. menuwep2 ..'"\n' )
        rt_weapontext:AppendText( menuwep3 .."\n" )
        rt_weapontext:AppendText( menuwep5 .."\n" )
        rt_weapontext:AppendText( menuwep4 .."\n" )
    function rt_weapontext:PerformLayout()
        self:SetFontInternal( "equipment_plname2" )
    end
    --wpmodel:Show()
end

function rt_armour()
    if IsValid( rt_armourtext ) then -- if exists (button pressed)
        rt_armourtext:Remove()
    end
    rt_armourtext = vgui.Create( "RichText", weapons_frame )
        rt_armourtext:SetSize( 680, 300 )
        rt_armourtext:SetPos( 900, 455 )
        rt_armourtext:SetVerticalScrollbarEnabled( false )
        rt_armourtext:InsertColorChange( 255, 255, 255, 255 )
        rt_armourtext:AppendText( menuarm .."\n" )
        rt_armourtext:AppendText( '"'.. menuarm2 ..'"\n' )
        rt_armourtext:AppendText( menuarm3 .." Defence\n" )
        rt_armourtext:AppendText( menuarm4 .." Flex Defence\n" )
        rt_armourtext:AppendText( menuarm5 .."\n" )
    function rt_armourtext:PerformLayout()
        self:SetFontInternal( "equipment_plname2" )
    end
    --wpmodel:Show()
end

-- INIT
hook.Add( "InitPostEntity", "weaponsframeinit", function()
    -- Weapons (and armour) frame.
    weapons_frame = vgui.Create( "DFrame", equipframe )
        weapons_frame:MakePopup()
        weapons_frame:SetSize( 1600, 800 )
        weapons_frame:Center()
        weapons_frame:SetDraggable( false )
        weapons_frame:ShowCloseButton( false )
        weapons_frame:SetTitle( "" ) 
        weapons_frame:SetPaintShadow( true )
        weapons_frame.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
            draw.RoundedBoxEx( 0, 225, 25, 3, h, color_black, false, false, false, false)
			draw.RoundedBoxEx( 0, 225, weapons_frame:GetTall()/2 + 16, w - 225, 3, color_black, false, false, false, false)
            draw.SimpleText( "Equipment", "equipment_plname4", w/2, 10, color_white, a, a )
        end
    --------------------
    -- Model displayer. Needs tweaking.
    -- wpmodel = vgui.Create( "DAdjustableModelPanel", weapons_frame )
    --     wpmodel:SetSize( 725, 305 )
    --     wpmodel:SetPos( 875, 455 )
    --     wpmodel:SetAmbientLight( Color( 255, 255, 255, 255 ) )
    --     wpmodel:SetModel( "models/rustyknife/rustyknife.mdl" )
    --------------------
    -- Exit buttons. Should be changed.
    local wf_ovbutton = vgui.Create( "DImageButton", weapons_frame )
		wf_ovbutton:SetSize( 200, 35 )
		wf_ovbutton:SetPos( 0, weapons_frame:GetTall()/2 )
		wf_ovbutton:SetImage( "hud/entourage_overview.png" )
		wf_ovbutton.Paint = function( self, w, h )
			draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, false, true, false, true)
		end
			wf_ovbutton.DoClick = function()
			mainframe:ToggleVisible()
			weapons_frame:ToggleVisible()
			image_check1:SetPos( ScrW()+100, ScrH()+100 )
			image_check2:SetPos( ScrW()+100, ScrH()+100 )
			CrossCheck1()
		end

    -- local st_ovbutton = vgui.Create( "DImageButton", stats_frame )
	-- 	st_ovbutton:SetSize( 200, 35 )
	-- 	st_ovbutton:SetPos( 0, stats_frame:GetTall()/2 )
	-- 	st_ovbutton:SetImage( "hud/entourage_overview.png" )
	-- 	st_ovbutton.Paint = function( self, w, h )
	-- 		draw.RoundedBoxEx( 8, 0, 0, w, h, plcol, false, true, false, true)
	-- 	end
	-- 		st_ovbutton.DoClick = function()
	-- 		mainframe:ToggleVisible()
	-- 		stats_frame:ToggleVisible()
	-- 	end
    --------------------
    -- Here comes the big one.
    for k, v in pairs( plweapons ) do -- my dearest creation
		local weaponbutton = vgui.Create( "DImageButton", weapons_frame ) 
			weaponbutton:SetImage( weaponlist[ v["Item"] ].Icon )
			weaponbutton:SetSize( 100, 100 )
			weaponbutton.DoClick = function( self ) -- set weapon and stats
				menuwep = weaponlist[ v["Item"] ].Name
				menuwep2 = weaponlist[ v["Item"] ].Desc
				menuwep4 = weaponlist[ v["Item"] ].Desc2
				menuwep5 = weaponlist[ v["Item"] ].Desc3
				if weaponlist[ v["Item"] ].dmgtype == "Slash" then
					menuwep3 = weaponlist[ v["Item"] ].DMG1.. "-".. weaponlist[ v["Item"] ].DMG2 .." Slash damage"
				elseif weaponlist[ v["Item"] ].dmgtype == "Pierce" then
					menuwep3 = weaponlist[ v["Item"] ].DMG3 .." Pierce damage"
				elseif weaponlist[ v["Item"] ].dmgtype == "Blunt" then
					menuwep3 = weaponlist[ v["Item"] ].DMG4.. "-".. weaponlist[ v["Item"] ].DMG5 .." Blunt damage"
				else
					menuwep3 = weaponlist[ v["Item"] ].DMG1.. "-".. weaponlist[ v["Item"] ].DMG2 .." Slash damage, ".. weaponlist[ v["Item"] ].DMG3 .." Pierce damage, ".. weaponlist[ v["Item"] ].DMG4.. "-".. weaponlist[ v["Item"] ].DMG5 .." Blunt damage"
				end
				image_check1:SetParent( weapons_frame )
				image_check1:SetPos( self:GetPos() )

				
				playerstats_a["DEF"] = playerstats_a["DEF"] + weaponlist[ v["Item"] ].PDEF - weaponlist[ playerstats_a["currentweapon"] ].PDEF -- defence
				playerstats["DEF"] = playerstats["DEF"] + weaponlist[ v["Item"] ].PDEF - weaponlist[ playerstats["currentweapon"] ].PDEF -- defence
					--playerstats["arov_def2"] = weaponlist[ v["Item"] ].PDEF
				playerstats_a["SDL"] = playerstats_a["SDL"] + weaponlist[ v["Item"] ].PSDL - weaponlist[ playerstats_a["currentweapon"] ].PSDL -- sidle
				playerstats["SDL"] = playerstats["SDL"] + weaponlist[ v["Item"] ].PSDL - weaponlist[ playerstats["currentweapon"] ].PSDL -- sidle
					--playerstats["arov_sdl2"] = weaponlist[ v["Item"] ].PSDL
				playerstats_a["AGI"] = playerstats_a["AGI"] + weaponlist[ v["Item"] ].PAGI - weaponlist[ playerstats_a["currentweapon"] ].PAGI
				playerstats["AGI"] = playerstats["AGI"] + weaponlist[ v["Item"] ].PAGI - weaponlist[ playerstats["currentweapon"] ].PAGI
					--playerstats["arov_pagi2"] = weaponlist[ v["Item"] ].PAGI
				
				playerstats_a["currentweapon"] = v["Item"]
				playerstats["currentweapon"] = v["Item"]

				--PlayerstatsSave()
				rt_weapon()
			end

			weaponbutton.DoRightClick = function( self ) -- set weapon preview
				menuwep = weaponlist[ v["Item"] ].Name
				menuwep2 = weaponlist[ v["Item"] ].Desc
				menuwep4 = weaponlist[ v["Item"] ].Desc2
				menuwep5 = weaponlist[ v["Item"] ].Desc3
				if weaponlist[ v["Item"] ].dmgtype == "Slash" then
					menuwep3 = weaponlist[ v["Item"] ].DMG1.. "-".. weaponlist[ v["Item"] ].DMG2.. " Slash damage"
				elseif weaponlist[ v["Item"] ].dmgtype == "Pierce" then
					menuwep3 = weaponlist[ v["Item"] ].DMG3 .." Pierce damage"
				elseif weaponlist[ v["Item"] ].dmgtype == "Blunt" then
					menuwep3 = weaponlist[ v["Item"] ].DMG4.. "-".. weaponlist[ v["Item"] ].DMG5.. " Blunt damage"
				else
					menuwep3 = weaponlist[ v["Item"] ].DMG1.. "-".. weaponlist[ v["Item"] ].DMG2.. " Slash damage, ".. weaponlist[ v["Item"] ].DMG3 .." Pierce damage, ".. weaponlist[ v["Item"] ].DMG4.. "-".. weaponlist[ v["Item"] ].DMG5 .." Blunt damage"
				end
			end
			if k < 7 then
				weaponbutton:SetPos( ( k * 100 - 100 + k * 5 - 5 ) + 250, 65 )
			elseif k < 13 then
				weaponbutton:SetPos( ( k * 100 - 700 + k * 5 - 35 ) + 250, 170 )
			else 
				weaponbutton:SetPos( ( k * 100 - 1300 + k * 5 - 65 ) + 250, 275 ) 
			end

	for k, v in pairs( plarmours ) do
		local armourbutton = vgui.Create( "DImageButton", weapons_frame )
			armourbutton:SetImage( weaponlist[ v["Item"] ].Icon )
			armourbutton:SetSize( 100, 100 )
			armourbutton.DoClick = function( self )
				menuarm = weaponlist[ v["Item"] ].Name
				menuarm2 = weaponlist[ v["Item"] ].Desc
				menuarm3 = weaponlist[ v["Item"] ].PDEF
				menuarm4 = weaponlist[ v["Item"] ].PDFX
				menuarm5 = weaponlist[ v["Item"] ].Desc2

				image_check2:SetParent( weapons_frame )
				image_check2:SetPos( self:GetPos() )
				
				playerstats_a["DEF"] = playerstats_a["DEF"] + weaponlist[ v["Item"] ].PDEF - weaponlist[ playerstats_a["currentarmour"] ].PDEF -- what else do I do and not spam?
				playerstats["DEF"] = playerstats["DEF"] + weaponlist[ v["Item"] ].PDEF - weaponlist[ playerstats["currentarmour"] ].PDEF
				--playerstats["arov_def"] = weaponlist[ v["Item"] ].PDEF
				playerstats_a["DFX"] = playerstats_a["DFX"] + weaponlist[ v["Item"] ].PDFX - weaponlist[ playerstats_a["currentarmour"] ].PDFX
				playerstats["DFX"] = playerstats["DFX"] + weaponlist[ v["Item"] ].PDFX - weaponlist[ playerstats["currentarmour"] ].PDFX
				--playerstats["arov_dfx"] = weaponlist[ v["Item"] ].PDFX
				playerstats_a["DDG"] = playerstats_a["DDG"] + weaponlist[ v["Item"] ].PDG - weaponlist[ playerstats_a["currentarmour"] ].PDG
				playerstats["DDG"] = playerstats["DDG"] + weaponlist[ v["Item"] ].PDG - weaponlist[ playerstats["currentarmour"] ].PDG
				--playerstats["arov_ddg"] = weaponlist[ v["Item"] ].PDG
				playerstats_a["AGI"] = playerstats_a["AGI"] + weaponlist[ v["Item"] ].PAGI - weaponlist[ playerstats_a["currentarmour"] ].PAGI
				playerstats["AGI"] = playerstats["AGI"] + weaponlist[ v["Item"] ].PAGI - weaponlist[ playerstats["currentarmour"] ].PAGI
				--playerstats["arov_pagi"] = weaponlist[ v["Item"] ].PAGI

				playerstats_a["currentarmour"] = v["Item"]
				playerstats["currentarmour"] = v["Item"]

				--PlayerstatsSave()
				rt_armour()
			end
			armourbutton.DoRightClick = function( self )
				menuarm = weaponlist[ v["Item"] ].Name
				menuarm2 = weaponlist[ v["Item"] ].Desc
				menuarm3 = weaponlist[ v["Item"] ].PDEF
				menuarm4 = weaponlist[ v["Item"] ].PDFX
				menuarm5 = weaponlist[ v["Item"] ].Desc2
			end
			if k < 7 then
				armourbutton:SetPos( ( k * 100 - 100 + k * 5 - 5 ) + 250, 455 )
			elseif k < 13 then
				armourbutton:SetPos( ( k * 100 - 700 + k * 5 - 35 ) + 250, 560 )
			else 
				armourbutton:SetPos( ( k * 100 - 1300 + k * 5 - 65 ) + 250, 665 ) 
			end
	end
	end
    --------------------
    -- Epilogue
    weapons_frame:SetDeleteOnClose( false )
    weapons_frame:Close()
    --------------------

end)