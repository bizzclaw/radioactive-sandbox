
// REPLACE MODDABLE.LUA WITH THIS IF YOU WANT TO HAVE STALKER PLAYERMODELS!
// YOU NEED THE STALKER PLAYERMODEL CONTENT PACK!
// http://www.garrysmod.org/downloads/?a=view&id=96195
// some of the models in that pack have broken anims but whatever...

// Team Numbers 

TEAM_ARMY = 1
TEAM_BANDOLIERS = 2
TEAM_EXODUS = 3
TEAM_LONER = 4

// Team Names

GM.BandoliersTeamName = "Bandits"
GM.ArmyTeamName = "Duty Alliance"
GM.ExodusTeamName = "Freedom"

// Team Leader Models

GM.TeamLeaderModels = {}
GM.TeamLeaderModels[ TEAM_ARMY ] = "models/stalker_hood_duty.mdl"
GM.TeamLeaderModels[ TEAM_EXODUS ] = "models/stalker_antigas_killer_us.mdl"
GM.TeamLeaderModels[ TEAM_BANDOLIERS ] = "models/stalker_bandit_veteran2.mdl"
GM.TeamLeaderModels[ TEAM_LONER ] = "models/stalker_hood_monolith.mdl"

// Team Player Models

GM.TeamPlayerModels = {}
GM.TeamPlayerModels[ TEAM_ARMY ] = { "models/stalker_hood_svob.mdl",
									 "models/stalker_hood_svob1.mdl",
								 	 "models/stalker_hood.mdl",
									 "models/stalker_hood_corpse.mdl" }
									 
GM.TeamPlayerModels[ TEAM_EXODUS ] = { "models/stalker_antigas_killer.mdl",
									   "models/stalker_antigas_killer2.mdl",
									   "models/stalker_antigas_killer3.mdl" }

GM.TeamPlayerModels[ TEAM_BANDOLIERS ] = { "models/stalker_bandit_veteran.mdl" }

GM.TeamPlayerModels[ TEAM_LONER ] = { "models/stalker_hood_monolith.mdl",
									  "models/stalker_hood_mono_corpse.mdl" }
	
// Chat Auto-Emotes

GM.ChatEmotes = {}
GM.ChatEmotes[ "Drunk" ] = { "/me burps",
"/me belches",
"/me vomits",
"/me feels dizzy and disoriented",
"/me staggers to the left",
"/me staggers to the right",
"/me has a headache from drinking too much alcohol",
"/me drank too much vodka",
"/me is drunk",
"/me has a stomach ache from drinking moonshine" }

GM.ChatEmotes[ "Radiation" ] = { "/me is nauseous from radiation poisoning",
"/me feels weak",
"/me is fatigued",
"/me has an unhealthy radioactive glow",
"/me vomits up blood",
"/me has a headache from radiation poisoning" }

GM.ChatEmotes[ "Bleeding" ] = { "/me feels weak from blood loss",
"/me has lost a lot of blood",
"/me needs some bandages",
"/me is covered in blood",
"/me feels lightheaded" }

GM.ChatEmotes[ "Pain" ] = { "/me moans in pain",
"/me requires first aid",
"/me is in a lot of pain",
"/me is severely injured",
"/me is hurt badly" }

// Weight Limits (lbs)
	
GM.OptimalWeight = 15 // If your weight is less than this then you gain stamina faster.
GM.MaxWeight = 35     // If your weight is higher than this then you run slower. 
GM.WeightCap = 50     // If your weight is higher than this then you run at a snail's pace.

if CLIENT then return end

GM.MinEventDelay = 60 * 5  // The minimum possible time, in seconds, between random events
GM.MaxEventDelay = 60 * 25 // The maximum possible time, in seconds, between random events

GM.RadiationAmount = 0.6   // How much of the radiation on the map should be disabled on map startup? ( Scalar - 0.6 means 60% will be disabled )
GM.MaxLoot = 0.05          // Maximum amount of loot to be generated ( Scalar - 0.10 means 10% of the info_lootspawns will have loot at them. )
GM.MaxZombiesScale = 0.75  // Scalar for amount of zombies to spawn per player - 1.0 means spawning 1 zombie per player, 2.0 means 2 per player, etc.
GM.MaxRoguesScale = 0.50   // Scalar for amount of rogues to spawn per player - 1.0 means spawning 1 rogue per player, 2.0 means 2 per player, etc.
GM.MaxZombies = 8         // Max amount of zombies allowed.
GM.MaxRogues = 6          // Max amount of rogues allowed.

function GM:LootThink()

	if #ents.FindByClass( "info_lootspawn" ) < 10 then return end

	local amt = math.floor( GAMEMODE.MaxLoot * #ents.FindByClass( "info_lootspawn" ) )
	local total = 0
	
	for k,v in pairs( ents.FindByClass( "sent_lootbag" ) ) do
	
		if v.RandomLoot then
		
			total = total + 1
		
		end
	
	end
	
	local num = amt - total
	local tbl = { ITEM_FOOD, ITEM_SUPPLY, ITEM_LOOT, ITEM_AMMO, ITEM_MISC, ITEM_EXODUS, ITEM_WPN_COMMON }
	local chancetbl = { 1.00,    0.80,        0.80,      0.40,     0.60,       0.05,          0.05 }
	
	if num > 0 then
	
		for i=1, num do
		
			local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
			local pos = ent:GetPos()
		
			local loot = ents.Create( "sent_lootbag" )
			loot:SetPos( pos + Vector(0,0,5) )
			
			for j=1, math.random(2,5) do
			
				local num = math.Rand(0,1)
				local choice = math.random(1,7)
				
				while num > chancetbl[ choice ] do
				
					num = math.Rand(0,1)
					choice = math.random(1,7)
				
				end
			
				local rand = item.RandomItem( tbl[choice] )
			
				loot:AddItem( rand.ID )
			
			end
			
			loot.RandomLoot = true
			loot:Spawn()
		
		end
	
	end

end

function GM:NPCThink()
	
	if #ents.FindByClass( "npc_rogue" ) < math.Round( GAMEMODE.MaxRoguesScale * #player.GetAll() ) and #ents.FindByClass( "npc_rogue" ) < GAMEMODE.MaxRogues then
	
		local tbl = ents.FindByClass( "info_npcspawn" )
		
		if #tbl < 1 then return end
		
		local spawn
		local blocked = true 
		local count = 0
		
		while blocked and count < 20 do
		
			spawn = table.Random( tbl )
			blocked = false
			count = count + 1
		
			for k,v in pairs( player.GetAll() ) do
			
				if v:GetPos():Distance( spawn:GetPos() ) < 800 then 
				
					blocked = true
				
				end
			
			end
		
		end
		
		local ent = ents.Create( "npc_rogue" )
		ent:SetPos( spawn:GetPos() )
		ent:Spawn()
	
	end
	
	if #ents.FindByClass( "npc_zombie*" ) < math.Round( GAMEMODE.MaxZombiesScale * #player.GetAll() ) and #ents.FindByClass( "npc_zombie*" ) < GAMEMODE.MaxZombies then
	
		local tbl = ents.FindByClass( "info_npcspawn" )
		
		if #tbl < 1 then return end
		
		local spawn
		local blocked = true 
		local count = 0
		
		while blocked and count < 20 do
		
			spawn = table.Random( tbl )
			blocked = false
			count = count + 1
		
			for k,v in pairs( player.GetAll() ) do
			
				if v:GetPos():Distance( spawn:GetPos() ) < 800 then 
				
					blocked = true
				
				end
			
			end
		
		end
		
		local zomb = table.Random{ "npc_zombie_normal", "npc_zombie_fast", "npc_zombie_poison" }
		local ent = ents.Create( zomb )
		ent:SetPos( spawn:GetPos() )
		ent:Spawn()
	
	end

end

function GM:VehicleThink()

	if #ents.FindByClass( "info_lootspawn" ) < 10 then return end

	if #ents.FindByClass( "prop_vehicle_jeep" ) < 1 then
		
		local pos = table.Random( ents.FindByClass( "info_lootspawn" ) ):GetPos() 
		
		local trace = {}
		trace.start = pos
		trace.endpos = pos + Vector(0,0,90000)

		local tr = util.TraceLine( trace )
		
		while not tr.HitSky do
		
			pos = table.Random( ents.FindByClass( "info_lootspawn" ) ):GetPos() 
			
			trace = {}
			trace.start = pos
			trace.endpos = pos + Vector(0,0,90000)

			tr = util.TraceLine( trace )
		
		end
		
		local jeep = ents.Create( "prop_vehicle_jeep" )
		jeep:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" )
		jeep:SetModel( "models/buggy.mdl" )
		jeep:SetPos( trace.start + Vector(0,0,2500) )
		jeep:Spawn()
	
	end

end