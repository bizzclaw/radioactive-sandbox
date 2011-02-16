
// This is the ID given to any weapon item for all teams
ITEM_WPN_COMMON = 11

item.Register( { 
	Name = "HE Grenade", 
	Description = "These grenades have a large explosion radius and a fuse that lasts 3 seconds.",
	Stackable = true, 
	Type = ITEM_WPN_COMMON,
	Weight = 1, 
	Price = 50,
	Rarity = 0.50,
	Model = "models/weapons/w_eq_fraggrenade.mdl",
	Weapon = "rad_grenade",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(1,10,-3),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "MAC 10", 
	Description = "This submachine gun has a large magazine and fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 4, 
	Price = 200,
	Rarity = 0.25,
	Model = "models/weapons/w_smg_mac10.mdl",
	Weapon = "rad_mac10",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,22,5),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { 
	Name = "HK MP5", 
	Description = "This accurate submachine gun has a fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 6, 
	Price = 250,
	Rarity = 0.50,
	Model = "models/weapons/w_smg_mp5.mdl",
	Weapon = "rad_mp5",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,37,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "Winchester 1887", 
	Description = "This basic shotgun only holds 2 shells but is powerful up close.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 6, 
	Price = 200,
	Rarity = 0.50,
	Model = "models/weapons/w_annabelle.mdl",
	Weapon = "rad_shotgun",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-50,5),
	CamOrigin = Vector(3,0,2)
} )

