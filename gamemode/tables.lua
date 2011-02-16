
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

GM.BombExplosion = {"weapons/hegrenade/explode3.wav",
"weapons/hegrenade/explode4.wav",
"weapons/hegrenade/explode5.wav"}

GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

for k,v in pairs( GM.Corpses ) do
	util.PrecacheModel( v )
end