
// This is the ID given to any item that is ammunition
ITEM_AMMO = 4

// Price constants
PRICE_AMMOBOX = 30

function FUNC_AMMO( ply, id )

	local tbl = item.GetByID( id )
	
	if not tbl.Ammo then return true end

	ply:AddAmmo( tbl.Ammo, tbl.Amount )

	return true
	
end

function FUNC_DROPAMMO( ply, id )

	local tbl = item.GetByID( id )
	
	if not tbl.Ammo then return end

	ply:AddAmmo( tbl.Ammo, -tbl.Amount, true )

end

item.Register( { 
	Name = "Pistol Rounds", 
	Description = "This ammunition is made for handheld pistols. There are 40 rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.50,
	Model = "models/items/357ammo.mdl",
	Ammo = "Pistol",
	Amount = 40,
	Functions = { },
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(16,16,5),
	CamOrigin = Vector(0,0,5)	
} )

item.Register( { 
	Name = "Buckshot", 
	Description = "This ammunition is made for shotguns. There are 20 rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.20,
	Model = "models/items/boxbuckshot.mdl",
	Ammo = "Buckshot",
	Amount = 20,
	Functions = { },
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(20,10,10),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "SMG Rounds", 
	Description = "This ammunition is made for SMGs. There are 60 rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.60,
	Model = "models/items/boxsrounds.mdl",
	Ammo = "SMG",
	Amount = 60,
	Functions = { }, 
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(20,15,10),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "Rifle Rounds", 
	Description = "This ammunition is made for automatic rifles. There are 60 rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX + 10,
	Rarity = 0.80,
	Model = "models/items/boxmrounds.mdl",
	Ammo = "Rifle",
	Amount = 60,
	Functions = { }, 
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(25,15,10),
	CamOrigin = Vector(0,0,6)
} )

item.Register( { 
	Name = "Sniper Rounds", 
	Description = "This ammunition is made for sniper rifles. There are 10 rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.80,
	Model = "models/items/boxqrounds.mdl",
	Ammo = "Sniper",
	Amount = 10,
	Functions = { }, 
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(-16,-16,8),
	CamOrigin = Vector(3,0,2)
} )

