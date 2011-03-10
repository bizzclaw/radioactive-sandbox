
// This is the ID given to any weapon item for exodus
ITEM_WPN_EXODUS = 10

item.Register( { 
	Name = "P228 Compact", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_EXODUS,
	Weight = 3, 
	Price = 70,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_p228.mdl",
	Weapon = "rad_p228",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "M3 Super 90", 
	Description = "This powerful shotgun holds 6 rounds.",
	Stackable = false, 
	Type = ITEM_WPN_EXODUS,
	Weight = 7, 
	Price = 600,
	Rarity = 0.85,
	Model = "models/weapons/w_shot_m3super90.mdl",
	Weapon = "rad_m3",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,42,5),
	CamOrigin = Vector(8,0,2)
} )

item.Register( { 
	Name = "AK-47", 
	Description = "This automatic rifle is quite accurate and has a fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_EXODUS,
	Weight = 7, 
	Price = 600,
	Rarity = 0.60,
	Model = "models/weapons/w_rif_ak47.mdl",
	Weapon = "rad_ak47",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,43,5),
	CamOrigin = Vector(10,0,0)
} )

item.Register( { 
	Name = "SG 552", 
	Description = "This automatic rifle has a scope attached.",
	Stackable = false, 
	Type = ITEM_WPN_EXODUS,
	Weight = 8, 
	Price = 900,
	Rarity = 0.80,
	Model = "models/weapons/w_rif_sg552.mdl",
	Weapon = "rad_sg552",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,40,5),
	CamOrigin = Vector(6,0,0)
} )

item.Register( { 
	Name = "SG 550", 
	Description = "This automatic sniper rifle has a large magazine and a fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_EXODUS,
	Weight = 9, 
	Price = 1000,
	Rarity = 0.80,
	Model = "models/weapons/w_snip_sg550.mdl",
	Weapon = "rad_sg550",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,39,5),
	CamOrigin = Vector(11,0,0)
} )
