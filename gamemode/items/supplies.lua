
// This is the ID given to any item that is an essential supply for every faction
ITEM_SUPPLY = 2

function FUNC_ENERGY( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddStamina( 100 )

end

function FUNC_HEAL( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:AddHealth( 100 )
	ply:EmitSound( "HealthVial.Touch" )

end

function FUNC_SUPERHEAL( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:AddRadiation( -1 )
	ply:AddHealth( 200 )
	ply:EmitSound( "HealthVial.Touch" )

end

function FUNC_BANDAGE( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:SetBleeding( false )
	ply:AddHealth( 20 )
	ply:EmitSound( "Cardboard.Strain" )

end

item.Register( { 
	Name = "Energy Drink", 
	Description = "This is a carbonated energy drink. It will replenish your stamina when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 0.25, 
	Price = 10,
	Rarity = 0.25,
	Model = "models/props_junk/popcan01a.mdl",
	Functions = { FUNC_ENERGY },
	CamPos = Vector(10,10,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Basic Medikit", 
	Description = "This kit will heal 50% of your health when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 40,
	Rarity = 0.65,
	Model = "models/radbox/healthpack.mdl",
	Functions = { FUNC_HEAL },
	CamPos = Vector(23,8,5)	
} )

item.Register( { 
	Name = "Scientific Medikit", 
	Description = "This kit will heal 100% of your health and relieve a small amount of radiation poisoning when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 55,
	Rarity = 0.85,
	Model = "models/radbox/healthpack2.mdl",
	Functions = { FUNC_SUPERHEAL },
	CamPos = Vector(23,8,5)
} )

item.Register( { 
	Name = "Bandage", 
	Description = "This medicinal gauze will effectively cover your open wounds and stop all bleeding.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 0.50, 
	Price = 25,
	Rarity = 0.50,
	Model = "models/radbox/bandage.mdl",
	Functions = { FUNC_BANDAGE },
	CamPos = Vector(20,10,5),
	CamOrigin = Vector(0,1,1)	
} )

