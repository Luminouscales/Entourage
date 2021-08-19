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

    local proceed = net.ReadBool()

	mgbplayer = ply
    vis_int = 0

    RunString( skill_id .."()" )

    if proceed then
        hook.Call( "PlayerTurnEnd" )
        timer.Simple( 2, function()
            EnemyAttack()
        end)
    end
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
    timer.Simple( 1.25, function()
        dmg_modifier = 1
        acc_modifier = 1
    end)
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

-- Special Retract function for Distraction skill
function s_Retract2( bonus )
    local stuntarget = turntargets[1]
    local hittarget = turntargets[2]
    local dmg_modifier3 = dmg_modifier

    timer.Simple( 0.25, function()
        if IsValid(stuntarget) and stuntarget:Health() > 0 then
            turntarget = stuntarget
            turntargetsave = stuntarget:GetName()
            up_open = false

            dmg_modifier = dmg_modifier3 / 4
            RunString( items_table[ wpn ].func )

            -- again
            if IsValid(stuntarget) and stuntarget:Health() > 0 then
                if math.random( 1, 100 ) <= ( 25 + bonus * 5 ) - enemies_table[ turntargetsave ].DFX * 0.5 then
                    turntarget:SetNWInt( "stunturns", turntarget:GetNWInt( "stunturns" ) + 1 )
                    PrintMessage( HUD_PRINTTALK, turntargetsave .." is stunned for ".. turntarget:GetNWInt( "stunturns" ) .." turn(s)..." )
                    if enemies_table[ turntargetsave ].StunAnim ~= nil then
                        RunString( enemies_table[ turntargetsave ].StunAnim )
                    end
                end
            end
        end
    end)

    timer.Simple( 0.5, function()
        if IsValid(hittarget) and hittarget:Health() > 0 then
            turntarget = hittarget
            turntargetsave = hittarget:GetName()
            up_open = false

            dmg_modifier = dmg_modifier3
            RunString( items_table[ wpn ].func )
        end
    end)

    timer.Simple( 1.25, function()
        dmg_modifier = 1
        acc_modifier = 1
    end)
end

function DoCooldown( player, id, turns )
    local plid = player:UserID()
    local skcdid = "s_".. id .."_cd"
    player:SetNWBool( "s_".. id .."_oncd", true )
    player:SetNWInt( skcdid, turns )
    hook.Add( "EnemyTurnEnd", plid .."_".. id, function()
        player:SetNWInt( skcdid, player:GetNWInt( skcdid ) - 1 )
        if player:GetNWInt( skcdid ) <= -1 then
            player:SetNWBool( "s_".. id .."_oncd", false )
            hook.Remove( "EnemyTurnEnd", plid .."_".. id )
        end
    end)
end

-- SLASH
function s_precstrike()
    -- Precision Strike

    -- UP Cost
    entourage_AddUP( -10, 25 )

    -- First, check whether the weapon type is appropriate - if not, deduct damage and accuracy. Define level variables.
    local bonus1 = skill_lvl * 0.1

    if pltype == "Slash" or "Multiple" then
        dmg_modifier = 1 + bonus1
        acc_modifier = 1.5 + bonus1
    else
        dmg_modifier = 0.25 + bonus1
        acc_modifier = 0.75 + bonus1
    end
    -- Deal damage and stuffs, leave it to the weapon functions.
    s_Retract()

    -- Cooldown, buffs, skillnote
    entourage_AddBuff( mgbplayer, "precstrike", 3, skill_lvl )
    DoCooldown( mgbplayer, "precstrike", 3 )
    SendSkillNote( "Precision Strike" )
end

function s_defmano()
    -- Defensive Manoeuvre

    entourage_AddUP( -15, 25 )

    if pltype == "Slash" then
        dmg_modifier = 0.4 + lvl * 0.1
        acc_modifier = 1
    else
        dmg_modifier = 0.25 + lvl * 0.1
        acc_modifier = 0.75
    end

    s_Retract()

    entourage_AddBuff( mgbplayer, "defmano", 3, skill_lvl )
    DoCooldown( mgbplayer, "defmano", 3 )
    SendSkillNote( "Defensive Manoeuvre" )
end

function s_firstaid()
    -- Defensive Manoeuvre

    entourage_AddUP( -15, 25 )

    local target = turntargets[1]

    timer.Simple( 0.5, function()
        local heal = math.Round( 20 + 10 * skill_lvl + target:GetMaxHealth() / ( 100 - ( 2 + 3 * skill_lvl ) ), 0 )
        entourage_AddHealth( target, heal )
    end)

    entourage_AddBuff( mgbplayer, "firstaid", 3, skill_lvl )
    DoCooldown( mgbplayer, "firstaid", 3 )
    SendSkillNote( "First Aid" )
end

function s_broadswing()
    -- Broad Swing

    entourage_AddUP( -10, 25 )

    if pltype == "Slash" then
        dmg_modifier = 0.40 + skill_lvl * 0.05
        acc_modifier = 1.1
    else
        dmg_modifier = 0.1 + skill_lvl * 0.05
        acc_modifier = 0.6
    end

    s_Retract()

    DoCooldown( mgbplayer, "broadswing", 2 )
    SendSkillNote( "Broad Swing" )
end

function s_fragmentation()
    -- Fragmentation

    entourage_AddUP( -20, 25 )

    if pltype == "Slash" then
        dmg_modifier = 0.6 + skill_lvl * 0.05
        acc_modifier = 0.85
    else
        dmg_modifier = 0.3 + skill_lvl * 0.05
        acc_modifier = 0.55
    end

    s_Retract()

    DoCooldown( mgbplayer, "fragmentation", 4 )
    SendSkillNote( "Fragmentation" )
end

function s_medicsupplies()
    -- Medical Supplies

    entourage_AddUP( -20, 25 )

    local target = turntargets[1]

    timer.Simple( 0.5, function()
        local heal = math.Round( 40 + 10 * skill_lvl, 0 )
        entourage_AddHealth( target, heal )
    end)

    DoCooldown( mgbplayer, "medicsupplies", 4 )
    SendSkillNote( "Medical Supplies" )
end

function s_moraleslash()
    -- Morale Slash

    entourage_AddUP( -15, 25 )

    local bonus1 = skill_lvl * 0.05

    if pltype == "Slash" then
        dmg_modifier = 1.1 + bonus1
        acc_modifier = 1
    else
        dmg_modifier = 0.55 + bonus1
        acc_modifier = 0.50
    end

    s_Retract( bonus1 )

    hook.Add( "EntityTakeDamage", "moraleslash_oh", function( target, dmg )
        local playa = dmg:GetAttacker()
        if target:IsNPC() and playa == mgbplayer then
            print( "hit ")
            pl_stats_tbl[ mgbplayer:UserID() ].AGI = pl_stats_tbl[ mgbplayer:UserID() ].AGI + 1
            entourage_AddHealth( playa, 5 * skill_lvl + playa:GetMaxHealth() * 0.05 )
            hook.Remove( "EntityTakeDamage", "moraleslash_oh" )
        end
    end)
    timer.Simple( 1.25, function()
        hook.Remove( "EntityTakeDamage", "moraleslash_oh" )
    end)
    DoCooldown( mgbplayer, "moraleslash", 3 )
    SendSkillNote( "Morale Slash" )
end

function s_acrobatics()
    -- Acrobatics

    entourage_AddUP( -10, 25 )

    if pltype == "Slash" then
        dmg_modifier = 0.2 + skill_lvl * 0.05
        acc_modifier = 1.5
    else
        dmg_modifier = 0.05 + skill_lvl * 0.05
        acc_modifier = 0.75
    end

    s_Retract()

    DoCooldown( mgbplayer, "acrobatics", 5 )
    SendSkillNote( "Acrobatics" )
end

function s_distraction()
    -- Distraction

    entourage_AddUP( -20, 25 )

    if pltype == "Slash" then
        dmg_modifier = 1.15 + skill_lvl * 0.05
        acc_modifier = 1
    else
        dmg_modifier = 0.55 + skill_lvl * 0.05
        acc_modifier = 0.5
    end

    s_Retract2( skill_lvl )

    DoCooldown( mgbplayer, "distraction", 5 )
    SendSkillNote( "Distraction" )
end

function s_performance()
    -- Performance

    entourage_AddUP( -15, 25 )

    local lvl = skill_lvl
    local bonus1 = lvl * 0.05

    if pltype == "Pierce" then
        dmg_modifier = 0.55 + bonus1
        acc_modifier = 1
    else
        dmg_modifier = 0.25 + bonus1
        acc_modifier = 0.5
    end

    s_Retract()

    for _, v in ipairs( player.GetAll() ) do
        entourage_AddHealth( v, 5 + 5 * lvl )
    end

    DoCooldown( mgbplayer, "performance", 2 )
    SendSkillNote( "Performance" )
end
-- Enemy-only functions

-- Strike positions

-------------------

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
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF * 0.65 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.015 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 20
    stunbonus = 5
    CalcAttack()
end

function WideStagger()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.4, 0.65 )
    attackdmg = (attackdmg - pl_stats_tbl[ attacktarget_id ].DEF * 0.9 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.015 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 10
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
        calc_info:SetDamagePosition( strikepos )
        calc_info:SetDamageForce( strikevel * ( attackdmg / ( attacktarget:GetMaxHealth() * 0.5 ) ) )

        if c_type2 == "Pierce" then
            DoCrit2a()
        end

        local ah = math.Round( calc_info:GetDamage(), 0 )
        PrintMessage( HUD_PRINTTALK, current_enemy:GetName() .." dealt ".. ah .." ".. c_type2 .." damage to ".. attacktarget:GetName() )
        attacktarget:TakeDamageInfo( calc_info )
        net.Start( "DISPLAY_PAIN" )
            net.WriteEntity( attacktarget )
            net.WriteInt( ah, 32 )
            net.WriteBool( false ) -- heal? true or false
        net.Broadcast()

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
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 2, 3 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF * 1.25 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX * 0.02 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 0
    stunbonus = 50
    CalcAttack()
end

function G_Sudety()
    pl_stats_tbl[ attacktarget_id ].DEF = pl_stats_tbl[ attacktarget_id ].DEF - 7
end

function P_Eviscerate()
    -- Eviscerate ignores defence and flex defence completely.
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * 2 + 10

    c_miss = -25
    c_type = DMG_SNIPER
    c_type2 = "Pierce"

    CalcAttack()
end