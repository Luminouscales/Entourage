zone1_3 = {
    "SnowtlionScout()",
    "SnowtlionScout()",
    "SnowtlionScout()",
    -- "SnowtlionSkinner()",
    -- "SnowtlionSkinner()",
    -- "SnowtlionMiner()"
}




-- Intro anim for antlion enemies
function AntUnborrow()
    local ant = necessity
    -- this ensures the antlion is invisible when spawned
    ant:DrawShadow( false )
    ant:SetRenderMode( RENDERMODE_NONE )
    -- after a given random amount of time, make visible and dig out
    timer.Simple( 0.3 + math.random( 0.1, 0.2 ), function()
        ant:ResetSequence( "digout" )
        ant:DrawShadow( true )
        ant:SetRenderMode( RENDERMODE_NORMAL )
        timer.Simple( 1, function()
            if math.random( 1, 10 ) == 1 then
                ant:ResetSequence( "distract" )
                ant:EmitSound( "npc/antlion/attack_double3.wav", 75, 100, 1, CHAN_VOICE, SND_DELAY )
                timer.Simple( 3, function()
                    ant:ResetSequence( table.Random( antlion_idle ) )
                end)
            else
                ant:ResetSequence( table.Random( antlion_idle ) )
            end
        end)
    end)
end

function SnowtlionScout()
    necessity = ents.Create( "npc_antlion" ) 
        -- necessity:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
		necessity:SetPos( enemypos_placeholder )
		necessity:SetAngles( Angle( 0, 90, 0 ) )
		necessity:SetName( "Frostlion Scout" ) 
        necessity:SetNWString( "nameNW", "Frostlion Scout" ) 
        --SetKeyValue( "startburrowed", 1 )
		necessity:Spawn()
        necessity:SetSkin( 4 )
        health = math.random( 29, 37 )
		necessity:SetMaxHealth( health )
		necessity:SetHealth( health )
        necessity:SetNWString( "nwhudname", "Frostlion Scout" )
        necessity:SetNWFloat( "animend", 1.5 )
        -- Define whether the enemy has an alternate end animation outside of "idle"
        -- Set 0 for values that are unused.
        necessity:SetNWString( "animend_a", 0 )
        necessity:SetNWFloat( "animend_b", 0 )
        ----------------------------------------------------------------------------
        necessity:SetNWString( "animstart", "attack1" )
        AntUnborrow()
        
		lives = lives + 1
        battle_enemies[lives] = necessity
end

function SnowtlionSkinner()
    necessity = ents.Create( "npc_antlion" )
        necessity:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
		necessity:SetPos( enemypos_placeholder )
		necessity:SetAngles( Angle( 0, 90, 0 ) )
		necessity:SetName( "Frostlion Skinner" ) 
        necessity:SetNWString( "nameNW", "Frostlion Skinner" ) 
        -- necessity:SetKeyValue( "startburrowed", 1 )
		necessity:Spawn()
        necessity:SetSkin( 1 )
        health = math.random( 18, 25 )
		necessity:SetMaxHealth( health )
		necessity:SetHealth( health )
        necessity:SetNWString( "nwhudname", "Frostlion Skinner" )
        necessity:SetModelScale( 0.9, 0 )
        necessity:SetNWFloat( "animend", 1.5 )
        necessity:SetNWString( "animstart", "attack2" )
        necessity:SetNWString( "animend_a", 0 )
        necessity:SetNWFloat( "animend_b", 0 )
        necessity:SetNWFloat( "scaleNW", 0.9 )
        AntUnborrow()
		
		lives = lives + 1
        battle_enemies[lives] = necessity
end

function SnowtlionMiner()
    necessity = ents.Create( "npc_antlion" )
        necessity:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
		necessity:SetPos( enemypos_placeholder )
		necessity:SetAngles( Angle( 0, 90, 0 ) )
		necessity:SetName( "Frostlion Miner" ) 
        necessity:SetNWString( "nameNW", "Frostlion Miner" ) 
       -- necessity:SetKeyValue( "startburrowed", 1 )
		necessity:Spawn()
        necessity:SetSkin( 2 )
        health = math.random( 40, 60 )
		necessity:SetMaxHealth( health )
		necessity:SetHealth( health )
        necessity:SetNWString( "nwhudname", "Frostlion Miner" )
        necessity:SetModelScale( 1.15, 0 )
        necessity:SetNWFloat( "animend", 0.5 )
        necessity:SetNWString( "animstart", "charge_start" )
        necessity:SetNWString( "animend_a", "charge_end" )
        necessity:SetNWFloat( "animend_b", 1.3 )
        necessity:SetNWFloat( "scaleNW", 1.15 )
        AntUnborrow()
		
		lives = lives + 1
        battle_enemies[lives] = necessity
end

function EncounterAntlion() -- Function for spawning antlions.

    
    enemypos_placeholder = Vector( -80, -234, -982 )
    RunString( table.Random( zone1_3 ) )
    enemy1 = necessity

	
    timer.Simple( 0.5, function()
        if math.random( 1, 2 ) == 2 then -- 50% chance, right antlion
            enemypos_placeholder = Vector( 60, -234, -982 )
            RunString( table.Random( zone1_3 ) )
            enemy2 = necessity
        end
    end)

    timer.Simple( 1, function()
        if math.random( 1, 4 ) == 1 then -- 25% chance, left antlion
            enemypos_placeholder = Vector( -225, -234, -982 )
            RunString( table.Random( zone1_3 ) )
            enemy3 = necessity
        end
    end)

	timer.Simple(1.25, function()
        sendIDs()
	end)

end


-- Unique: Chapter 1 Boss
function FrostlionGuardian()
    guardian = ents.Create( "npc_antlionguard" )
        guardian:SetKeyValue( "spawnflags", SF_NPC_WAIT_FOR_SCRIPT )
        guardian:SetPos( Vector( -80, -234, -982 ) )
        guardian:SetAngles( Angle( 0, 90, 0 ) )
        guardian:SetName( "Frostlion Guardian" ) 
        guardian:SetNWString( "nameNW", "Frostlion Guardian" ) 
        guardian:Spawn()
        local health = 1000
        guardian:SetMaxHealth( health )
        guardian:SetHealth( health )
        guardian:SetNWString( "nwhudname", "Frostlion Guardian" )
        guardian:SetModelScale( 1.15, 0 )
        guardian:SetNWFloat( "animend", 0.5 )
        guardian:SetNWString( "animstart", "shove" )
        --guardian:SetNWString( "animend_a", "charge_end" )
        --guardian:SetNWFloat( "animend_b", 1.3 )
        guardian:SetNWFloat( "scaleNW", 1.15 )

        enemy1 = guardian
        lives = lives + 1
        battle_enemies[lives] = guardian
end

function EncounterGuardian()
    doom = Color( 255, 40, 40 )
    stakes = 2
    EncounterInit()

    timer.Simple( 3, function()
        FrostlionGuardian()
    end)
    
    timer.Simple( 4.25, function()
        sendIDs()
    end)

end

function sendIDs()
    net.Start( "enemysend" ) -- Send enemy ID
        net.WriteEntity( enemy1 )
        net.WriteEntity( enemy2 )
        net.WriteEntity( enemy3 )
    net.Broadcast()
    actions = #battle_enemies
    previous_enemya = 0
    for k, v in ipairs( battle_enemies ) do
        v:SetNWInt( "tbl_deaths", k )
    end
end