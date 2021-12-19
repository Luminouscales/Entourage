-- This is a script file for Frostlion Knight

-- This is a Scout but tankier and with a blunt attack.

-- Attack process:
-- 50% chance for Slash
-- 50% chance to try for blunt
    -- If a character has less than 30 Dodge: 75% for Blunt, otherwise Slash


function FrostlionKnightAI()
    attacktarget = table.Random( allplayers )
    attacktarget_id = attacktarget:UserID()
    -- First, perform attack sequence
    current_enemy:UseNoBehavior()
    current_enemy:ResetSequenceInfo()	
    current_enemy:SetNPCState( NPC_STATE_SCRIPT )
    current_enemy:ResetSequence( "ragdoll" ) -- Reset the animation

    if math.random( 1, 2 ) == 1 then -- if blunt
        
        local martius = {}

        for _, v in pairs( allplayers ) do
            if pl_stats_tbl[ v:UserID() ].DDG_TRUE < 31 then
                table.insert( martius, v )
            end
        end

        if table.IsEmpty( martius ) == false then
            if math.random( 1, 4 ) < 4 then
                attacktarget = table.Random( martius )
                attacktarget_id = attacktarget:UserID()
                SendSkillNote( "Blunt Attack" )
                current_enemy:ResetSequence( "charge_start" )
                current_enemy:EmitSound( "npc/antlion/attack_double3.wav", 75, 100, 1, CHAN_VOICE )
                timer.Simple( 0.5, function()
                    current_enemy:ResetSequenceInfo()
                    current_enemy:ResetSequence( "ragdoll" )
                    current_enemy:ResetSequence( "charge_end" )

                    strikepos = attacktarget:EyePos( ) + Vector( 0, -15, -15 )
                    strikevel = Vector( math.random( 1500, -1500 ), 4000, 4000 )
                    BluntAttack()
                    timer.Simple( 1, function()
                        current_enemy:ResetSequence( table.Random( antlion_idle ) )
                    end)
                end)
            else
                SendSkillNote( "Slash Attack" )
                current_enemy:ResetSequence( "attack1" )
                timer.Simple( 0.5, function()
                    strikepos = attacktarget:EyePos( ) + Vector( -25, 0, -25 )
                    strikevel = Vector( -3500, 3500, 1000 )
                    SlashAttack()
                end)
            end
        end
    else
        SendSkillNote( "Slash Attack" )
        current_enemy:ResetSequence( "attack1" )
        timer.Simple( 0.5, function()
            strikepos = attacktarget:EyePos( ) + Vector( -25, 0, -25 )
            strikevel = Vector( -3500, 3500, 1000 )
            SlashAttack()
        end)
    end

    timer.Simple( 1.5, function()
        current_enemy:ResetSequence( table.Random( antlion_idle ) )
    end)

    -- Advance after two seconds
    timer.Simple( 2, function()
        EnemyAttack()
    end)
end