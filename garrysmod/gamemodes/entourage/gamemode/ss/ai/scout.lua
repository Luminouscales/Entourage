-- This is a script file for Frostlion Scout


-- This is the most basic of basic enemies; pick a random target and attack them with slash damage.
local skill_table = {
    "SlashAttack()"
}

function FrostlionScoutAI()
    attacktarget = table.Random( allplayers )
    attacktarget_id = attacktarget:UserID()
    -- First, perform attack sequence
    current_enemy:UseNoBehavior()
    current_enemy:ResetSequenceInfo()	
    current_enemy:SetNPCState( NPC_STATE_SCRIPT )
    current_enemy:ResetSequence( "ragdoll" ) -- Reset the animation
    current_enemy:ResetSequence( "attack1" )

    SendSkillNote( "Slash Attack" )

    timer.Simple( 0.5, function()
        SlashAttack()
    end)

    timer.Simple( 1.5, function()
        current_enemy:ResetSequence( table.Random( antlion_idle ) )
    end)

    -- Advance after two seconds
    timer.Simple( 2, function()
        EnemyAttack()
    end)
end


-- Stun animation. Used for all antlions

function AntlionStun()
    turntarget:ResetSequence( "ragdoll" )
    turntarget:ResetSequence( "Flip1" )

    timer.Simple( 2.25, function()
        turntarget:ResetSequence( table.Random( antlion_idle ) )
    end)
end