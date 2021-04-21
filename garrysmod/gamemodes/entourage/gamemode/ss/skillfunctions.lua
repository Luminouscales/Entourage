util.AddNetworkString( "player_makeskill" )

net.Receive( "player_makeskill", function( len, ply )
	turntarget = net.ReadEntity()
	turntargetsave = turntarget:GetName()
	wpndmg1 = net.ReadDouble()
	wpndmg2 = net.ReadDouble()
	pltype2 = net.ReadString()
	allplayers = net.ReadTable()
	wpn = net.ReadString()
    skill_id = net.ReadString()
    skill_lvl = net.ReadInt( 32 )
	player = ply

    RunString( skill_id .."()" )

    timer.Simple( 2, function()
        enemy_makeattack()
    end)
end)

-- SLASH
function s_precstrike()
    -- Precision Strike

    -- UP Cost
    entourage_AddUP( -10, 25 )

    -- First, check whether the weapon type is appropriate - if not, deduct damage and accuracy. Define level variables.
    local lvl = skill_lvl
    local bonus1 = lvl * 0.1
    local bonus2 = lvl * 0.05

    if items_table[ wpn ].func == "Slash" or "Multiple" then
        dmg_modifier = 1 + bonus1
        acc_modifier = 1.1 + bonus2
    else
        dmg_modifier = 0.25 + bonus1
        acc_modifier = 0.90 + bonus2
    end
    -- Deal damage and stuffs, leave it to the weapon functions.
    timer.Simple( 0.5, function()
        up_open = false
        RunString( items_table[ wpn ].func )
    end)

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

    timer.Simple( 0.5, function()
        up_open = false
        RunString( items_table[ wpn ].func )
        dmg_modifier = 1
        acc_modifier = 1
    end)

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

    entourage_AddUP( -20, 25 )

    local lvl = skill_lvl
    local bonus1 = lvl * 0.05 -- raw
    local bonus2 = lvl * 0.05 -- scaling

    local target = turntarget

    -- Heal effect; main
    -- 20 + 10 * plskills_a["s_firstaid"].Level
    -- 3 + 3 * plskills_a["s_firstaid"].Level
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