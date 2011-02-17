
GM.OptimalWeight = 15 // If your weight is less than this then you gain stamina faster.
GM.MaxWeight = 35     // If your weight is higher than this then you run slower. 
GM.WeightCap = 50     // If your weight is higher than this then you run at a snail's pace.

if CLIENT then return end

GM.MinEventDelay = 60 * 5  // The minimum possible time, in seconds, between random events
GM.MaxEventDelay = 60 * 25 // The maximum possible time, in seconds, between random events

GM.MaxLoot = 0.05          // Maximum amount of loot to be generated ( Scalar - 0.10 means 10% of the info_lootspawns will have loot at them. )
GM.MaxZombiesScale = 1.0   // Scalar for amount of zombies to spawn per player - 1.0 means spawning 1 zombie per player, 2.0 means 2 per player, etc.
GM.MaxRoguesScale = 0.75   // Scalar for amount of rogues to spawn per player - 1.0 means spawning 1 rogue per player, 2.0 means 2 per player, etc.

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
	local chancetbl = { 1.0,    0.8,        0.7,      0.4,        0.6,       0.1,        0.2 }
	
	if num > 0 then
	
		for i=1, num do
		
			local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
			local pos = ent:GetPos()
		
			local loot = ents.Create( "sent_lootbag" )
			loot:SetPos( pos + Vector(0,0,5) )
			
			for j=1, math.random(2,5) do
			
				local num = math.Rand(0,1)
				local choice = math.random(1,7)
				
				while num < chancetbl[ choice ] do
				
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
	
	if #ents.FindByClass( "npc_rogue" ) < math.Round( GAMEMODE.MaxRoguesScale * #player.GetAll() ) then
	
		local tbl = ents.FindByClass( "info_npcspawn" )
		
		if #tbl < 1 then return end
		
		local spawn = table.Random( tbl )
		
		local ent = ents.Create( "npc_rogue" )
		ent:SetPos( spawn:GetPos() )
		ent:Spawn()
	
	end
	
	if #ents.FindByClass( "npc_zombie*" ) < math.Round( GAMEMODE.MaxZombiesScale * #player.GetAll() ) then
	
		local tbl = ents.FindByClass( "info_npcspawn" )
		
		if #tbl < 1 then return end
		
		local spawn = table.Random( tbl )
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

