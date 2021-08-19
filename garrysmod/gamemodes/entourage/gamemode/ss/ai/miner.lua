-- This is a script file for Frostlion Miner


-- This is the most basic of stunning enemies; pick a random enemy, then hit them for Blunt. Try to stun.
local skill_table = {
    "BluntAttack()"
}

function FrostlionMinerAI()
    attacktarget = table.Random( allplayers )
    attacktarget_id = attacktarget:UserID()
    -- First, perform attack sequence
    current_enemy:UseNoBehavior()
    current_enemy:ResetSequenceInfo()	
    current_enemy:SetNPCState( NPC_STATE_SCRIPT )
    current_enemy:ResetSequence( "ragdoll" ) -- Reset the animation
    current_enemy:ResetSequence( current_enemy:GetNWString( "animstart" ) )
    -- Unique attack sound.
    current_enemy:EmitSound( enemies_table[current_enemy:GetName()].sound_att, 75, 100, 1, CHAN_VOICE )

    SendSkillNote( "Blunt Attack" )
    
    timer.Simple( 0.5, function()
        current_enemy:ResetSequenceInfo()
        current_enemy:ResetSequence( "ragdoll" )
        current_enemy:ResetSequence( "charge_end" )

        strikepos = Entity(1):EyePos( ) + Vector( 0, -15, -15 )
        strikevel = Vector( math.random( 1500, -1500 ), 4000, 4000 )
        BluntAttack()
        timer.Simple( 1.3, function()
            current_enemy:ResetSequence( table.Random( antlion_idle ) )
        end)
    end)

    timer.Simple( 2.5, function()
        EnemyAttack()
    end)
end