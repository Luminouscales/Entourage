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


function entourage_AddBuff( target, buff, turns, lvl )
    local sex = 0
    local valid = 0
    local buffid = buffs_id_tbl[ buff ].id
    local targetid = target:UserID()

    -- Proofcheck target
    if isstring( target ) then
        lyxtargetname = target
        for _, ply in ipairs( ents.GetAll() ) do 
            if ply:GetName() == lyxtargetname then -- if matches
                local target3 = ply -- set placeholder
                if target3:IsPlayer() or target3:IsNPC() then -- if player or npc
                    target2 = ply
                    sex = sex + 1
                end
            end
        end
        if sex > 1 then
            print( "Buff error: multiple entities with same name detected (use unique entity ID).")
        elseif target2 == nil then
            print( "Buff error: invalid target.")
        else
            valid = valid + 1
        end
    elseif isnumber( target ) then
        target2 = Entity( target )
        if IsValid(target2) and target2:IsPlayer() or target2:IsNPC() then
            valid = valid + 1
        else
            print( "Buff error: invalid target.")
        end
    elseif target:IsPlayer() or target:IsNPC() then
        target2 = target
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
        if target2:IsPlayer() then -- this is the solution until I add actual stats for enemies. if ever.
            turns2 = turns
            lvl2 = lvl
            RunString( "b_".. buff .."()" )
            print( "Buff successfully applied." )

            print( "buffid: ".. buffid)
            table.insert( buffs_tbl[ targetid ], buffid, { buff, turns2 } ) -- add buff
            --buffs_tbl[ targetid ].buffid
            local cd = -1
            hook.Add( "EnemyTurnEnd", targetid.. "pestremoval".. buffid, function() -- remove when necessary
                cd = cd + 1
                print( cd )
                print( turns2 )
                print( cd >= turns2 )
                buffs_tbl[ targetid ][buffid][2] = turns2 - cd

                if cd >= turns2 then
                    --table.remove( buffs_tbl[ targetid ], buffid ) -- fuck you, fuck all of you
                    buffs_tbl[ targetid ][ buffid ] = nil
                    hook.Remove( "EnemyTurnEnd", targetid.. "pestremoval".. buffid )
                end
            end)
        else
            print( "Buff could not be applied: target is not a player.")
        end
    end
end

function b_precstrike()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda
    local turns3 = turns2

    SetOffset( target2, "fcs", 2 + lvl )

    hook.Add( "EnemyTurnEnd", id .."_b_precstrikehook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns3 then
            SetOffset( target2, "fcs", ( 2 + lvl ) * -1 )
            hook.Remove( "EnemyTurnEnd", id .."_b_precstrikehook".. mathilda2 )
        end
    end)
end

function b_defmano()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda
    local turns3 = turns2

    local calc1 = 2 + 3 * lvl + pl_stats_tbl[ id ].DEF / 10
    local calc2 = 20 + 2 * lvl
    SetOffset( target2, "def", calc1 )
    SetOffset( target2, "dfx", calc2 )

    hook.Add( "EnemyTurnEnd", id .."defmanohook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns3 then
            SetOffset( target2, "def", - calc1 )
            SetOffset( target2, "dfx", - calc2 )
            hook.Remove( "EnemyTurnEnd", id .."defmanohook".. mathilda2 )
        end
    end)
end

function b_firstaid()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda
    local turns3 = turns2

    SetOffset( target2, "mgt", lvl )

    hook.Add( "EnemyTurnEnd", pl_id .."firstaidhook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns3 then
            SetOffset( target2, "mgt", - lvl )
            hook.Remove( "EnemyTurnEnd", pl_id .."firstaidhook" .. mathilda2 )
        end
    end)
end

function b_moraleslash()
    -- void
end

function b_acrobatics()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda
    local turns3 = turns2
    local bonus1 = lvl * 5

    pl_stats_tbl[ id ].DDG_OV = pl_stats_tbl[ id ].DDG_OV + 45 + bonus1

    hook.Add( "EnemyTurnEnd", id .."acrobaticshook".. mathilda2, function()
        cd = cd + 1
        if cd == turns3 then
            pl_stats_tbl[ id ].DDG_OV = pl_stats_tbl[ id ].DDG_OV - 45 - bonus1
            hook.Remove( "EnemyTurnEnd", id .."acrobaticshook".. mathilda2 )
        end
    end) 
end

function b_dedications()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda
    local turns3 = turns2
    local bonus1 = lvl * 2
    local bonus2 = math.Clamp( bonus1 / 10, 1, 1000 )
    local bonus3 = lvl * 2


    SetOffset( target2, "def", 1 + bonus1 + bonus2 )
    SetOffset( target2, "flatdmg", 1 + ( bonus1 + bonus2 ) * 2 )

    hook.Add( "EnemyTurnEnd", id .."_b_dedicationshook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns3 then
            SetOffset( target2, "def", ( 1 + bonus1 ) * -1 )
            SetOffset( target2, "flatdmg", ( 1 + bonus1  * 2 ) * -1 )
            hook.Remove( "EnemyTurnEnd", id .."_b_dedicationshook".. mathilda2 )
        end
    end)
end

function b_moderato()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda
    local turns3 = turns2
    local bonus1 = lvl * 5


    SetOffset( target2, "acc", 20 + bonus1 )
    SetOffset( target2, "ddg", 10 + bonus1 )

    hook.Add( "EnemyTurnEnd", id .."_b_moderatohook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns3 then
            SetOffset( target2, "acc", ( 20 + bonus1 ) * -1 )
            SetOffset( target2, "ddg", ( 20 + bonus1 ) * -1 )
            hook.Remove( "EnemyTurnEnd", id .."_b_moderatohook".. mathilda2 )
        end
    end)
end