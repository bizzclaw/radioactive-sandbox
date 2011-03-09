
resource.AddFile( "materials/radbox/radar.vmt" )
resource.AddFile( "materials/radbox/radar_back.vtf" )
resource.AddFile( "materials/models/srp/items/art_urchen/urchen.vmt" )
resource.AddFile( "materials/models/srp/items/art_urchen/urchen2.vmt" )
resource.AddFile( "resource/fonts/Graffiare.ttf" )
resource.AddFile( "sound/radbox/warning.wav" )
resource.AddFile( "sound/radbox/heartbeat.wav" )
resource.AddFile( "sound/radbox/anom01.wav" )
resource.AddFile( "sound/radbox/anom02.wav" )
resource.AddFile( "sound/radbox/anom03.wav" )
resource.AddFile( "sound/radbox/anom04.wav" )

for i=1,8 do

	resource.AddFile( "sound/radbox/geiger_" .. i .. ".vtf" )

end

local include_mat = { "materials/models/weapons/v_models/shot_m3super91/shot_m3super91_norm",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91_2_norm",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91_2",
"materials/models/ammoboxes/smg",
"materials/models/srp/items/art_crystalthorn/crystalthorn",
"materials/models/srp/items/art_crystalthorn/crystalthorn2",
"materials/models/srp/items/art_fireball/fireball",
"materials/models/srp/items/art_fireball/fireball2",
"materials/models/srp/items/art_moonlight/moonlight",
"materials/models/srp/items/art_moonlight/moonlight2",
"materials/models/srp/items/art_stoneblood/stoneblood",
"materials/radbox/radar_arm",
"materials/radbox/radar_arrow",
"materials/radbox/logo_nma",
"materials/radbox/logo_exodus",
"materials/radbox/logo_bandoliers",
"materials/radbox/menu_quest",
"materials/radbox/menu_loot",
"materials/radbox/menu_trade",
"materials/radbox/menu_cancel",
"materials/radbox/menu_save",
"materials/radbox/nvg_noise",
"materials/radbox/refract_ring",
"materials/radbox/img_radiation",
"materials/radbox/img_blood",
"materials/radbox/img_health",
"materials/radbox/img_stamina",
"materials/radbox/healthpack",
"materials/radbox/healthpack2",
"materials/radbox/bandage",
"materials/radbox/geiger",
"materials/radbox/geiger_needle",
"materials/radbox/geiger_model" }

for k,v in pairs( include_mat ) do

	resource.AddFile( v..".vmt" )
	resource.AddFile( v..".vtf" )

end

local include_model = { "models/weapons/v_shot_m3super91",
"models/items/boxqrounds",
"models/srp/items/art_fireball",
"models/srp/items/art_moonlight",
"models/srp/items/art_stoneblood",
"models/srp/items/art_urchen",
"models/srp/items/art_crystalthorn",
"models/radbox/bandage",
"models/radbox/geiger",
"models/radbox/healthpack",
"models/radbox/healthpack2" }

for k,v in pairs( include_model ) do

	resource.AddFile( v..".vvd" )
	resource.AddFile( v..".sw.vtx" )
	resource.AddFile( v..".mdl" )
	resource.AddFile( v..".dx80.vtx" )
	resource.AddFile( v..".dx90.vtx" )

end

