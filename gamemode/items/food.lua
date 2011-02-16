
// This is the ID given to any item that is edible 
ITEM_FOOD = 1

// Weight constants
WEIGHT_FOOD_SMALL = 0.15
WEIGHT_FOOD_LARGE = 0.30

// Price constants
PRICE_FOOD = 5
PRICE_RAREFOOD = 50
PRICE_BOOZE = 25

function FUNC_DRINK( ply, id, client )

	if client then return "Drink" end

	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddHealth( 20 )
	ply:AddStamina( 20 )

end

function FUNC_EAT( ply, id, client )

	if client then return "Eat" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "npc/barnacle/barnacle_crunch2.wav", 100, math.random( 90, 110 ) )
	ply:AddHealth( 20 )
	ply:AddStamina( 20 )

end

item.Register( { 
	Name = "Grapefruit", 
	Description = "This kind of fruit is quite rare to find in these areas. It looks ripe.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_RAREFOOD,
	Rarity = 0.85,
	Model = "models/props/de_inferno/crate_fruit_break_gib2.mdl",
	Functions = { FUNC_EAT },
	CamPos = Vector(10,12,1),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Milk", 
	Description = "Dairy products are a rare delicacy to find nowadays. The milk in this jug smells pretty fresh.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_RAREFOOD,
	Rarity = 0.95,
	Model = "models/props_junk/garbage_milkcarton001a.mdl", 
	Functions = { FUNC_DRINK },
	CamPos = Vector(20,15,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Milk", 
	Description = "Dairy products are a rare delicacy to find nowadays. This milk smells a bit strange, but it should still be safe to drink.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_RAREFOOD,
	Rarity = 0.95,
	Model = "models/props_junk/garbage_milkcarton002a.mdl", 
	Functions = { FUNC_DRINK },
	CamPos = Vector(20,15,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Water", 
	Description = "This dirty bottle is full of water. It should be safe to drink.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_FOOD,
	Rarity = 0.05,
	Model = "models/props_junk/garbage_plasticbottle003a.mdl",
	Functions = { FUNC_DRINK },
	CamPos = Vector(20,22,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Canned Soup", 
	Description = "This can contains some sort of vegetable soup. The label has been torn off.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_FOOD,
	Rarity = 0.05,
	Model = "models/props_junk/garbage_metalcan002a.mdl",
	Functions = { FUNC_EAT },
	CamPos = Vector(10,15,0),
	CamOrigin = Vector(0,0,1)	
} )

item.Register( { 
	Name = "Canned Meat", 
	Description = "This can contains what appears to be processed meat. Maybe it's dog food.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_FOOD,
	Rarity = 0.05,
	Model = "models/props_junk/garbage_metalcan001a.mdl",
	Functions = { FUNC_EAT },
	CamPos = Vector(10,10,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Food Carton", 
	Description = "This carton of partially eaten food doesn't look very appetizing.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_FOOD,
	Rarity = 0.20,
	Model = "models/props_junk/garbage_takeoutcarton001a.mdl",
	Functions = { FUNC_EAT } 
} )

