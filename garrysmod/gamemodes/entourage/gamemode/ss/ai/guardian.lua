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
    RunString( table.Random( sktbl_guardian ) )
end

-- Skills
function Guardian_Bash()
    SendSkillNote( "Bash" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "shove" )
    timer.Simple( 0.5, function()
        Bash()
    end)

    timer.Simple( 1.5, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
    end)
    
    timer.Simple(2.5, function()
        playerturn()
    end)
end

function Guardian_Stagger()
    SendSkillNote( "Wide Stagger" )

    enemy1:ResetSequence( "ragdoll" )
    enemy1:ResetSequence( "bash_cave01" )
    timer.Simple( 0.8, function()
        WideStagger()
    end)

    timer.Simple( 2, function()
        enemy1:ResetSequence( table.Random( guardian_idle ) )
    end)
    
    timer.Simple( 3, function()
        playerturn()
    end)
end