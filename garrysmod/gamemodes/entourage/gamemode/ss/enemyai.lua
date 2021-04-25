
-- Calculates damage based on resistances

function SnowtlionMinerDMG()
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.0075 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) * 2.5
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) * 0.85
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function UniversalDMG() -- TEMPLATE
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.005 ) -- slash deals more against flex defence
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) -- pierce is unaffected by DFX
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) -- blunt is affected less by defence and more by DFX
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function SkinnerDMG()
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.005 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) * 0.75
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) * 1.75
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end