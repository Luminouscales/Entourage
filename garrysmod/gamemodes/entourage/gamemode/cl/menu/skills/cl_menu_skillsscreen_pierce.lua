hook.Add( "InitPostEntity", "fuck_pierce", function()
    timer.Simple( 0.5, function()
        -- Passive Skills
        local sk_p_p1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_p1:SetSize( 75, 75 )
            sk_p_p1:SetPos( 50, 167 )
            sk_p_p1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_p1.DoClick = function()
                PlaceholderFunction()
            end 

        local sk_p_p2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_p2:SetSize( 75, 75 )
            sk_p_p2:SetPos( 50, 460 - 25 )
            sk_p_p2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_p2.DoClick = function()
                PlaceholderFunction() 
            end

        local sk_p_p3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_p3:SetSize( 75, 75 )
            sk_p_p3:SetPos( 50, 705 )
            sk_p_p3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_p3.DoClick = function()
                PlaceholderFunction()
            end
        ------------------------
        -- Main skills
        --- Row 1
        local sk_p_m1_1 = vgui.Create( "DImageButton", skills_frame_pierce ) 
            sk_p_m1_1:SetSize( 50, 50 )
            sk_p_m1_1:SetPos( 225, 167 + 12 )
            sk_p_m1_1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m1_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m1_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m1_2:SetSize( 50, 50 )
            sk_p_m1_2:SetPos( 325, 167 + 12 )
            sk_p_m1_2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m1_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m1_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m1_3:SetSize( 50, 50 )
            sk_p_m1_3:SetPos( 425, 167 + 12 )
            sk_p_m1_3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m1_3.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 2
        local sk_p_m2_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m2_1:SetSize( 50, 50 )
            sk_p_m2_1:SetPos( 225, 460 - 25 + 12 )
            sk_p_m2_1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m2_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m2_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m2_2:SetSize( 50, 50 )
            sk_p_m2_2:SetPos( 325, 460 - 25 + 12 )
            sk_p_m2_2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m2_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m2_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m2_3:SetSize( 50, 50 )
            sk_p_m2_3:SetPos( 425, 460 - 25 + 12 )
            sk_p_m2_3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m2_3.DoClick = function()
                PlaceholderFunction()
            end
        --- Row 3
        local sk_p_m3_1 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m3_1:SetSize( 50, 50 )
            sk_p_m3_1:SetPos( 225, 705 + 12 )
            sk_p_m3_1:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m3_1.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m3_2 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m3_2:SetSize( 50, 50 )
            sk_p_m3_2:SetPos( 325, 705 + 12 )
            sk_p_m3_2:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m3_2.DoClick = function()
                PlaceholderFunction()
            end

        local sk_p_m3_3 = vgui.Create( "DImageButton", skills_frame_pierce )
            sk_p_m3_3:SetSize( 50, 50 )
            sk_p_m3_3:SetPos( 425, 705 + 12 )
            sk_p_m3_3:SetImage( "menu/entourage_skill_m_ph.png" )
            sk_p_m3_3.DoClick = function()
                PlaceholderFunction()
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
    end)
end)