
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/srp/items/art_urchen.mdl" )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then

		phys:Wake()

	end
	
	self.Distance = 50
	self.AutoRemove = CurTime() + 600

end

function ENT:Think() 
	
	if self.AutoRemove < CurTime() then
	
		self.Entity:Remove()
	
	end
	
end 

function ENT:Use( ply, caller )
	
	ply:AddToInventory( self.Entity )

end
