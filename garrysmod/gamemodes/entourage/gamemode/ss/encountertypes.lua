zone1_3 = {
    "SnowtlionScout()",
    "SnowtlionScout()",
    "SnowtlionScout()",
    "SnowtlionSkinner()",
    "SnowtlionSkinner()",
    "SnowtlionMiner()"
}

function SnowtlionScout()
    necessity = ents.Create( "npc_antlion" ) 
        necessity:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
		necessity:SetPos( enemypos_placeholder )
		necessity:SetAngles( Angle( 0, 90, 0 ) )
		necessity:SetName( "Snowtlion Scout" ) 
        necessity:SetNWString( "nameNW", "Snowtlion Scout" ) 
		necessity:Spawn()
        necessity:SetSkin( 4 )
        health = math.random( 29, 37 )
		necessity:SetMaxHealth( health )
		necessity:SetHealth( health )
        necessity:SetNWString( "nwhudname", "Snowtlion Scout" )
        necessity:SetNWFloat( "animend", 1.5 )
        -- Define whether the enemy has an alternate end animation outside of "idle"
        -- Set 0 for values that are unused.
        necessity:SetNWString( "animend_a", 0 )
        necessity:SetNWFloat( "animend_b", 0 )
        ----------------------------------------------------------------------------
        necessity:SetNWString( "animstart", "attack1" )
        
		lives = lives + 1
        print( lives )
end

function SnowtlionSkinner()
    necessity = ents.Create( "npc_antlion" )
        necessity:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
		necessity:SetPos( enemypos_placeholder )
		necessity:SetAngles( Angle( 0, 90, 0 ) )
		necessity:SetName( "Snowtlion Skinner" ) 
        necessity:SetNWString( "nameNW", "Snowtlion Skinner" ) 
		necessity:Spawn()
        necessity:SetSkin( 1 )
        health = math.random( 18, 25 )
		necessity:SetMaxHealth( health )
		necessity:SetHealth( health )
        necessity:SetNWString( "nwhudname", "Snowtlion Skinner" )
        necessity:SetModelScale( 0.9, 0 )
        necessity:SetNWFloat( "animend", 1.5 )
        necessity:SetNWString( "animstart", "attack2" )
        necessity:SetNWString( "animend_a", 0 )
        necessity:SetNWFloat( "animend_b", 0 )
        necessity:SetNWFloat( "scaleNW", 0.9 )
		
		lives = lives + 1
        print( lives )
end

function SnowtlionMiner()
    necessity = ents.Create( "npc_antlion" )
        necessity:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
		necessity:SetPos( enemypos_placeholder )
		necessity:SetAngles( Angle( 0, 90, 0 ) )
		necessity:SetName( "Snowtlion Miner" ) 
        necessity:SetNWString( "nameNW", "Snowtlion Miner" ) 
		necessity:Spawn()
        necessity:SetSkin( 2 )
        health = math.random( 40, 60 )
		necessity:SetMaxHealth( health )
		necessity:SetHealth( health )
        necessity:SetNWString( "nwhudname", "Snowtlion Miner" )
        necessity:SetModelScale( 1.15, 0 )
        necessity:SetNWFloat( "animend", 0.5 )
        necessity:SetNWString( "animstart", "charge_start" )
        necessity:SetNWString( "animend_a", "charge_end" )
        necessity:SetNWFloat( "animend_b", 1.3 )
        necessity:SetNWFloat( "scaleNW", 1.15 )
		
		lives = lives + 1
        print( lives )
end

function EncounterAntlion() -- Function for spawning antlions.

    
    enemypos_placeholder = Vector( -80, -234, -982 )
    RunString( table.Random( zone1_3 ) )
    enemy1 = necessity

	
    timer.Simple( 0.5, function()
        if math.random( 1, 10 ) >= 5 then -- 50% chance, right antlion
            enemypos_placeholder = Vector( 60, -234, -982 )
            RunString( table.Random( zone1_3 ) )
            enemy2 = necessity

        end
    end)

    timer.Simple( 1, function()
        if math.random( 1, 100 ) >= 75 then -- 25% chance, left antlion

            enemypos_placeholder = Vector( -225, -234, -982 )
            RunString( table.Random( zone1_3 ) )
            enemy3 = necessity

        end
    end)

	timer.Simple(1.5, function()
		net.Start( "enemysend" ) -- Send enemy ID
			net.WriteEntity( enemy1 )
			net.WriteEntity( enemy2 )
			net.WriteEntity( enemy3 )
		net.Broadcast()
	end)

end