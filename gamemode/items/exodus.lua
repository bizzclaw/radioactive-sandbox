
// This is the ID given to any item that is an exodus supply
ITEM_EXODUS = 3

// Weight constants
WEIGHT_MEDS = 0.15

// Price constants
PRICE_MEDS = 30

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
	Description = "This medication will neutralize radiation poisoning.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = WEIGHT_MEDS, 
	Price = PRICE_MEDS,
	Rarity = 0.20,
	Model = "models/healthvial.mdl",
	Functions = { FUNC_ANTIRAD },
	CamPos = Vector(15,10,9),
	CamOrigin = Vector(0,0,6)	
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
	Description = "This module connects to your radar, improving its detection range.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 0.75, 
	Price = 100,
	Rarity = 0.85,
	Model = "models/gibs/shield_scanner_gib1.mdl",
	Functions = {},
	CamPos = Vector(5,8,8),
	CamOrigin = Vector(0,0,0)		
} )

item.Register( { 
	Name = "Hazard Detector", 
	Description = "This field detector will emit warning sounds when radioactive deposits or anomalies are nearby.",
	Stackable = true, 
	Type = ITEM_EXODUS,
	Weight = 1.25, 
	Price = 100,
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


