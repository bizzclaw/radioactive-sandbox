
// REPLACE RESOURCE.LUA WITH THIS IF YOU WANT PLAYERS TO DOWNLOAD THE PLAYERMODELS FROM THE SERVER WHEN THEY JOIN!
// YOU NEED THE STALKER PLAYERMODEL CONTENT PACK!
// http://www.garrysmod.org/downloads/?a=view&id=96195

resource.AddFile( "materials/radbox/radar.vmt" )
resource.AddFile( "materials/radbox/radar_back.vtf" )
resource.AddFile( "resource/fonts/Graffiare.ttf" )
resource.AddFile( "sound/radbox/warning.vtf" )
resource.AddFile( "sound/radbox/heartbeat.vtf" )

local include_mat = { "materials/models/weapons/v_models/shot_m3super91/shot_m3super91_norm",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91_2_norm",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91_2",
"materials/models/ammoboxes/smg",
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
"materials/radbox/bandage" }

for k,v in pairs( include_mat ) do

	resource.AddFile( v..".vmt" )
	resource.AddFile( v..".vtf" )

end

local include_model = { "models/weapons/v_shot_m3super91",
"models/items/boxqrounds",
"models/radbox/bandage",
"models/radbox/healthpack",
"models/radbox/healthpack2",
"models/stalker_hood_duty.mdl",
"models/stalker_antigas_killer_us.mdl",
"models/stalker_bandit_veteran.mdl",
"models/stalker_bandit_veteran2.mdl",
"models/stalker_hood_monolith.mdl",
"models/stalker_hood_mono_corpse.mdl",
"models/stalker_hood_svob.mdl",
"models/stalker_hood_svob1.mdl",
"models/stalker_hood.mdl",
"models/stalker_hood_corpse.mdl",
"models/stalker_antigas_killer.mdl",
"models/stalker_antigas_killer2.mdl",
"models/stalker_antigas_killer3.mdl" }

for k,v in pairs( include_model ) do

	resource.AddFile( v..".vvd" )
	resource.AddFile( v..".sw.vtx" )
	resource.AddFile( v..".mdl" )
	resource.AddFile( v..".dx80.vtx" )
	resource.AddFile( v..".dx90.vtx" )

end

