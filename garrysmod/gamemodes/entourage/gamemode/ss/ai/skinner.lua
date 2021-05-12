-- This is a script file for Frostlion Skinner


-- This is the most basic of basic enemies; pick a random target and stab them for crits
local skill_table = {
    "PierceAttack()"
}

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