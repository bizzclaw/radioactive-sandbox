
// This is the ID given to any weapon item for the bandoliers
ITEM_WPN_BANDOLIERS = 8

item.Register( { 
	Name = "Glock 19", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
	Weight = 3, 
	Price = 70,
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
	Price = 350,
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
	Name = "FAMAS", 
	Description = "This automatic rifle has a smaller magazine but a faster rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
	Weight = 7, 
	Price = 500,
	Rarity = 0.60,
	Model = "models/weapons/w_rif_famas.mdl",
	Weapon = "rad_famas",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,40,5),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { 
	Name = "IMI Galil", 
	Description = "This automatic rifle has a larger magazine.",
	Stackable = false, 
	Type = ITEM_WPN_BANDOLIERS,
	Weight = 8, 
	Price = 650,
	Rarity = 0.60,
	Model = "models/weapons/w_rif_galil.mdl",
	Weapon = "rad_galil",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,43,5),
	CamOrigin = Vector(10,0,0)
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