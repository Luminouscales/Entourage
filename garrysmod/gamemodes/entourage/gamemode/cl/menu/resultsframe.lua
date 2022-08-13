results_frame = vgui.Create( "DFrame" )
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
results_frame:Hide()

local closebutton = vgui.Create( "DImageButton", results_frame )
closebutton:SetImage( "icon16/cross.png" )
closebutton:SetSize( 15, 15 )
closebutton:SetPos( 5, 5 )
closebutton.DoClick = function()
    results_frame:Hide()
    if dropitemtable[1] then -- if there are unobtained items
        noinventory_frame:Show()
        WeaponGrid_noinventory()
    end
end

resultsframe_exp = vgui.Create( "RichText", results_frame )
    resultsframe_exp:SetVerticalScrollbarEnabled( false )
    resultsframe_exp:SetSize( 600, 800 )
    resultsframe_exp:SetPos( 10, 35 )
    function resultsframe_exp:PerformLayout()
        self:SetFontInternal( "equipment_plname2" )
    end

function UpdateResultsText()
    resultsframe_exp:SetText("")
    resultsframe_exp:InsertColorChange( 255, 255, 255, 255 )
    resultsframe_exp:AppendText( "Experience Gained: ".. tostring( exp_real ) .."\n" )
    resultsframe_exp:AppendText( "Current level: ".. playerstats_a["LVL3"] .." - ".. playerstats_a["LVL1"] .."/".. playerstats_a["LVL2"] .." experience\n" )
    if just_leveledup == true then
        resultsframe_exp:InsertColorChange( 235, 255, 40, 255 )
        resultsframe_exp:AppendText( "You just leveled up! You are now level ".. playerstats_a["LVL3"] .."\n")
        resultsframe_exp:AppendText( "You now have ".. playerstats_a["LVL_POINTS"] .." upgrade points.\n" )
    end
    if dropitemtable2[1] then -- if there are items
        resultsframe_exp:InsertColorChange( 255, 255, 255, 255 )
        resultsframe_exp:AppendText( "Items found:")

        for k, v in ipairs( dropitemtable2 ) do
            resultsframe_exp:InsertColorChange( 235, 255, 40, 255 )
            resultsframe_exp:AppendText( " ".. items_table[v[1]]["Name"] )
            if k ~= #dropitemtable2 then
                resultsframe_exp:InsertColorChange( 255, 255, 255, 255 )
                resultsframe_exp:AppendText( "," )
            end
        end
    end
end

-- Item drops
net.Receive( "dropitem", function()
    local name = net.ReadString()
    local type = net.ReadUInt( 3 )
    local table = {}
    local empty = "p"
    local position = #dropitemtable + 1

    dropitemtable[ position ] = { name, type }
    dropitemtable2[ #dropitemtable2 + 1 ] = { name, type }

    if type == 1 then -- if weapon
        table = plweapons
        empty = "EmptySlot"
    elseif type == 2 then -- if armour
        table = plarmours
        empty = "EmptySlot2"
    elseif type == 3 then -- if trinket
        table = pltrinkets
        empty = "EmptySlot3"
    else -- if consumable
        PlaceholderFunction()
    end

    for k, v in ipairs(table) do
        if v["Item"] == empty then
            v["Item"] = name
            Fuckk( position ) -- table.remove doesn't work in net functions. Why? Beats me.
        return end
    end
end)

function Fuckk( position )
    table.remove( dropitemtable, position )
end

-- Full inventory screen
noinventory_frame = vgui.Create( "DFrame" )
    noinventory_frame:SetSize( 1370, 520 )
    noinventory_frame:Center()
    noinventory_frame:SetDraggable( false )
    noinventory_frame:SetTitle( "" )
    noinventory_frame:ShowCloseButton( false )
    noinventory_frame.Paint = function( self, w, h )
        draw.RoundedBox( 8, 0, 0, w, h, Color( 110, 110, 115, 240 ) )
        draw.RoundedBoxEx( 6, 0, 0, w, 25, plcol, true, true, false, false )
        draw.SimpleText( "Results!", "equipment_plname4", w/2, 10, color_white, a, a )
        draw.SimpleText( "Your inventory is full - choose an item to discard.", "equipment_plname2", w/2, 60, color_white, a, a )
    end
    noinventory_frame:Hide()

image_check4 = vgui.Create( "DImage", noinventory_frame)
    image_check4:SetSize( 100, 100 )
    image_check4:SetPos( 690, 100 )
    image_check4:SetImage( "entourage_checkedslot2.png" )

discarditem = vgui.Create( "DButton", noinventory_frame )
    discarditem:SetSize( 260, 60 )
    discarditem:SetPos( noinventory_frame:GetWide()/2 - discarditem:GetWide()/2, 435 )
    discarditem:SetText( "" )
    discarditem.Paint = function( self, w, h )
        draw.RoundedBox( 8, 0, 0, w, h, Color( 235, 35, 40 ))     
        draw.SimpleText( "DISCARD", "equipment_plname2", w/2, 30, color_white, a, a )
    end
    discarditem.DoDoubleClick = function( self )
        if selfpos then
            typetable[ selfpos ] = { ["Item"] = dropitemtable[1][1] }
        end
        table.remove( dropitemtable, 1 )
        if dropitemtable[1] then
            WeaponGrid_noinventory()
            rt_weapon_noi()
        else
            noinventory_frame:Hide()
        end
    end

function WeaponGrid_noinventory()

    typetable = {}
    typeweapon = dropitemtable[ 1 ][2]

    if typeweapon == 1 then
        typetable = plweapons
    elseif typeweapon == 2 then
        typetable = plarmours
    else 
        typetable = pltrinkets
    end

    image_check4:SetParent( weapons_frame )
    image_check4:SetParent( noinventory_frame )

    for _, v in ipairs( noinventory_frame:GetChildren() ) do -- Delete existing weapon buttons
        if v:GetName() == "DImageButton" then
            v:Remove()
        end
    end
    for k, v in pairs( typetable ) do
        PrintTable( typetable )
        local weaponbutton = vgui.Create( "DImageButton", noinventory_frame ) 
            weaponbutton:SetImage( items_table[ v["Item"] ].Icon )
            weaponbutton:SetSize( 100, 100 )
            weaponbutton.DoClick = function( self )
                noimenuwep = items_table[ v["Item"] ].Name
                noimenuwep2 = items_table[ v["Item"] ].Desc
                noimenuwep4 = items_table[ v["Item"] ].Desc2

                if typeweapon == 1 then
                    noimenuwep5 = items_table[ v["Item"] ].Desc3
                
                    if items_table[ v["Item"] ].dmgtype == "Slash" then
                        noimenuwep3 = items_table[ v["Item"] ].DMG1.. "-".. items_table[ v["Item"] ].DMG2 .." Slash damage"
                    elseif items_table[ v["Item"] ].dmgtype == "Pierce" then
                        noimenuwep3 = items_table[ v["Item"] ].DMG3 .." Pierce damage"
                    elseif items_table[ v["Item"] ].dmgtype == "Blunt" then
                        noimenuwep3 = items_table[ v["Item"] ].DMG4.. "-".. items_table[ v["Item"] ].DMG5 .." Blunt damage"
                    else
                        noimenuwep3 = items_table[ v["Item"] ].DMG1.. "-".. items_table[ v["Item"] ].DMG2 .." Slash damage, ".. items_table[ v["Item"] ].DMG3 .." Pierce damage, ".. items_table[ v["Item"] ].DMG4.. "-".. items_table[ v["Item"] ].DMG5 .." Blunt damage"
                    end
                elseif typeweapon == 2 then
                    noiarmour1 = items_table[ dropitemtable[1][1] ]["PDEF"]
                    noiarmour2 = items_table[ dropitemtable[1][1] ]["PDFX"]
                end

                image_check4:SetParent( weapons_frame )
                image_check4:SetParent( noinventory_frame )
                image_check4:SetPos( self:GetPos() )

                rt_weapon_noi( typeweapon )

                selfpos = k
            end

            if k < 7 then
                weaponbutton:SetPos( ( k * 100 - 100 + k * 5 - 5 ) + 50, 100 )
            elseif k < 13 then
                weaponbutton:SetPos( ( k * 100 - 700 + k * 5 - 35 ) + 50, 205 )
            else 
                weaponbutton:SetPos( ( k * 100 - 1300 + k * 5 - 65 ) + 50 , 310 ) 
            end
    end

    -- Button showing item
    local itemname = dropitemtable[1][1]
    local weaponbutton2 = vgui.Create( "DImageButton", noinventory_frame )
        weaponbutton2:SetImage( items_table[ itemname ].Icon )
        weaponbutton2:SetSize( 100, 100 )
        weaponbutton2:SetPos( 690, 100 )
        weaponbutton2.DoClick = function( self )
            noimenuwep = items_table[ itemname ].Name

            noimenuwep4 = items_table[ itemname ].Desc2
            if typeweapon == 1 then
                noimenuwep5 = items_table[ itemname ].Desc3

                if items_table[ itemname ].dmgtype == "Slash" then
                    noimenuwep3 = items_table[ itemname ].DMG1.. "-".. items_table[ itemname ].DMG2 .." Slash damage"
                elseif items_table[ itemname ].dmgtype == "Pierce" then
                    noimenuwep3 = items_table[ itemname ].DMG3 .." Pierce damage"
                elseif items_table[ itemname ].dmgtype == "Blunt" then
                    noimenuwep3 = items_table[ itemname ].DMG4.. "-".. items_table[ itemname ].DMG5 .." Blunt damage"
                else
                    noimenuwep3 = items_table[ itemname ].DMG1.. "-".. items_table[ itemname ].DMG2 .." Slash damage, ".. items_table[ itemname ].DMG3 .." Pierce damage, ".. items_table[ itemname ].DMG4.. "-".. items_table[ v["Item"] ].DMG5 .." Blunt damage"
                end
            elseif typeweapon == 2 then
                noiarmour1 = items_table[ dropitemtable[1][1] ]["PDEF"]
                noiarmour2 = items_table[ dropitemtable[1][1] ]["PDFX"]
            end

            image_check4:SetParent( weapons_frame )
            image_check4:SetParent( noinventory_frame )
            image_check4:SetPos( self:GetPos() )

            rt_weapon_noi( typeweapon )

            selfpos = nil
        end

    weaponbutton2.DoClick( weaponbutton2 )
end

function rt_weapon_noi( type )
    if IsValid( rt_weapontext ) then -- if exists (button pressed)
        rt_weapontext:Remove()
    end
    rt_weapontext = vgui.Create( "RichText", noinventory_frame )
        rt_weapontext:SetSize( 680, 210 )
        rt_weapontext:SetPos( 685, 200 )
        rt_weapontext:SetVerticalScrollbarEnabled( false )
        rt_weapontext:InsertColorChange( 255, 255, 255, 255 )
        rt_weapontext:AppendText( noimenuwep .."\n" )
        if type == 1 then
            rt_weapontext:AppendText( noimenuwep3 .."\n" )
            rt_weapontext:AppendText( noimenuwep5 .."\n" )
        elseif type == 2 then
            rt_weapontext:AppendText( noiarmour1 .." Defence\n" )
            rt_weapontext:AppendText( noiarmour2 .." Flex Defence\n" )
        end
        rt_weapontext:AppendText( noimenuwep4 .."\n" )
        
    function rt_weapontext:PerformLayout()
        self:SetFontInternal( "equipment_plname2" )
    end
end
