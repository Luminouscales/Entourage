-- This file contains code for the implementation of buffs and debuffs.

function entourage_AddBuff( target, buff, turns, lvl )
    local sex = 0
    local valid = 0

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
    if isfunction( buff ) then
        valid = valid + 1
    elseif isstring( buff ) then
        print( "Buff error: invalid buff name (name must not be a string).")
    else
        print( "Buff error: invalid buff name.")
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
        turns2 = turns
        print( turns2, turns )
        lvl2 = lvl
        if target2:IsPlayer() then -- this is the solution until I add actual stats for enemies. if ever.
            buff()
            print( "Buff successfully applied." )
        else
            print( "Buff could not be applied: target is not a player.")
        end
        
    end

end

function b_precstrike()
    local lvl = lvl2 -- skill_lvl is defined in skillfunctions.lua. otherwise it is defined manually
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda + 1

    pl_stats_tbl[ id ].FCS = pl_stats_tbl[ id ].FCS + 2 + lvl 

    hook.Add( "EnemyTurnEnd", id .."_b_precstrikehook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns2 then
            pl_stats_tbl[ id ].FCS = pl_stats_tbl[ id ].FCS - 2 - lvl
            hook.Remove( "EnemyTurnEnd", id .."_b_precstrikehook".. mathilda2 )
        end
    end)
end

function b_defmano()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda + 1

    local calc1 = 2 + 3 * lvl + pl_stats_tbl[ id ].DEF / 10
    local calc2 = 20 + 2 * lvl
    pl_stats_tbl[ id ].DEF = pl_stats_tbl[ id ].DEF + calc1
    pl_stats_tbl[ id ].DFX = pl_stats_tbl[ id ].DFX + calc2

    hook.Add( "EnemyTurnEnd", id .."defmanohook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns2 then
            pl_stats_tbl[ id ].DEF = pl_stats_tbl[ id ].DEF - calc1
            pl_stats_tbl[ id ].DFX = pl_stats_tbl[ id ].DFX - calc2
            hook.Remove( "EnemyTurnEnd", id .."defmanohook".. mathilda2 )
        end
    end)
end

function b_firstaid()
    local lvl = lvl2
    local id = target2:UserID()
    local cd = 0
    mathilda = mathilda + 1
    local mathilda2 = mathilda + 1

    pl_stats_tbl[ mgbplayer:UserID() ].MGT = pl_stats_tbl[ mgbplayer:UserID() ].MGT + lvl

    hook.Add( "EnemyTurnEnd", pl_id .."firstaidhook".. mathilda2, function()
        cd = cd + 1
        if cd >= turns2 then
            pl_stats_tbl[ mgbplayer:UserID() ].MGT = pl_stats_tbl[ mgbplayer:UserID() ].MGT - lvl
            hook.Remove( "EnemyTurnEnd", pl_id .."firstaidhook" .. mathilda2)
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
    local mathilda2 = mathilda + 1

    pl_stats_tbl[ pl_id ].DDG_OV = pl_stats_tbl[ pl_id ].DDG_OV + 50 + bonus1

    hook.Add( "EnemyTurnEnd", pl_id .."acrobaticshook".. mathilda2, function()
        cd = cd + 1
        if cd == 1 then
            pl_stats_tbl[ pl_id ].DDG_OV = pl_stats_tbl[ pl_id ].DDG_OV - 50 - bonus1
            hook.Remove( "EnemyTurnEnd", pl_id .."acrobaticshook".. mathilda2 )
        end
    end) 
end