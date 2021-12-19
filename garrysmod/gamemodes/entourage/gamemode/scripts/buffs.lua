util.AddNetworkString( "getbufftbl" )
util.AddNetworkString( "sendbufftbl" )

-- This file contains code for the implementation of buffs and debuffs.

-- Table for managing every player's buffs
-- REWORK FOR MULTIPLAYER


hook.Add("PlayerInitialSpawn", "placeholderfunco", function()
    buffs_tbl = {
        [Entity(1):UserID()] = {}
    }
end)

net.Receive( "getbufftbl", function( len, ply )
    local buffent = net.ReadEntity()
    net.Start( "sendbufftbl" )
        if buffent:IsPlayer() then
            net.WriteBool( true )
            net.WriteTable( buffs_tbl[ buffent:UserID() ] )
            net.WriteTable( pl_stats_tbl[ buffent:UserID() ] )
        else
            net.WriteBool( false )
            net.WriteTable( buffs_tbl_enemy[ buffent:EntIndex() ] )
        end
    net.Send( ply )
end)


function entourage_AddBuff( target, buff, turns, lvl, stacking )
    target2 = target
    turns2 = turns
    lvl2 = lvl
    buffid = buffs_id_tbl[ buff ].id
    targetid = target:UserID()

    local buffid2 = buffid
    local targetid2 = targetid

    local sex = 0
    local valid = 0

    -- Proofcheck target
    if isstring( target ) then
        local lyxtargetname = target
        for _, ply in ipairs( ents.GetAll() ) do 
            if ply:GetName() == lyxtargetname then -- if matches
                local target = ply -- set placeholder
                if target:IsPlayer() or target:IsNPC() then -- if player or npc
                    target = ply
                    sex = sex + 1
                end
            end
        end
        if sex > 1 then
            print( "Buff error: multiple entities with same name detected (use unique entity ID).")
        elseif target == nil then
            print( "Buff error: invalid target.")
        else
            valid = valid + 1
        end
    elseif isnumber( target ) then
        target = Entity( target )
        if IsValid(target) and target:IsPlayer() or target:IsNPC() then
            valid = valid + 1
        else
            print( "Buff error: invalid target.")
        end
    elseif target:IsPlayer() or target:IsNPC() then
        target = target
        valid = valid + 1
    end

    -- Proofcheck buff name  
    if isstring( buff ) then
        valid = valid + 1
    else
        print( "Buff error: invalid buff type.")
    end

    -- Proofcheck turns
    if isnumber( turns ) then
        valid = valid + 1
    else
        print( "Buff error: invalid turn value.")
    end

    -- Proofcheck level
    if isnumber( lvl ) then
        valid = valid + 1
    else
        print( "Buff error: invalid level value.")
    end

    if valid ~= 4 then
        print( "Unable to apply buff.")
    else
        if target:IsPlayer() then -- this is the solution until I add actual stats for enemies. if ever.
            local cd = 0
            mathilda = mathilda + 1
            if buffs_tbl[ targetid2 ][ buffid2 ] then -- if the same buff is already applied
                buffs_tbl[ targetid2 ][buffid2][2] = turns
                if stacking then
                    if buffs_tbl[ targetid2 ][buffid2][3] then
                        buffs_tbl[ targetid2 ][buffid2][3] = buffs_tbl[ targetid2 ][buffid2][3] + 1
                    else
                        buffs_tbl[ targetid2 ][buffid2][3] = 1
                    end
                    stackvar = buffs_tbl[ targetid2 ][buffid2][3]
                    if stackvar then
                        stackvar = buffs_tbl[ targetid2 ][buffid2][3]
                    else
                        stackvar = 1
                    end
                    RunString( "b_".. buff .."()" )
                    stackvar = nil
                end
            else
                print( stackvar )
                if stackvar then
                    stackvar = buffs_tbl[ targetid2 ][buffid2][3]
                else
                    stackvar = 1
                end

                print( "buffid: ".. buffid2)
                table.insert( buffs_tbl[ targetid2 ], buffid2, { buff, turns } ) -- add buff

                local cd = 0
                hook.Add( "EnemyTurnEnd", targetid2.. "pestremoval".. buffid2, function() -- remove when necessary
                    print( "Trying to remove buff..." )
                    cd = cd + 1
                    buffs_tbl[ targetid2 ][buffid2][2] = turns - cd

                    if buffs_tbl[ targetid2 ][buffid2][2] == 0 then
                        print( "Buff removed successfully." )
                        buffs_tbl[ targetid2 ][ buffid2 ] = nil
                        hook.Remove( "EnemyTurnEnd", targetid2.. "pestremoval".. buffid2 )
                    end
                end)

                RunString( "b_".. buff .."()" )
                print( "Buff successfully applied." )
                stackvar = nil
            end
        else
            print( "Buff could not be applied: target is not a player.")
        end
    end
end

-- Template
function b_xyz()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    local bonus1 = lvl3 * 5

    SetOffset( target3, "x", 1 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."_b_xyzhook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 6 ] == nil then
                    SetOffset( target3, "x", - ( 1 ) * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."_b_xyzhook".. mathilda2 )
                end
            end)
        end)
    end
end

function b_precstrike( a, b, c, d )
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    SetOffset( target2, "fcs", 2 + lvl2 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid .."_b_precstrikehook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid ][ 1 ] == nil then
                    SetOffset( target2, "fcs", - ( 2 + lvl2 ) * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid .."_b_precstrikehook".. mathilda2 )
                end
            end)
        end)
    end
end

function b_defmano()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    local calc1 = 2 + 3 * lvl3 + pl_stats_tbl[ targetid2 ].DEF / 10
    local calc2 = 20 + 2 * lvl3
    SetOffset( target3, "def", calc1 )
    SetOffset( target3, "dfx", calc2 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."defmanohook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 2 ] == nil then
                    SetOffset( target3, "def", - calc1 * stackvar2 )
                    SetOffset( target3, "dfx", - calc2 * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."defmanohook".. mathilda2 )
                    print( "Offset successfully removed." )
                end
            end)
        end)
    end
end

function b_firstaid()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    SetOffset( target3, "mgt", lvl3 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."firstaidhook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 3 ] == nil then
                    SetOffset( target3, "mgt", - lvl3 * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."firstaidhook" .. mathilda2 )
                end
            end)
        end)
    end
end

function b_moraleslash()
    -- void
end

function b_acrobatics()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar
    
    local bonus1 = lvl3 * 5

    SetOffset( target3, "ddg", 45 + bonus1 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."acrobaticshook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 4 ] == nil then
                    print(" yes")
                    SetOffset( target3, "ddg", - ( 45 + bonus1 ) * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."acrobaticshook".. mathilda2 )
                end
            end)
        end)
    end
end

function b_dedications()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    local bonus1 = lvl3 * 2
    local bonus2 = math.Clamp( bonus1 / 10, 1, 1000 )
    local bonus3 = lvl3 * 2

    SetOffset( target3, "def", 1 + bonus1 + bonus2 )
    SetOffset( target3, "flatdmg", 1 + ( bonus1 + bonus2 ) * 2 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."_b_dedicationshook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 5 ] == nil then
                    SetOffset( target3, "def", - ( 1 + bonus1 ) * stackvar2 )
                    SetOffset( target3, "flatdmg", - ( 1 + bonus1  * 2 ) * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."_b_dedicationshook".. mathilda2 )
                end
            end)
        end)
    end
end

function b_moderato()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    local bonus1 = lvl3 * 5

    SetOffset( target3, "acc", 20 + bonus1 )
    SetOffset( target3, "ddg", 10 + bonus1 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."_b_moderatohook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 6 ] == nil then
                    SetOffset( target3, "acc", - ( 20 + bonus1 ) * stackvar2 )
                    SetOffset( target3, "ddg", - ( 20 + bonus1 ) * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."_b_moderatohook".. mathilda2 )
                end
            end)
        end)
    end
end

function b_tknives() -- young dragon prodigy student saviour turned cum slut and loves it
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    mathilda = mathilda + 1
    local mathilda2 = mathilda + 1
    local bonus1 = lvl3 * 2

    SetOffset( target3, "ddg", 7 + bonus1 )
    
    hook.Add( "EnemyTurnEnd", targetid2 .."_b_tkniveshook".. mathilda2, function()
        timer.Simple( 0.1, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 7 ] == nil then
                    SetOffset( target3, "ddg", - ( 8 + bonus1 ) )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."_b_tkniveshook".. mathilda2 )
                end
            end)
        end)
    end)
end

function b_gouge()
    local mathilda2 = mathilda
    local target3 = target2
    local lvl3 = lvl2
    local targetid2 = targetid
    local stackvar2 = stackvar

    local bonus1 = lvl3 * 5

    SetOffset( target3, "x", 1 )

    if stackvar2 and stackvar2 == 1 or stackvar2 == nil then
        hook.Add( "EnemyTurnEnd", targetid2 .."_b_gougehook".. mathilda2, function()
            timer.Simple( 0.1, function()
                if buffs_tbl[ targetid2 ][ 6 ] == nil then
                    SetOffset( target3, "x", - ( 1 ) * stackvar2 )
                    hook.Remove( "EnemyTurnEnd", targetid2 .."_b_gougehook".. mathilda2 )
                end
            end)
        end)
    end
end