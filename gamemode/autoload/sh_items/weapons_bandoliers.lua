
--// This is the ID given to any weapon item for the bandoliers
ITEM_WPN_BANDOLIERS = 8

item.Register( { 
	Name = "Glock 19", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
	Weight = 3, 
	Price = 50,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_glock18.mdl",
	Weapon = "rad_glock",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "HK UMP45", 
	Description = "This submachine gun has a smaller magazine and fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
	Weight = 6, 
	Price = 300,
	Rarity = 0.60,
	Model = "models/weapons/w_smg_ump45.mdl",
	Weapon = "rad_ump45",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,36,5),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { 
	Name = "AK-47", 
	Description = "This automatic rifle is quite accurate and has a fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
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
	Type = ITEM_WPN_BANDOLIERS,
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
	Name = "Steyr Scout", 
	Description = "This bolt-action sniper rifle is useful for eliminating targets from a distance.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
	Weight = 9, 
	Price = 1100,
	Rarity = 0.80,
	Model = "models/weapons/w_snip_scout.mdl",
	Weapon = "rad_scout",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,45,5),
	CamOrigin = Vector(10,0,0)
} )