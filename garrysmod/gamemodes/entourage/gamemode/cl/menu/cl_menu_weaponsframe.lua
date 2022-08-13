-- Functions - can be left outside of Init hooks.
function rt_weapon()
    if IsValid( rt_weapontext ) then -- if exists (button pressed)
        rt_weapontext:Remove()
    end
    rt_weapontext = vgui.Create( "RichText", weapongrid )
        rt_weapontext:SetSize( 680, 300 )
        rt_weapontext:SetPos( 0, 330 )
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
end

function rt_armour()
    if IsValid( rt_armourtext ) then -- if exists (button pressed)
        rt_armourtext:Remove()
    end
    rt_armourtext = vgui.Create( "RichText", armourgrid )
        rt_armourtext:SetSize( 680, 300 )
        rt_armourtext:SetPos( 0, 330 )
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
end

function rt_trinket()
    if IsValid( rt_trinkettext ) then -- if exists (button pressed)
        rt_trinkettext:Remove()
    end
    rt_trinkettext = vgui.Create( "RichText", trinketgrid )
        rt_trinkettext:SetSize( 680, 300 )
        rt_trinkettext:SetPos( 0, 330 )
        rt_trinkettext:SetVerticalScrollbarEnabled( false )
        rt_trinkettext:InsertColorChange( 255, 255, 255, 255 )
        rt_trinkettext:AppendText( menutr .."\n" )
        rt_trinkettext:AppendText( menutr2 .."\n" )
        rt_trinkettext:AppendText( menutr3 )

    function rt_trinkettext:PerformLayout()
        self:SetFontInternal( "equipment_plname2" )
    end
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
        weapons_frame.Paint = function( self, w, h )
            draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
            draw.RoundedBoxEx( 0, 225, 25, 3, h, color_black, false, false, false, false)
			--draw.RoundedBoxEx( 0, 225, weapons_frame:GetTall()/2 + 16, w - 225, 3, color_black, false, false, false, false)
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
			CrossCheck1()
		end

	-- seperate frame for weapon and armour buttons because i need them
		weapongrid = vgui.Create( "DFrame", weapons_frame )
			weapongrid:SetSize( 630, 700 )
			weapongrid:SetPos( 250, 65 )
			weapongrid:SetDraggable( false )
			weapongrid:ShowCloseButton( false )
			weapongrid:SetTitle("")
			weapongrid.Paint = function()
			end
		image_check1 = vgui.Create( "DImage", weapongrid)
				image_check1:SetSize( 100, 100 )
				image_check1:SetImage( "entourage_checkedslot.png" )
				image_check1:SetPos( 0, 0)

		armourgrid = vgui.Create( "DFrame", weapons_frame )
			armourgrid:SetSize( 630, 700 )
			armourgrid:SetPos( 250, 65 )
			armourgrid:SetDraggable( false )
			armourgrid:ShowCloseButton( false )
			armourgrid:SetTitle("")
			armourgrid.Paint = function()
			end
		local image_check2 = vgui.Create( "DImage", armourgrid)
			image_check2:SetSize( 100, 100 )
			image_check2:SetImage( "entourage_checkedslot.png" )

		trinketgrid = vgui.Create( "DFrame", weapons_frame )
			trinketgrid:SetSize( 630, 700 )
			trinketgrid:SetPos( 250, 65 )
			trinketgrid:SetDraggable( false )
			trinketgrid:ShowCloseButton( false )
			trinketgrid:SetTitle("")
			trinketgrid.Paint = function()
			end
		local image_check3 = vgui.Create( "DImage", trinketgrid )
			image_check3:SetSize( 100, 100 )
			image_check3:SetImage( "entourage_checkedslot.png" )
	-- grid buttons
		local trinketgridbutton = vgui.Create( "DImageButton", weapons_frame )
			trinketgridbutton:SetSize( 30, 30 )
			trinketgridbutton:SetPos( 1560, 760 )
			trinketgridbutton:SetImage( "hud/entourage_trinket.png" )
			trinketgridbutton.DoClick = function()
				weapongrid:Hide()
				armourgrid:Hide()
				trinketgrid:Show()
					RefreshTrinketGrid()
			end
		local armourgridbutton = vgui.Create( "DImageButton", weapons_frame )
			armourgridbutton:SetSize( 30, 30 )
			armourgridbutton:SetPos( 1520, 760 )
			armourgridbutton:SetImage( "hud/entourage_armouricon.png" )
			armourgridbutton.DoClick = function()
				weapongrid:Hide()
				armourgrid:Show()
					RefreshArmourGrid()
				trinketgrid:Hide()
			end
		local weapongridbutton = vgui.Create( "DImageButton", weapons_frame )
			weapongridbutton:SetSize( 30, 30 )
			weapongridbutton:SetPos( 1480, 760 )
			weapongridbutton:SetImage( "hud/entourage_wpicon.png" )
			weapongridbutton.DoClick = function()
				weapongrid:Show()
					RefreshWeaponGrid()
				armourgrid:Hide()
				trinketgrid:Hide()
			end

  
    --------------------
    -- Here comes the big one.
	function RefreshWeaponGrid()

		for _, v in ipairs( weapongrid:GetChildren() ) do -- Delete existing weapon buttons
			if v:GetName() == "DImageButton" then
				v:Remove()
			end
		end

		for k, v in pairs( plweapons ) do -- my dearest creation
			local weaponbutton = vgui.Create( "DImageButton", weapongrid ) 
				weaponbutton:SetImage( items_table[ v["Item"] ].Icon )
				weaponbutton:SetSize( 100, 100 )
				weaponbutton.DoClick = function( self ) -- set weapon and stats
					menuwep = items_table[ v["Item"] ].Name
					menuwep2 = items_table[ v["Item"] ].Desc
					menuwep4 = items_table[ v["Item"] ].Desc2
					menuwep5 = items_table[ v["Item"] ].Desc3
					if items_table[ v["Item"] ].dmgtype == "Slash" then
						menuwep3 = items_table[ v["Item"] ].DMG1.. "-".. items_table[ v["Item"] ].DMG2 .." Slash damage"
					elseif items_table[ v["Item"] ].dmgtype == "Pierce" then
						menuwep3 = items_table[ v["Item"] ].DMG3 .." Pierce damage"
					elseif items_table[ v["Item"] ].dmgtype == "Blunt" then
						menuwep3 = items_table[ v["Item"] ].DMG4.. "-".. items_table[ v["Item"] ].DMG5 .." Blunt damage"
					else
						menuwep3 = items_table[ v["Item"] ].DMG1.. "-".. items_table[ v["Item"] ].DMG2 .." Slash damage, ".. items_table[ v["Item"] ].DMG3 .." Pierce damage, ".. items_table[ v["Item"] ].DMG4.. "-".. items_table[ v["Item"] ].DMG5 .." Blunt damage"
					end

					-- Yes these two need to run every time. I don't care to put in the effort
					image_check1:SetParent( weapons_frame)
					image_check1:SetParent( weapongrid)
					image_check1:SetPos( self:GetPos() )

					-- Disable the innate effect of previous weapon
					if items_table[ playerstats_a["currentweapon"] ].early == 1 then
						net.Start( "weapon_effect" )
							net.WriteString( playerstats_a["currentweapon"] )
							net.WriteBool( false )
						net.SendToServer()
					end
					
					playerstats_a["DEF"] = playerstats_a["DEF"] + items_table[ v["Item"] ].PDEF - items_table[ playerstats_a["currentweapon"] ].PDEF
					playerstats["DEF"] = playerstats_a["DEF"]

					playerstats_a["SDL"] = playerstats_a["SDL"] + items_table[ v["Item"] ].PSDL - items_table[ playerstats_a["currentweapon"] ].PSDL
					playerstats["SDL"] = playerstats_a["SDL"]

					playerstats_a["AGI"] = playerstats_a["AGI"] + items_table[ v["Item"] ].PAGI - items_table[ playerstats_a["currentweapon"] ].PAGI
					playerstats["AGI"] = playerstats_a["AGI"]
					
					playerstats_a["currentweapon"] = v["Item"]
					playerstats["currentweapon"] = v["Item"]

					rt_weapon()

					if items_table[ playerstats_a["currentweapon"] ].early == 1 then
						net.Start( "weapon_effect" )
							net.WriteString( playerstats_a["currentweapon"] )
							net.WriteBool( true )
						net.SendToServer()
					end
				end

				weaponbutton.DoRightClick = function( self ) -- set weapon preview
					menuwep = items_table[ v["Item"] ].Name
					menuwep2 = items_table[ v["Item"] ].Desc
					menuwep4 = items_table[ v["Item"] ].Desc2
					menuwep5 = items_table[ v["Item"] ].Desc3
					if items_table[ v["Item"] ].dmgtype == "Slash" then
						menuwep3 = items_table[ v["Item"] ].DMG1.. "-".. items_table[ v["Item"] ].DMG2.. " Slash damage"
					elseif items_table[ v["Item"] ].dmgtype == "Pierce" then
						menuwep3 = items_table[ v["Item"] ].DMG3 .." Pierce damage"
					elseif items_table[ v["Item"] ].dmgtype == "Blunt" then
						menuwep3 = items_table[ v["Item"] ].DMG4.. "-".. items_table[ v["Item"] ].DMG5.. " Blunt damage"
					else
						menuwep3 = items_table[ v["Item"] ].DMG1.. "-".. items_table[ v["Item"] ].DMG2.. " Slash damage, ".. items_table[ v["Item"] ].DMG3 .." Pierce damage, ".. items_table[ v["Item"] ].DMG4.. "-".. items_table[ v["Item"] ].DMG5 .." Blunt damage"
					end
				end

				if k < 7 then
					weaponbutton:SetPos( ( k * 100 - 100 + k * 5 - 5 ), 0 )
				elseif k < 13 then
					weaponbutton:SetPos( ( k * 100 - 700 + k * 5 - 35 ), 105 )
				else 
					weaponbutton:SetPos( ( k * 100 - 1300 + k * 5 - 65 ), 210 ) 
				end
		end
	end

	function RefreshArmourGrid()
		for _, v in ipairs( weapongrid:GetChildren() ) do
			if v:GetName() == "DImageButton" then
				v:Remove()
			end
		end
		for k, v in pairs( plarmours ) do
			local armourbutton = vgui.Create( "DImageButton", armourgrid )
				armourbutton:SetImage( items_table[ v["Item"] ].Icon )
				armourbutton:SetSize( 100, 100 )
				armourbutton.DoClick = function( self )
					menuarm = items_table[ v["Item"] ].Name
					menuarm2 = items_table[ v["Item"] ].Desc
					menuarm3 = items_table[ v["Item"] ].PDEF
					menuarm4 = items_table[ v["Item"] ].PDFX
					menuarm5 = items_table[ v["Item"] ].Desc2

					image_check2:SetParent( weapons_frame)
					image_check2:SetParent( armourgrid )
					image_check2:SetPos( self:GetPos() )
					
					playerstats_a["DEF"] = playerstats_a["DEF"] + items_table[ v["Item"] ].PDEF - items_table[ playerstats_a["currentarmour"] ].PDEF -- what else do I do and not spam?
					playerstats["DEF"] = playerstats_a["DEF"]

					playerstats_a["DFX"] = playerstats_a["DFX"] + items_table[ v["Item"] ].PDFX - items_table[ playerstats_a["currentarmour"] ].PDFX
					playerstats["DFX"] = playerstats_a["DFX"]

					playerstats_a["DDG"] = playerstats_a["DDG"] + items_table[ v["Item"] ].PDG - items_table[ playerstats_a["currentarmour"] ].PDG
					playerstats["DDG"] = playerstats_a["DDG"]

					playerstats_a["AGI"] = playerstats_a["AGI"] + items_table[ v["Item"] ].PAGI - items_table[ playerstats_a["currentarmour"] ].PAGI
					playerstats["AGI"] = playerstats_a["AGI"]

					playerstats_a["currentarmour"] = v["Item"]
					playerstats["currentarmour"] = v["Item"]

					rt_armour()
				end
				armourbutton.DoRightClick = function( self )
					menuarm = items_table[ v["Item"] ].Name
					menuarm2 = items_table[ v["Item"] ].Desc
					menuarm3 = items_table[ v["Item"] ].PDEF
					menuarm4 = items_table[ v["Item"] ].PDFX
					menuarm5 = items_table[ v["Item"] ].Desc2
				end
				if k < 7 then
					armourbutton:SetPos( ( k * 100 - 100 + k * 5 - 5 ), 0 )
				elseif k < 13 then
					armourbutton:SetPos( ( k * 100 - 700 + k * 5 - 35 ), 105 )
				else 
					armourbutton:SetPos( ( k * 100 - 1300 + k * 5 - 65 ), 210 ) 
				end
		end
	end
	
	function RefreshTrinketGrid()
		for _, v in ipairs( weapongrid:GetChildren() ) do
			if v:GetName() == "DImageButton" then
				v:Remove()
			end
		end
		for k, v in pairs( pltrinkets ) do
			local trinketbutton = vgui.Create( "DImageButton", trinketgrid )
				trinketbutton:SetImage( items_table[ v["Item"] ].Icon )
				trinketbutton:SetSize( 100, 100 )
				trinketbutton.DoClick = function( self )
					RunString( "eph_".. playerstats[ "currenttrinket" ] .."(false)" )
					
					playerstats_a["currenttrinket"] = v["Item"]
					playerstats["currenttrinket"] = v["Item"]

					RunString( "eph_".. playerstats[ "currenttrinket" ] .."(true)" )

					menutr = items_table[ v["Item"] ].Name
					menutr2 = items_table[ v["Item"] ].Desc
					menutr3 = items_table[ v["Item"] ].Desc2

					image_check3:SetParent( weapons_frame )
					image_check3:SetParent( trinketgrid )
					image_check3:SetPos( self:GetPos() )

					rt_trinket()
				end
				trinketbutton.DoRightClick = function( self )
					menutr = items_table[ v["Item"] ].Name
					menutr2 = items_table[ v["Item"] ].Desc
					menutr3 = items_table[ v["Item"] ].Desc2
				end
				if k < 7 then
					trinketbutton:SetPos( ( k * 100 - 100 + k * 5 - 5 ), 0 )
				elseif k < 13 then
					trinketbutton:SetPos( ( k * 100 - 700 + k * 5 - 35 ), 105 )
				else 
					trinketbutton:SetPos( ( k * 100 - 1300 + k * 5 - 65 ), 210 ) 
				end
		end
	end
    --------------------
    -- Epilogue
    weapons_frame:SetDeleteOnClose( false )
    weapons_frame:Hide()
	armourgrid:Hide()
	trinketgrid:Hide()
    --------------------

end)