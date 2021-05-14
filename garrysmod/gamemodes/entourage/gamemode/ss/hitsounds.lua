-- FE hitsounds but only with the kill sound and crit sound

local f_high = file.Find("sound/high_feher*.wav", "GAME")

-- Crits

hook.Add( "EntityTakeDamage", "FESoundHook", function( target, dmginfo )
    if dmginfo:GetDamage() >= target:GetMaxHealth() * 0.75 then
        target:EmitSound( f_high[math.random(1, #f_high)], 60, 100, 1, CHAN_AUTO )
    end
end)

-- Kills
hook.Add( "OnNPCKilled", "FEDeathHook", function( npc, attacker, inflictor )
	npc:EmitSound( "final_feher.wav", 60, 100, 1, CHAN_BODY ) 
end)

hook.Add( "PlayerDeath", "FEDeathHook_Player", function( player, inflictor, attacker )
	player:EmitSound( "final_feher.wav", 80, 100, 1 )
end)