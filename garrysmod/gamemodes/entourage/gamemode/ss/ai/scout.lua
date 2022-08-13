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
        strikepos = Entity(1):EyePos( ) + Vector( -25, 0, -25 )
        strikevel = Vector( -3500, 3500, 1000 )
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
    local save = turntarget
    save:ResetSequence( "ragdoll" )
    save:ResetSequence( "Flip1" )

    timer.Simple( 1.5, function()
        if IsValid( save ) then
            save:ResetSequence( table.Random( antlion_idle ) )
        end
    end)
end

droptable_frostlionscout = {
    [1] = { "Kajzerka",
        5,
        3
    },
    [2] = { "OldCrowbar",
        15,
        1
    },
    [3] = { "SlimArmour",
        10,
        2
}
}
enemies_table["Frostlion Scout"]["droptable"] = droptable_frostlionscout -- :3