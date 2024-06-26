-- This is the script for Frostlion Guardian's battle.

sktbl_guardian = {
    "Guardian_Bash()",
    "Guardian_Stagger()"
}

function GuardianAI()
    attacktarget = table.Random( allplayers )
    attacktarget_id = attacktarget:UserID()
    enemy1:UseNoBehavior()
    enemy1:SetNPCState( NPC_STATE_SCRIPT )
    enemy1:ResetSequenceInfo()
    -- Call allies every 5 turns
    if g_stampede ~= true then
        if g_sudety ~= true then
            if turn % 10 == 0 then -- Do charge attack every 10 turns
                BattleCry()
            elseif turn % 5 == 0 then 
                Guardian_AllyCall()
            else
                RunString( table.Random( sktbl_guardian ) )
            end
        else
            Sudety()
            g_sudety = false
        end
    else
        Stampede()
    end
end

-- Skills
function Guardian_Bash()
    SendSkillNote( "Bash" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "shove" )

    timer.Simple( 0.5, function()
        strikepos = Entity(1):EyePos( ) + Vector( 0, -15, -15 )
        strikevel = Vector( math.random( 7500, -7500 ), 10000, 7500 )
        Bash()
    end)

    timer.Simple( 1.5, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
    end)
    
    timer.Simple(2.5, function()
        hook.Remove( "EntityTakeDamage", "widestagger" )
        EnemyAttack()
    end)

    hook.Add( "EntityTakeDamage", "widestagger", function( target, dmg )
        if target:IsPlayer() and dmg:GetAttacker() == enemy1 then
            target:EmitSound( "widestagger_2.wav", 150, 100, 1, CHAN_BODY )
        end
    end)
end

function Guardian_Stagger()
    SendSkillNote( "Wide Stagger" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "bash_cave01" )

    -- Swing sound
    enemy1:EmitSound( "widestagger_1.wav", 150, 100, 1, CHAN_BODY )

    timer.Simple( 0.8, function()
        strikepos = Entity(1):EyePos( ) + Vector( 0, -15, -15 )
        strikevel = Vector( math.random( 7500, -7500 ), 7500, 4000 )
        WideStagger()
    end)

    timer.Simple( 2, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
    end)
    
    timer.Simple( 3, function()
        hook.Remove( "EntityTakeDamage", "widestagger" )
        EnemyAttack()
    end)

    -- This manages sound appropriately.
    hook.Add( "EntityTakeDamage", "widestagger", function( target, dmg )
        if target:IsPlayer() and dmg:GetAttacker() == enemy1 then
            target:EmitSound( "widestagger_2.wav", 150, 100, 1, CHAN_BODY )
        end
    end)
end

function Guardian_AllyCall()
    if enemy2 == nil or enemy3 == nil then
        SendSkillNote( "Ally Call" )

        enemy1:ResetSequence( "ragdoll" )
        enemy1:ResetSequence( "bark" )

        timer.Simple( 2.75, function()
            G_AllyCall()
        end)

        timer.Simple( 2.75, function()
            enemy1:ResetSequence( table.Random( guardian_idle ) )
        end)
        
        timer.Simple( 5, function()
            EnemyAttack()
        end)
    else
        -- Refresh if enemies are full
        RunString( table.Random( sktbl_guardian ) )
    end

    g_sudety = true
end

function BattleCry()
    SendSkillNote( "Battle Cry", Color( 255, 5, 5 ) )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "roar" )

    timer.Simple( 4, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
    end)
    
    timer.Simple( 5, function()
        EnemyAttack()
    end)

    g_stampede = true
end

function Stampede()
    SendSkillNote( "Stampede", Color( 255, 5, 5 ) )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "charge_startfast" )

    timer.Simple( 1, function()
        strikepos = Entity(1):EyePos( ) + Vector( 0, -15, -15 )
        strikevel = Vector( 0, 15000, -2000 )
        enemy1:ResetSequence( "charge_crash" )
        G_Stampede()
    end)

    timer.Simple( 4.5, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
        hook.Remove( "EntityTakeDamage", "widestagger" )
        EnemyAttack()
    end)

    g_stampede = false

    hook.Add( "EntityTakeDamage", "widestagger", function( target, dmg )
        if target:IsPlayer() and dmg:GetAttacker() == enemy1 then
            target:EmitSound( "kablamo.wav", 150, 100, 1, CHAN_BODY )
        end
    end)
end

function Sudety()
    SendSkillNote( "Brute of Sudety" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "short_roar" )

    timer.Simple( 0.5, function()
        G_Sudety()
    end)

    timer.Simple( 2, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
        SendSkillNote( "Party defence decreased significantly!" )
    end)
    
    timer.Simple( 2.5, function()
        EnemyAttack()
    end)
end

function GuardianStun()
    local feher = turntarget
    feher:ResetSequence( "ragdoll" )
    feher:ResetSequence( "physhit_rl" )

    timer.Simple( 2, function()
        if IsValid( feher ) then
            feher:ResetSequence( table.Random( antlion_idle ) )
        end
    end)
end

function GuardianPain()
    if IsValid( turntarget ) then
        local feher = turntarget
        feher:ResetSequence( "ragdoll" )
        if engine.TickCount() % 2 == 0 then
            feher:ResetSequence( "pain" )
        else
            feher:ResetSequence( "physhit_rl" )
        end

        timer.Create( "guardianpain", 1, 1, function()
            if IsValid( feher ) then
                feher:ResetSequence( table.Random( antlion_idle ) )
            end
        end)
    end
end