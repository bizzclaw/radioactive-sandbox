
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_junk/garbage_bag001a.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()

	end

	self.LastUse = 0
	self.Cash = 0
	
end

function ENT:SetCash( amt )

	self.Cash = amt

end

function ENT:GetCash()

	return self.Cash

end

function ENT:Think() 

	if not ValidEntity( self.Entity:GetUser() ) then
		
		if #self.Entity:GetItems() < 1 or ( self.DieTime and self.DieTime < CurTime() ) then
	
			self.Entity:Remove()
			
		end
	
	end
	
	if not ValidEntity( self.Entity:GetUser() ) then return end
	
	if not self.Entity:GetUser():Alive() then
	
		self.Entity:SetUser()
	
	end
	
end 

function ENT:SetRemoval( num )
	
	self.DieTime = CurTime() + num

end

function ENT:SetQuest( ply )
	
	self.Entity:SetNWEntity( "QuestOwner", ply )

end

function ENT:GetUser()

	return self.User
	
end

function ENT:SetUser( ply )

	self.User = ply
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		if ply then
	
			phys:EnableMotion( false )
			
		else
		
			phys:EnableMotion( true )
		
		end
	
	end
	
	if not ply and #self.Entity:GetItems() < 1 then
	
		self.Entity:Remove()
	
	end
	
end

function ENT:OnExit( ply )

	if ( self.LastUse or 0 ) > CurTime() then return end
	if ValidEntity( self.Entity:GetNWEntity( "QuestOwner", nil ) ) and self.Entity:GetNWEntity( "QuestOwner", nil ) != ply then return end
	
	self.LastUse = CurTime() + 1.0

	if ValidEntity( self.Entity:GetUser() ) then
	
		self.Entity:SetUser()
		ply:ToggleStashMenu( self.Entity, false, "StashMenu" )
	
	end

end

function ENT:OnUsed( ply )

	if ( self.LastUse or 0 ) > CurTime() then return end
	if ValidEntity( self.Entity:GetNWEntity( "QuestOwner", nil ) ) and self.Entity:GetNWEntity( "QuestOwner", nil ) != ply then return end
	
	self.LastUse = CurTime() + 1.0

	if not ValidEntity( self.Entity:GetUser() ) then
	
		ply:SynchCash( self.Cash )
	
		self.Entity:SetUser( ply )
		ply:ToggleStashMenu( self.Entity, true, "StashMenu" )
	
	end

end

function ENT:Use( ply, caller )

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
			
		self.Entity:GetUser():SynchStash( self.Entity )
			
	end

end

