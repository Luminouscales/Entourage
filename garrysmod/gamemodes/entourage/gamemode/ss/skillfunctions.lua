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

    -- pl_stats_tbl[ player:UserID() ].DEF =  pl_stats_tbl[ player:UserID() ].DEF + pl_stats_tbl[ player:UserID() ].VIT + pl_stats_tbl[ player:UserID() ].SDL

    -- Other effects.
    -- Add Focus for 3 turns.
    pl_stats_tbl[ player:UserID() ].FCS = pl_stats_tbl[ player:UserID() ].FCS + 1 + lvl
    -- Remove focus after 3 turns.
    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EntityTakeDamage", pl_id .."precstrikehook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                pl_stats_tbl[ player:UserID() ].FCS = pl_stats_tbl[ player:UserID() ].FCS - 1 - hookv2
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

    local calc1 = 2 + pl_stats_tbl[ player:UserID() ].DEF / 10 + 3 * lvl
    local calc2 = 5 + pl_stats_tbl[ player:UserID() ].DFX / 10 + 2 * lvl
    pl_stats_tbl[ player:UserID() ].DEF = pl_stats_tbl[ player:UserID() ].DEF + calc1
    pl_stats_tbl[ player:UserID() ].DFX = pl_stats_tbl[ player:UserID() ].DFX + calc2

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EntityTakeDamage", pl_id .."defmanohook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                pl_stats_tbl[ player:UserID() ].DEF = pl_stats_tbl[ player:UserID() ].DEF - calc1
                pl_stats_tbl[ player:UserID() ].DFX = pl_stats_tbl[ player:UserID() ].DFX - calc2
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

    pl_stats_tbl[ player:UserID() ].MGT = pl_stats_tbl[ player:UserID() ].MGT + lvl

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EntityTakeDamage", pl_id .."firstaidhook", function( target )
        if target == Levitus then
            cd = cd + 1
            if cd >= 3 then
                pl_stats_tbl[ player:UserID() ].MGT = pl_stats_tbl[ player:UserID() ].MGT - lvl
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


-- Enemy-only functions

function SlashAttack()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.random( 0.9, 1.1 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.005 )
    attackdmg = math.Round( math.Clamp( attackdmg, 1, 9999 ), 0 )

    c_miss = 0
    c_type = DMG_SLASH
    c_type2 = "Slash"

    CalcAttack()
end

function BluntAttack()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.random( 0.75, 1.25 )
    attackdmg = ( math.random( enemies_table[ current_enemy:GetName() ].DMG1, enemies_table[ current_enemy:GetName() ].DMG2 ) - attacktarget:GetNWInt( "defNW" ) * 0.9 ) * ( 1 - attacktarget:GetNWInt( "dfxNW" ) * 0.015 )
    --attackdmg = math.Round( math.Clamp( , 0, 9999 ), 0 )
end

-- Frostlion Guardian skill
function WideStagger()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.random( 0.8, 1.2 )
    attackdmg = ( attackdmg - attacktarget:GetNWInt( "defNW" ) * 0.9 ) * ( 1 - attacktarget:GetNWInt( "dfxNW" ) * 0.015 )
    attackdmg = math.Round( math.Clamp( attackdmg, 1, 9999 ), 0 )

    c_type = "Blunt"
    c_miss = 20
    CalcAttack()
end

function CalcAttack()
    if math.random( 1, 100 ) > pl_stats_tbl[ attacktarget_id ].DDG_TRUE + enemies_table[ current_enemy:GetName() ].MISS + c_miss then
        calc_info = DamageInfo()
        calc_info:SetAttacker( current_enemy )
        calc_info:SetDamageType( c_type )
        calc_info:SetDamage( attackdmg )

        if c_type2 == "Pierce" then
            DoCrit2a()
        end

        attacktarget:TakeDamageInfo( calc_info )
        PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt ".. attackdmg .." ".. c_type2 .." damage to ".. attacktarget:GetName() )

        if c_type2 == "Blunt" then
            DoStun()
        end

    else
        PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." dodged ".. current_enemy:GetName() .."'s attack!" )
    end
end