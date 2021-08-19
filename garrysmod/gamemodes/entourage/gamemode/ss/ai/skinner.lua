-- This is a script file for Frostlion Skinner

function FrostlionSkinnerAI()
    attacktarget = table.Random( allplayers )
    attacktarget_id = attacktarget:UserID()
    -- First, perform attack sequence
    current_enemy:UseNoBehavior()
    current_enemy:ResetSequenceInfo()	
    current_enemy:SetNPCState( NPC_STATE_SCRIPT )
    current_enemy:ResetSequence( "ragdoll" ) -- Reset the animation
    current_enemy:ResetSequence( "attack2" )

    SendSkillNote( "Pierce Attack" )

    timer.Simple( 0.6, function()
        strikepos = Entity(1):EyePos( ) + Vector( 0, 0, -15 )
        strikevel = Vector( math.random( 1500, -1500 ), 2500, -7500 )
        PierceAttack()
    end)

    timer.Simple( 1.5, function()
        current_enemy:ResetSequence( table.Random( antlion_idle ) )
    end)

    -- Advance after two seconds
    timer.Simple( 2, function()
        EnemyAttack()
    end)
end