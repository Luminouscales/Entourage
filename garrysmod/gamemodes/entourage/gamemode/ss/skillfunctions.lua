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
    slash_dfx = net.ReadInt( 32 )
    slash_acc = net.ReadInt( 32 ) * 0.05 

    proceed = net.ReadBool()
    --endcustom = net.ReadBool()

	mgbplayer = ply
    vis_int = 0

    RunString( skill_id .."()" )

    -- if proceed then
    --     hook.Call( "PlayerTurnEnd" )
    --     timer.Simple( 2, function()
    --         EnemyAttack()
    --     end)
    -- end
end)

-- Utility
-- Function for dealing skill damage. Does not support damage decrease by number of targets.
function s_Retract()
    for k, v in pairs( turntargets ) do 
        vis_int = vis_int + 0.25
        timer.Simple( vis_int, function()
            if IsValid(v) and v:Health() > 0 then
                turntarget = v
                turntargetsave = v:GetName()
                up_open = false

                RunString( items_table[ wpn ].func )
            end
            if k == #turntargets and proceed then
                timer.Simple( 1, function()
                    hook.Call( "PlayerTurnEnd" )
                    EnemyAttack()
                end)
            end
        end)
    end
    timer.Simple( 1.25, function()
        dmg_modifier = 1
        acc_modifier = 1
        flatdmg = 0
        critbonus = 0
        critdmg = 0
    end)
end

function DoCrit2a()
	if critbonus == nil then
		critbonus = 0
	end
	if math.random( 1, 100 ) <= enemies_table[ current_enemy:GetName() ].DMGC + critbonus then
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
	if math.random( 1, 100 ) <= attackdmg / attacktarget:GetMaxHealth() * 70 + stunbonus + stunbonus_a - pl_stats_tbl[ attacktarget_id ].VIT_TRUE * 2 - pl_stats_tbl[ attacktarget_id ].DFX_TRUE * 0.5 - attacktarget:GetNWInt( "stunturns_a" ) * 50 then 
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
        dmg_modifier = 0.4 + skill_lvl * 0.1
        acc_modifier = 1
    else
        dmg_modifier = 0.25 + skill_lvl * 0.1
        acc_modifier = 0.75
    end

    s_Retract()

    entourage_AddBuff( mgbplayer, "defmano", 1, skill_lvl )
    DoCooldown( mgbplayer, "defmano", 3 )
    SendSkillNote( "Defensive Manoeuvre" )
end

function s_firstaid()
    -- First Aid

    entourage_AddUP( -15, 25 )

    local target = turntargets[1]

    timer.Simple( 0.5, function()
        local heal = math.Round( 10 + 10 * skill_lvl + target:GetMaxHealth() / ( 100 - ( 2 + 3 * skill_lvl ) ), 0 )
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
        dmg_modifier = 0.65 + skill_lvl * 0.05
        acc_modifier = 1.25
    else
        dmg_modifier = 0.30 + skill_lvl * 0.05
        acc_modifier = 1
    end

    s_Retract()

    DoCooldown( mgbplayer, "broadswing", 2 )
    SendSkillNote( "Broad Swing" )

    -- timer.Simple( 2, function()
    --     EnemyAttack()
    -- end)
end

function s_fragmentation()
    -- Fragmentation

    entourage_AddUP( -20, 25 )

    if pltype == "Slash" then
        dmg_modifier = 0.85 + skill_lvl * 0.05
        acc_modifier = 0.85
    else
        dmg_modifier = 0.4 + skill_lvl * 0.05
        acc_modifier = 0.55
    end

    slash_dfx = slash_dfx + ( 10 + skill_lvl * 2 ) * 0.01

    s_Retract()

    DoCooldown( mgbplayer, "fragmentation", 4 )
    SendSkillNote( "Fragmentation" )

    -- timer.Simple( 2, function()
    --     EnemyAttack()
    -- end)
end

function s_medicsupplies()
    -- Medical Supplies

    entourage_AddUP( -20, 25 )

    local heal = math.Round( 40 + 10 * skill_lvl, 0 )
    for i = 1, #turntargets, 1 do
        if heal > 0 then
            entourage_AddHealth( turntargets[i], heal )
            heal = math.Clamp( heal, 0, heal - ( turntargets[i]:GetMaxHealth() - turntargets[i]:Health() ) )
        end
        -- if i == #turntargets or heal <= 0 then
        --     timer.Simple( 2, function()
        --         EnemyAttack()
        --     end)
        -- end
    end

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
            SetOffset( mgbplayer, "cle", 1 )
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

    entourage_AddBuff( mgbplayer, "acrobatics", 1, skill_lvl )
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

    entourage_AddUP( -10, 25 )

    local bonus1 = skill_lvl * 0.05

    if pltype == "Pierce" then
        dmg_modifier = 0.30 + bonus1
        acc_modifier = 1
    else
        dmg_modifier = 0.10 + bonus1
        acc_modifier = 0.5
    end

    s_Retract()

    for _, v in ipairs( player.GetAll() ) do
        entourage_AddHealth( v, 5 + 5 * skill_lvl + v:GetMaxHealth()/95 )
    end

    DoCooldown( mgbplayer, "performance", 1 )
    SendSkillNote( "Performance" )
end

function s_vprecision()
    entourage_AddUP( -25, 25 )

    local bonus1 = skill_lvl * 0.05 + 0.5
    local save = ( pl_stats_tbl[ mgbplayer:UserID() ].AGI_TRUE + pl_stats_tbl[ mgbplayer:UserID() ].FCS_TRUE ) * bonus1
    local dude = mgbplayer

    mgbplayer:SetNWInt( "flatdmg", mgbplayer:GetNWInt( "flatdmg") + save )

    if pltype == "Slash" or "Multiple" then
        dmg_modifier = 1
        acc_modifier = 1
    else
        dmg_modifier = 0.5
        acc_modifier = 0.75
    end

    hook.Add( "EnemyTurnEnd", mgbplayer:UserID() .."COCKA", function()
        mgbplayer:SetNWInt( mgbplayer:GetNWInt( "flatdmg" ) - save )
        hook.Remove( "EnemyTurnEnd", dude:UserID() .."COCKA" )
    end)

    s_Retract()

    DoCooldown( mgbplayer, "vprecision", 3 )
    SendSkillNote( "Via Precision" )
end

function s_dedications()
    entourage_AddUP( -15, 25 )

    for _, v in ipairs( player.GetAll() ) do
        local id = v:UserID()
        entourage_AddBuff( v, "dedications", 3, skill_lvl )
    end

    DoCooldown( mgbplayer, "dedications", 3 )
    SendSkillNote( "Dedications" )
    timer.Simple( 0.4, function()
        SendSkillNote( "Party Defence and Damage is increased!" )
    end)
end

function s_moderato()
    entourage_AddUP( -25, 25 )

    for _, v in ipairs( player.GetAll() ) do
        local id = v:UserID()
        entourage_AddBuff( v, "moderato", 2, skill_lvl )
    end

    DoCooldown( mgbplayer, "moderato", 2 )
    SendSkillNote( "Moderato" )
    timer.Simple( 0.4, function()
        SendSkillNote( "Party Accuracy and Dodge is increased!" )
    end)
end

function s_zillionedge()
    entourage_AddUP( -15, 25 )

    -- First, check whether the weapon type is appropriate - if not, deduct damage and accuracy. Define level variables.
    local bonus1 = skill_lvl * 0.05
    local bonus2 = math.random( -0.5 - bonus1, 0.5 + bonus1 )

    if pltype == "Pierce" or "Multiple" then
        dmg_modifier = 1 + bonus2
        acc_modifier = 1
    else
        dmg_modifier = 0.5 + bonus2
        acc_modifier = 0.75
    end
    -- Deal damage and stuffs, leave it to the weapon functions.
    s_Retract()

    -- Cooldown, buffs, skillnote
    DoCooldown( mgbplayer, "zillionedge", 2 )
    SendSkillNote( "Zillion Edge" )
end

function s_tknives()
    entourage_AddUP( -10, 25 )

    local bonus1 = skill_lvl * 2
    local bonus2 = skill_lvl * 0.03

    if pltype == "Pierce" or "Multiple" then
        dmg_modifier = 0.3 + bonus2
        acc_modifier = 1
    else
        dmg_modifier = 0.05 + bonus2
        acc_modifier = 0.75
    end
    -- Deal damage and stuffs, leave it to the weapon functions.
    hook.Add( "EntityTakeDamage", "tknives_oh", function( target, dmg )
        local playa = dmg:GetAttacker()
        if target:IsNPC() and playa == mgbplayer then
            entourage_AddBuff( mgbplayer, "tknives", 1, skill_lvl, true )
        end
    end)
    timer.Simple( 4, function()
        hook.Remove( "EntityTakeDamage", "tknives_oh" )
    end)

    -- Roll random targets
    local targets = math.random( 1, 6 )
    local targetstbl = {}
    for k, v in ipairs( battle_enemies ) do 
        targetstbl[k] = v
    end
    turntargets = {}
    for i = 1, targets, 1 do 
        turntargets[i] = table.Random( targetstbl )
        -- if i == targets then
        --     timer.Simple( 1, function()
        --         EnemyAttack()
        --     end)
        -- end
    end
    ----------------------
    s_Retract()

    -- Cooldown, buffs, skillnote
    -- DoCooldown( mgbplayer, "tknives", 1 )
    SendSkillNote( "Throwing Knives" )
end

function s_qethics()
    -- Questionable Ethics

    entourage_AddUP( -15, 25 )

    local target = mgbplayer

    timer.Simple( 0.5, function()
        local heal1 = math.random( 0, target:GetMaxHealth()/100 * 25 + skill_lvl * 5 )
        entourage_AddHealth( target, math.Round( heal1, 0 ) )
    end)

    DoCooldown( mgbplayer, "qethics", 3 )
    SendSkillNote( "Questionable Ethics" )
end

function s_heartcut()
    entourage_AddUP( -15, 25 )

    local bonus1 = skill_lvl
    local bonus2 = math.random( -0.5 - bonus1, 0.5 + bonus1 )

    if pltype == "Pierce" or "Multiple" then
        dmg_modifier = 0.75
        acc_modifier = 1
        critbonus = 15 + bonus1 * 5
        critdmg = 1.10 + bonus1 * 0.05
    else
        dmg_modifier = 0.35
        acc_modifier = 0.75
    end
    -- Deal damage and stuffs, leave it to the weapon functions.
    s_Retract()

    -- Cooldown, buffs, skillnote
    DoCooldown( mgbplayer, "heartcut", 3 )
    SendSkillNote( "Heartful Cut" )
end

function s_gouge()
    -- Gouge

    -- UP Cost
    entourage_AddUP( -20, 25 )

    -- First, check whether the weapon type is appropriate - if not, deduct damage and accuracy. Define level variables.
    local bonus1 = skill_lvl * 0.05

    if pltype == "Pierce" or "Multiple" then
        dmg_modifier = 0.5 + bonus1
        acc_modifier = 1
    else
        dmg_modifier = 0.5
        acc_modifier = 0.75
    end

    mathilda = mathilda + 1
    local mathilda2 = mathilda
    hook.Add( "EntityTakeDamage", mathilda2 .."gouge_oh", function( target, dmg )
        local playa = dmg:GetAttacker()
        if target:IsNPC() and playa == mgbplayer then
            SetOffset( mgbplayer, "ddg", 15 + skill_lvl * 3 )
            hook.Remove( "EntityTakeDamage", mathilda2 .."gouge_oh" )
        end
    end)
    timer.Simple( 1.25, function()
        hook.Remove( "EntityTakeDamage", "gouge_oh" )
    end)

    -- Deal damage and stuffs, leave it to the weapon functions.
    s_Retract()

    -- Cooldown, buffs, skillnote
    entourage_AddBuff( mgbplayer, "gouge", 3, skill_lvl )
    DoCooldown( mgbplayer, "gouge", 3 )
    SendSkillNote( "Gouge" )
end
-- Enemy-only functions

function SlashAttack()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.9, 1.1 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF_TRUE ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX_TRUE * 0.005 )

    c_miss = 0
    c_type = DMG_SLASH
    c_type2 = "Slash"

    CalcAttack()
end


function PierceAttack()
    attackdmg = ( enemies_table[ current_enemy:GetName() ].DMG ) - ( pl_stats_tbl[ attacktarget_id ].DEF_TRUE * enemies_table[ current_enemy:GetName() ].DMGP )

    c_miss = 0
    c_type = DMG_SNIPER
    c_type2 = "Pierce"

    CalcAttack()
end

function BluntAttack()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.75, 1.25 )
    attackdmg = ( attackdmg - ( pl_stats_tbl[ attacktarget_id ].DEF_TRUE * 0.9 ) ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX_TRUE * 0.015  )

    c_miss = 0
    c_type = DMG_CLUB
    c_type2 = "Blunt"

    CalcAttack()
end

function Bash()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.8, 1.2 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF_TRUE * 1.35 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX_TRUE * 0.025 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 25
    stunbonus = 5
    CalcAttack()
end

function WideStagger()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 0.35, 0.55 )
    attackdmg = (attackdmg - pl_stats_tbl[ attacktarget_id ].DEF_TRUE * 0.85 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX_TRUE * 0.02 )

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

        if c_type2 == "Blunt" and attacktarget:Health() > 0 then
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
        if attacktarget:IsPlayer() and math.random( 1, 10 ) + attackdmg / attacktarget:Health() * 10 >= 10 then
            SendDialogue( 0, attacktarget, "plconv_dodge" )
        end
    end
end

function G_AllyCall()
    if enemy2 == nil then
        enemypos_placeholder = Vector( 60, -234, -982 )
        SnowtlionKnight( 50 )
        enemy2 = necessity
        timer.Simple( 1.25, function()
            sendIDs()
        end)
    else
        enemypos_placeholder = Vector( -225, -234, -982 )
        SnowtlionKnight( 50 )
        enemy3 = necessity
        timer.Simple( 1.25, function()
            sendIDs()
        end)
    end
end

function G_Stampede()
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * math.Rand( 2.5, 3.5 )
    attackdmg = ( attackdmg - pl_stats_tbl[ attacktarget_id ].DEF_TRUE * 2.2 ) * ( 1 - pl_stats_tbl[ attacktarget_id ].DFX_TRUE * 0.025 )

    c_type = DMG_CLUB
    c_type2 = "Blunt"
    c_miss = 20
    stunbonus = 50
    CalcAttack()
end

function G_Sudety()
    SetOffset( attacktarget, "def", -7 )
end

function P_Eviscerate()
    -- Eviscerate ignores defence and flex defence completely.
    attackdmg = enemies_table[ current_enemy:GetName() ].DMG * 2 + 10

    c_miss = -25
    c_type = DMG_SNIPER
    c_type2 = "Pierce"

    CalcAttack()
end