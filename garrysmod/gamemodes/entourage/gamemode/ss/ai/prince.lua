-- This is the script for Frostlion Prince's battle.

-- The prince appears alongside two miners and doesn't attack until they are dead.
-- Once a miner stuns a target, the Prince attacks them for very high damage.

function PrinceAI()
    attacktarget = table.Random( allplayers )
    attacktarget_id = attacktarget:UserID()
    enemy1:UseNoBehavior()
    enemy1:SetNPCState( NPC_STATE_SCRIPT )
    enemy1:ResetSequenceInfo()

    for _, v in pairs( allplayers ) do
        if v:GetNWInt( "stunturns" ) > 0 then
            attacktarget = v
            attacktarget_id = v:UserID()
        break end
    end

    -- sloppy, but im tired.
    if attacktarget:GetNWInt( "stunturns" ) > 0 then
        Prince_Eviscerate()
    elseif IsValid(enemy2) == false or IsValid(enemy3) == false or enemy1:Health() < 100 then -- If at least one Miner is dead, start attacking
        Prince_Basic()
    else -- otherwise, wait.
        Prince_Wait()
    end
end

-- Skills
function Prince_Basic()
    SendSkillNote( "Pierce Attack" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "attack1" )

    timer.Simple( 0.5, function()
        strikepos = Entity(1):EyePos( ) + Vector( 0, 0, -15 )
        strikevel = Vector( math.random( 1500, -1500 ), 2500, -7500 )
        PierceAttack()
    end)

    timer.Simple( 1.5, function()
        enemy1:ResetSequence( table.Random( antlion_idle ) )
    end)
    
    timer.Simple(2.5, function()
        EnemyAttack()
    end)
end

function Prince_Wait()
    SendSkillNote( "Evade" )

    -- Add some dodge
    enemies_table[ "Frostlion Prince" ].DDG = enemies_table[ "Frostlion Prince" ].DDG + 75

    hook.Add( "PlayerTurnEnd", "p_evade_remover", function()
        timer.Simple( 3, function()
            enemies_table[ "Frostlion Prince" ].DDG = enemies_table[ "Frostlion Prince" ].DDG - 75
            hook.Remove( "PlayerTurnEnd", "p_evade_remover" )
        end)
    end)
    
    timer.Simple( 1, function()
        EnemyAttack()
    end)
end

function Prince_Eviscerate()
    SendSkillNote( "Eviscerate" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "attack6" )

    timer.Simple( 0.75, function()
        strikepos = Entity(1):EyePos( ) + Vector( 0, 0, -15 )
        strikevel = Vector( math.random( 1500, -1500 ), 3500, -7500 ) * 1.5
        P_Eviscerate()
    end)

    timer.Simple( 2, function()
        enemy1:ResetSequence( table.Random( antlion_idle ) )
    end)
    
    timer.Simple(3, function()
        EnemyAttack()
    end)
end