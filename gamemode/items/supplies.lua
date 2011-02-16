
// This is the ID given to any item that is an essential supply for every faction
ITEM_SUPPLY = 2

function FUNC_ENERGY( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddStamina( 80 )

end

function FUNC_HEAL( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:SetBleeding( false )
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
	Description = "This is a carbonated energy drink. It should replenish some of your stamina.",
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
	Name = "Medikit", 
	Description = "This kit will restore your health and stop any bleeding when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 35,
	Rarity = 0.50,
	Model = "models/items/healthkit.mdl",
	Functions = { FUNC_HEAL },
	CamPos = Vector(0,30,12),
	CamOrigin = Vector(3,10,6)	
} )

item.Register( { 
	Name = "Bandages", 
	Description = "These bandages will cover any open wounds and stop any bleeding.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 0.50, 
	Price = 15,
	Rarity = 0.50,
	Model = "models/props_lab/box01a.mdl",
	Functions = { FUNC_BANDAGE } 
} )




