
-- Calculates damage based on resistances

function SnowtlionMinerDMG()
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.01 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) ) * 2.5
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) * 0.85
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function UniversalDMG() -- TEMPLATE
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.01 ) -- slash deals more against flex defence
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.01 ) ) -- pierce is unaffected by DFX
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) -- blunt is affected less by defence and more by DFX
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function SkinnerDMG()
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.01 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.01 ) ) * 0.75
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.02 ) * 1.75
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3, 1, 999 ), 0 )
end

function DefaultDMG() -- Guardian AI
	if pltype2 == "Slash" then
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF ) * ( 1 + slash_dfx - enemies_table[ turntargetsave ].DFX * 0.01 )
	elseif pltype2 == "Pierce" then
		wpndmg3 = ( wpndmg3 - ( enemies_table[ turntargetsave ].DEF - enemies_table[ turntargetsave ].DEF * wp_pierce ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.01 ) )
	else
		wpndmg3 = ( wpndmg3 - enemies_table[ turntargetsave ].DEF * 0.75 ) * ( 1 - enemies_table[ turntargetsave ].DFX * 0.01 )
	end
	wpndmg3 = math.Round( math.Clamp( wpndmg3 * 1.25, 1, 999 ), 0 ) -- multiply because of guardian's damage res
end