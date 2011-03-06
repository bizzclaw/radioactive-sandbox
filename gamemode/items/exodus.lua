
// This is the ID given to any item that is an exodus supply
ITEM_EXODUS = 3

function FUNC_ANTIRAD( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Weapon_SMG1.Special1" )
	ply:SetRadiation( 0 )

end

function FUNC_FLARE( ply, id, client )

	if client then return "Ignite" end
	
	ply:RemoveFromInventory( id )
	
	local prop = ents.Create( "sent_flare" )
	prop:SetPos( ply:GetItemDropPos() )
	prop:Spawn()

end

item.Register( { 
	Name = "Anti-Rad", 
	Description = "This powerful medication will instantly neutralize all radiation poisoning.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 0.15, 
	Price = 30,
	Rarity = 0.30,
	Model = "models/healthvial.mdl",
	Functions = { FUNC_ANTIRAD },
	CamPos = Vector(15,10,9),
	CamOrigin = Vector(0,0,5)	
} )

item.Register( { 
	Name = "Respirator", 
	Description = "This mask filters out hazardous airborne chemicals and radiation when equipped.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 1.75, 
	Price = 200,
	Rarity = 0.95,
	Model = "models/items/combine_rifle_cartridge01.mdl",
	Functions = {},
	CamPos = Vector(15,15,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Sonar Module", 
	Description = "This device connects to your radar, improving its detection range and speed.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 0.75, 
	Price = 100,
	Rarity = 0.90,
	Model = "models/gibs/shield_scanner_gib1.mdl",
	Functions = {},
	CamPos = Vector(5,8,8),
	CamOrigin = Vector(0,0,0)		
} )

item.Register( { 
	Name = "Field Detector Module", 
	Description = "This field detector will emit warning sounds when anomalies are nearby. It will also display them on your radar.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 1.25, 
	Price = 120,
	Rarity = 0.90,
	Model = "models/items/battery.mdl",
	Functions = {},
	CamPos = Vector(15,15,5),
	CamOrigin = Vector(0,0,6)		
} )

item.Register( { 
	Name = "Flare", 
	Description = "This emergency flare will emit a bright red light for a short duration of time.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 0.35, 
	Price = 20,
	Rarity = 0.10,
	Model = "models/props_c17/trappropeller_lever.mdl",
	Functions = { FUNC_FLARE },
	CamPos = Vector(15,5,5),
	CamOrigin = Vector(0,0,0)		
} )


