exp_real = 0
just_leveledup = false
up_int2 = 0
hp_int2 = 0
skillnote_show = false
tosia = "no"
choices = 0 


net.Receive( "up_hudshow", function()
    -- I'm going to kiss myself on the lips.
    up_int2 = up_int2 + 1
    local up_int = up_int2
    local up_start = SysTime()
    local up_value = net.ReadInt( 32 )
    -- If value negative
    if up_value < 0 then
        hook.Add( "HUDPaint", "up_hudshow_hook".. up_int, function() 
            draw.SimpleTextOutlined("-".. up_value, "equipment_plname2", 280, Lerp( ( SysTime() - up_start ) * 0.5, ScrH() + 10, ScrH() - 300 ), Color( 255, 65, 65, Lerp( ( SysTime() - up_start ) * 0.5, 500, 0 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, Lerp( ( SysTime() - up_start ) * 0.5, 500, 0 ) ) )
        end)
    -- If value positive 
    elseif up_value > 0 then 
        hook.Add( "HUDPaint", "up_hudshow_hook".. up_int, function() 
            draw.SimpleTextOutlined("+".. up_value, "equipment_plname2", 280, Lerp( ( SysTime() - up_start ) * 0.5, ScrH() + 10, ScrH() - 300 ), Color( 120, 255, 65, Lerp( ( SysTime() - up_start ) * 0.5, 500, 0 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, Lerp( ( SysTime() - up_start ) * 0.5, 500, 0 ) ) )
        end)
    -- Don't run if you're somehow trying to add 0 UP.
    end
    timer.Simple( 3, function()
        hook.Remove( "HUDPaint", "up_hudshow_hook".. up_int )
    end)
end)

net.Receive( "DISPLAY_PAIN", function()
    local hitent = net.ReadEntity()
    local hitint = net.ReadInt( 32 )
    local isheal = net.ReadBool()

    local hp_start = SysTime()
    hp_int2 = hp_int2 + 1
    local hp_int = hp_int2

    --local brave_ness = 255

    if isheal then
        hook.Add( "HUDPaint", "hp_hudshow_hook".. hp_int, function() 
            local hitent_pos = hitent:GetPos():ToScreen()
            draw.SimpleTextOutlined( hitint, "equipment_plname4", hitent_pos.x, hitent_pos.y, Color( 120, 255, 65, Lerp( ( SysTime() - hp_start ) * 0.4, 255, 0 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, Lerp( ( SysTime() - hp_start ) * 0.4, 255, 0 ) ) )
        end)
    else
        hook.Add( "HUDPaint", "hp_hudshow_hook".. hp_int, function() 
            if IsValid( hitent ) then
                local hitent_pos = hitent:GetPos():ToScreen()
                draw.SimpleTextOutlined( hitint, "equipment_plname4", hitent_pos.x, hitent_pos.y, Color( 255, 65, 65, Lerp( ( SysTime() - hp_start ) * 0.4, 255, 0 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, Lerp( ( SysTime() - hp_start ) * 0.4, 255, 0 ) ) )
            end
        end)
    end
    timer.Simple( 3, function()
        hook.Remove( "HUDPaint", "hp_hudshow_hook".. hp_int )
    end)
end)

-- Music function
function test()
    sound.PlayFile( "sound/cer2.mp3", "noblock noplay mono", function( a, b, c )
        a:EnableLooping( true )
        a:SetVolume( 2 )
        a:Play()
        channel = a
        -- garbage collection? who the fuck coded this?
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

net.Receive( "enemysend", function()
	enemy1 = net.ReadEntity()
	enemy2 = net.ReadEntity()
	enemy3 = net.ReadEntity()
end)

net.Receive( "encounter_intro", function()

    SendStats()

    local difficulty = net.ReadInt( 32 )
    local delay = net.ReadInt( 32 )

	surface.PlaySound( "shink.wav" )
	surface.PlaySound( "shink.wav" )

	timer.Simple( 1, function() -- visual
        if difficulty == 1 then
            difficulty_text = "Encounter!"
        else 
            difficulty_text = "Boss Encounter!"
        end

		EncounterNormalText1()
        -- This has to be fixed once I add weapons with only 2 damage types.
        if weaponlist[ playerstats_a["currentweapon"] ].dmgtype == "Multiple" then
            pltype = table.Random( {"Slash", "Blunt", "Pierce"} )
            DefineDMGA()
        end
	end)

	hook.Remove("HUDPaint", "dangerbar") -- visual
	pleqic:ToggleVisible()
	equipframe:Close()

	net.Start("getmycordsyoufuckingcunt")
		net.WriteVector( LocalPlayer():GetPos() ) 
		net.WriteAngle( LocalPlayer():GetAngles() )
		net.WriteDouble( playerstats_a["HP1"] )
	net.SendToServer()

	timer.Simple( 4 + delay, function()
		BattleHud()
	end)
end)

net.Receive( "descmodel_cl2", function()
	finalentity = net.ReadEntity()
end)

net.Receive( "net_enemy_senddata", function()
    local lvl_int = net.ReadInt( 32 )
    local exp_int = net.ReadInt( 32 )
    exp_real = exp_real + math.Clamp( math.Round( exp_int + ( exp_int * ( math.Clamp( lvl_int - playerstats_a["LVL3"], -15, 15 ) ) / 3 ), 0 ), 0, 100000 )
end)

-- This is the frame for results after battle.
function ResultsFrame()
    local results_frame = vgui.Create( "DFrame" )
        results_frame:SetSize( 600, 800 )
        results_frame:Center()
        results_frame:SetDraggable( false )
        results_frame:SetTitle( "" )
        results_frame:ShowCloseButton( false )
        results_frame.Paint = function( self, w, h )
            draw.RoundedBox( 8, 0, 0, w, h, Color( 110, 110, 115, 240 ) )
            draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false )
            draw.SimpleText( "Results!", "equipment_plname4", w/2, 10, color_white, a, a )
        end
        local closebutton = vgui.Create( "DImageButton", results_frame )
		closebutton:SetImage( "icon16/cross.png" )
		closebutton:SetSize( 20, 20 )
		closebutton:SetPos( 5, 5 )
		closebutton.DoClick = function()
			results_frame:Close()
		end
        resultsframe_exp = vgui.Create( "RichText", results_frame )
            resultsframe_exp:SetVerticalScrollbarEnabled( false )
		    resultsframe_exp:SetSize( 600, 800 )
		    resultsframe_exp:SetPos( 10, 35 )
		    resultsframe_exp:InsertColorChange( 255, 255, 255, 255 )
            resultsframe_exp:AppendText( "Experience Gained: ".. tostring( exp_real ) .."\n" )
            resultsframe_exp:AppendText( "Current level: ".. playerstats_a["LVL3"] .." - ".. playerstats_a["LVL1"] .."/".. playerstats_a["LVL2"] .." experience\n" )
            if just_leveledup == true then
                resultsframe_exp:InsertColorChange( 235, 255, 40, 255 )
                resultsframe_exp:AppendText( "You just leveled up! You are now level ".. playerstats_a["LVL3"] .."\n")
                resultsframe_exp:AppendText( "You now have ".. playerstats_a["LVL_POINTS"] .." upgrade points." )
            end
            function resultsframe_exp:PerformLayout()
                self:SetFontInternal( "equipment_plname2" )
            end
        
end
--------------------------------------
function CheckEXP()
    if playerstats_a["LVL1"] >= playerstats_a["LVL2"] then
        just_leveledup = true
        playerstats_a["LVL1"] = playerstats_a["LVL1"] - playerstats_a["LVL2"]
        playerstats_a["LVL3"] = playerstats_a["LVL3"] + 1
        playerstats_a["LVL2"] = 100 * playerstats_a["LVL3"] + 50 * playerstats_a["LVL3"]
        playerstats_a["LVL_POINTS"] = playerstats_a["LVL_POINTS"] + 2
        playerstats_a["HP2"] = playerstats_a["HP2"] + 10
        CheckEXP()
    end
end

function AddEXP( amount, override ) -- debug
    if isnumber( override ) then
        for i = 1, override, 1 do 
            LevelUp()
        end
    else
        playerstats_a["LVL1"] = playerstats_a["LVL1"] + amount
        CheckEXP()
    end
end

function LevelUp()
    playerstats_a["LVL1"] = playerstats_a["LVL2"]
    CheckEXP()
end
-------------------------

function BattleHud()
	bhud_frame:Show() -- this turns into clickframe then into a basic attack function
    bhud_frame3:Show()
	bhud_attbbasic:Hide() -- precached

	timer.Simple(2, function()
        local down = Vector( 0, 0, 0 )
        local down2 = Vector( 0, 0, -16 )

        local up_start = 0
        local up_base = 0

		hook.Add("HUDPaint", "battlehudpaint", function()

            -- Probably necessary if you want the statuses to work properly in first-person
            local playerpoint = LocalPlayer():GetPos()
            local playerpoint2 = playerpoint:ToScreen()
            local playerpointn = LocalPlayer():GetPos()
            local playerpoint2n = playerpointn:ToScreen()

            if IsValid( enemy1 ) then
                enemy1loc = enemy1:GetPos() 
                enemy1point = enemy1loc:ToScreen()
                enemy1locn = enemy1:GetPos()
                enemy1pointn = enemy1locn:ToScreen()
            end

            if IsValid( enemy2 ) then
                enemy2loc = enemy2:GetPos()
                enemy2point = enemy2loc:ToScreen()
                enemy2locn = enemy2:GetPos()
                enemy2pointn = enemy2locn:ToScreen()
            end

            if IsValid( enemy3 ) then
                enemy3loc = enemy3:GetPos() 
                enemy3point = enemy3loc:ToScreen()
                enemy3locn = enemy3:GetPos()
                enemy3pointn = enemy3locn:ToScreen()
            end
            ----------------------------------------------

            if inbattle then
                -- Player text
			    draw.SimpleTextOutlined( math.Clamp( LocalPlayer():Health(), 0, 1000 ) .."/".. LocalPlayer():GetMaxHealth(), "danger_font", playerpoint2n.x, playerpoint2n.y + 30, Color( 120, 255, 65 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
                draw.SimpleTextOutlined( LocalPlayer():Name(), "danger_font", playerpoint2.x, playerpoint2.y + 12, Color( 120, 255, 65 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
                ---------------------------------

                -- UP Circle, base
                surface.SetDrawColor( 70, 160, 80, 200 )
                draw.NoTexture()
                draw.Circle( 150, ScrH() - 150, 100, 200, -360 )

                -- UP Circle, fill.
                -- All of the functions below suck (it doesn't Lerp on the first hit), also the circle doesn't form properly, but I don't 
                -- have the designing qualifications to fix it.
                up_int2 = -360 * ( cl_Levitus:GetNWInt( "team_UP" ) / 100 )
                -- smoothing
                local up_smooth = Lerp( ( SysTime() - up_start ), up_base, up_int2 )

                if cl_Levitus:GetNWInt( "team_UP" ) ~= up_base then
                    if ( up_smooth ~= up_int2 ) then
                        up_int2 = up_smooth
                    end
            
                    up_base = up_int2
                    up_start = SysTime()
                    up_int2 = -360 * ( cl_Levitus:GetNWInt( "team_UP" ) / 100 )
                end
                
                surface.SetDrawColor( 105, 255, 120, 200)
                draw.Circle( 150, ScrH() - 150, 100, 200, up_smooth )

                -- UP Circle, text. Must be after everything else.
                draw.SimpleText( "Utility Points", "equipment_plname2", 150, ScrH() - 165, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                draw.SimpleText( cl_Levitus:GetNWInt( "team_UP" ) .."/100", "equipment_plname2", 150, ScrH() - 130, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                --------------------------------------------------------------------------------------------------------------------------------------------------------

            end

			if IsValid( enemy1 ) and inbattle then
				draw.SimpleTextOutlined( math.Clamp( enemy1:Health(), 0, 1000 ) .."/".. enemy1:GetMaxHealth(), "danger_font", enemy1pointn.x, enemy1pointn.y + 48, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color( 0, 0, 0 ) )
                draw.SimpleTextOutlined( enemy1:GetNWString( "nwhudname" ), "danger_font", enemy1point.x, enemy1point.y + 30, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color( 0, 0, 0 ) )
			end
			if IsValid( enemy2 ) and inbattle then
				draw.SimpleTextOutlined( math.Clamp( enemy2:Health(), 0, 1000 ) .."/".. enemy2:GetMaxHealth(), "danger_font", enemy2pointn.x, enemy2pointn.y + 38, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color( 0, 0, 0 ) )
                draw.SimpleTextOutlined( enemy2:GetNWString( "nwhudname" ), "danger_font", enemy2point.x, enemy2point.y + 20, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color( 0, 0, 0 ) )
			end
			if IsValid( enemy3 ) and inbattle then
				draw.SimpleTextOutlined( math.Clamp( enemy3:Health(), 0, 1000 ) .."/".. enemy3:GetMaxHealth(), "danger_font", enemy3pointn.x, enemy3pointn.y + 42, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color( 0, 0, 0 ) )
                draw.SimpleTextOutlined( enemy3:GetNWString( "nwhudname" ), "danger_font", enemy3point.x, enemy3point.y + 25, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color( 0, 0, 0 ) )
			end
		end)

        hook.Add( "HUDPaint", "skillname_test", function()
            if skillnote_show then
                local all_width = string.len( skillnote ) * 12.3 + 50
                draw.RoundedBoxEx( 14, ScrW()/2 - all_width / 2, 250, all_width, 32, Color( 60, 60, 60, Lerp( ( SysTime() - show_x ) * 10, 0, 240 ) ), true, true, true, true )
                draw.SimpleText( skillnote, "equipment_plname2", ScrW()/2, 266, Color( 255, 255, 255, Lerp( ( SysTime() - show_x ) * 10, 0, 255 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        end)
	end)
end

function uhhVariablesTest()
    net.WriteInt( plskills["s_slasher"].Level, 32)
    net.WriteInt( plskills["s_slicer"].Level, 32)
    net.WriteInt( plskills["s_dicer"].Level, 32)
end

function BasicAttackPlayer()
	net.Start( "player_makeattack" )
		net.WriteTable( cl_s_targets_tbl )
		net.WriteDouble( plattack1  )
		net.WriteDouble( plattack2 )
		net.WriteString( pltype )
		net.WriteTable( player.GetAll() )
		net.WriteString( playerstats_a["currentweapon"] )
        uhhVariablesTest()
        net.WriteBool( choicesb )
	net.SendToServer()
end -- after enemy turns, do function below

function SkillPlayer()
	net.Start( "player_makeskill" )
        net.WriteTable( cl_s_targets_tbl )
		net.WriteDouble( plattack1 )
		net.WriteDouble( plattack2 )
		net.WriteString( pltype )
		net.WriteTable( player.GetAll() )
		net.WriteString( playerstats_a["currentweapon"] )
        net.WriteString( skill_id )
        net.WriteInt( skill_lvl, 32 )
        uhhVariablesTest()
        net.WriteBool( choicesb )
	net.SendToServer()
end -- after enemy turns, do function below

net.Receive( "player_doturn", function()
    choices = 0
    choicesb = false
    actions_lbl:SetText( playerstats_a.actionvar - choices )
    if LocalPlayer():GetNWInt( "stunturns" ) == 0 then
        bhud_frame:Show()
        bhud_attbbasic:Hide()
    else
        net.Start( "player_removestunturns" )
        net.SendToServer()
    end
end) 

net.Receive( "encounter_outro", function() -- everyone is dead, back to the overworld
    playerstats_a["LVL1"] = playerstats_a["LVL1"] + exp_real
    CheckEXP()
    exp_real = 0
    inbattle = false
	bhud_frame:Close()
	bhud_frame3:Close()
	timer.Simple(2, function()
		hook.Remove( "HUDPaint", "battlehudpaint" )
		pleqic:ToggleVisible()
		DangerHUD()
        ResultsFrame()
        -- Cleanup after battle
            just_leveledup = false
        ---------------------------
	end)
end) 

function LookPos()
    shitpos2 = LocalPlayer():GetViewEntity()
    shitpos = shitpos2:GetPos()
    if shitpos2 == LocalPlayer() then
        shitpos = LocalPlayer():GetShootPos() -- + Vector( 0, 0, 20 )
    end
end

hook.Add( "InitPostEntity", "clickframe_init", function()
    timer.Simple( 1, function()
        clickframe = vgui.Create("DFrame")
            clickframe:MakePopup()
            clickframe:SetSize( ScrW(), ScrH() )
            clickframe:SetTitle("")
            clickframe:SetDraggable( false )
            clickframe:ShowCloseButton( false )
            clickframe:SetWorldClicker( true )
        clickframe.Paint = function( self, w, h )
        end
        -- basic attacks don't support 10 targetting yet
        function clickframe:OnMousePressed( keycode )
            if keycode == 107 then
                LookPos()
                local rtrace = util.QuickTrace( shitpos, gui.ScreenToVector(input.GetCursorPos() ) * Vector( 1000, 1000, 1000 ), { LocalPlayer() } )
                    if rtrace.Entity:Health() > 0 and rtrace.Entity:IsNPC() then
                        cl_s_int = cl_s_int + 1
                        cl_s_targets_tbl[ cl_s_int ] = rtrace.Entity

                        if cl_s_int == cl_s_targets then
                            choices = choices + 1
                            actions_lbl:SetText( playerstats_a.actionvar - choices )
                            clickframe:Close()
                            bhud_frame2:Hide()
                            if choices == playerstats_a.actionvar then
                                choicesb = true
                                bhud_frame:Hide()
                            end
                            BasicAttackPlayer()
                        end
                    end
            elseif keycode == 108 then
                clickframe:Close()
            end
        end

        clickframe_skill = vgui.Create("DFrame")
            clickframe_skill:MakePopup()
            clickframe_skill:SetSize( ScrW(), ScrH() )
            clickframe_skill:SetTitle("")
            clickframe_skill:SetDraggable( false )
            clickframe_skill:ShowCloseButton( false )
            clickframe_skill:SetWorldClicker( true )
        clickframe_skill.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 0)
            surface.DrawRect( 0, 0, w, h )
        end
        function clickframe_skill:OnMousePressed( keycode )
            if keycode == 107 then 
                -- if skill is set to target ALL enemies
                if cl_s_targets == 10 then 
                    local int = 0
                    if IsValid( enemy1 ) then
                        int = int + 1
                        cl_s_targets_tbl[ int ] = enemy1
                    end
                    if IsValid( enemy2 ) then 
                        int = int + 1
                        cl_s_targets_tbl[ int ] = enemy2
                    end
                    if IsValid( enemy3 ) then
                        int = int + 1
                        cl_s_targets_tbl[ int ] = enemy3
                    end
                    SkillPlayer()
                    clickframe_skill:Close()
                    bhud_frame:Hide()
                    bhud_frame2:Hide()
                -- if skill is set to target all players; must be reworked for multiplayer
                elseif cl_s_targets == 11 then
                    cl_s_targets_tbl[ 1 ] = LocalPlayer()
                    SkillPlayer()
                    clickframe_skill:Close()
                    bhud_frame:Hide()
                    bhud_frame2:Hide()
                -- otherwise do it normally
                else
                    LookPos()
                    local rtrace = util.QuickTrace( shitpos, gui.ScreenToVector(input.GetCursorPos() ) * Vector( 1000, 1000, 1000 ) )
                        if rtrace.Entity:Health() > 0 then
                            cl_s_int = cl_s_int + 1
                            cl_s_targets_tbl[ cl_s_int ] = rtrace.Entity
                            
                            -- Run and end once all targets are set
                            if cl_s_int == cl_s_targets then
                                choices = choices + 1
                                actions_lbl:SetText( playerstats_a.actionvar - choices )
                                clickframe_skill:Close()
                                bhud_frame2:Hide()
                                if choices == playerstats_a.actionvar then
                                    choicesb = true
                                    bhud_frame:Hide()
                                end
                                SkillPlayer()
                            end
                        end
                end
            elseif keycode == 108 then
                clickframe_skill:Close()
            end
        end

        clickframe:SetDeleteOnClose( false )
        clickframe:Close()
        clickframe_skill:SetDeleteOnClose( false )
        clickframe_skill:Close()

        -- Main frame for all other elements. Probably.
        bhud_frame = vgui.Create( "DFrame" )
            bhud_frame:SetDraggable( false )
            bhud_frame:SetSize( ScrW(), ScrH() ) 
            bhud_frame:SetPos( 0, 0 )
            bhud_frame:SetTitle( "" ) 
            bhud_frame:ShowCloseButton( false )
        bhud_frame.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 0)
            surface.DrawRect( 0, 0, ScrW(), ScrH() )
        end
        function bhud_frame:OnMousePressed( keycode )
            if keycode == 108 then
                LookPos()
                desctrace = util.QuickTrace( shitpos, gui.ScreenToVector(input.GetCursorPos() ) * Vector( 1000, 1000, 1000 ) )
                if desctrace.Entity:IsNPC() or desctrace.Entity:IsPlayer() then
                    if IsValid(entdesc) == false then
                        entdesc_details()
                    end
                end
            end
        end

        -------------------------------------------------------------------------------------------------------------------------------------------------

        bhud_frame2 = vgui.Create( "DFrame" )
            bhud_frame2:SetDraggable( false )
            bhud_frame2:SetSize( ScrW(), ScrH() ) 
            bhud_frame2:SetPos( 0, 0 )
            bhud_frame2:SetTitle( "" ) 
            bhud_frame2:ShowCloseButton( false )
            bhud_frame2.Paint = function( self, w, h )
                surface.SetDrawColor( 0, 0, 0, 0)
                surface.DrawRect( 0, 0, ScrW(), ScrH() )
            end
        function bhud_frame2:OnMousePressed( keycode )
            if keycode == 108 then
                bhud_frame2:Hide()
            end
        end

        -- Frame for camera buttons
        bhud_frame3 = vgui.Create( "DFrame" )
        bhud_frame3:SetDraggable( false )
        bhud_frame3:SetSize( 70, 600 ) 
        bhud_frame3:SetPos( ScrW()-70, 250 )
        bhud_frame3:SetTitle( "" ) 
        bhud_frame3:ShowCloseButton( false )
        bhud_frame3.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 0)
            surface.DrawRect( 0, 0, ScrW(), ScrH() )
        end

        bhud_attb = vgui.Create( "DImageButton", bhud_frame )
            bhud_attb:SetPos( ScrW()/2 - 127, 950 )
            bhud_attb:SetSize( 255, 110 )
            bhud_attb:SetImage( "hud/button_attack.png" )
            bhud_attb.DoClick = function()
                bhud_attbbasic:ToggleVisible()
            end

        bhud_attbbasic = vgui.Create( "DImageButton", bhud_frame )
            bhud_attbbasic:SetPos( ScrW()/2 -127, 840 )
            bhud_attbbasic:SetSize( 255, 110 )
            bhud_attbbasic:SetImage( "hud/button_attack_basic.png" )
        bhud_attbbasic.DoClick = function()
            bhud_frame2:Show()
            bhud_slash:Hide()
            bhud_pierce:Hide()
            bhud_blunt:Hide()
            -- This function can be optimized but this needs to be ran three times or else multi-type weapons will not function correctly. Ich weiss.
            if isnumber( weaponlist[ playerstats_a["currentweapon"] ].DMG1 ) then
                bhud_slash:Show()
            end
            if isnumber( weaponlist[ playerstats_a["currentweapon"] ].DMG3 ) then
                bhud_pierce:Show()
            end
            if isnumber( weaponlist[ playerstats_a["currentweapon"] ].DMG4 ) then
                bhud_blunt:Show()
            end
        end

        -- Basic Attack damage type buttons.
        bhud_types_form = vgui.Create( "DImage", bhud_frame2 )
            bhud_types_form:SetPos( ScrW()/2 - 355, 725 )
            bhud_types_form:SetSize( 775, 118 )
            bhud_types_form:SetImage( "hud/base3.png" )
        bhud_slash = vgui.Create( "DImageButton", bhud_frame2 )
            bhud_slash:SetPos( ScrW()/2 - 95, 729 )
            bhud_slash:SetSize( 253, 110 )
            bhud_slash:SetImage( "hud/slash1.png" )
        bhud_slash.DoClick = function()
            plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG1
            plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG2
            pltype = "Slash"
            clickframe_Init()
            clickframe:Show()
        end
        bhud_pierce = vgui.Create( "DImageButton", bhud_frame2 )
            bhud_pierce:SetPos( ScrW()/2 - 293, 729 )
            bhud_pierce:SetSize( 253, 110 )
            bhud_pierce:SetImage( "hud/pierce1.png" )
        bhud_pierce.DoClick = function()
            plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG3
            plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG3
            pltype = "Pierce"
            clickframe_Init()
            clickframe:Show()
        end
        bhud_blunt = vgui.Create( "DImageButton", bhud_frame2 )
            bhud_blunt:SetPos( ScrW()/2 + 103, 729)
            bhud_blunt:SetSize( 253, 110 )
            bhud_blunt:SetImage( "hud/blunt1.png" )
        bhud_blunt.DoClick = function()
            plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG4
            plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG5
            pltype = "Blunt"
            clickframe_Init():Show()
        end
        bhud_brace = vgui.Create( "DImageButton", bhud_frame )
            bhud_brace:SetPos( ScrW()-100, ScrH()-100 )
            bhud_brace:SetSize( 40, 50 )
            bhud_brace:SetImage( "hud/f.png" )
            bhud_brace.DoClick = function()
                net.Start( "player_brace" )
                    net.WriteTable( player.GetAll() )
                net.SendToServer()
                bhud_frame:Hide()
                bhud_frame2:Hide()
            end
        bhud_wait = vgui.Create( "DImageButton", bhud_frame )
            bhud_wait:SetPos( ScrW()-180, ScrH()-100 )
            bhud_wait:SetSize( 70, 50 )
            bhud_wait:SetImage( "hud/entourage_defiance.png" )
            bhud_wait.DoClick = function()
                if playerstats_a.actionvar - choices == 1 then
                    net.Start( "player_wait" )
                        net.WriteTable( player.GetAll() )
                    net.SendToServer()
                    bhud_frame:Hide()
                    bhud_frame2:Hide()
                else
                    choices = choices + 1
                    actions_lbl:SetText( playerstats_a.actionvar - choices )
                end
            end
        bhud_frame.Think = function()
            -- im too tired and lazy to make this optimized
            if playerstats_a.actionvar - choices ~= 1 then
                bhud_brace:SetColor( Color( 255, 255, 255, 100 ) )
                bhud_brace:SetMouseInputEnabled( false )
            else
                bhud_brace:SetColor( Color( 255, 255, 255, 255 ) )
                bhud_brace:SetMouseInputEnabled( true )
            end
        end
        -- Buttons for changing perspectives
        bhud_cam1 = vgui.Create( "DImageButton", bhud_frame3 )
            bhud_cam1:SetSize( 40, 40 )
            bhud_cam1:SetPos( 0, 0 )
            bhud_cam1:SetImage( "hud/numba1.png" )
            bhud_cam1.DoClick = function()
                net.Start( "givemereverie" )
                    net.WriteInt( 1726, 32 )
                net.SendToServer()
            end
        bhud_cam2 = vgui.Create( "DImageButton", bhud_frame3 )
            bhud_cam2:SetSize( 40, 40 )
            bhud_cam2:SetPos( 0, 50 )
            bhud_cam2:SetImage( "hud/numba2.png" )
            bhud_cam2.DoClick = function()
                net.Start( "givemereverie" )
                    net.WriteInt( 1724, 32 )
                net.SendToServer()
            end
        bhud_cam3 = vgui.Create( "DImageButton", bhud_frame3 )
            bhud_cam3:SetSize( 40, 40 )
            bhud_cam3:SetPos( 0, 100 )
            bhud_cam3:SetImage( "hud/numba3.png" )
            bhud_cam3.DoClick = function()
                net.Start( "givemereverie" )
                    net.WriteInt( 1723, 32 )
                net.SendToServer()
            end
        bhud_cam4 = vgui.Create( "DImageButton", bhud_frame3 )
            bhud_cam4:SetSize( 40, 40 )
            bhud_cam4:SetPos( 0, 150 )
            bhud_cam4:SetImage( "hud/numba4.png" )
            bhud_cam4.DoClick = function()
                net.Start( "givemereverie" )
                    net.WriteInt( 1722, 32 )
                net.SendToServer()
            end
        bhud_cam5 = vgui.Create( "DImageButton", bhud_frame3 )
            bhud_cam5:SetSize( 40, 40 )
            bhud_cam5:SetPos( 0, 200 )
            bhud_cam5:SetImage( "hud/numba5.png" )
            bhud_cam5.DoClick = function()
                net.Start( "givemereverie" )
                    net.WriteInt( 1725, 32 )
                net.SendToServer()
            end
        bhud_cam6 = vgui.Create( "DImageButton", bhud_frame3 )
            bhud_cam6:SetSize( 40, 40 )
            bhud_cam6:SetPos( 0, 250 )
            bhud_cam6:SetImage( "hud/numba6.png" )
            bhud_cam6.DoClick = function()
                net.Start( "givemereverie" )
                    net.WriteInt( 0, 32 )
                net.SendToServer()
            end
        actions_icon = vgui.Create( "DImage", bhud_frame3 )
            actions_icon:SetSize( 40, 40 )
            actions_icon:SetPos( 0, 350 )
            actions_icon:SetImage( "hud/entourage_wpicon.png" )
        actions_lbl = vgui.Create( "DLabel", bhud_frame3 )
            actions_lbl:SetSize( 40, 40 )
            actions_lbl:SetPos( 10, 350 )
            actions_lbl:SetText( playerstats_a.actionvar - choices )
            actions_lbl:SetFont( "equipment_plname" )
        ------------------------------------------------------------------
        -- Skills battle frame

        -- Button to show skills frame
        local bhud_skills_button = vgui.Create( "DButton", bhud_frame )
            bhud_skills_button:SetSize( 150, 50 )
            bhud_skills_button:SetPos( 0, 100 )
            bhud_skills_button.Paint = function( self, w, h )
                draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 50, 50, 50 ), false, true, false, true )
            end
            bhud_skills_button:SetFont( "equipment_plname2" )
            bhud_skills_button:SetTextColor( color_white )
            bhud_skills_button:SetText( "Skills" )
            bhud_skills_button.DoClick = function()
                bhud_skills_frame:ToggleVisible()
                skills_frame_init()
                bhud_skills_tip:Hide()
            end
            -- Actual skills frame
            bhud_skills_frame = vgui.Create( "DFrame", bhud_frame )
                bhud_skills_frame:SetPos( bhud_skills_button:GetWide(), bhud_skills_button:GetY() )
                bhud_skills_frame:SetSize( bhud_frame:GetWide() - bhud_skills_button:GetWide() - 50, bhud_skills_button:GetTall() )
                bhud_skills_frame:SetTitle( "" )
                bhud_skills_frame:ShowCloseButton( false )
                bhud_skills_frame:SetDraggable( false )
                bhud_skills_frame.Paint = function( self, w, h )
                    draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 90, 85, 85 ), true, true, true, true )
                end
                -- This function creates available skills.
                function skills_frame_init()
                    local integer = -1
                    -- clean buttons if they are already initialized. check if theyre the skil button or shit breaks :)
                    if bhud_skills_frame:HasChildren() then
                        for k, v in pairs( bhud_skills_frame:GetChildren() ) do
                            if v:GetName() == "DImageButton" then 
                                v:Remove()
                            end
                        end
                    end
                    for k, v in pairs( plskills ) do
                        -- If skill has at least one point or is from a trinket
                        if v.equipped == 1 or v.equipped == -1 then
                            integer = integer + 1
                            skillbutton = vgui.Create( "DImageButton", bhud_skills_frame )
                                skillbutton:SetSize( 25, 25 )
                                skillbutton:SetPos( 10 + integer * 35, bhud_skills_frame:GetTall()/2 - skillbutton:GetTall()/2 )
                                skillbutton:SetImage( "skills/entourage_".. k .."_small.png" )
                                skillbutton:SetTooltip( skillsbase[ k ].Name .."\nUP Cost: ".. skillsbase[ k ].cost .."\nCooldown: ".. skillsbase[ k ].cd .." turns" )
                                skillbutton.DoClick = function()
                                    if skillsbase[ k ].cost <= cl_Levitus:GetNWInt( "team_UP" ) and LocalPlayer():GetNWBool( k .."_oncd" ) == false then
                                        skill_id = k
                                        skill_lvl = v.Level
                                        DefineDMG()
                                        clickframeskill_Init()
                                        clickframe_skill:Show()

                                        bhud_skills_tip:Show()
                                        bhud_skills_tip1:SetText( skillsbase[ k ].Name )
                                        bhud_skills_tip1:SizeToContents()
                                        bhud_skills_tip1:Center()
                                        bhud_skills_tip1:SetPos( bhud_skills_tip1:GetX() + 40, 0 )
                                        bhud_skills_tip2:SetText( skillsbase[ k ].Description .."\nUP Cost: ".. skillsbase[ k ].cost .."\nCooldown: ".. skillsbase[ k ].cd .." turns" )
                                        bhud_skills_tip3:SetImage( "skills/entourage_".. k ..".png" )
                                        tosia = k
                                    end
                                end
                                skillbutton.DoRightClick = function()
                                    if tosia == k and bhud_skills_tip:IsVisible() then
                                        bhud_skills_tip:Hide()
                                    else
                                        bhud_skills_tip:Show()
                                        bhud_skills_tip1:SetText( skillsbase[ k ].Name )
                                        bhud_skills_tip1:SizeToContents()
                                        bhud_skills_tip1:Center()
                                        bhud_skills_tip1:SetPos( bhud_skills_tip1:GetX() + 80 , 0 )
                                        bhud_skills_tip2:SetText( skillsbase[ k ].Description .."\nUP Cost: ".. skillsbase[ k ].cost .."\nCooldown: ".. skillsbase[ k ].cd .." turns" )
                                        bhud_skills_tip3:SetImage( "skills/entourage_".. k ..".png" )
                                        tosia = k
                                    end
                                end
                                local skillbuttoncd = vgui.Create( "DImage", skillbutton )
                                    skillbuttoncd:SetSize( 25, 25 )
                                    skillbuttoncd:SetPos( 0, 0 )
                                    skillbuttoncd:Hide()
                                function skillbutton:Think()
                                    if skillsbase[ k ].cost <= cl_Levitus:GetNWInt( "team_UP" ) and LocalPlayer():GetNWBool( k .."_oncd" ) == false then
                                        skillbuttoncd:Hide()
                                        self:SetColor( Color( 255, 255, 255, 255 ) )
                                    elseif skillsbase[ k ].cost <= cl_Levitus:GetNWInt( "team_UP" ) and LocalPlayer():GetNWBool( k .."_oncd" ) then
                                        skillbuttoncd:SetImage( "hud/numba".. LocalPlayer():GetNWInt( k .."_cd" ) + 1 ..".png" )
                                        skillbuttoncd:Show()
                                        self:SetColor( Color( 255, 255, 255, 100 ) )
                                    else
                                        skillbuttoncd:Hide()
                                        self:SetColor( Color( 255, 255, 255, 100 ) )
                                    end
                                end
                        end
                    end
                end
            bhud_skills_tip = vgui.Create( "DFrame", bhud_frame )
                bhud_skills_tip:SetPos( 150, 150 )
                bhud_skills_tip:SetSize( 500, 200 )
                bhud_skills_tip:SetTitle( "" )
                bhud_skills_tip:ShowCloseButton( false )
                bhud_skills_tip:SetDraggable( false )
                bhud_skills_tip.Paint = function( self, w, h )
                    draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 50, 50, 50 ), false, false, true, true )
                    surface.SetDrawColor( 20, 20, 20 )
                    surface.DrawRect( 160, 0, 4, h )
                end
                bhud_skills_tip1 = vgui.Create( "DLabel", bhud_skills_tip ) -- Skill name
                    bhud_skills_tip1:SetPos( 0, 0 )
                    bhud_skills_tip1:SetSize( 200, 30 )
                    bhud_skills_tip1:SetVerticalScrollbarEnabled( false )
                    bhud_skills_tip1:InsertColorChange( 255, 255, 255, 255 )
                    bhud_skills_tip1:SetMouseInputEnabled( false )
                    bhud_skills_tip1:SetFont( "equipment_plname4" )
                bhud_skills_tip2 = vgui.Create( "RichText", bhud_skills_tip ) -- other stuff
                    bhud_skills_tip2:SetPos( 170, 40 )
                    bhud_skills_tip2:SetSize( 338, 150 )
                    bhud_skills_tip2:SetVerticalScrollbarEnabled( false )
                    bhud_skills_tip2:InsertColorChange( 255, 255, 255, 255 )
                    function bhud_skills_tip2:PerformLayout()
                        self:SetFontInternal( "danger_font" )
                    end
                bhud_skills_tip3 = vgui.Create( "DImage", bhud_skills_tip )
                    bhud_skills_tip3:SetSize( 125, 125 )
                    bhud_skills_tip3:SetPos( 20, 37 )
            bhud_skills_tip:Hide()
            bhud_skills_frame:Hide()
        -------------------------------------
        bhud_frame:SetDeleteOnClose( false )
        bhud_frame:Close()	
        bhud_frame2:SetDeleteOnClose( false )
        bhud_frame2:Close()	
        bhud_frame3:SetDeleteOnClose( false )
        bhud_frame3:Close()			
        -- End of battle hud.

        -------------------------------------------------------------------------------------
        -- Right-click Enemy description.
    end)
end)

function entdesc_details()
    entdesc = vgui.Create( "DFrame", bhud_frame )
    entdesc:MakePopup()
    entdesc:SetDraggable( true )
    entdesc:SetSize( 800, 800 )
    entdesc:Center()
    entdesc:SetTitle( "" )
    entdesc:ShowCloseButton( false )
    entdesc.Paint = function( self, w, h )
        draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
        draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false)
        draw.SimpleText( "Overview", "equipment_plname4", w/2, 10, color_white, a, a )
        draw.SimpleText( targetent:GetNWString( "nameNW" ), "equipment_plname", 45, 50, color_white, b, a )
    end

    targetent = desctrace.Entity
    targetnpc = desctrace.Entity:IsNPC()
    entdesc_m = vgui.Create( "DModelPanel", entdesc )
        entdesc_m:SetMouseInputEnabled( false )
        
        entdesc_m:SetModel( targetent:GetModel() )
        entdesc_m:SetAnimated( true )

        if targetnpc then
            -- NPC mode
            entdesc_m:SetSize( 300, 300 )
            entdesc_m:SetPos( 5, 5 )
            entdesc_m:SetCamPos( Vector( 165, -50, 10 ) )
            entdesc_m:GetEntity():SetSkin( targetent:GetSkin() )
            entdesc_m:GetEntity():SetModelScale( targetent:GetNWFloat( "scaleNW", 1 ) )
            entdesc_m:GetEntity():SetSequence( targetent:GetSequence() )
            entdesc_m:SetFOV( 40 )
            entdesc_desc = vgui.Create( "RichText", entdesc )
                entdesc_desc:SetSize( 470, 180 )
                entdesc_desc:SetPos( 325, 65 )
                entdesc_desc:SetVerticalScrollbarEnabled( false )
                entdesc_desc:InsertColorChange( 255, 255, 255, 255 )
                entdesc_desc:AppendText( enemies_table[ targetent:GetNWString( "nameNW" ) ].Description  )
            entdesc_desc2 = vgui.Create( "RichText", entdesc )
                entdesc_desc2:SetSize( 800, 520 )
                entdesc_desc2:SetPos( 45, 300 )
                entdesc_desc2:SetVerticalScrollbarEnabled( false )
                entdesc_desc2:InsertColorChange( 255, 255, 255, 255 )
                entdesc_desc2:AppendText( "Health: ".. targetent:Health() .." / ".. targetent:GetMaxHealth() .."\n")
                entdesc_desc2:AppendText( "Defence: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DEF .."\n")
                entdesc_desc2:AppendText( "Flex Defence: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DFX .."\n")
                entdesc_desc2:AppendText( "Damage: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DMG .." ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGT .."\n")
                if IsValid( enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGP ) then
                    entdesc_desc2:AppendText( "Armour Penetration: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGP .."\n" )
                end
                if IsValid( enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGC ) then
                    entdesc_desc2:AppendText( "Crit Chance: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGC .."%" .."\n" )
                end
                if IsValid( enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGS ) then
                    entdesc_desc2:AppendText( "Base Stun Chance: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DMGS .."%\n" )
                end
                entdesc_desc2:AppendText( "Base Miss Chance: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].MISS .."%" .."\n" )
                entdesc_desc2:AppendText( "Base Dodge Chance: ".. enemies_table[ targetent:GetNWString( "nameNW" ) ].DDG .."%" .."\n" )
                entdesc_desc2:AppendText( "\n" )
                entdesc_desc2:AppendText( "Debug ID: ".. targetent:EntIndex() ) -- MIKOŁAJ TO DEBIL
                function entdesc_desc2:PerformLayout()
                    self:SetFontInternal( "equipment_plname2" )
                end
            function entdesc_desc:PerformLayout()
                self:SetFontInternal( "equipment_plname2" )
            end
        else
            -- Player mode
            entdesc_m:SetSize( 700, 700 )
            entdesc_m:Center( 700, 700 )
            entdesc_m:SetCamPos( Vector( 75, 0, 50 ) )
            function entdesc_m.Entity:GetPlayerColor() return targetent:GetPlayerColor() end
            entdesc_m:SetFOV( 70 )
            plcol2 = targetent:GetPlayerColor() * Vector( 255, 255, 255 )
            -- https://cdn.discordapp.com/attachments/471302316734283776/867731331243966503/mods.png
            entdesc.Paint = function( self, w, h )
                draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 110, 110, 115, 240 ), true, true, true, true)
                draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol2, true, true, false, false)
                draw.SimpleText( targetent:Name(), "encounter_font", w/2, 75, plcol, a, a )
                draw.SimpleText( "Overview", "equipment_plname4", w/2, 10, color_white, a, a )
                draw.SimpleText( "Level ".. playerstats_a["LVL3"] .." ".. tag, "equipment_plname4", w/2, 130, color_white, a, a )
                draw.SimpleText( playerstats_a["LVL1"] .."/".. playerstats_a["LVL2"], "equipment_plname4", w/2, 165, color_white, a, a )
                draw.SimpleText( LocalPlayer():Health() .."/".. playerstats_a["HP2"], "equipment_plname2", w/2 - 32, 690, color_white, b, a )
                draw.SimpleText( weaponlist[ playerstats_a["currentweapon"] ].Name, "equipment_plname2", w/2 - 35, 730, color_white, b, a )
                draw.SimpleText( weaponlist[ playerstats_a["currentarmour"] ].Name, "equipment_plname2", w/2 - 35, 770, color_white, b, a )
                draw.SimpleText( playerstats_a["MGT"], "equipment_plname2", 545, 250, color_white, b, a )
                draw.SimpleText( playerstats_a["VIT"], "equipment_plname2", 545, 303, color_white, b, a )
                draw.SimpleText( playerstats_a["AGI"], "equipment_plname2", 545, 355, color_white, b, a )
                draw.SimpleText( playerstats_a["SDL"], "equipment_plname2", 545, 410, color_white, b, a )
                draw.SimpleText( playerstats_a["FCS"], "equipment_plname2", 545, 465, color_white, b, a )
                draw.SimpleText( playerstats_a["DEF"], "equipment_plname2", 545, 520, color_white, b, a )
                draw.SimpleText( playerstats_a["DFX"], "equipment_plname2", 545, 575, color_white, b, a )
            end

        local mf_hpic = vgui.Create( "DImage", entdesc )
			mf_hpic:SetImage( "hud/entourage_hpicon.png")
			mf_hpic:SetPos( 325, 675)
			mf_hpic:SetSize( 30, 30 )

		local mf_wpic = vgui.Create( "DImage", entdesc )
			mf_wpic:SetImage( "hud/entourage_wpicon.png")
			mf_wpic:SetPos( 325, 708)
			mf_wpic:SetSize( 30, 30 )

		local mf_amic = vgui.Create( "DImage", entdesc )
			mf_amic:SetImage( "hud/entourage_armouricon.png")
			mf_amic:SetPos( 325, 750)
			mf_amic:SetSize( 30, 30 )

		local mf_mgt = vgui.Create( "DImage", entdesc )
			mf_mgt:SetImage( "hud/entourage_might.png")
			mf_mgt:SetPos( 490, 230 )
			mf_mgt:SetSize( 35, 35 )

		local mf_vit = vgui.Create( "DImage", entdesc )
			mf_vit:SetImage( "hud/entourage_defiance.png")
			mf_vit:SetPos( 490, 285 )
			mf_vit:SetSize( 35, 35 )

		local mf_cty = vgui.Create( "DImage", entdesc )
			mf_cty:SetImage( "hud/entourage_celerity.png")
			mf_cty:SetPos( 490, 340 )
			mf_cty:SetSize( 35, 35 )

		local mf_sdl = vgui.Create( "DImage", entdesc )
			mf_sdl:SetImage( "hud/entourage_sidle.png")
			mf_sdl:SetPos( 490, 385 )
			mf_sdl:SetSize( 35, 35 )

		local mf_fcs = vgui.Create( "DImage", entdesc )
			mf_fcs:SetImage( "hud/entourage_focus.png")
			mf_fcs:SetPos( 490, 450 )
			mf_fcs:SetSize( 35, 35 )

		local mf_def = vgui.Create( "DImage", entdesc )
			mf_def:SetImage( "hud/entourage_defence.png")
			mf_def:SetPos( 490, 505 )
			mf_def:SetSize( 35, 35 )

		local mf_dfx = vgui.Create( "DImage", entdesc )
			mf_dfx:SetImage( "hud/entourage_flexdefence.png")
			mf_dfx:SetPos( 490, 560 )
			mf_dfx:SetSize( 35, 35 )

        end
        
        function entdesc_m:LayoutEntity( ent )
            if ( self.bAnimated ) then
                self:RunAnimation()
            end
            entdesc_m:GetEntity():SetAngles( Angle( 0, RealTime() * 0 % 360, 0 ) ) -- Clever modification of this function prevents it from spinning whilst still allowing animations to run. I know, I know.
        end

    local closebutton = vgui.Create( "DImageButton", entdesc )
        closebutton:SetImage( "icon16/cross.png" )
        closebutton:SetSize( 20, 20 )
        closebutton:SetPos( 2, 2 )
        closebutton.DoClick = function()
            entdesc:Remove()
        end

    -- Display all target effects
    net.Start("getbufftbl")
        net.WriteEntity( targetent )
    net.SendToServer()
    timer.Simple( 0.1, function()
        for k, v in pairs( ovbufftbl ) do
            local bufficon = vgui.Create( "DImage", entdesc )
                bufficon:SetSize( 25, 25 )
                bufficon:SetPos( 10, 35 + 35 * k - 35 )
                bufficon:SetImage( "hud/entourage_placeholder.png" )
        end
    end)
end
-- entdesc:SetDeleteOnClose( false )
-- entdesc:Close()	

net.Receive( "sendbufftbl", function()
    print("YEAH")
    ovbufftbl = net.ReadTable()
end)

function DefineDMG()
    local a = weaponlist[ playerstats_a["currentweapon"] ].dmgtype
    if a == "Slash" then
        plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG1
        plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG2
        pltype = "Slash"
    elseif a == "Blunt" then
        plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG4
        plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG5
        pltype = "Blunt"
    elseif a == "Pierce" then
        plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG3
        plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG3
        pltype = "Pierce"
    end
end
-- Defining stuff if battle is started and you have a multi-type weapon
function DefineDMGA()
    if pltype == "Slash" then
        plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG1
        plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG2
        pltype = "Slash"
    elseif pltype == "Blunt" then
        plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG4
        plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG5
        pltype = "Blunt"
    elseif pltype == "Pierce" then
        plattack1 = weaponlist[ playerstats_a["currentweapon"] ].DMG3
        plattack2 = weaponlist[ playerstats_a["currentweapon"] ].DMG3
        pltype = "Pierce"
    end
end

-- skill clickframe management
function clickframeskill_Init()
    cl_s_int = 0
    cl_s_targets = skillsbase[ skill_id ].targets
    cl_s_targets_tbl = {}
end

function clickframe_Init()
    cl_s_int = 0
    cl_s_targets =  weaponlist[ playerstats_a["currentweapon"] ].targets
    cl_s_targets_tbl = {}
end

function SkillNoteCL( skillnote2 )
    skillnote = skillnote2
    skillnote_show = true
    show_x = SysTime()
    timer.Simple( 1.75, function()
        skillnote_show = false
    end)
end

-- Skill note management
net.Receive( "sendskillnote", function()
    skillnote = net.ReadString()
    SkillNoteCL( skillnote )
end)

net.Receive( "endgame", function()
    LocalPlayer():ScreenFade( 2, Color( 0, 0, 0 ), 2, 1000 )
    bhud_frame:Close()
    bhud_frame3:Close()
    inbattle = false
end)