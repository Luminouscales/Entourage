util.AddNetworkString( "player_makeskill" )

net.Receive( "player_makeskill", function( len, ply )
	turntargets = net.ReadTable()
	wpndmg1 = net.ReadDouble()
	wpndmg2 = net.ReadDouble()
	pltype = net.ReadString()
    c_type2 = pltype
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
        EnemyAttack()
    end)

    hook.Call( "PlayerTurnEnd" )
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

function DoCrit2a()
	if critbonus_a == nil then
		critbonus_a = 0
	end
	if math.random( 1, 100 ) <= enemies_table[ current_enemy:GetName() ].DMGC + critbonus_a then
		calc_info:SetDamage( calc_info:GetDamage() * 2.5 )
        DoCrit2()
		PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt critical damage!" )

        attacktarget:EmitSound( "mgb_crit1.mp3", 150, 100, 1, CHAN_BODY )
	end
end

function DoStun()
	if enemies_table[ current_enemy:GetName() ].DMGS ~= nil then
		stunbonus_a = enemies_table[ current_enemy:GetName() ].DMGS
	else
		stunbonus_a = 0
	end
    if stunbonus == nil then
		stunbonus = 0
    end
	if math.random( 1, 100 ) <= attackdmg / attacktarget:GetMaxHealth() * 70 + stunbonus + stunbonus_a - pl_stats_tbl[ attacktarget_id ].VIT * 2 - pl_stats_tbl[ attacktarget_id ].DFX * 0.5 - attacktarget:GetNWInt( "stunturns_a" ) * 40 then 
		attacktarget:SetNWInt( "stunturns", attacktarget:GetNWInt( "stunturns" ) + 1 )
		attacktarget:SetNWInt( "stunturns_a", attacktarget:GetNWInt( "stunturns" ) + 1 )
        if attacktarget:GetNWInt( "stunturns" ) > 1 then
            problem_gramatyczny = " turns..."
        else
            problem_gramatyczny = " turn..."
        end
		PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." is stunned for ".. attacktarget:GetNWInt( "stunturns" ) ..problem_gramatyczny )
		DoCrit2()
        stunbonus_a = 0
        stunbonus = 0
	end
end

-- This is for running stuff related to enemy crits. and stuns.
function DoCrit2()
	-- Taking crits decreases UP by 10. Also runs on stuns.
	timer.Simple( 0.2, function()
		if attackdmg > 0 then
			entourage_AddUP( -10, 25 )
		end
	end)
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
    pl_stats_tbl[ player:UserID() ].FCS = pl_stats_tbl[ player:UserID() ].FCS + 1 + lvl
    -- Remove focus after 3 turns.
    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    local hookv2 = lvl
    hook.Add( "EnemyTurnEnd", pl_id .."precstrikehook", function()
        cd = cd + 1
        if cd >= 3 then
            pl_stats_tbl[ player:UserID() ].FCS = pl_stats_tbl[ player:UserID() ].FCS - 1 - hookv2
            hookv1:SetNWBool( "s_precstrike_oncd", false )
            hook.Remove( "EnemyTurnEnd", pl_id .."precstrikehook" )
        end
    end)
    SendSkillNote( "Precision Strike" )
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
    hook.Add( "EnemyTurnEnd", pl_id .."defmanohook", function()
        cd = cd + 1
        if cd >= 3 then
            pl_stats_tbl[ player:UserID() ].DEF = pl_stats_tbl[ player:UserID() ].DEF - calc1
            pl_stats_tbl[ player:UserID() ].DFX = pl_stats_tbl[ player:UserID() ].DFX - calc2
            hookv1:SetNWBool( "s_defmano_oncd", false )
            hook.Remove( "EnemyTurnEnd", pl_id .."defmanohook" )
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
    hook.Add( "EnemyTurnEnd", pl_id .."firstaidhook", function()
        cd = cd + 1
        if cd >= 3 then
            pl_stats_tbl[ player:UserID() ].MGT = pl_stats_tbl[ player:UserID() ].MGT - lvl
            hookv1:SetNWBool( "s_firstaid_oncd", false )
            hook.Remove( "EnemyTurnEnd", pl_id .."firstaidhook" )
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
        acc_modifier = 1.1
    else
        dmg_modifier = 0.1 + bonus1
        acc_modifier = 0.6
    end

    s_Retract()

    player:SetNWBool( "s_broadswing_oncd", true )

    local pl_id = player:AccountID()
    local cd = 0
    local hookv1 = player
    hook.Add( "EnemyTurnEnd", pl_id .."broadswinghook", function()
        cd = cd + 1
        if cd >= 2 then
            hookv1:SetNWBool( "s_broadswing_oncd", false )
            hook.Remove( "EnemyTurnEnd", pl_id .."broadswinghook" )
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
    hook.Add( "EnemyTurnEnd", pl_id .."fragmentationhook", function()
        cd = cd + 1
        if cd >= 4 then
            hookv1:SetNWBool( "s_fragmentation_oncd", false )
            hook.Remove( "EnemyTurnEnd", pl_id .."fragmentationhook" )
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
    hook.Add( "EnemyTurnEnd", pl_id .."firstaidhook", function()
        cd = cd + 1
        if cd >= 3 then
            hookv1:SetNWBool( "s_medicsupplies_oncd", false )
            hook.Remove( "EnemyTurnEnd", pl_id .."medicsupplieshook" )
        end
    end)
end


-- Enemy-only functions

function SlashAttack()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.9, 1.1 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.005 )

    c_miss = 0
    c_type = DMG_SLASH
    c_type2 = "Slash"

    CalcAttack()
end


function PierceAttack()
    attackdmg = ( enemies_table[ current_enemy:GetName() ].DMG ) - ( pl_stats_tbl[ attacktarget_id ].DEF * enemies_table[ current_enemy:GetName() ].DMGP )

    c_miss = 0
    c_type = DMG_SNIPER
    c_type2 = "Pierce"

    CalcAttack()
end

function BluntAttack()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.75, 1.25 )
    attackdmg = ( attackdmg - ( pl_stats_tbl[ attacktarget_id ].DEF * 0.9 ) ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.015  )

    c_miss = 0
    c_type = DMG_CLUB
    c_type2 = "Blunt"

    CalcAttack()
end

function Bash()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.8, 1.2 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF * 0.9 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.015 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 25
    stunbonus = -10
    CalcAttack()
end

function WideStagger()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.4, 0.65 )
    attackdmg = (attackdmg - pl_stats_tbl[ attacktarget_id ].DEF * 0.9 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.015 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 15
    stunbonus = 20
    CalcAttack()
end

function CalcAttack()
    if math.random( 1, 100 ) > pl_stats_tbl[ attacktarget_id ].DDG_TRUE + enemies_table[ current_enemy:GetName() ].MISS + c_miss then

        attackdmg = attackdmg + attackdmg * attacktarget:GetNWInt( "dmgresistance" )
        attackdmg = math.Round( math.Clamp( attackdmg, 1, 9999 ), 0 )

        calc_info = DamageInfo()
        calc_info:SetAttacker( current_enemy )
        calc_info:SetDamageType( c_type )
        calc_info:SetDamage( attackdmg )

        if c_type2 == "Pierce" then
            DoCrit2a()
        end

        attacktarget:TakeDamageInfo( calc_info )
        PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt ".. math.Round( calc_info:GetDamage(), 0 ) .." ".. c_type2 .." damage to ".. attacktarget:GetName() )

        if c_type2 == "Blunt" then
            DoStun()
        end

    else
        PrintMessage( HUD_PRINTTALK, attacktarget:GetName() .." dodged ".. current_enemy:GetName() .."'s attack!" )
        if c_type2 == "Slash" then
            attacktarget:EmitSound( "mgb_miss1.mp3", 150, 100, 1, CHAN_BODY )
        elseif c_type2 == "Pierce" then
            attacktarget:EmitSound( "mgb_miss2.mp3", 150, 100, 1, CHAN_BODY )
        else
            attacktarget:EmitSound( "mgb_miss3.mp3", 150, 100, 1, CHAN_BODY )
        end
    end
end

function G_AllyCall()
    if enemy2 == nil then
        enemypos_placeholder = Vector( 60, -234, -982 )
        SnowtlionScout()
        enemy2 = necessity
        timer.Simple( 1.25, function()
            sendIDs()
        end)
    else
        enemypos_placeholder = Vector( -225, -234, -982 )
        SnowtlionScout()
        enemy3 = necessity
        timer.Simple( 1.25, function()
            sendIDs()
        end)
    end
end

function G_Stampede()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 1.5, 2 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF * 0.9 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.015 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 0
    stunbonus = 30
    CalcAttack()
end

function G_Sudety()
    attacktarget:SetNWInt( "dmgresistance", math.Clamp( attacktarget:GetNWInt( "dmgresistance" ) - 0.12, -0.46, 0.46 ) )
end

function P_Eviscerate()
    -- Eviscerate ignores defence and flex defence completely.
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * 2 + 10

    c_miss = -25
    c_type = DMG_SNIPER
    c_type2 = "Pierce"

    CalcAttack()
end