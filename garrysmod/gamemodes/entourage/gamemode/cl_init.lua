include( "shared.lua" )

include( "cl/datacontrol_cl.lua" )

include( "cl/menu/cl_menu_overview.lua" )
include( "cl/menu/cl_menu_skillsscreen.lua" )
	include( "cl/menu/skills/cl_menu_skillsscreen_slash.lua" )
	include( "cl/menu/skills/cl_menu_skillsscreen_pierce.lua" )
	include( "cl/menu/skills/cl_menu_skillsscreen_blunt.lua" )
include( "cl/menu/cl_menu_statsscreen.lua" )
include( "cl/menu/cl_menu_weaponsframe.lua" )

include( "cl/encountersystem_cl.lua" )
include( "cl/hud_cl.lua" )
include( "cl/battlesystem_cl.lua" )

-- Running without this timer breaks the script. Can't remember why. 
timer.Simple( 0.9, function()
	
	skills_frame:Close()
	skills_frame_slash:Close()
	skills_frame_pierce:Close()
	skills_frame_blunt:Close()

	-- These have to be parented again because the code for some reason refuses to do so by itself.
	-- Probably has something to do with the timer above, even though that doesn't make any sense either.
	skills_frame:SetParent( equipframe )
	skills_frame_slash:SetParent( equipframe )
	skills_frame_pierce:SetParent( equipframe )
	skills_frame_blunt:SetParent( equipframe )
	--------------------------------------------
	equipframe:Close()
end)

function PlaceholderFunction()
	print( "Debug message. Report this message to the developer." )
end

function DoDescs( frame )
	-- Check if skill icon should be transparent or not.
	if IsValid( aimed_skill2 ) then 
		if plskills_a[ define_col ].equipped < 1 then
			aimed_skill2:SetColor( Color( 255, 255, 255, 50 ) )
		else
			aimed_skill2:SetColor( Color( 255, 255, 255, 255 ) )
		end
	end

	if IsValid( sk_name ) then
		sk_name:Remove()
		sk_desc1:Remove()
		starlight:Remove()
	end

	if IsValid( aimed_skill2 ) then
		skpic:SetImage( skpic_a )
		skpic2:SetImage( skpic2_a )
	end

	starlight = vgui.Create( "DFrame", frame )
		starlight:SetPos( 1356, 0 )
		starlight:SetSize( 384, 400 )
		starlight:ShowCloseButton( false )
		starlight.Paint = function( self, w, h )
		end

	sk_name = vgui.Create( "DLabel", starlight )
		--sk_name:SetFont( "equipment_plname3" )
		sk_name:SetColor( color_white )
		sk_name:SetExpensiveShadow( 2, color_black )
		sk_name:Hide()

	sk_desc1 = vgui.Create( "RichText", frame )
		sk_desc1:SetVerticalScrollbarEnabled( false )
		sk_desc1:Hide()
		function sk_desc1:PerformLayout()
			self:SetFontInternal( "equipment_plname2" )
		end
end

--Fonts
surface.CreateFont( "equipment_big", {
	font = "Tajawal", 
	extended = false,
	size = 150,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont( "equipment_plname3", {
	font = "Tajawal", 
	extended = false,
	size = 60,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "equipment_plname5", {
	font = "Tajawal", 
	extended = false,
	size = 80,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "equipment_plname", {
	font = "Tajawal", 
	extended = false,
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont( "equipment_plname2", {
	font = "Tajawal", 
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "equipment_plname4", {
	font = "Tajawal", 
	extended = false,
	size = 35,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "danger_font", {
	font = "Tajawal", 
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont( "encounter_font", {
	font = "Tajawal", 
	extended = false,
	size = 125,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

net.Receive( "playersave", function()
	PlayerstatsSave()
end)

function draw.Circle( x, y, radius, seg, override )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * override )
		table.insert( cir, { 
			x = x + math.sin( a ) * radius,
			y = y + math.cos( a ) * radius, 
			u = math.sin( a ) / 2 + 0.5, 
			v = math.cos( a ) / 2 + 0.5 
		} )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function GM:AddDeathNotice() end
function GM:DrawDeathNotice() end
function GM:SpawnMenuEnabled() return false end
timer.Simple( 3, function()
	CreateContextMenu()	
end)