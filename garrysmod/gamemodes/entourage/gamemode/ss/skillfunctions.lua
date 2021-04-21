util.AddNetworkString( "player_makeskill" )

net.Receive( "player_makeskill", function( len, ply )
	turntargets = net.ReadTable()
	wpndmg1 = net.ReadDouble()
	wpndmg2 = net.ReadDouble()
	pltype = net.ReadString()
	allplayers = net.ReadTable()
	wpn = net.ReadString()
    skill_id = net.ReadString()
    skill_lvl = net.ReadInt( 32 )

    slash_dmg = net.ReadInt( 32 ) * 0.05 
    slash_dfx = net.ReadInt( 32 ) * 0.03
    slash_acc = net.ReadInt( 32 ) * 0.05 

	player = ply
    vis_int = 0

    RunString( skill_id .."()" )

    timer.Simple( 2, function()
        enemy_makeattack()
    end)
end)

-- Utility
-- Function for dealing skill damage. Does not support damage decrease by number of targets.
function s_Retract()
    local i = 0
    for k, v in pairs( turntargets ) do
        i = i + 1
    end
    for k, v in pairs( turntargets ) do 
        vis_int = vis_int + 0.25
        timer.Simple( vis_int, function()
            if IsValid(v) and v:Health() > 0 then
                turntarget = v
                turntargetsave = v:GetName()
                up_open = false

                RunString( items_table[ wpn ].func )

            end
        end)
    end
    dmg_modifier = 1
    acc_modifier = 1
end


-- SLASH
function s_precstrike()
    -- Precision Strike

    -- UP Cost
    entourage_AddUP( -10, 25 )

    -- First, check whether the weapon type is appropriate - if not, deduct damage and accuracy. Define level variables.
    local lvl = skill_lvl
    local bonus1 = lvl * 0.1
    local bonus2 = lvl * 0.05

    if pltype == "Slash" or "Multiple" then
        dmg_modifier = 1 + bonus1
        acc_modifier = 1.1 + bonus2
    else
        dmg_modifier = 0.25 + bonus1
        acc_modifier = 0.90 + bonus2
    end
    -- Deal damage and stuffs, leave it to the weapon functions.
    s_Retract()

    -- Cooldown
    player:SetNWBool( "s_precstrike_oncd", true )

    -- Other effects.
    -- Add Focus for 3 turns.
    player:SetNWInt( "fcsNW", player:GetNWInt( "fcsNW" ) + 1 + lvl)
    -- Remove focus after 3 turns.
    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EntityTakeDamage", pl_id .."precstrikehook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                hookv1:SetNWInt( "fcsNW", hookv1:GetNWInt( "fcsNW" ) - 1 - hookv2 )
                hookv1:SetNWBool( "s_precstrike_oncd", false )
                hook.Remove( "EntityTakeDamage", pl_id .."precstrikehook" )
            end
        end
    end)
end

function s_defmano()
    -- Defensive Manoeuvre

    entourage_AddUP( -15, 25 )

    local lvl = skill_lvl
    local bonus1 = lvl * 0.05

    if pltype == "Slash" then
        dmg_modifier = 0.75 + bonus1
        acc_modifier = 1
    else
        dmg_modifier = 0.25 + bonus1
        acc_modifier = 0.75
    end

    s_Retract()

    player:SetNWBool( "s_defmano_oncd", true )

    -- Other effects.

    local calc1 = 2 + player:GetNWInt( "defNW" ) / 10 + 3 * lvl
    local calc2 = 5 + player:GetNWInt( "dfxNW" ) / 10 + 2 * lvl
    player:SetNWInt( "defNW", player:GetNWInt( "defNW" ) + calc1 )
    player:SetNWInt( "dfxNW", player:GetNWInt( "dfxNW" ) + calc2 )

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EntityTakeDamage", pl_id .."defmanohook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                player:SetNWInt( "defNW", player:GetNWInt( "defNW" ) - calc1 )
                player:SetNWInt( "dfxNW", player:GetNWInt( "dfxNW" ) - calc2 )
                hookv1:SetNWBool( "s_defmano_oncd", false )
                hook.Remove( "EntityTakeDamage", pl_id .."defmanohook" )
            end
        end
    end)
end

function s_firstaid()
    -- Defensive Manoeuvre

    entourage_AddUP( -15, 25 )

    local lvl = skill_lvl
    local bonus1 = lvl * 0.05 -- raw
    local bonus2 = lvl * 0.05 -- scaling

    local target = turntargets[1]

    timer.Simple( 0.5, function()
        local heal = math.Round( 20 + 10 * lvl + target:GetMaxHealth() / ( 100 - ( 2 + 3 * lvl ) ), 0 )
        target:SetHealth( math.Clamp( target:Health() + heal, 0, target:GetMaxHealth() ) )
        PrintMessage( HUD_PRINTTALK, target:GetName() .." was healed for ".. heal .." HP!" )
    end)

    player:SetNWBool( "s_firstaid_oncd", true )

    -- Other effects.

    target:SetNWInt( "mgtNW", target:GetNWInt( "mgtNW" ) + lvl )

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EntityTakeDamage", pl_id .."firstaidhook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                target:SetNWInt( "mgtNW", target:GetNWInt( "mgtNW" ) - lvl )
                hookv1:SetNWBool( "s_firstaid_oncd", false )
                hook.Remove( "EntityTakeDamage", pl_id .."firstaidhook" )
            end
        end
    end)
end

function s_broadswing()
    -- Broad Swing

    entourage_AddUP( -10, 25 )

    local lvl = skill_lvl
    local bonus1 = lvl * 0.05

    if pltype == "Slash" then
        dmg_modifier = 0.40 + bonus1
        acc_modifier = 0.9
    else
        dmg_modifier = 0.1 + bonus1
        acc_modifier = 0.6
    end

    s_Retract()

    player:SetNWBool( "s_broadswing_oncd", true )

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    hook.Add( "EntityTakeDamage", pl_id .."broadswinghook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 2 then
                hookv1:SetNWBool( "s_broadswing_oncd", false )
                hook.Remove( "EntityTakeDamage", pl_id .."broadswinghook" )
            end
        end
    end)
end

function s_fragmentation()
    -- Fragmentation

    entourage_AddUP( -20, 25 )

    local lvl = skill_lvl
    local bonus1 = lvl * 0.05

    if pltype == "Slash" then
        dmg_modifier = 0.6 + bonus1
        acc_modifier = 0.85
    else
        dmg_modifier = 0.3 + bonus1
        acc_modifier = 0.55
    end

    s_Retract()

    player:SetNWBool( "s_fragmentation_oncd", true )

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    hook.Add( "EntityTakeDamage", pl_id .."fragmentationhook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 4 then
                hookv1:SetNWBool( "s_fragmentation_oncd", false )
                hook.Remove( "EntityTakeDamage", pl_id .."fragmentationhook" )
            end
        end
    end)
end

function s_medicsupplies()
    -- Medical Supplies

    entourage_AddUP( -20, 25 )

    local lvl = skill_lvl

    local target = turntargets[1]

    timer.Simple( 0.5, function()
        local heal = math.Round( 40 + 10 * lvl, 0 )
        target:SetHealth( math.Clamp( target:Health() + heal, 0, target:GetMaxHealth() ) )
        PrintMessage( HUD_PRINTTALK, target:GetName() .." was healed for ".. heal .." HP!" )
    end)

    player:SetNWBool( "s_medicsupplies_oncd", true )


    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    hook.Add( "EntityTakeDamage", pl_id .."firstaidhook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                hookv1:SetNWBool( "s_medicsupplies_oncd", false )
                hook.Remove( "EntityTakeDamage", pl_id .."medicsupplieshook" )
            end
        end
    end)
end