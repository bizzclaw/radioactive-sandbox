ENT.Type = "point"

function ENT:Initialize()

end

function ENT:SetCash( amt )

	self.Cash = amt

end

function ENT:GetCash()

	return self.Cash

end

function ENT:GetUser()

	return self.User
	
end

function ENT:SetUser( ply )

	self.User = ply
	
end

function ENT:SetupItems( ply )

	if not GAMEMODE.PlayerInventories[ string.lower( ply:SteamID() ) ] then
	
		self.Items = {}
		self.Cash = 0
		
		return
	
	end

	self.Items = GAMEMODE.PlayerInventories[ string.lower( ply:SteamID() ) ].Tbl or {}
	self.Cash = GAMEMODE.PlayerInventories[ string.lower( ply:SteamID() ) ].Money
	
	ply:SynchCash( self.Cash )

end

function ENT:OnExit( ply )
	
	ply:ToggleStashMenu( self.Entity, false, "StashMenu", 1.0 )
	ply.Stash = nil
	
	GAMEMODE:SaveInventory( ply, self.Entity:GetItems(), self.Entity:GetCash() )

end


function ENT:GetItems()

	return self.Items or {}
	
end

function ENT:AddItem( id )

	self.Items = self.Items or {}

	table.insert( self.Items, id )
	
	self.Entity:Synch()

end

function ENT:RemoveItem( id )

	for k,v in pairs( self.Items ) do
	
		if v == id then
		
			self.Entity:Synch()
		
			table.remove( self.Items, k )
			
			return
		
		end
	
	end

end

function ENT:Synch()

	if ValidEntity( self.Entity:GetUser() ) then
	
		self.Entity:GetUser():SynchCash( self.Cash )
		self.Entity:GetUser():SynchStash( self.Entity )
		
	end

end
