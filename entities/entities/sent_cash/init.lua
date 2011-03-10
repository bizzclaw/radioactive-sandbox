
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( Model( "models/props/cs_assault/money.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()

	end
	
	self.Cash = 0

end

function ENT:Think() 
	
end 

function ENT:SetCash( amt )

	self.Cash = amt
	
	self.Entity:SetNWInt( "Cash", amt )
	
end

function ENT:GetCash()

	return self.Cash

end

function ENT:Use( ply, caller )
	
	ply:AddCash( self.Cash )
	
	self.Entity:Remove()

end
