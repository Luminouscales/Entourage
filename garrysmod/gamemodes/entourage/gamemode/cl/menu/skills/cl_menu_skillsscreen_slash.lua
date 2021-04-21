-- Is this going to be big? Yes. But that's because this is the most comfortable and customizable way 
-- I can think of. Iterating over a table is better for inventories that change - skills will never change 
-- and when they will, I will want them to. If necessary, rework this, but this should do for the time being.

local unavailable = Color( 255, 255, 255, 50 )
local col_tier1 = Color( 255, 255, 255, 255 )
local skpic_a = "skills/entourage_precstrike.png"
local madechanges = false

function DefineColour()
    if skillsbase[ define_col ].tier == 1 then
        sk_name:InsertColorChange( 255, 255, 255, 255 )
    end
end

function DefineText()
    -- For longer names:
        -- Needs more experimentation.
        -- Size 19 fits PERFECTLY with plname0
    if string.len( define_text ) >= 19 then
        function sk_name:PerformLayout()
            self:SetFontInternal( "equipment_plname" )
        end
    end
    -- Clawmade center function. Isn't it beautiful?
    sk_name:SetPos( 1350 + ( 385 - 17.18 * string.len( define_text ) ) / 2, 270 )
    -----------------------------------------------------------------------------
    sk_name:SetSize( 17.18 * string.len( define_text ) + 25, 60 )
    sk_name:Show()
end

hook.Add( "InitPostEntity", "fuck_slash", function()
    timer.Simple( 0.5, function()
        -- Passive Skills
        local sk_s_p1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_p1:SetSize( 75, 75 )
            sk_s_p1:SetPos( 50, 167 )
            sk_s_p1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_p1.DoClick = function()
                PlaceholderFunction()
            end 

        local sk_s_p2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_p2:SetSize( 75, 75 )
            sk_s_p2:SetPos( 50, 460 - 25 )
            sk_s_p2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_p2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_p3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_p3:SetSize( 75, 75 )
            sk_s_p3:SetPos( 50, 705 )
            sk_s_p3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_p3.DoClick = function()
                PlaceholderFunction()
            end
        ------------------------
        -- Main skills
        --- Row 1
        local s_precstrike = vgui.Create( "DImageButton", skills_frame_slash )
            s_precstrike:SetSize( 50, 50 )
            s_precstrike:SetPos( 225, 167 + 12 )
            s_precstrike:SetImage( "skills/entourage_s_precstrike.png" )
            s_precstrike.DoClick = function( )
                -- First, define the image and show it...
                skpic_a = s_precstrike:GetImage()
                skpic:Show()

                aimed_skill2 = s_precstrike

                -- ...then, set variables...
                define_col = "s_precstrike"
                define_text = "Precision Strike"

                DoDescs()

                -- ...and use colour function...
                DefineColour()
                -- ...then manage the name stuff and use center function which also shows the name.
                sk_name:AppendText( define_text )
                DefineText()
                -- Then realize you must do the same for the description. Fuck me.
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Deal damage to one target equal to ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 100 + 10 * plskills_a["s_precstrike"].Level .."% " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "slash weapon strength with ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 10 + 5 * plskills_a["s_precstrike"].Level .."% " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "bonus accuracy. Gain " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 1 + plskills_a["s_precstrike"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " FCS lasting for " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "3 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "turns. \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                if plskills_a["s_precstrike"].Level > 4 then 
                    sk_desc1:AppendText( 2 )
                else 
                    sk_desc1:AppendText( 3 )
                end
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "5 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_precstrike"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                sk_desc1:SetSize( 380, 370 )
                sk_desc1:SetPos( 1365, sk_name:GetY() + sk_name:GetTall() )
                sk_desc1:Show()
                skupgrade:Show()
                -- Holy shit.
            end
            if plskills_a["s_precstrike"].equipped < 1 then
                s_precstrike:SetColor( unavailable )
            end

        local s_defmano = vgui.Create( "DImageButton", skills_frame_slash )
            s_defmano:SetSize( 50, 50 )
            s_defmano:SetPos( 325, 167 + 12 )
            s_defmano:SetImage( "skills/entourage_s_defmano.png" )
            s_defmano.DoClick = function( )
                skpic_a = s_defmano:GetImage()
                skpic:Show()

                aimed_skill2 = s_defmano

                define_col = "s_defmano"
                define_text = "Defensive Manoeuvre"

                DoDescs()

                DefineColour()

                sk_name:AppendText( define_text )
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Deal ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 75 + 5 * plskills_a["s_defmano"].Level .."% ")
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "base weapon damage to one target, gain ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "(".. math.floor( 2 + playerstats_a["DEF"] / 10 + 3 * plskills_a["s_defmano"].Level ) .." DEF, ".. math.floor( 5 + playerstats_a["DFX"] / 10 + 2 * plskills_a["s_defmano"].Level ) .."% DFX) ")
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "defensive stats for ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                if plskills_a["s_defmano"].Level > 4 then
                    sk_desc1:AppendText( "2 " )
                    sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                    sk_desc1:AppendText( "turns.")
                else
                    sk_desc1:AppendText( "1 " )
                    sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                    sk_desc1:AppendText( "turn.")
                end
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "3 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "10 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_defmano"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                sk_desc1:SetSize( 380, 370 )
                sk_desc1:SetPos( 1365, sk_name:GetY() + sk_name:GetTall() )
                sk_desc1:Show()
                skupgrade:Show()

            end
            if plskills_a["s_defmano"].equipped < 1 then
                s_defmano:SetColor( unavailable )
            end

        local s_firstaid = vgui.Create( "DImageButton", skills_frame_slash )
            s_firstaid:SetSize( 50, 50 )
            s_firstaid:SetPos( 425, 167 + 12 )
            s_firstaid:SetImage( "skills/entourage_s_firstaid.png" )
            s_firstaid.DoClick = function()
                skpic_a = s_firstaid:GetImage()
                skpic:Show()

                aimed_skill2 = s_firstaid

                define_col = "s_firstaid"
                define_text = "First Aid"

                DoDescs()

                DefineColour()

                sk_name:AppendText( define_text )
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Heal target for " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 20 + 10 * plskills_a["s_firstaid"].Level .."HP + ".. 3 + 3 * plskills_a["s_firstaid"].Level .."% " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " of their max HP. Grant " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 1 + 2 * plskills_a["s_firstaid"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " MGT for " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "3 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "turns." )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "3 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "15 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_firstaid"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                sk_desc1:SetSize( 380, 370 )
                sk_desc1:SetPos( 1365, sk_name:GetY() + sk_name:GetTall() )
                sk_desc1:Show()
                skupgrade:Show()
            end
            if plskills_a["s_firstaid"].equipped < 1 then
                s_firstaid:SetColor( unavailable )
            end
        --- Row 2
        local sk_s_m2_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_m2_1:SetSize( 50, 50 )
            sk_s_m2_1:SetPos( 225, 460 - 25 + 12 )
            sk_s_m2_1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_m2_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_m2_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_m2_2:SetSize( 50, 50 )
            sk_s_m2_2:SetPos( 325, 460 - 25 + 12 )
            sk_s_m2_2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_m2_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_m2_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_m2_3:SetSize( 50, 50 )
            sk_s_m2_3:SetPos( 425, 460 - 25 + 12 )
            sk_s_m2_3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_m2_3.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 3
        local sk_s_m3_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_m3_1:SetSize( 50, 50 )
            sk_s_m3_1:SetPos( 225, 705 + 12 )
            sk_s_m3_1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_m3_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_m3_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_m3_2:SetSize( 50, 50 )
            sk_s_m3_2:SetPos( 325, 705 + 12 )
            sk_s_m3_2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_m3_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_m3_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_m3_3:SetSize( 50, 50 )
            sk_s_m3_3:SetPos( 425, 705 + 12 )
            sk_s_m3_3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_s_m3_3.DoClick = function()
                PlaceholderFunction()
            end
        ------------------------
        -- Subclass Skills
        --- Row 1
        local sk_s_s1_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s1_1:SetSize( 50, 50 )
            sk_s_s1_1:SetPos( 480, 167 + 12 - 60 )
            sk_s_s1_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s1_2:SetSize( 50, 50 )
            sk_s_s1_2:SetPos( 580, 167 + 12 - 60 )
            sk_s_s1_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_3 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s1_3:SetSize( 50, 50 )
            sk_s_s1_3:SetPos( 680, 167 + 12 - 60 )
            sk_s_s1_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_4 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s1_4:SetSize( 50, 50 )
            sk_s_s1_4:SetPos( 780, 167 + 12 - 60 )
            sk_s_s1_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_5 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s1_5:SetSize( 50, 50 )
            sk_s_s1_5:SetPos( 880, 167 + 12 - 60 )
            sk_s_s1_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_6 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s1_6:SetSize( 50, 50 )
            sk_s_s1_6:SetPos( 980, 167 + 12 - 60 )
            sk_s_s1_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_7 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s1_7:SetSize( 50, 50 )
            sk_s_s1_7:SetPos( 1080, 167 + 12 - 60 )
            sk_s_s1_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_7.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_8 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s1_8:SetSize( 50, 50 )
            sk_s_s1_8:SetPos( 1180, 167 + 12 - 60 )
            sk_s_s1_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s1_9 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s1_9:SetSize( 50, 50 )
            sk_s_s1_9:SetPos( 1280, 167 + 12 - 60 )
            sk_s_s1_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s1_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 2
        local sk_s_s2_1 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s2_1:SetSize( 50, 50 )
            sk_s_s2_1:SetPos( 480, 167 + 12 + 60 )
            sk_s_s2_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_2 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s2_2:SetSize( 50, 50 )
            sk_s_s2_2:SetPos( 580, 167 + 12 + 60 )
            sk_s_s2_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_3:SetSize( 50, 50 )
            sk_s_s2_3:SetPos( 680, 167 + 12 + 60 )
            sk_s_s2_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_4 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_4:SetSize( 50, 50 )
            sk_s_s2_4:SetPos( 780, 167 + 12 + 60 )
            sk_s_s2_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_5 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_5:SetSize( 50, 50 )
            sk_s_s2_5:SetPos( 880, 167 + 12 + 60 )
            sk_s_s2_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_6 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_6:SetSize( 50, 50 )
            sk_s_s2_6:SetPos( 980, 167 + 12 + 60 )
            sk_s_s2_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_7 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_7:SetSize( 50, 50 )
            sk_s_s2_7:SetPos( 1080, 167 + 12 + 60 )
            sk_s_s2_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_7.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_8 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_8:SetSize( 50, 50 )
            sk_s_s2_8:SetPos( 1180, 167 + 12 + 60 )
            sk_s_s2_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s2_9 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s2_9:SetSize( 50, 50 )
            sk_s_s2_9:SetPos( 1280, 167 + 12 + 60 )
            sk_s_s2_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s2_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 3
        local sk_s_s3_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_1:SetSize( 50, 50 )
            sk_s_s3_1:SetPos( 480, 460 - 25 + 12 - 60 )
            sk_s_s3_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_2:SetSize( 50, 50 )
            sk_s_s3_2:SetPos( 580, 460 - 25 + 12 - 60 )
            sk_s_s3_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_3:SetSize( 50, 50 )
            sk_s_s3_3:SetPos( 680, 460 - 25 + 12 - 60 )
            sk_s_s3_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_4 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_4:SetSize( 50, 50 )
            sk_s_s3_4:SetPos( 780, 460 - 25 + 12 - 60 )
            sk_s_s3_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_5 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_5:SetSize( 50, 50 )
            sk_s_s3_5:SetPos( 880, 460 - 25 + 12 - 60 )
            sk_s_s3_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_6 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_6:SetSize( 50, 50 )
            sk_s_s3_6:SetPos( 980, 460 - 25 + 12 - 60 )
            sk_s_s3_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_7 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_7:SetSize( 50, 50 )
            sk_s_s3_7:SetPos( 1080, 460 - 25 + 12 - 60 )
            sk_s_s3_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_7.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_8 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_8:SetSize( 50, 50 )
            sk_s_s3_8:SetPos( 1180, 460 - 25 + 12 - 60 )
            sk_s_s3_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s3_9 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s3_9:SetSize( 50, 50 )
            sk_s_s3_9:SetPos( 1280, 460 - 25 + 12 - 60 )
            sk_s_s3_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s3_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 4
        local sk_s_s4_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_1:SetSize( 50, 50 )
            sk_s_s4_1:SetPos( 480, 460 - 25 + 12 + 60 )
            sk_s_s4_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_2:SetSize( 50, 50 )
            sk_s_s4_2:SetPos( 580, 460 - 25 + 12 + 60 )
            sk_s_s4_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_3:SetSize( 50, 50 )
            sk_s_s4_3:SetPos( 680, 460 - 25 + 12 + 60 )
            sk_s_s4_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_4 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_4:SetSize( 50, 50 )
            sk_s_s4_4:SetPos( 780, 460 - 25 + 12 + 60 )
            sk_s_s4_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_5 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_5:SetSize( 50, 50 )
            sk_s_s4_5:SetPos( 880, 460 - 25 + 12 + 60 )
            sk_s_s4_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_6 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_6:SetSize( 50, 50 )
            sk_s_s4_6:SetPos( 980, 460 - 25 + 12 + 60 )
            sk_s_s4_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_7 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_7:SetSize( 50, 50 )
            sk_s_s4_7:SetPos( 1080, 460 - 25 + 12 + 60 )
            sk_s_s4_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_7.DoClick = function()
                PlaceholderFunction()
            end
        
        local sk_s_s4_8 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_8:SetSize( 50, 50 )
            sk_s_s4_8:SetPos( 1180, 460 - 25 + 12 + 60 )
            sk_s_s4_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s4_9 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s4_9:SetSize( 50, 50 )
            sk_s_s4_9:SetPos( 1280, 460 - 25 + 12 + 60 )
            sk_s_s4_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s4_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 5
        local sk_s_s5_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_1:SetSize( 50, 50 )
            sk_s_s5_1:SetPos( 480, 705 + 12 - 60 )
            sk_s_s5_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_2:SetSize( 50, 50 )
            sk_s_s5_2:SetPos( 580, 705 + 12 - 60 )
            sk_s_s5_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_3:SetSize( 50, 50 )
            sk_s_s5_3:SetPos( 680, 705 + 12 - 60 )
            sk_s_s5_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_4 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_4:SetSize( 50, 50 )
            sk_s_s5_4:SetPos( 780, 705 + 12 - 60 )
            sk_s_s5_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_5 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_5:SetSize( 50, 50 )
            sk_s_s5_5:SetPos( 880, 705 + 12 - 60 )
            sk_s_s5_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_6 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s5_6:SetSize( 50, 50 )
            sk_s_s5_6:SetPos( 980, 705 + 12 - 60 )
            sk_s_s5_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_7 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_7:SetSize( 50, 50 )
            sk_s_s5_7:SetPos( 1080, 705 + 12 - 60 )
            sk_s_s5_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_7.DoClick = function()
                PlaceholderFunction()
            end
        
        local sk_s_s5_8 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_8:SetSize( 50, 50 )
            sk_s_s5_8:SetPos( 1180, 705 + 12 - 60 )
            sk_s_s5_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s5_9 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s5_9:SetSize( 50, 50 )
            sk_s_s5_9:SetPos( 1280, 705 + 12 - 60 )
            sk_s_s5_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s5_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 6
        local sk_s_s6_1 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_1:SetSize( 50, 50 )
            sk_s_s6_1:SetPos( 480, 705 + 12 + 60 )
            sk_s_s6_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_2 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_2:SetSize( 50, 50 )
            sk_s_s6_2:SetPos( 580, 705 + 12 + 60 )
            sk_s_s6_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_3 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_3:SetSize( 50, 50 )
            sk_s_s6_3:SetPos( 680, 705 + 12 + 60 )
            sk_s_s6_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_4 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_4:SetSize( 50, 50 )
            sk_s_s6_4:SetPos( 780, 705 + 12 + 60 )
            sk_s_s6_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_5 = vgui.Create( "DImageButton", skills_frame_slash ) 
            sk_s_s6_5:SetSize( 50, 50 )
            sk_s_s6_5:SetPos( 880, 705 + 12 + 60 )
            sk_s_s6_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_6 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_6:SetSize( 50, 50 )
            sk_s_s6_6:SetPos( 980, 705 + 12 + 60 )
            sk_s_s6_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_7 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_7:SetSize( 50, 50 )
            sk_s_s6_7:SetPos( 1080, 705 + 12 + 60 )
            sk_s_s6_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_7.DoClick = function()
                PlaceholderFunction()
            end
        
        local sk_s_s6_8 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_8:SetSize( 50, 50 )
            sk_s_s6_8:SetPos( 1180, 705 + 12 + 60 )
            sk_s_s6_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_s_s6_9 = vgui.Create( "DImageButton", skills_frame_slash )
            sk_s_s6_9:SetSize( 50, 50 )
            sk_s_s6_9:SetPos( 1280, 705 + 12 + 60 )
            sk_s_s6_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_s_s6_9.DoClick = function()
                PlaceholderFunction()
            end
        
        -- Sidebar
        skpic = vgui.Create( "DImage", skills_frame_slash )
            skpic:SetImage( skpic_a )
            skpic:SetPos( skills_frame_slash:GetWide() - 293, 68 )
            skpic:SetSize( 200, 200 )
            skpic:Hide()
        function DoDescs()

            -- Check if skill icon should be transparent or not.
            if IsValid( aimed_skill2 ) then 
                if plskills_a[ define_col ].equipped < 1 then
                    aimed_skill2:SetColor( unavailable )
                else
                    aimed_skill2:SetColor( Color( 255, 255, 255, 255 ) )
                end
            end

            if IsValid( sk_name ) then
                sk_name:Remove()
                sk_desc1:Remove()
            end

            if IsValid( aimed_skill2 ) then
                skpic:SetImage( skpic_a )
            end

            sk_name = vgui.Create( "RichText", skills_frame_slash )
                sk_name:SetVerticalScrollbarEnabled( false )
                sk_name:Hide()
                function sk_name:PerformLayout()
                    self:SetFontInternal( "equipment_plname3" )
                end
            sk_desc1 = vgui.Create( "RichText", skills_frame_slash )
                sk_desc1:SetVerticalScrollbarEnabled( false )
                sk_desc1:Hide()
                function sk_desc1:PerformLayout()
                    self:SetFontInternal( "equipment_plname2" )
                end
        end
        DoDescs()
        
        -- Upgrade button
        skupgrade = vgui.Create( "DButton", skills_frame_slash ) 
            skupgrade:SetPos( 1448, 740 )
            skupgrade:SetSize( 200, 60 )
            skupgrade.Paint = function( self, w, h )
                if playerstats_a["SLASH_POINTS"] > 0 and skillsbase[ define_col ].min <= playerstats_a["LVL3"] and skillsbase[ define_col ].max > plskills_a[ define_col ].Level then
                    draw.RoundedBoxEx(6, 0, 0, w, h, plcol, true, true, true, true )
                    skupgrade:SetMouseInputEnabled( true )
                else
                    draw.RoundedBoxEx(6, 0, 0, w, h, Color( plcol.x, plcol.y, plcol.z, 50 ), true, true, true, true )
                    skupgrade:SetMouseInputEnabled( false )
                end
            end
            skupgrade.DoClick = function()
                playerstats_a["SLASH_POINTS"] = playerstats_a["SLASH_POINTS"] - 1
                plskills_a[define_col].Level = plskills_a[define_col].Level + 1
                plskills_a[define_col].equipped = 1
                -- sk_name:Remove()
                -- sk_desc1:Remove()
                DoDescs()
                aimed_skill2.DoClick()
                madechanges = true
            end
            skupgrade:SetFont( "equipment_plname2" )
            skupgrade:SetTextColor( color_white )
            skupgrade:SetText( "Upgrade" )
            skupgrade:Hide()
        ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        local skpoints = vgui.Create( "DImage", skills_frame_slash )
            skpoints:SetImage( "menu/entourage_lvlpoint.png")
            skpoints:SetPos( 1370, skills_frame_slash:GetTall() - 60 )
            skpoints:SetSize( 50, 50 )

        -- Save & revert functionality - branded by LuminouscalesTech, all rights reserved.
        local sk_save = vgui.Create( "DImageButton", skills_frame_slash )
            sk_save:SetImage( "menu/entourage_save.png" )
            sk_save:SetSize( 35, 35 )
            sk_save:SetPos( skpoints:GetX(), skpoints:GetY() - skpoints:GetTall() )
            sk_save.DoClick = function()
                plskills = table.Copy( plskills_a )
                playerstats = table.Copy( playerstats_a )
                madechanges = false
                DoDescs()
                aimed_skill2.DoClick()
            end
        local sk_revert = vgui.Create( "DImageButton", skills_frame_slash )
            sk_revert:SetImage( "menu/entourage_revert.png" )
            sk_revert:SetSize( 35, 35 )
            sk_revert:SetPos( sk_save:GetX() + sk_save:GetWide() + 20, sk_save:GetY() )
            sk_revert.DoClick = function()
                plskills_a = table.Copy( plskills )
                playerstats_a = table.Copy( playerstats )
                madechanges = false
                DoDescs()
                aimed_skill2.DoClick()
            end
        sk_save:Hide()
        sk_revert:Hide()

        function skills_frame_slash:Think()
            if madechanges then
                sk_save:Show()
                sk_revert:Show()
            else
                sk_save:Hide()
                sk_revert:Hide()
            end
        end

    end)
    
end)