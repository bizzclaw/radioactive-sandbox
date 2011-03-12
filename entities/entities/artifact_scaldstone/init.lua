
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/srp/items/art_fireball.mdl" )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then

		phys:SetDamping( 10, 10 )
		phys:Wake()

	end

	self.AutoRemove = CurTime() + 600

end

function ENT:Think() 

end 

function ENT:Use( ply, caller )
	
	ply:AddToInventory( self.Entity )

end
