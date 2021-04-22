-- This is the script for Frostlion Guardian's battle.

function guardianTest()
    enemy1:UseNoBehavior()
    enemy1:SetNPCState( NPC_STATE_SCRIPT )
    enemy1:ResetSequenceInfo()
    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "shove" )

    timer.Simple( 0.5, function()
        KnockerAI()
    end)

    timer.Simple( 1.5, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
    end)
    
    timer.Simple(3, function()
        playerturn()
    end)
end

