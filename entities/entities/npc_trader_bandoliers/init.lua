AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.BuybackScale = 0.75
ENT.Team = TEAM_BANDOLIERS

function ENT:GenerateInventory()

	self.Items = {}

	for i=1, 4 do
		
		local tbl = item.RandomItem( ITEM_FOOD )
			
		while table.HasValue( self.Items, tbl.ID ) do
			
			tbl = item.RandomItem( ITEM_FOOD )
			
		end
			
		self.Entity:AddItem( tbl.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_SUPPLY ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_BUYABLE ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_MISC ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_WPN_COMMON ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_WPN_BANDOLIERS ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end

end
