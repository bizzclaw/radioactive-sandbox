
GM.DeathSounds = {"player/death1.wav",
"player/death2.wav",
"player/death3.wav",
"player/death4.wav",
"player/death5.wav"}

GM.Ricochet = {"weapons/fx/rics/ric1.wav",
"weapons/fx/rics/ric2.wav",
"weapons/fx/rics/ric3.wav",
"weapons/fx/rics/ric4.wav",
"weapons/fx/rics/ric5.wav"}

GM.Geiger = {"radbox/geiger_1.wav",
"radbox/geiger_2.wav",
"radbox/geiger_3.wav",
"radbox/geiger_4.wav",
"radbox/geiger_5.wav",
"radbox/geiger_6.wav",
"radbox/geiger_7.wav",
"radbox/geiger_8.wav"}

GM.Coughs = { "ambient/voices/cough1.wav",
"ambient/voices/cough2.wav",
"ambient/voices/cough3.wav",
"ambient/voices/cough4.wav",
"ambient/voices/citizen_beaten3.wav",
"ambient/voices/citizen_beaten4.wav" }

GM.Corpses = {"models/player/Charple01.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

for k,v in pairs( GM.Corpses ) do
	util.PrecacheModel( v )
end