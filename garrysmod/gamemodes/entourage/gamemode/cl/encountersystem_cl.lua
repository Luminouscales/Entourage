encounter_rate3 = 0
inbattle = false

function EncounterNormalText1()
	local start = SysTime()
	hook.Add( "HUDPaint", "enc_n_t1", function()
		draw.SimpleTextOutlined( "Encounter!", "encounter_font", Lerp( ( SysTime() - start ) / 2, -75, ScrW()+250), ScrH()/2, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(0, 0, 0, 255) )
	end)
	inbattle = true

	if SysTime() - start > 2 then
		start = SysTime()
	end
end

net.Receive( "encounter_var", function()
	encounter_rate4 = net.ReadInt( 32 )   
	print( encounter_rate4 ) 
end)

net.Receive( "encounter_cl", function()
	hook.Add( "Tick", "encounter_hook_cl", function()
		if tostring( Entity(1):GetVelocity() ) > tostring( Vector(0, 0, 0) ) then
			encounter_rate3 = encounter_rate3 + 0.8
		end
		if encounter_rate3 >= encounter_rate4 then 
			encounter_rate3 = 0
			hook.Remove( "Tick", "encounter_hook_cl" )
		end
	end)	
end)
