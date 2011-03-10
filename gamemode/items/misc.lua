
// This is the ID given to any item that doesnt fit in any other category - feel free to add your own items here
ITEM_MISC = 5 // Can be found in stores or in loot
ITEM_BUYABLE = 6 // Only found in stores
ITEM_LOOT = 7 // Only found in loot
ITEM_QUEST = 420 
ITEM_QUEST_ZOMBIE = 421 

PRICE_QUEST_ZOMBIE_ITEM = 20
PRICE_QUEST_ITEM = 80

function FUNC_BADWATER( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( 1 )
	ply:AddStamina( 40 )

end

function FUNC_BOOZE( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( -2 )
	ply:AddStamina( 20 )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 1 )
	umsg.End()

end

function FUNC_MOONSHINE( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( -1 )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 2 )
	umsg.End()

end

function FUNC_TOGGLEVIS( ply, id, client )

	if client then return "Toggle" end
	
	if ply:FlashlightIsOn() then
	
		ply:Flashlight( false )
		
	end
	
	ply.NVG = !ply.NVG
	
	if ply.NVG then
	
		ply:EmitSound( "Buttons.snd15" )
	
	else
	
		ply:EmitSound( "Buttons.snd14" )
	
	end
	
	umsg.Start( "NVGToggle", ply )
    umsg.Bool( ply.NVG )
	umsg.End()

end

function FUNC_NIGHTVIS( ply, id )

	if ply:FlashlightIsOn() then
	
		ply:Flashlight( false )
		
	end
	
	ply.NVG = false
	
	umsg.Start( "NVGToggle", ply )
    umsg.Bool( false )
	umsg.End()
	
	return true
	
end

item.Register( { 
	Name = "Murky Water", 
	Description = "This old glass bottle is full of murky water. It doesn't look safe to drink.",
	Stackable = true, 
	Type = ITEM_LOOT,
	Weight = 0.30, 
	Price = 5,
	Rarity = 0.50,
	Model = "models/props_junk/garbage_glassbottle001a.mdl",
	Functions = { FUNC_BADWATER },
	CamPos = Vector(15,17,3),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Vodka", 
	Description = "This glass bottle is full of vodka. It will provide some relief from radiation poisoning and make you slightly drunk when used.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 0.30, 
	Price = 25,
	Rarity = 0.10,
	Model = "models/props_junk/garbage_glassbottle002a.mdl",
	Functions = { FUNC_BOOZE },
	CamPos = Vector(15,20,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Nightvision Module", 
	Description = "This module replaces your flashlight. It should make it much easier to see in the dark.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 1.50, 
	Price = 70,
	Rarity = 0.70,
	Model = "models/gibs/manhack_gib03.mdl",
	Functions = { FUNC_TOGGLEVIS },
	PickupFunction = FUNC_NIGHTVIS,
	CamPos = Vector(10,10,8),
	CamOrigin = Vector(0,0,1)		
} )

item.Register( { 
	Name = "Geiger Counter Module", 
	Description = "This device will warn you of dangerous radioactive deposits near your position.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 1.25, 
	Price = 50,
	Rarity = 0.90,
	Model = "models/radbox/geiger.mdl",
	Functions = {},
	CamPos = Vector(15,10,5),
	CamOrigin = Vector(0,0,3)	
} )

item.Register( { 
	Name = "Moonshine Vodka", 
	Description = "This old glass bottle is full of homemade vodka. It's less potent than regular vodka but tastes twice as strong.",
	Stackable = true, 
	Type = ITEM_BUYABLE,
	Weight = 0.30, 
	Price = 15,
	Rarity = 0.25,
	Model = "models/props_junk/garbage_glassbottle003a.mdl",
	Functions = { FUNC_MOONSHINE },
	CamPos = Vector(16,18,-3),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Binder", 
	Description = "This binder is full of detailed notes. It probably belonged to a scientist at one point.",
	Stackable = true, 
	Type = ITEM_QUEST,
	Weight = 1.50, 
	Price = PRICE_QUEST_ITEM,
	Rarity = 0.25,
	Model = "models/props_lab/bindergreenlabel.mdl",
	Functions = { },
	CamPos = Vector(25,15,0),
	CamOrigin = Vector(0,0,8)	
} )

item.Register( { 
	Name = "Strange Device", 
	Description = "This peculiar device looks like it was part of a larger machine.",
	Stackable = true, 
	Type = ITEM_QUEST,
	Weight = 4.50, 
	Price = PRICE_QUEST_ITEM,
	Rarity = 0.10,
	Model = "models/items/combine_rifle_ammo01.mdl",
	Functions = { },
	CamPos = Vector(18,15,0),
	CamOrigin = Vector(0,0,6)	
} )

item.Register( { 
	Name = "Strange Device", 
	Description = "This peculiar device looks like it was part of a larger machine.",
	Stackable = true, 
	Type = ITEM_QUEST,
	Weight = 3.50, 
	Price = PRICE_QUEST_ITEM,
	Rarity = 0.25,
	Model = "models/props_lab/reciever01d.mdl",
	Functions = { },
	CamPos = Vector(20,15,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Tissue Sample", 
	Description = "This labeled container contains what appears to be a chunk of flesh.",
	Stackable = true, 
	Type = ITEM_QUEST,
	Weight = 2.50, 
	Price = PRICE_QUEST_ITEM,
	Rarity = 0.25,
	Model = "models/props_lab/jar01b.mdl",
	Functions = { },
	CamPos = Vector(15,15,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Human Skull", 
	Description = "This skull looks pretty old. You decided to name it Murray.",
	Stackable = true, 
	Type = ITEM_QUEST,
	Weight = 2.50, 
	Price = PRICE_QUEST_ITEM,
	Rarity = 0.75,
	Model = "models/gibs/hgibs.mdl",
	Functions = { },
	CamPos = Vector(15,10,0),
	CamOrigin = Vector(0,0,2)	
} )

item.Register( { 
	Name = "Zombie Claw", 
	Description = "This is the claw of a zombie.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/gibs/antlion_gib_small_1.mdl",
	Functions = { },
	CamPos = Vector(10,15,5),
	CamOrigin = Vector(0,0,1)	
} )

item.Register( { 
	Name = "Zombie Spine", 
	Description = "This is the spine of a zombie.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/gibs/HGIBS_spine.mdl",
	Functions = { },
	CamPos = Vector(15,15,5),
	CamOrigin = Vector(0,0,2)	
} )

item.Register( { 
	Name = "Zombie Rib", 
	Description = "This is the rib of a zombie.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/gibs/HGIBS_rib.mdl",
	Functions = { },
	CamPos = Vector(10,15,3),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Zombie Flesh", 
	Description = "This is a chunk of zombie flesh.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/props_junk/watermelon01_chunk02a.mdl",
	Functions = { },
	CamPos = Vector(8,8,5),
	CamOrigin = Vector(0,0,2.5)	
} )
