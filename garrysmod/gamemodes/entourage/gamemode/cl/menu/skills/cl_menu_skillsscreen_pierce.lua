local unavailable = Color( 255, 255, 255, 50 )
local col_tier1 = Color( 255, 255, 255, 255 )
skpic2_a = "skills/entourage_s_precstrike.png"
local madechanges = false

function FuckMyLife2()
    sk_desc1:SetSize( 380, 380 )
    sk_desc1:SetPos( 1365, sk_name:GetY() + sk_name:GetTall() )
    sk_desc1:Show()
    skupgrade2:Show()
end

hook.Add( "InitPostEntity", "fuck_pierce", function()
    timer.Simple( 0.5, function()
        -- Passive Skills
        local s_sharpcare = vgui.Create( "DImageButton", skills_frame_pierce )
            s_sharpcare:SetSize( 75, 75 )
            s_sharpcare:SetPos( 50, 167 )
            s_sharpcare:SetImage( "skills/entourage_s_slasher.png" )
            s_sharpcare.DoClick = function()
                skpic2_a = s_sharpcare:GetImage()
                skpic2:Show()

                aimed_skill2 = s_sharpcare

                define_col = "s_sharpcare"
                define_text = "Sharp Care"

                DoDescs( skills_frame_pierce )

                DefineColour()

                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Increases all pierce damage by " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 5 * plskills_a["s_sharpcare"].Level .."% \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "Passive Skill \n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_sharpcare"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "/20" )

                FuckMyLife2()
            end
            

        local s_immaculate = vgui.Create( "DImageButton", skills_frame_pierce )
            s_immaculate:SetSize( 75, 75 )
            s_immaculate:SetPos( 50, 435 )
            s_immaculate:SetImage( "skills/entourage_s_immaculate.png" )
            s_immaculate.DoClick = function()
                skpic2_a = s_immaculate:GetImage()
                skpic2:Show()

                aimed_skill2 = s_immaculate

                define_col = "s_immaculate"
                define_text = "Immaculate Blades"

                DoDescs( skills_frame_pierce )

                DefineColour()

                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Increases pierce armour penetration by " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 5 * plskills_a["s_immaculate"].Level .."% \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "Passive Skill \n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_immaculate"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "/20" )

                FuckMyLife2()
            end

        local s_scrutiny = vgui.Create( "DImageButton", skills_frame_pierce )
            s_scrutiny:SetSize( 75, 75 )
            s_scrutiny:SetPos( 50, 705 )
            s_scrutiny:SetImage( "skills/entourage_s_scrutiny.png" )
            s_scrutiny.DoClick = function()
                skpic2_a = s_scrutiny:GetImage()
                skpic2:Show()

                aimed_skill2 = s_scrutiny

                define_col = "s_scrutiny"
                define_text = "Vile Scrutiny"

                DoDescs( skills_frame_pierce )

                DefineColour()

                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Increases critical strike chance by " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 5 * plskills_a["s_scrutiny"].Level .."% \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "Passive Skill \n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_scrutiny"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "/20" )

                FuckMyLife2()
            end
        ------------------------
        -- Main skills
        --- Row 1
        local s_performance = vgui.Create( "DImageButton", skills_frame_pierce ) 
            s_performance:SetSize( 50, 50 )
            s_performance:SetPos( 225, 167 + 12 )
            s_performance:SetImage( "skills/entourage_s_performance.png" )
            s_performance.DoClick = function()
                skpic2_a = s_performance:GetImage()
                skpic2:Show()

                aimed_skill2 = s_performance

                define_col = "s_performance"
                define_text = "Performance"

                DoDescs( skills_frame_pierce )

                DefineColour()

                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Strike all enemies for " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 55 + 5 * plskills_a["s_performance"].Level .."% " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " of base weapon damage. Heal allies for " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 5 + 5 * plskills_a["s_performance"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " HP. \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "3 turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "15 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_performance"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_performance"].equipped < 1 then
                s_performance:SetColor( unavailable )
            end 

        local s_dedications = vgui.Create( "DImageButton", skills_frame_pierce )
            s_dedications:SetSize( 50, 50 )
            s_dedications:SetPos( 325, 167 + 12 )
            s_dedications:SetImage( "skills/entourage_s_dedications.png" )
            s_dedications.DoClick = function()
                skpic2_a = s_dedications:GetImage()
                skpic2:Show()

                aimed_skill2 = s_dedications

                define_col = "s_dedications"
                define_text = "Dedications"

                DoDescs( skills_frame_pierce )
                DefineColour()
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Party gains " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 1 + 2 * plskills_a["s_dedications"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " flat damage and " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 1 + 4 * plskills_a["s_dedications"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " Defence for 4 turns; 10% of the bonus is retained permanently.\n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "4 turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "15 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_dedications"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_dedications"].equipped < 1 then
                s_dedications:SetColor( unavailable )
            end 

        local s_moderato = vgui.Create( "DImageButton", skills_frame_pierce )
            s_moderato:SetSize( 50, 50 )
            s_moderato:SetPos( 425, 167 + 12 )
            s_moderato:SetImage( "skills/entourage_s_moderato.png" )
            s_moderato.DoClick = function()
                skpic2_a = s_moderato:GetImage()
                skpic2:Show()

                aimed_skill2 = s_moderato

                define_col = "s_moderato"
                define_text = "Moderato"

                DoDescs( skills_frame_pierce )
                DefineColour()
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Party gains " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 20 + 5 * plskills_a["s_moderato"].Level .."%" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " accuracy and " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 10 + 5 * plskills_a["s_moderato"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " dodge chance for 2 turns. \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "2 turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "25 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_moderato"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_moderato"].equipped < 1 then
                s_moderato:SetColor( unavailable )
            end

        --- Row 2
        local s_heartcut = vgui.Create( "DImageButton", skills_frame_pierce )
            s_heartcut:SetSize( 50, 50 )
            s_heartcut:SetPos( 225, 460 - 25 + 12 )
            s_heartcut:SetImage( "skills/entourage_s_heartcut.png" )
            s_heartcut.DoClick = function()
                skpic2_a = s_heartcut:GetImage()
                skpic2:Show()

                aimed_skill2 = s_heartcut

                define_col = "s_heartcut"
                define_text = "Heartful Cut"

                DoDescs( skills_frame_pierce )
                DefineColour()
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Party gains " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 20 + 5 * plskills_a["s_heartcut"].Level .."%" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " accuracy and " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 10 + 5 * plskills_a["s_heartcut"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " dodge chance for 2 turns. \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "2 turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "25 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_heartcut"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_heartcut"].equipped < 1 then
                s_heartcut:SetColor( unavailable )
            end

        local sk_p_m2_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m2_2:SetSize( 50, 50 )
            sk_p_m2_2:SetPos( 325, 460 - 25 + 12 )
            sk_p_m2_2:SetImage( "skills/entourage_s_blank.png" )
            sk_p_m2_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m2_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m2_3:SetSize( 50, 50 )
            sk_p_m2_3:SetPos( 425, 460 - 25 + 12 )
            sk_p_m2_3:SetImage( "skills/entourage_s_blank.png" )
            sk_p_m2_3.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 3
        local s_zillionedge = vgui.Create( "DImageButton", skills_frame_pierce )
            s_zillionedge:SetSize( 50, 50 )
            s_zillionedge:SetPos( 225, 705 + 12 )
            s_zillionedge:SetImage( "skills/entourage_s_zillionedge.png" )
            s_zillionedge.DoClick = function()
                skpic2_a = s_zillionedge:GetImage()
                skpic2:Show()

                aimed_skill2 = s_zillionedge

                define_col = "s_zillionedge"
                define_text = "Zillion Edge"

                DoDescs( skills_frame_pierce )
                DefineColour()
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Deal " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 50 - 5 * plskills_a["s_zillionedge"].Level .."-".. 150 + 5 * plskills_a["s_zillionedge"].Level .."% ")
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "base weapon damage to one target. \n" )
                sk_desc1:AppendText( "\n" )
                sk_desc1:AppendText( "2 turn cooldown \n" )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( "15 " )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_zillionedge"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_zillionedge"].equipped < 1 then
                s_zillionedge:SetColor( unavailable )
            end

        local s_tknives = vgui.Create( "DImageButton", skills_frame_pierce )
            s_tknives:SetSize( 50, 50 )
            s_tknives:SetPos( 325, 705 + 12 )
            s_tknives:SetImage( "skills/entourage_s_tknives.png" )
            s_tknives.DoClick = function()
                skpic2_a = s_tknives:GetImage()
                skpic2:Show()

                aimed_skill2 = s_tknives

                define_col = "s_tknives"
                define_text = "Throwing Knives"

                DoDescs( skills_frame_pierce )
                DefineColour()
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Strike a random target 1-6 times for " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 30 + 3 * plskills_a["s_tknives"].Level .."%" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " base weapon damage. Gain " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 7 + 2 * plskills_a["s_tknives"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " dodge chance per each hit for 1 turn. \n\n" )
                sk_desc1:AppendText( "10 " )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_tknives"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_tknives"].equipped < 1 then
                s_tknives:SetColor( unavailable )
            end

        local s_qethics = vgui.Create( "DImageButton", skills_frame_pierce )
            s_qethics:SetSize( 50, 50 )
            s_qethics:SetPos( 425, 705 + 12 )
            s_qethics:SetImage( "skills/entourage_s_qethics.png" )
            s_qethics.DoClick = function()
                skpic2_a = s_qethics:GetImage()
                skpic2:Show()

                aimed_skill2 = s_qethics

                define_col = "s_qethics"
                define_text = "Questionable Ethics"

                DoDescs( skills_frame_pierce )
                DefineColour()
                DefineText()

                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "Heal yourself for 1% - " )
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( 25 + ( 5 * plskills_a["s_qethics"].Level + 5 ) .."%" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( " of your maximum HP.\n\n" )
                sk_desc1:InsertColorChange( 255, 255, 255, 255 )
                sk_desc1:AppendText( "20 " )
                sk_desc1:AppendText( "UP cost \n" )
                sk_desc1:AppendText( "Skill level: ")
                sk_desc1:InsertColorChange( plcol.x, plcol.y, plcol.z, 255 )
                sk_desc1:AppendText( plskills_a["s_qethics"].Level )
                sk_desc1:InsertColorChange( 255, 255, 255, 255)
                sk_desc1:AppendText( "/10")

                FuckMyLife2()
            end
            if plskills_a["s_qethics"].equipped < 1 then
                s_qethics:SetColor( unavailable )
            end
        ------------------------
        -- Subclass Skills
        --- Row 1
        local sk_p_s1_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s1_1:SetSize( 50, 50 )
            sk_p_s1_1:SetPos( 480, 167 + 12 - 60 )
            sk_p_s1_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s1_2:SetSize( 50, 50 )
            sk_p_s1_2:SetPos( 580, 167 + 12 - 60 )
            sk_p_s1_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_3 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s1_3:SetSize( 50, 50 )
            sk_p_s1_3:SetPos( 680, 167 + 12 - 60 )
            sk_p_s1_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_4 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s1_4:SetSize( 50, 50 )
            sk_p_s1_4:SetPos( 780, 167 + 12 - 60 )
            sk_p_s1_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_5 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s1_5:SetSize( 50, 50 )
            sk_p_s1_5:SetPos( 880, 167 + 12 - 60 )
            sk_p_s1_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_6 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s1_6:SetSize( 50, 50 )
            sk_p_s1_6:SetPos( 980, 167 + 12 - 60 )
            sk_p_s1_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_7 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s1_7:SetSize( 50, 50 )
            sk_p_s1_7:SetPos( 1080, 167 + 12 - 60 )
            sk_p_s1_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_7.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_8 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s1_8:SetSize( 50, 50 )
            sk_p_s1_8:SetPos( 1180, 167 + 12 - 60 )
            sk_p_s1_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s1_9 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s1_9:SetSize( 50, 50 )
            sk_p_s1_9:SetPos( 1280, 167 + 12 - 60 )
            sk_p_s1_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s1_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 2
        local sk_p_s2_1 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s2_1:SetSize( 50, 50 )
            sk_p_s2_1:SetPos( 480, 167 + 12 + 60 )
            sk_p_s2_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_2 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s2_2:SetSize( 50, 50 )
            sk_p_s2_2:SetPos( 580, 167 + 12 + 60 )
            sk_p_s2_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_3:SetSize( 50, 50 )
            sk_p_s2_3:SetPos( 680, 167 + 12 + 60 )
            sk_p_s2_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_4 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_4:SetSize( 50, 50 )
            sk_p_s2_4:SetPos( 780, 167 + 12 + 60 )
            sk_p_s2_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_5 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_5:SetSize( 50, 50 )
            sk_p_s2_5:SetPos( 880, 167 + 12 + 60 )
            sk_p_s2_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_6 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_6:SetSize( 50, 50 )
            sk_p_s2_6:SetPos( 980, 167 + 12 + 60 )
            sk_p_s2_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_7 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_7:SetSize( 50, 50 )
            sk_p_s2_7:SetPos( 1080, 167 + 12 + 60 )
            sk_p_s2_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_7.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_8 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_8:SetSize( 50, 50 )
            sk_p_s2_8:SetPos( 1180, 167 + 12 + 60 )
            sk_p_s2_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s2_9 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s2_9:SetSize( 50, 50 )
            sk_p_s2_9:SetPos( 1280, 167 + 12 + 60 )
            sk_p_s2_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s2_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 3
        local sk_p_s3_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_1:SetSize( 50, 50 )
            sk_p_s3_1:SetPos( 480, 460 - 25 + 12 - 60 )
            sk_p_s3_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_2:SetSize( 50, 50 )
            sk_p_s3_2:SetPos( 580, 460 - 25 + 12 - 60 )
            sk_p_s3_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_3:SetSize( 50, 50 )
            sk_p_s3_3:SetPos( 680, 460 - 25 + 12 - 60 )
            sk_p_s3_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_4 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_4:SetSize( 50, 50 )
            sk_p_s3_4:SetPos( 780, 460 - 25 + 12 - 60 )
            sk_p_s3_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_5 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_5:SetSize( 50, 50 )
            sk_p_s3_5:SetPos( 880, 460 - 25 + 12 - 60 )
            sk_p_s3_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_6 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_6:SetSize( 50, 50 )
            sk_p_s3_6:SetPos( 980, 460 - 25 + 12 - 60 )
            sk_p_s3_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_7 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_7:SetSize( 50, 50 )
            sk_p_s3_7:SetPos( 1080, 460 - 25 + 12 - 60 )
            sk_p_s3_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_7.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_8 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_8:SetSize( 50, 50 )
            sk_p_s3_8:SetPos( 1180, 460 - 25 + 12 - 60 )
            sk_p_s3_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s3_9 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s3_9:SetSize( 50, 50 )
            sk_p_s3_9:SetPos( 1280, 460 - 25 + 12 - 60 )
            sk_p_s3_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s3_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 4
        local sk_p_s4_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_1:SetSize( 50, 50 )
            sk_p_s4_1:SetPos( 480, 460 - 25 + 12 + 60 )
            sk_p_s4_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_2:SetSize( 50, 50 )
            sk_p_s4_2:SetPos( 580, 460 - 25 + 12 + 60 )
            sk_p_s4_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_3:SetSize( 50, 50 )
            sk_p_s4_3:SetPos( 680, 460 - 25 + 12 + 60 )
            sk_p_s4_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_4 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_4:SetSize( 50, 50 )
            sk_p_s4_4:SetPos( 780, 460 - 25 + 12 + 60 )
            sk_p_s4_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_5 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_5:SetSize( 50, 50 )
            sk_p_s4_5:SetPos( 880, 460 - 25 + 12 + 60 )
            sk_p_s4_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_6 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_6:SetSize( 50, 50 )
            sk_p_s4_6:SetPos( 980, 460 - 25 + 12 + 60 )
            sk_p_s4_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_7 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_7:SetSize( 50, 50 )
            sk_p_s4_7:SetPos( 1080, 460 - 25 + 12 + 60 )
            sk_p_s4_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_7.DoClick = function()
                PlaceholderFunction()
            end
        
        local sk_p_s4_8 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_8:SetSize( 50, 50 )
            sk_p_s4_8:SetPos( 1180, 460 - 25 + 12 + 60 )
            sk_p_s4_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s4_9 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s4_9:SetSize( 50, 50 )
            sk_p_s4_9:SetPos( 1280, 460 - 25 + 12 + 60 )
            sk_p_s4_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s4_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 5
        local sk_p_s5_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_1:SetSize( 50, 50 )
            sk_p_s5_1:SetPos( 480, 705 + 12 - 60 )
            sk_p_s5_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_2:SetSize( 50, 50 )
            sk_p_s5_2:SetPos( 580, 705 + 12 - 60 )
            sk_p_s5_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_3:SetSize( 50, 50 )
            sk_p_s5_3:SetPos( 680, 705 + 12 - 60 )
            sk_p_s5_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_4 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_4:SetSize( 50, 50 )
            sk_p_s5_4:SetPos( 780, 705 + 12 - 60 )
            sk_p_s5_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_5 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_5:SetSize( 50, 50 )
            sk_p_s5_5:SetPos( 880, 705 + 12 - 60 )
            sk_p_s5_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_6 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s5_6:SetSize( 50, 50 )
            sk_p_s5_6:SetPos( 980, 705 + 12 - 60 )
            sk_p_s5_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_7 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_7:SetSize( 50, 50 )
            sk_p_s5_7:SetPos( 1080, 705 + 12 - 60 )
            sk_p_s5_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_7.DoClick = function()
                PlaceholderFunction()
            end
        
        local sk_p_s5_8 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_8:SetSize( 50, 50 )
            sk_p_s5_8:SetPos( 1180, 705 + 12 - 60 )
            sk_p_s5_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s5_9 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s5_9:SetSize( 50, 50 )
            sk_p_s5_9:SetPos( 1280, 705 + 12 - 60 )
            sk_p_s5_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s5_9.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 6
        local sk_p_s6_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_1:SetSize( 50, 50 )
            sk_p_s6_1:SetPos( 480, 705 + 12 + 60 )
            sk_p_s6_1:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_2:SetSize( 50, 50 )
            sk_p_s6_2:SetPos( 580, 705 + 12 + 60 )
            sk_p_s6_2:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_3:SetSize( 50, 50 )
            sk_p_s6_3:SetPos( 680, 705 + 12 + 60 )
            sk_p_s6_3:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_3.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_4 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_4:SetSize( 50, 50 )
            sk_p_s6_4:SetPos( 780, 705 + 12 + 60 )
            sk_p_s6_4:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_4.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_5 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_s6_5:SetSize( 50, 50 )
            sk_p_s6_5:SetPos( 880, 705 + 12 + 60 )
            sk_p_s6_5:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_5.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_6 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_6:SetSize( 50, 50 )
            sk_p_s6_6:SetPos( 980, 705 + 12 + 60 )
            sk_p_s6_6:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_6.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_7 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_7:SetSize( 50, 50 )
            sk_p_s6_7:SetPos( 1080, 705 + 12 + 60 )
            sk_p_s6_7:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_7.DoClick = function()
                PlaceholderFunction()
            end
        
        local sk_p_s6_8 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_8:SetSize( 50, 50 )
            sk_p_s6_8:SetPos( 1180, 705 + 12 + 60 )
            sk_p_s6_8:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_8.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_s6_9 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_s6_9:SetSize( 50, 50 )
            sk_p_s6_9:SetPos( 1280, 705 + 12 + 60 )
            sk_p_s6_9:SetImage( "menu/entourage_skill_s_ph.png" )
            sk_p_s6_9.DoClick = function()
                PlaceholderFunction()
            end

            -- Sidebar
        skpic2 = vgui.Create( "DImage", skills_frame_pierce )
            skpic2:SetImage( skpic2_a )
            skpic2:SetPos( skills_frame_pierce:GetWide() - 293, 68 )
            skpic2:SetSize( 200, 200 )
            skpic2:Hide()
        
        -- This function is defined in Slash already
        DoDescs( skills_frame_pierce )
    
    -- Upgrade button
        skupgrade2 = vgui.Create( "DButton", skills_frame_pierce ) 
            skupgrade2:SetPos( 1448, 740 )
            skupgrade2:SetSize( 200, 60 )
            skupgrade2.Paint = function( self, w, h )
                if playerstats_a["PIERCE_POINTS"] > 0 and skillsbase[ define_col ].min <= playerstats_a["LVL3"] and skillsbase[ define_col ].max > plskills_a[ define_col ].Level then
                    draw.RoundedBoxEx(6, 0, 0, w, h, plcol, true, true, true, true )
                    skupgrade2:SetMouseInputEnabled( true )
                else
                    draw.RoundedBoxEx(6, 0, 0, w, h, Color( plcol.x, plcol.y, plcol.z, 50 ), true, true, true, true )
                    skupgrade2:SetMouseInputEnabled( false )
                end
            end
        skupgrade2.DoClick = function()
            playerstats_a["PIERCE_POINTS"] = playerstats_a["PIERCE_POINTS"] - 1
            plskills_a[define_col].Level = plskills_a[define_col].Level + 1
            if plskills_a[define_col].equipped ~= 2 then
                plskills_a[define_col].equipped = 1
            end
            DoDescs( skills_frame_pierce )
            aimed_skill2.DoClick()
            madechanges = true
        end
        skupgrade2:SetFont( "equipment_plname2" )
        skupgrade2:SetTextColor( color_white )
        skupgrade2:SetText( "Upgrade" )
        skupgrade2:Hide()
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local skpoints = vgui.Create( "DImage", skills_frame_pierce )
        skpoints:SetImage( "menu/entourage_lvlpoint.png")
        skpoints:SetPos( 1370, skills_frame_pierce:GetTall() - 60 )
        skpoints:SetSize( 50, 50 )

    -- Save & revert functionality - branded by LuminouscalesTech, all rights reserved.
    local sk_save = vgui.Create( "DImageButton", skills_frame_pierce )
        sk_save:SetImage( "menu/entourage_save.png" )
        sk_save:SetSize( 35, 35 )
        sk_save:SetPos( skpoints:GetX(), skpoints:GetY() - skpoints:GetTall() )
        sk_save.DoClick = function()
            plskills = table.Copy( plskills_a )
            playerstats = table.Copy( playerstats_a )
            madechanges = false
            DoDescs( skills_frame_pierce )
            aimed_skill2.DoClick()
        end
    local sk_revert = vgui.Create( "DImageButton", skills_frame_pierce )
        sk_revert:SetImage( "menu/entourage_revert.png" )
        sk_revert:SetSize( 35, 35 )
        sk_revert:SetPos( sk_save:GetX() + sk_save:GetWide() + 20, sk_save:GetY() )
        sk_revert.DoClick = function()
            plskills_a = table.Copy( plskills )
            playerstats_a = table.Copy( playerstats )
            madechanges = false
            DoDescs( skills_frame_pierce )
            aimed_skill2.DoClick()
        end
    sk_save:Hide()
    sk_revert:Hide()

    function skills_frame_pierce:Think()
        if madechanges then
            sk_save:Show()
            sk_revert:Show()
        else
            sk_save:Hide()
            sk_revert:Hide()
        end
    end

    local sk_s_cover = vgui.Create( "DImage", skills_frame_pierce )
        sk_s_cover:SetImage( "menu/entourage_cover.png" )
        sk_s_cover:SetSize( 870, 805 )
        sk_s_cover:SetPos( 480, 70 )
    end)
end)