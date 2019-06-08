
--// This is the ID given to any weapon item for the army
ITEM_WPN_ARMY = 9

function FUNC_DROPWEAPON( ply, id, client )

	if client then return "Drop" end
	
	local tbl = item.GetByID( id )
	
	local prop = ents.Create( "sent_droppedgun" )
	prop:SetPos( ply:GetItemDropPos() )
	prop:SetModel( tbl.Model )
	prop:Spawn()
	
	ply:EmitSound( Sound( "items/ammopickup.wav" ) )
	ply:RemoveFromInventory( id )
	
	if not ply:HasItem( id ) then
	
		ply:StripWeapon( tbl.Weapon )
		
	end

end

function FUNC_REMOVEWEAPON( ply, id )

	local tbl = item.GetByID( id )
	
	if not ply:HasItem( id ) then
	
		ply:StripWeapon( tbl.Weapon )
		
	end

end

function FUNC_GRABWEAPON( ply, id )

	local tbl = item.GetByID( id )
	
	ply:Give( tbl.Weapon )
	
	return true

end

item.Register( { 
	Name = "USP Compact", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 3, 
	Price = 50,
	Rarity = 0.50,
	Model = "models/weapons/w_pistol.mdl",
	Weapon = "rad_usp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-18,0),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "Desert Eagle", 
	Description = "This pistol makes up for its smaller magazine with raw firepower.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 4, 
	Price = 250,
	Rarity = 0.60,
	Model = "models/weapons/w_pist_deagle.mdl",
	Weapon = "rad_deagle",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,16,5),
	CamOrigin = Vector(7,0,2)
} )

item.Register( { 
	Name = "M1014 Shotgun", 
	Description = "This powerful automatic shotgun holds 8 rounds.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 7, 
	Price = 650,
	Rarity = 0.85,
	Model = "models/weapons/w_shot_xm1014.mdl",
	Weapon = "rad_m1014",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,34,5),
	CamOrigin = Vector(12,0,2)
} )

item.Register( { 
	Name = "M4A1", 
	Description = "This accurate automatic rifle has a decent rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 7, 
	Price = 600,
	Rarity = 0.85,
	Model = "models/weapons/w_rif_m4a1.mdl",
	Weapon = "rad_m4",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,43,5),
	CamOrigin = Vector(10,0,2)
} )

item.Register( { 
	Name = "M249", 
	Description = "This belt-fed machine gun is capable of firing 100 rounds before reloading.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 10, 
	Price = 800,
	Rarity = 0.85,
	Model = "models/weapons/w_mach_m249para.mdl",
	Weapon = "rad_m249",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,36,5),
	CamOrigin = Vector(13,0,2)
} )

item.Register( { 
	Name = "Steyr AUG", 
	Description = "This automatic rifle has a scope attached.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 8, 
	Price = 900,
	Rarity = 0.85,
	Model = "models/weapons/w_rif_aug.mdl",
	Weapon = "rad_steyr",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,40,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "G3 SG1", 
	Description = "This automatic sniper rifle has a large magazine and a fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 9, 
	Price = 1000,
	Rarity = 0.85,
	Model = "models/weapons/w_snip_g3sg1.mdl",
	Weapon = "rad_g3",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,45,5),
	CamOrigin = Vector(7,0,2)
} )

item.Register( { 
	Name = "AWP", 
	Description = "This bolt-action sniper rifle is useful for eliminating targets from a distance.",
	Stackable = false, 
	Type = ITEM_WPN_ARMY,
	Weight = 9, 
	Price = 1200,
	Rarity = 0.85,
	Model = "models/weapons/w_snip_awp.mdl",
	Weapon = "rad_awp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,55,5),
	CamOrigin = Vector(12,0,2)
} )